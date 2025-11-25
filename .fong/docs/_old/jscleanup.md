# JavaScript Helper Function Cleanup Guide

## Overview
Hướng dẫn cleanup JavaScript helper functions để code ngắn gọn, clean và source speaks itself.

## Prerequisites
⚠️ **QUAN TRỌNG**: Backup file trước khi cleanup
```bash
cp "original-file.js" "original-file.js-$(date +%Y%m%d-%H%M).bak"
```

## Core Principles
🎯 **CHỈ REMOVE COMMENT - KHÔNG LÀM GÌ KHÁC**
- ❌ KHÔNG thay đổi code style
- ❌ KHÔNG refactoring
- ❌ KHÔNG thay đổi logic
- ❌ KHÔNG thay đổi tên biến, tên hàm
- ✅ CHỈ remove comment không cần thiết
- ✅ Giữ nguyên tất cả mọi thứ khác

## Standard Cleanup Steps

### 1. Header Cleanup
**Before:**
```javascript
/**
 *
 * Fong fixed  20 25-06-23
 *
 *
 * Utility module to check user account type (free/paid users)
 * 2025-06-07 21:55:46 quyen
 * @file wp-content/plugins/fong_de_lms/modules/learndash-middleware/src/public/js/utils/fong-user-account-checker.js
 * @module learndash-middleware-user-account-checker
 * @description Kiểm tra loại tài khoản user để áp dụng logic điều kiện
 *
 * @requires FONG global object
 * @requires FONG_LEARNDASH global object
 *
 * quyen + (hành động: tạo mới file) 2025-06-07 20:20:56
 * File utility mới để kiểm tra loại tài khoản user và quyết định có áp dụng logic quiz navigation hay không
 */
```

**After:**
```javascript
/**
 * Utility module to check user account type (free/paid users)
 */
```

### 2. Function JSDoc Cleanup
**Before:**
```javascript
/**
 * Kiểm tra xem user hiện tại có phải là free hoặc paid user không
 * @returns {boolean} true nếu là free/paid user, false nếu là loại tài khoản khác
 *
 * quyen + (hành động: tạo mới function) 2025-06-07 20:20:56
 * Function chính để kiểm tra loại tài khoản user
 */
```

**After:**
```javascript
/**
 * Kiểm tra xem user hiện tại có phải là free hoặc paid user không
 * @returns {boolean} true nếu là free/paid user, false nếu là loại tài khoản khác
 */
```

### 3. Remove Internal Comments
**Before:**
```javascript
export function isFreeOrPaidUser() {
  // .2025-06-23 vài ngày trước a Fong có sửa file này 1 chút, ở chỗ ... (bên dưới)
  try {
    // Kiểm tra các biến global cần thiết
    if (typeof FONG === "undefined" || typeof FONG_LEARNDASH === "undefined") {
      return false;
    }

    // Kiểm tra user đã đăng nhập chưa
    if (!FONG_LEARNDASH.is_logged_in) {
      return false;
    }

    // Check actual role từ FONG.role
    const userRole = FONG.role;
    if (!userRole) {
      return false;
    }

    // Fong 2025-06-23 (thực ra là vài ngày trước )
    // Kiểm tra role thực tế - chỉ free/paid user mới return true
    const freeOrPaidRoles = ["fong_free_user", "fong_paid_user"];
    const isFreeOrPaid = freeOrPaidRoles.includes(userRole);

    return isFreeOrPaid;
  } catch (error) {
    console.error(
      "[UserAccountChecker] Error checking user account type:",
      error
    );
    return false;
  }
}
```

**After:**
```javascript
export function isFreeOrPaidUser() {
  try {
    if (typeof FONG === "undefined" || typeof FONG_LEARNDASH === "undefined") {
      return false;
    }

    if (!FONG_LEARNDASH.is_logged_in) {
      return false;
    }

    const userRole = FONG.role;
    if (!userRole) {
      return false;
    }

    const freeOrPaidRoles = ["fong_free_user", "fong_paid_user"];
    const isFreeOrPaid = freeOrPaidRoles.includes(userRole);

    return isFreeOrPaid;
  } catch (error) {
    console.error(
      "[UserAccountChecker] Error checking user account type:",
      error
    );
    return false;
  }
}
```

