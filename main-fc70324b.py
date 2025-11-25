#!/usr/bin/env python3
"""
VETA (Viet-Eng-Term-Analyzer) - Main Entry Point
Phân tích ngôn ngữ đa ngữ (Anh-Việt) với OpenAI API
"""
from pathlib import Path
import sys

project_root = Path(__file__).parent.absolute()
sys.path.insert(0, str(project_root / "src"))

from veta_analyzer import analyze_mixed_text


def main() -> int:
    """Main entry point"""
    if len(sys.argv) < 2:
        print("Usage: ./main-fc70324b.sh '<text to analyze>'")
        print("Example: ./main-fc70324b.sh 'Hiện tại, tôi đang học về Prompt Engineering'")
        return 1

    input_text = sys.argv[1]
    result = analyze_mixed_text(input_text)

    import json
    print(json.dumps(result, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    sys.exit(main())
