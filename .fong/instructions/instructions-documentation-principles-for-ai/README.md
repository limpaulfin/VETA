# Documentation Principles for AI - Modular Guide

**Version**: 1.0.0 (Modular Architecture)
**Created**: 2025-11-12
**Purpose**: Core principles for creating AI-readable technical documentation and instructions

---

## 📂 Documentation Structure

This directory contains modular documentation (v1.0.0) with focused components (<150 LOC each).

### Core Files (Read in Order)

| # | File | LOC | Purpose |
|---|------|-----|---------|
| 00 | `00-instructions-documentation-principles-for-ai.md` | ~100 | **Main index & navigation hub** |
| 01 | `01-core-principles.md` | ~100 | 6 core principles (DRY/SSoT/Modularity/WBS/Progressive Disclosure/Traceability) |
| 02 | `02-architecture-patterns.md` | ~80 | 3 architecture patterns (single/folder/hybrid) |
| 03 | `03-single-file-skeleton.md` | ~120 | Template for single-file instructions |
| 04 | `04-folder-based-skeleton.md` | ~120 | Template for folder-based instructions |
| 05 | `05-cross-referencing-patterns.md` | ~80 | 6 cross-referencing patterns |
| 06 | `06-ai-readability-guidelines.md` | ~80 | 10 AI-readability rules |
| 07 | `07-terminology-standards.md` | ~60 | Consistent terminology usage |
| 08 | `08-anti-patterns.md` | ~80 | 8 anti-patterns to avoid |
| 99 | `99-quick-reference.md` | ~60 | TL;DR cheatsheet |

### Architecture Principles

Following **Google SWE** documentation best practices:
1. **SSoT** - Each concept lives in one place
2. **Strategic Redundancy** - Critical rules repeated where needed
3. **Self-Contained** - Each file understandable standalone
4. **Cross-Referenced** - Rich navigation between related topics
5. **Focused** - Each file <150 LOC, single responsibility

---

## 🚀 Quick Start

**New users**: Start with `00-instructions-documentation-principles-for-ai.md`

**Experienced users**: Jump to `99-quick-reference.md` for TL;DR

**Need templates?**: See `03-single-file-skeleton.md` or `04-folder-based-skeleton.md`

---

## 🎯 What This Is

Guide for writing technical documentation, instructions, PRDs, and guides that AI can:
- Read and parse accurately
- Understand semantic structure
- Execute workflows effectively
- Trace dependencies clearly

**Audience**: AI agents (Claude, GPT, etc.), not humans

**Key Constraint**: Balance brevity (Pareto 80/20) with completeness. No yapping. Precise terminology only.

---

## 📊 Modular vs Monolithic

**Before (v0)**:
- Single file: 620 lines
- Hard to navigate
- All-or-nothing reading

**After (v1.0)**:
- 10 focused files: 60-120 lines each
- Clear navigation structure
- Read only what you need

---

## 🔗 Related Files

### Research Sources
- **DKM NewRAG**: 8 books (Craft of Research, How to Write a Thesis, Pragmatic Programmer, Team Topologies, Google TypeScript Style Guide, Peopleware, Software Engineers Guidebook)
- **Perplexity AI**: Google docs standards, WBS principles, modular patterns

### Memory Files
- `.fong/.memory/2025-11-12-documentation-principles-v1.md`

---

## 📝 Version History

- **v1.0.0** (2025-11-12): Modular architecture - split into 10 focused files (60-120 LOC each)

---

## 🤝 Contributing

When updating this documentation:

1. **Maintain LOC limits**: Keep files <150 LOC (ideally <100)
2. **Update cross-references**: Use relative links `./XX-filename.md`
3. **Test navigation**: Verify all links work
4. **Update version**: Increment version in affected files
5. **Update README**: Reflect structural changes here

---

**Start Reading**: [00-instructions-documentation-principles-for-ai.md](./00-instructions-documentation-principles-for-ai.md)
