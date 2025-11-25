#!/usr/bin/env node

/**
 * BPMN to Image Converter
 *
 * Converts BPMN XML diagrams to high-resolution PNG/JPG images.
 * Supports multiple paper sizes (A4, A3, A2, A1, Letter, Legal) and custom dimensions.
 *
 * Usage:
 *   node bpmn-convert.js <input.bpmn> <output.png> [options]
 *
 * Paper Size & Dimensions:
 *   --paper <size>              Paper preset: A4, A3, A2, A1, Letter, Legal (default: A4)
 *   --orientation <o>           portrait | landscape (default: portrait)
 *   --width <pixels>            Custom width (overrides --paper)
 *   --height <pixels>           Custom height (overrides --paper)
 *
 * Resolution & Quality:
 *   --dpi <value>               DPI: 72, 96, 150, 300, 600 (default: 300)
 *   --format <fmt>              png | jpg (default: auto from extension)
 *   --quality <1-100>           JPEG quality (default: 90)
 *
 * Layout & Cropping:
 *   --padding <pixels>          Padding around auto-cropped diagram (default: 20)
 *   --fit <mode>                auto-crop | viewport | none (default: auto-crop)
 *
 * Examples:
 *   # Basic usage
 *   node bpmn-convert.js diagram.bpmn output.png
 *
 *   # A3 landscape with extra padding
 *   node bpmn-convert.js diagram.bpmn output.png --paper A3 --orientation landscape --padding 40
 *
 *   # Custom size for very large/complex diagrams
 *   node bpmn-convert.js complex.bpmn output.png --width 5000 --height 3000 --padding 50
 *
 *   # High DPI for print
 *   node bpmn-convert.js diagram.bpmn output.png --dpi 600
 */

const fs = require('fs');
const path = require('path');
const colorModdle = require('bpmn-in-color-moddle/resources/bpmn-in-color.json');

// Paper size presets at 300 DPI
const PAPER_SIZES_300DPI = {
  A4: { portrait: { width: 2480, height: 3508 }, landscape: { width: 3508, height: 2480 } },
  A3: { portrait: { width: 3508, height: 4961 }, landscape: { width: 4961, height: 3508 } },
  A2: { portrait: { width: 4961, height: 7016 }, landscape: { width: 7016, height: 4961 } },
  A1: { portrait: { width: 7016, height: 9933 }, landscape: { width: 9933, height: 7016 } },
  Letter: { portrait: { width: 2550, height: 3300 }, landscape: { width: 3300, height: 2550 } },
  Legal: { portrait: { width: 2550, height: 4200 }, landscape: { width: 4200, height: 2550 } }
};

// DPI to scale factor mapping
const DPI_SCALE_FACTORS = {
  72: 0.75,    // 72 DPI / 96 DPI
  96: 1.0,     // 96 DPI / 96 DPI (web standard)
  150: 1.5625, // 150 DPI / 96 DPI
  300: 3.125,  // 300 DPI / 96 DPI (print quality)
  600: 6.25    // 600 DPI / 96 DPI (high-end print)
};

// Defaults
const DEFAULT_DPI = 300;
const DEFAULT_PADDING = 20;

/**
 * Parse command-line arguments
 */