### 4. Remove Metadata Comments
**Before:**
```javascript
/**
 * Log thông tin debug về loại tài khoản
 *
 * quyen + (hành động: tạo mới function) 2025-06-07 20:20:56
 * Function debug để log thông tin tài khoản user cho việc troubleshooting
 */
export function debugUserAccountInfo() {
  if (typeof console !== "undefined" && console.log) {
    // Intentionally left blank to remove debug logs.
  }
}
```

**After:**
```javascript
/**
 * Log thông tin debug về loại tài khoản
 */
export function debugUserAccountInfo() {
  if (typeof console !== "undefined" && console.log) {
  }
}
```

## Rules for JavaScript Helper Functions

### What to Keep
- ✅ Function logic và structure 
- ✅ Variable names và naming convention
- ✅ Code style và formatting
- ✅ Error handling
- ✅ Return statements
- ✅ Basic JSDoc with function purpose

### What to Remove
- ❌ Timestamp comments
- ❌ Author information
- ❌ Detailed file history
- ❌ Internal step-by-step comments
- ❌ Debug comments
- ❌ Metadata trong JSDoc

### Locations
- **Plugin JS**: `/wp-content/plugins/fong_de_lms/`
- **Theme JS**: `/wp-content/themes/astra-child-deutschfuns/`

## Example: Complete Cleanup

### Before Cleanup (82 lines)
```javascript
/**
 *
 * Fong fixed  20 25-06-23
 *
 *
 * Utility module to check user account type (free/paid users)
 * 2025-06-07 21:55:46 quyen
 * @file wp-content/plugins/fong_de_lms/modules/learndash-middleware/src/public/js/utils/fong-user-account-checker.js
 * @module learndash-middleware-user-account-checker
 * @description Kiểm tra loại tài khoản user để áp dụng logic điều kiện
 *
 * @requires FONG global object
 * @requires FONG_LEARNDASH global object
 *
 * quyen + (hành động: tạo mới file) 2025-06-07 20:20:56
 * File utility mới để kiểm tra loại tài khoản user và quyết định có áp dụng logic quiz navigation hay không
 */

/**
 * Kiểm tra xem user hiện tại có phải là free hoặc paid user không
 * @returns {boolean} true nếu là free/paid user, false nếu là loại tài khoản khác
 *
 * quyen + (hành động: tạo mới function) 2025-06-07 20:20:56
 * Function chính để kiểm tra loại tài khoản user
 */
export function isFreeOrPaidUser() {
  // .2025-06-23 vài ngày trước a Fong có sửa file này 1 chút, ở chỗ ... (bên dưới)
  try {
    // Kiểm tra các biến global cần thiết
    if (typeof FONG === "undefined" || typeof FONG_LEARNDASH === "undefined") {
      return false;
    }
    // ... rest with internal comments
  } catch (error) {
    console.error("[UserAccountChecker] Error checking user account type:", error);
    return false;
  }
}
```

### After Cleanup (52 lines)
```javascript
/**
 * Utility module to check user account type (free/paid users)
 */

/**
 * Kiểm tra xem user hiện tại có phải là free hoặc paid user không
 * @returns {boolean} true nếu là free/paid user, false nếu là loại tài khoản khác
 */
export function isFreeOrPaidUser() {
  try {
    if (typeof FONG === "undefined" || typeof FONG_LEARNDASH === "undefined") {
      return false;
    }

    if (!FONG_LEARNDASH.is_logged_in) {
      return false;
    }

    const userRole = FONG.role;
    if (!userRole) {
      return false;
    }

    const freeOrPaidRoles = ["fong_free_user", "fong_paid_user"];
    const isFreeOrPaid = freeOrPaidRoles.includes(userRole);

    return isFreeOrPaid;
  } catch (error) {
    console.error("[UserAccountChecker] Error checking user account type:", error);
    return false;
  }
}
```

## Key Benefits
- **Ngắn gọn**: Giảm ~37% dòng code không cần thiết
- **Clean**: Source code speaks itself
- **Đơn giản**: Dễ đọc và maintain
- **An toàn**: Không thay đổi logic hay functionality
- **Consistent**: Giữ nguyên coding style

## Safety Checklist
- [ ] Backup file completed
- [ ] Only comments removed, no logic changes
- [ ] Function names unchanged
- [ ] Variable names unchanged
- [ ] Code style preserved
- [ ] Error handling intact
- [ ] Return statements preserved

## Usage
Apply cho tất cả JavaScript helper functions trong theme và plugin của Deutschfuns LMS.