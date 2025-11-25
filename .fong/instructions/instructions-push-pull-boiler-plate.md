# Instructions Push/Pull Boiler-plate

**ID:** 92ec99d9-0f82-41c1-bb83-523834d7692c  
**Updated:** 2025-10-20

---

## 🎯 Triết Lý

**Single Source of Truth (SSoT):** Một project được chỉ định làm "boiler-plate" - nguồn chuẩn cho `.fong` configuration và instructions.

**DRY (Don't Repeat Yourself):** Synchronize files từ một nguồn duy nhất ra các projects thay vì duplicate và maintain nhiều bản copy.

**Flexible & Scalable:** Projects có thể thêm/bớt bất cứ lúc nào - dùng dynamic discovery thay vì hardcode danh sách.

---

## 📍 Cấu Trúc Chung

### Source Project (Boiler-plate)
```
${BOILERPLATE_PROJECT}/
├── .fong/
│   ├── instructions/
│   ├── agents/
│   └── ...
└── .claude/
    ├── hooks/
    │   ├── SessionStart.sh         ⚠️ CRITICAL - Must push with settings.json
    │   ├── UserPromptSubmit.sh     ⚠️ CRITICAL - Must push with settings.json
    │   └── *.sh                    ⚠️ CRITICAL - All hook scripts
    └── settings.json               🚨 MANDATORY - Required for hooks to work
```

**⚠️ CRITICAL FILES:**
- **`.claude/settings.json`**: MANDATORY - hooks sẽ KHÔNG work nếu thiếu file này
- **`.claude/hooks/*`**: ALL files (including `.sh`, `.md`, `.json`, etc.) - không chỉ shell scripts
- **Rule**: Khi push `.claude/*`, PHẢI push CẢ settings.json VÀ hooks/ directory (tất cả files)

### Target Projects
Tất cả projects có `.fong` directory trong workspace của bạn.

---

## 🔍 Discovery: Tìm All Projects

### Pattern để tìm projects có `.fong`

#### Tầng 1: Projects trực tiếp trong workspace
```bash
# Pattern: ${WORKSPACE_ROOT}/*/.fong
# Example: /home/fong/Projects/project-a/.fong
find ${WORKSPACE_ROOT} -maxdepth 2 -name ".fong" -type d 2>/dev/null | sort

# Hoặc dùng mindepth để chỉ lấy tầng 1
find ${WORKSPACE_ROOT} -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null | sort
```

#### Tầng 2: Projects trong subdirectories (Nested Projects)
```bash
# Pattern: ${WORKSPACE_ROOT}/*/*/.fong
# Example: /home/fong/Projects/de/public/.fong

# Cách 1: Scan từ subdirectory cụ thể
find ${WORKSPACE_ROOT}/de -maxdepth 2 -name ".fong" -type d 2>/dev/null | sort
find ${WORKSPACE_ROOT}/subfolder -maxdepth 2 -name ".fong" -type d 2>/dev/null | sort

# Cách 2: Scan tất cả subdirectories (tầng 2)
find ${WORKSPACE_ROOT} -mindepth 3 -maxdepth 3 -name ".fong" -type d 2>/dev/null | sort

# Cách 3: Scan cả tầng 1 + tầng 2
find ${WORKSPACE_ROOT} -mindepth 2 -maxdepth 3 -name ".fong" -type d 2>/dev/null | sort
```

#### Kết hợp multiple locations (Specific Locations Only)
```bash
# Tìm projects từ 2 locations cụ thể: Projects/* và Projects/de/*
# KHÔNG tìm deeper sub-directories
{
  find /home/fong/Projects -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null
  find /home/fong/Projects/de -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null
} | sort -u
```

**Giải thích depth:**
- `maxdepth 2`: Tìm đến level 2 từ starting point
  - `/workspace/.fong` (level 1) ❌
  - `/workspace/project/.fong` (level 2) ✅
  - `/workspace/project/sub/.fong` (level 3) ❌

- `mindepth 3 -maxdepth 3`: Chỉ lấy level 3
  - `/workspace/category/project/.fong` (level 3) ✅
  - `/workspace/project/.fong` (level 2) ❌

**Lợi ích:** Không cần hardcode danh sách projects - tự động phát hiện khi có thêm/bớt.

---

## 📤 Pull: Lấy Files Mới Nhất

### Pull từ Boiler-plate
```bash
# Pull toàn bộ .fong directory
cp -r ${BOILERPLATE_PROJECT}/.fong/* ${TARGET_PROJECT}/.fong/

# Pull .claude/hooks
cp -r ${BOILERPLATE_PROJECT}/.claude/hooks/* ${TARGET_PROJECT}/.claude/hooks/

# Pull .claude/settings.json (cần merge manually)
cp ${BOILERPLATE_PROJECT}/.claude/settings.json ${TARGET_PROJECT}/.claude/settings.json.new
```

---

## 📥 Push: Đẩy Files Ra All Projects

### Approach 1: Manual Copy Single File
```bash
# Push 1 file cụ thể từ project A sang project B
SOURCE="${SOURCE_PROJECT}/.fong/instructions/file.md"
TARGET_DIR="${TARGET_PROJECT}/.fong/instructions/"
cp "$SOURCE" "$TARGET_DIR"
```

### Approach 2: Automated Push - Tầng 1 (Direct Projects)
```bash
#!/bin/bash
# Tự động push files ra projects tầng 1

SOURCE_DIR="${SOURCE_PROJECT}/.fong/instructions"
FILES_TO_PUSH=(
  "file1.md"
  "file2.md"
)

# Dynamic discovery - tìm tất cả .fong directories tầng 1
TARGETS=($(find ${WORKSPACE_ROOT} -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null))

for FONG_DIR in "${TARGETS[@]}"; do
  TARGET_DIR="$FONG_DIR/instructions/"

  if [ -d "$TARGET_DIR" ]; then
    for FILE in "${FILES_TO_PUSH[@]}"; do
      SOURCE_FILE="$SOURCE_DIR/$FILE"

      if [ -f "$SOURCE_FILE" ]; then
        cp "$SOURCE_FILE" "$TARGET_DIR"
        echo "✅ Copied $FILE to: $TARGET_DIR"
      fi
    done
  fi
done
```

### Approach 3: Automated Push - Tầng 2 (Nested Projects)
```bash
#!/bin/bash
# Tự động push files ra projects tầng 2 (nested)

SOURCE_DIR="${SOURCE_PROJECT}/.fong/instructions"
FILES_TO_PUSH=(
  "smartsearch.md"
  "other-file.md"
)

# Pattern 1: Scan specific nested directories
# Example: /home/fong/Projects/de/*/.fong
NESTED_LOCATIONS=(
  "${WORKSPACE_ROOT}/de"
  "${WORKSPACE_ROOT}/subfolder"
)

for LOCATION in "${NESTED_LOCATIONS[@]}"; do
  TARGETS=($(find "$LOCATION" -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null))

  for FONG_DIR in "${TARGETS[@]}"; do
    TARGET_DIR="$FONG_DIR/instructions/"

    if [ -d "$TARGET_DIR" ]; then
      for FILE in "${FILES_TO_PUSH[@]}"; do
        SOURCE_FILE="$SOURCE_DIR/$FILE"

        if [ -f "$SOURCE_FILE" ]; then
          cp "$SOURCE_FILE" "$TARGET_DIR"
          echo "✅ Copied $FILE to: $TARGET_DIR"
        fi
      done
    fi
  done
done
```

### Approach 4: Combined Push - Specific Locations Only
```bash
#!/bin/bash
# Push chỉ ra 2 locations cụ thể: /home/fong/Projects/* và /home/fong/Projects/de/*
# KHÔNG push deeper sub-directories

SOURCE_DIR="${SOURCE_PROJECT}/.fong/instructions"
FILES_TO_PUSH=("smartsearch.md")

# Collect .fong directories from 2 specific locations only
TARGETS=(
  $(find /home/fong/Projects -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null)
  $(find /home/fong/Projects/de -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null)
)

# Remove duplicates and sort
TARGETS=($(printf '%s\n' "${TARGETS[@]}" | sort -u))

echo "Found ${#TARGETS[@]} projects with .fong directory"

for FONG_DIR in "${TARGETS[@]}"; do
  TARGET_DIR="$FONG_DIR/instructions/"

  # Skip source project
  if [[ "$FONG_DIR" == "$SOURCE_PROJECT/.fong" ]]; then
    continue
  fi

  if [ -d "$TARGET_DIR" ]; then
    for FILE in "${FILES_TO_PUSH[@]}"; do
      SOURCE_FILE="$SOURCE_DIR/$FILE"

      if [ -f "$SOURCE_FILE" ]; then
        cp "$SOURCE_FILE" "$TARGET_DIR"
        PROJECT_NAME=$(echo "$FONG_DIR" | sed "s|/home/fong/Projects/||" | sed 's|/.fong||')
        echo "✅ Copied $FILE to: $PROJECT_NAME"
      fi
    done
  fi
done
```

**Key Points:**
- Script tự động discover projects - không cần update danh sách khi thêm/bớt projects
- Approach 4 scan 2 locations cụ thể: `/home/fong/Projects/*` và `/home/fong/Projects/de/*`
- Không push deeper sub-directories - chỉ maxdepth 2 cho mỗi location
- Pattern excludes nested projects deeper than specified locations

### 🚨 CRITICAL: Push `.claude` Configuration Files

**⚠️ MANDATORY WORKFLOW** - Khi push `.claude` files, PHẢI push CẢ 3 components:

```bash
#!/bin/bash
# Push .claude configuration files ra all projects
# CRITICAL: Must push settings.json + hooks/ together

SOURCE_CLAUDE_DIR="${SOURCE_PROJECT}/.claude"

# Discover all target projects
TARGETS=(
  $(find /home/fong/Projects -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null)
  $(find /home/fong/Projects/de -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null)
)
TARGETS=($(printf '%s\n' "${TARGETS[@]}" | sort -u))

echo "🔥 Pushing .claude configuration to ${#TARGETS[@]} projects..."

for FONG_DIR in "${TARGETS[@]}"; do
  # Get project root (parent of .fong)
  PROJECT_ROOT=$(dirname "$FONG_DIR")
  TARGET_CLAUDE_DIR="${PROJECT_ROOT}/.claude"

  # Skip source project
  if [[ "$PROJECT_ROOT" == "$SOURCE_PROJECT" ]]; then
    continue
  fi

  PROJECT_NAME=$(echo "$PROJECT_ROOT" | sed "s|/home/fong/Projects/||")

  # Create .claude directory if not exists
  mkdir -p "${TARGET_CLAUDE_DIR}/hooks"

  # 1. Push settings.json (MANDATORY)
  if [ -f "${SOURCE_CLAUDE_DIR}/settings.json" ]; then
    cp "${SOURCE_CLAUDE_DIR}/settings.json" "${TARGET_CLAUDE_DIR}/settings.json"
    echo "  ✅ [${PROJECT_NAME}] settings.json"
  else
    echo "  ❌ [${PROJECT_NAME}] ERROR: settings.json NOT FOUND in source"
    continue
  fi

  # 2. Push ALL files in hooks/ directory (MANDATORY - not just .sh)
  cp -r "${SOURCE_CLAUDE_DIR}/hooks"/* "${TARGET_CLAUDE_DIR}/hooks/" 2>/dev/null
  HOOKS_PUSHED=$(ls -1 "${TARGET_CLAUDE_DIR}/hooks" 2>/dev/null | wc -l)

  if [ $HOOKS_PUSHED -eq 0 ]; then
    echo "  ⚠️  [${PROJECT_NAME}] WARNING: No files in hooks/"
  else
    echo "  ✅ [${PROJECT_NAME}] hooks/ (${HOOKS_PUSHED} files)"
  fi

  echo "  ✨ [${PROJECT_NAME}] Complete: 1 settings.json + ${HOOKS_PUSHED} files"
done

echo ""
echo "🎉 Push complete! Affected ${#TARGETS[@]} projects"
```

### 🔐 Approach 5: Push with Checksum Verification

```bash
#!/bin/bash
# Push .claude files + verify checksums (RECOMMENDED)

SOURCE_PROJECT="/home/fong/Projects/python_bo_go_ai"
SOURCE_CLAUDE_DIR="${SOURCE_PROJECT}/.claude"

# Discover all target projects
TARGETS=(
  $(find /home/fong/Projects -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null)
  $(find /home/fong/Projects/de -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null)
)
TARGETS=($(printf '%s\n' "${TARGETS[@]}" | sort -u))

echo "🔥 Pushing .claude configuration + verification to ${#TARGETS[@]} projects..."
echo ""

PUSH_SUCCESS=0
VERIFY_SUCCESS=0
VERIFY_FAILED=0

for FONG_DIR in "${TARGETS[@]}"; do
  PROJECT_ROOT=$(dirname "$FONG_DIR")
  TARGET_CLAUDE_DIR="${PROJECT_ROOT}/.claude"

  # Skip source project
  if [[ "$PROJECT_ROOT" == "$SOURCE_PROJECT" ]]; then
    continue
  fi

  PROJECT_NAME=$(echo "$PROJECT_ROOT" | sed "s|/home/fong/Projects/||")

  # Create .claude directory if not exists
  mkdir -p "${TARGET_CLAUDE_DIR}/hooks"

  # 1. Push settings.json (MANDATORY)
  if [ -f "${SOURCE_CLAUDE_DIR}/settings.json" ]; then
    cp "${SOURCE_CLAUDE_DIR}/settings.json" "${TARGET_CLAUDE_DIR}/settings.json"
    echo "  📤 [${PROJECT_NAME}] Pushing settings.json + hooks/"
  else
    echo "  ❌ [${PROJECT_NAME}] ERROR: settings.json NOT FOUND"
    continue
  fi

  # 2. Push all files in hooks/ (including .md, .json, .sh, etc.)
  cp -r "${SOURCE_CLAUDE_DIR}/hooks"/* "${TARGET_CLAUDE_DIR}/hooks/" 2>/dev/null
  ((PUSH_SUCCESS++))

  # 3. VERIFY: Compare checksums for all files
  VERIFY_OK=1
  
  # Get all source files
  SOURCE_FILES=($(ls -1 "${SOURCE_CLAUDE_DIR}/hooks" 2>/dev/null | sort))
  
  for FILE in "${SOURCE_FILES[@]}"; do
    SOURCE_FILE="${SOURCE_CLAUDE_DIR}/hooks/$FILE"
    TARGET_FILE="${TARGET_CLAUDE_DIR}/hooks/$FILE"
    
    if [ ! -f "$TARGET_FILE" ]; then
      echo "    ❌ VERIFY FAILED: $FILE missing in target"
      VERIFY_OK=0
      break
    fi
    
    # Calculate checksums
    SOURCE_HASH=$(sha256sum "$SOURCE_FILE" | cut -d' ' -f1)
    TARGET_HASH=$(sha256sum "$TARGET_FILE" | cut -d' ' -f1)
    
    if [ "$SOURCE_HASH" != "$TARGET_HASH" ]; then
      echo "    ❌ VERIFY FAILED: $FILE checksum mismatch"
      echo "       Source: $SOURCE_HASH"
      echo "       Target: $TARGET_HASH"
      VERIFY_OK=0
      break
    fi
  done
  
  if [ $VERIFY_OK -eq 1 ]; then
    FILE_COUNT=$(ls -1 "${TARGET_CLAUDE_DIR}/hooks" 2>/dev/null | wc -l)
    echo "    ✅ VERIFIED: ${FILE_COUNT} files (checksums match)"
    ((VERIFY_SUCCESS++))
  else
    echo "    ⚠️  [${PROJECT_NAME}] Verification failed - NEEDS RETRY"
    ((VERIFY_FAILED++))
  fi
done

echo ""
echo "═════════════════════════════════════════"
echo "PUSH + VERIFY REPORT:"
echo "  📤 Pushed to: $PUSH_SUCCESS projects"
echo "  ✅ Verified: $VERIFY_SUCCESS projects"
echo "  ❌ Failed: $VERIFY_FAILED projects"
echo "═════════════════════════════════════════"
```

**Checksum Script Utilities:**

```bash
# Quick checksum comparison helper
verify_file() {
  local source_file="$1"
  local target_file="$2"
  
  if [ ! -f "$source_file" ] || [ ! -f "$target_file" ]; then
    echo "❌ File not found"
    return 1
  fi
  
  local source_hash=$(sha256sum "$source_file" | cut -d' ' -f1)
  local target_hash=$(sha256sum "$target_file" | cut -d' ' -f1)
  
  if [ "$source_hash" = "$target_hash" ]; then
    echo "✅ $source_file matches"
    return 0
  else
    echo "❌ $source_file MISMATCH"
    echo "   Source: $source_hash"
    echo "   Target: $target_hash"
    return 1
  fi
}

# Usage:
# verify_file "/home/fong/Projects/python_bo_go_ai/.claude/hooks/init-prompt.md" \
#             "/home/fong/Projects/some-project/.claude/hooks/init-prompt.md"
```

**Verify All Projects Checksums:**

```bash
#!/bin/bash
# Batch verify checksums for all projects

SOURCE_PROJECT="/home/fong/Projects/python_bo_go_ai"
SOURCE_HOOKS_DIR="${SOURCE_PROJECT}/.claude/hooks"

TARGETS=(
  $(find /home/fong/Projects -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null)
  $(find /home/fong/Projects/de -mindepth 2 -maxdepth 2 -name ".fong" -type d 2>/dev/null)
)
TARGETS=($(printf '%s\n' "${TARGETS[@]}" | sort -u))

echo "🔍 COMPREHENSIVE CHECKSUM VERIFICATION"
echo ""

TOTAL_OK=0
TOTAL_FAIL=0

for FONG_DIR in "${TARGETS[@]}"; do
  PROJECT_ROOT=$(dirname "$FONG_DIR")
  TARGET_HOOKS_DIR="${PROJECT_ROOT}/.claude/hooks"
  PROJECT_NAME=$(echo "$PROJECT_ROOT" | sed "s|/home/fong/Projects/||")

  # Skip source project
  if [[ "$PROJECT_ROOT" == "$SOURCE_PROJECT" ]]; then
    continue
  fi

  # Get all source files
  SOURCE_FILES=($(ls -1 "$SOURCE_HOOKS_DIR" 2>/dev/null | sort))
  
  ALL_OK=1
  for FILE in "${SOURCE_FILES[@]}"; do
    SOURCE_FILE="${SOURCE_HOOKS_DIR}/$FILE"
    TARGET_FILE="${TARGET_HOOKS_DIR}/$FILE"
    
    if [ ! -f "$TARGET_FILE" ]; then
      echo "❌ $PROJECT_NAME: $FILE missing"
      ALL_OK=0
      break
    fi
    
    SOURCE_HASH=$(sha256sum "$SOURCE_FILE" | cut -d' ' -f1)
    TARGET_HASH=$(sha256sum "$TARGET_FILE" | cut -d' ' -f1)
    
    if [ "$SOURCE_HASH" != "$TARGET_HASH" ]; then
      echo "❌ $PROJECT_NAME: $FILE mismatch"
      ALL_OK=0
      break
    fi
  done
  
  if [ $ALL_OK -eq 1 ]; then
    FILE_COUNT=$(ls -1 "$TARGET_HOOKS_DIR" 2>/dev/null | wc -l)
    echo "✅ $PROJECT_NAME ($FILE_COUNT files verified)"
    ((TOTAL_OK++))
  else
    ((TOTAL_FAIL++))
  fi
done

echo ""
echo "═════════════════════════════════════════"
echo "VERIFICATION SUMMARY:"
echo "  ✅ OK: $TOTAL_OK"
echo "  ❌ FAILED: $TOTAL_FAIL"
echo "═════════════════════════════════════════"
```

**Why CRITICAL:**
- **Missing `settings.json`**: Hooks sẽ KHÔNG work → SessionStart/UserPromptSubmit hooks bị vô hiệu hóa
- **Missing `hooks/*` files**: Settings.json reference đến hooks nhưng files không tồn tại → Error
- **Incomplete push**: Nếu chỉ push 1 trong 2 → System không hoạt động đúng
- **Checksum mismatch**: Files bị corrupted hoặc không sync đúng → Dùng verification

**Checklist Before Push:**
- ✅ Verify `settings.json` exists in source
- ✅ Verify all `hooks/*` files exist in source (including .md, .json, .sh)
- ✅ Test with 1 project trước khi push all
- ✅ **Run checksum verification sau push**
- ✅ Git commit sau khi push để track changes

---

## 🔄 Contribution Workflow

### Projects khác muốn đóng góp instructions
```bash
# Copy file contribution vào collection folder của boiler-plate project
cp ${MY_PROJECT}/.fong/instructions/new-instruction.md \
   ${BOILERPLATE_PROJECT}/collection/
```

Boiler-plate maintainer sẽ review và merge vào `.fong/instructions/` nếu phù hợp.

---

## 🛠️ Best Practices

### 1. **Always Discover Dynamically**
- Dùng `find` thay vì hardcode danh sách projects
- Projects có thể thêm/bớt bất cứ lúc nào
- Adapt pattern theo structure của workspace

### 2. **Selective Push**
- Không push toàn bộ `.fong` - chỉ push specific files cần update
- Tránh ghi đè project-specific configurations
- Identify shared vs project-specific files

### 3. **Configuration Merge**
- **🚨 CRITICAL**: `.claude/settings.json` + `.claude/hooks/*` (ALL files) PHẢI được push CÙNG NHAU
  - **Nếu thiếu settings.json**: Hooks sẽ KHÔNG work
  - **Nếu thiếu hooks files**: Settings reference đến files không tồn tại → Error
  - **Rule**: Push CẢ settings.json VÀ hooks/ directory - KHÔNG ĐƯỢC push riêng lẻ
  - **Verification**: Sau push, PHẢI run checksum verification để confirm files match
- Instructions files thường có thể overwrite (shared logic)
- Custom configurations nên giữ nguyên khi không phải shared components

### 4. **Verify Before Push**
```bash
# Check file tồn tại trước khi push
[ -f "$SOURCE_FILE" ] && echo "File exists" || echo "File not found"

# Check target directory exists
[ -d "$TARGET_DIR" ] && echo "Directory exists" || echo "Create first"
```

### 5. **Keep It Simple**
- Manual copy cho ad-hoc tasks
- Automated script cho bulk updates
- Git commit sau khi push để track changes
- Test với 1-2 projects trước khi push tất cả

---

## 📊 Summary

| Operation | Method | Use Case |
|-----------|--------|----------|
| **Discover Projects** | `find ${WORKSPACE} -name ".fong"` | Tìm tất cả projects có `.fong` |
| **Pull từ Boiler-plate** | `cp -r ${SOURCE}/.fong/* ${TARGET}/.fong/` | Lấy latest configuration |
| **Push .fong Instructions** | Automated script với dynamic discovery | Update instructions across all projects |
| **🚨 Push .claude Config** | Push settings.json + hooks/*.sh CÙNG NHAU | Update Claude hooks & settings (MANDATORY together) |
| **Contribute** | Copy vào `collection/` folder | Đóng góp từ projects khác |

---

## 💡 Example Variables Mapping

Trong thực tế, bạn sẽ thay thế variables theo environment:

```bash
# Example: Workspace in /home/user/Projects/
WORKSPACE_ROOT="/home/user/Projects"
BOILERPLATE_PROJECT="${WORKSPACE_ROOT}/boiler-plate-project"
SOURCE_PROJECT="${WORKSPACE_ROOT}/project-A"
TARGET_PROJECT="${WORKSPACE_ROOT}/project-B"

# Example: Nested structure
WORKSPACE_ROOT="/home/user/Projects"
LOCATION_1="${WORKSPACE_ROOT}"
LOCATION_2="${WORKSPACE_ROOT}/subfolder"
```

---

**Philosophy:** Dynamic discovery + Selective synchronization = Flexible & Maintainable system.