function parseArgs(args) {
  if (args.length < 2) {
    console.error('Error: Missing required arguments');
    console.error('Usage: node bpmn-convert.js <input.bpmn> <output.png> [options]');
    process.exit(1);
  }

  const [inputFile, outputFile] = args;

  const config = {
    inputFile,
    outputFile,
    paper: 'A4',
    orientation: 'portrait',
    width: null,      // Custom width (overrides paper)
    height: null,     // Custom height (overrides paper)
    dpi: DEFAULT_DPI,
    format: path.extname(outputFile).slice(1).toLowerCase() || 'png',
    quality: 90,
    padding: DEFAULT_PADDING,
    fit: 'auto-crop'
  };

  // Parse options
  for (let i = 2; i < args.length; i++) {
    const arg = args[i];
    const next = args[i + 1];

    if (arg === '--paper' && next) {
      if (!PAPER_SIZES_300DPI[next]) {
        console.error(`Error: Invalid paper size. Use one of: ${Object.keys(PAPER_SIZES_300DPI).join(', ')}`);
        process.exit(1);
      }
      config.paper = next;
      i++;
    } else if (arg === '--orientation' && next) {
      if (!['portrait', 'landscape'].includes(next)) {
        console.error('Error: Invalid orientation. Use "portrait" or "landscape"');
        process.exit(1);
      }
      config.orientation = next;
      i++;
    } else if (arg === '--width' && next) {
      const width = parseInt(next, 10);
      if (isNaN(width) || width <= 0) {
        console.error('Error: Width must be a positive number');
        process.exit(1);
      }
      config.width = width;
      i++;
    } else if (arg === '--height' && next) {
      const height = parseInt(next, 10);
      if (isNaN(height) || height <= 0) {
        console.error('Error: Height must be a positive number');
        process.exit(1);
      }
      config.height = height;
      i++;
    } else if (arg === '--dpi' && next) {
      const dpi = parseInt(next, 10);
      if (!DPI_SCALE_FACTORS[dpi]) {
        console.error(`Error: Invalid DPI. Use one of: ${Object.keys(DPI_SCALE_FACTORS).join(', ')}`);
        process.exit(1);
      }
      config.dpi = dpi;
      i++;
    } else if (arg === '--format' && next) {
      const format = next.toLowerCase();
      if (!['png', 'jpg', 'jpeg'].includes(format)) {
        console.error('Error: Invalid format. Use "png" or "jpg"');
        process.exit(1);
      }
      config.format = format === 'jpeg' ? 'jpg' : format;
      i++;
    } else if (arg === '--quality' && next) {
      const quality = parseInt(next, 10);
      if (isNaN(quality) || quality < 1 || quality > 100) {
        console.error('Error: Quality must be between 1 and 100');
        process.exit(1);
      }
      config.quality = quality;
      i++;
    } else if (arg === '--padding' && next) {
      const padding = parseInt(next, 10);
      if (isNaN(padding) || padding < 0) {
        console.error('Error: Padding must be a non-negative number');
        process.exit(1);
      }
      config.padding = padding;
      i++;
    } else if (arg === '--fit' && next) {
      if (!['auto-crop', 'viewport', 'none'].includes(next)) {
        console.error('Error: Invalid fit mode. Use "auto-crop", "viewport", or "none"');
        process.exit(1);
      }
      config.fit = next;
      i++;
    }
  }

  return config;
}

/**
 * Convert BPMN to image
 */
