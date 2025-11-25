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
    └── settings.json
```

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
- `.claude/settings.json` cần merge manually (mỗi project có thể khác nhau)
- Instructions files thường có thể overwrite (shared logic)
- Custom configurations nên giữ nguyên

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
| **Push ra Projects** | Automated script với dynamic discovery | Update instructions across all projects |
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