async function convertBPMN(config) {
  const { inputFile, outputFile, paper, orientation, width: customWidth, height: customHeight,
          dpi, format, quality, padding, fit } = config;

  // Import puppeteer dynamically
  const puppeteer = await import('puppeteer');

  // Read BPMN XML
  if (!fs.existsSync(inputFile)) {
    console.error(`Error: Input file ${inputFile} not found`);
    process.exit(1);
  }

  const bpmnXml = fs.readFileSync(inputFile, 'utf8');

  // Determine viewport dimensions
  let width, height;
  if (customWidth && customHeight) {
    // Custom dimensions override everything
    width = customWidth;
    height = customHeight;
  } else if (PAPER_SIZES_300DPI[paper]) {
    // Use paper size preset
    const paperDims = PAPER_SIZES_300DPI[paper][orientation];
    width = paperDims.width;
    height = paperDims.height;
  } else {
    // Fallback to A4
    width = PAPER_SIZES_300DPI.A4[orientation].width;
    height = PAPER_SIZES_300DPI.A4[orientation].height;
  }

  // Get scale factor for selected DPI
  const deviceScaleFactor = DPI_SCALE_FACTORS[dpi];

  // Create HTML with bpmn-js viewer
  const html = `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <script src="https://unpkg.com/bpmn-js@17.11.1/dist/bpmn-viewer.development.js"></script>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    body {
      background-color: white;
      font-family: Arial, sans-serif;
      overflow: hidden;
      padding: 10px;
    }
    #canvas {
      width: calc(100vw - 20px);
      height: calc(100vh - 20px);
      background-color: white;
    }
    /* Bring BPMN.IO watermark closer to diagram */
    .bjs-powered-by {
      margin-top: 5px !important;
      padding-top: 2px !important;
    }
  </style>
</head>
<body>
  <div id="canvas"></div>
  <script>
    // Color moddle extension for parsing color attributes
    // bpmn-js@8.7+ has built-in color rendering support
    const colorModdleDescriptor = ${JSON.stringify(colorModdle)};

    const viewer = new BpmnJS({
      container: '#canvas',
      width: '100%',
      height: '100%',
      moddleExtensions: {
        color: colorModdleDescriptor
      }
    });

    // Expose viewer to global scope for screenshot script
    window.viewer = viewer;

    const bpmnXML = ${JSON.stringify(bpmnXml)};

    viewer.importXML(bpmnXML).then(() => {
      const canvas = viewer.get('canvas');

      // Use fit-viewport for better layout (NOT for resolution!)
      // deviceScaleFactor handles resolution
      canvas.zoom('fit-viewport');

      // Signal that rendering is complete
      window.renderComplete = true;
    }).catch((err) => {
      console.error('Error importing BPMN:', err);
      window.renderError = err.message;
    });
  </script>
</body>
</html>
  `;

  // Launch browser with no-sandbox
  const browser = await puppeteer.default.launch({
    headless: true,
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-accelerated-2d-canvas',
      '--disable-gpu'
    ]
  });

  try {
    const page = await browser.newPage();

    // Set viewport with calculated scale factor for desired DPI
    await page.setViewport({
      width: Math.min(width, 1920),  // Cap viewport width for performance
      height: Math.min(height, 1080), // Cap viewport height for performance
      deviceScaleFactor: deviceScaleFactor
    });

    // Set content and wait for render
    await page.setContent(html, { waitUntil: 'networkidle0' });

    // Wait for BPMN to render
    await page.waitForFunction(() => {
      return window.renderComplete === true || window.renderError;
    }, { timeout: 10000 });

    // Check for errors
    const renderError = await page.evaluate(() => window.renderError);
    if (renderError) {
      throw new Error(`Failed to render BPMN: ${renderError}`);
    }

    // Add small delay to ensure everything is painted
    await new Promise(resolve => setTimeout(resolve, 500));

    // Get actual content bounds in viewport coordinates
    const contentBounds = await page.evaluate((paddingValue) => {
      const viewer = window.viewer;
      if (!viewer) {
        throw new Error('BPMN viewer not found');
      }

      const canvas = viewer.get('canvas');
      const elementRegistry = viewer.get('elementRegistry');

      // Get current zoom and viewport box
      const zoom = canvas.zoom();
      const viewbox = canvas.viewbox();

      // Get all elements
      const elements = elementRegistry.getAll();

      if (elements.length === 0) {
        throw new Error('No BPMN elements found');
      }

      // Calculate bounding box using element.bounds (Perplexity recommended approach)
      let minX = Infinity, minY = Infinity;
      let maxX = -Infinity, maxY = -Infinity;

      elements.forEach(element => {
        const bbox = element.bounds || element;

        if (bbox && bbox.x !== undefined && bbox.y !== undefined) {
          // Use bounds object directly
          minX = Math.min(minX, bbox.x);
          minY = Math.min(minY, bbox.y);
          maxX = Math.max(maxX, bbox.x + (bbox.width || 0));
          maxY = Math.max(maxY, bbox.y + (bbox.height || 0));
        } else if (element.waypoints) {
          // Handle connections/flows
          element.waypoints.forEach(point => {
            minX = Math.min(minX, point.x);
            minY = Math.min(minY, point.y);
            maxX = Math.max(maxX, point.x);
            maxY = Math.max(maxY, point.y);
          });
        }
      });

      // Use padding from parameter
      const pagePadding = paddingValue;

      // Return dimensions directly (deviceScaleFactor handles resolution)
      return {
        x: minX - pagePadding,
        y: minY - pagePadding,
        width: (maxX - minX) + (pagePadding * 2),
        height: (maxY - minY) + (pagePadding * 2)
      };
    }, padding);

    // Use bounds directly (already includes padding from evaluate())
    const clipRegion = {
      x: contentBounds.x,
      y: contentBounds.y,
      width: contentBounds.width,
      height: contentBounds.height
    };

    console.log(`  Content bounds: ${Math.round(contentBounds.width)}x${Math.round(contentBounds.height)}px`);

    // Screenshot options with auto-crop
    const screenshotOptions = {
      path: outputFile,
      clip: clipRegion,
      omitBackground: false
    };

    // Add type and quality for JPEG
    if (format === 'jpg') {
      screenshotOptions.type = 'jpeg';
      screenshotOptions.quality = quality;
    } else {
      screenshotOptions.type = 'png';
    }

    // Take screenshot
    await page.screenshot(screenshotOptions);

    console.log(`✓ Successfully converted BPMN to ${outputFile}`);

    // Show paper/dimension info
    if (customWidth && customHeight) {
      console.log(`  Dimensions: ${customWidth}x${customHeight}px (custom)`);
    } else {
      console.log(`  Paper: ${paper} ${orientation} (${width}x${height}px @ 300 DPI)`);
    }

    console.log(`  DPI: ${dpi} (scale: ${deviceScaleFactor}x)`);
    console.log(`  Padding: ${padding}px`);
    console.log(`  Format: ${format.toUpperCase()}${format === 'jpg' ? ` (quality: ${quality})` : ''}`);

    const stats = fs.statSync(outputFile);
    console.log(`  File size: ${(stats.size / 1024).toFixed(1)} KB`);

  } finally {
    await browser.close();
  }
}

// Main
const args = process.argv.slice(2);
const config = parseArgs(args);

convertBPMN(config).catch(err => {
  console.error('Error:', err.message);
  process.exit(1);
});
