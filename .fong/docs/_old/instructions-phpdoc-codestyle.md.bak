# PHP Doc & Code Style Guidelines - Deutschfuns LMS

## 🔄 Autoload System

### **Core Principle: Trust the Autoload**
- **Mọi helper functions và controllers đều được autoload theo cơ chế riêng** 
- **KHÔNG cần `require_once` statements** trong 99% trường hợp
- **Chỉ có một số trường hợp đặc biệt mới cần require** (rất hiếm)
- **Tin tưởng vào autoload mechanism** - hệ thống sẽ tự động load

### **❌ KHÔNG LÀM:**
```php
// ❌ Không cần require helper functions
require_once __DIR__ . '/some-helper.php';
require_once FONG_DE_LMS_PLUGIN_DIR . 'modules/helpers/my-helper.php';
```

### **✅ LÀM:**
```php
// ✅ Trực tiếp gọi function - autoload sẽ handle
$result = fong_some_helper_function($param);
$instance = new Fong_Some_Class();
```

## 🎯 PHP Doc Style - Minimal Approach

### **Core Principle: Keep Only Essentials**

**⚠️ QUAN TRỌNG:** File này có 2 chuẩn PHPDoc khác nhau:
1. **Regular Functions/Classes:** Minimal PHPDoc - chỉ description, @param, @return
2. **Helper Functions:** Extended PHPDoc - thêm @package, @subpackage, @since (để tích hợp với autoload system)

### **🔗 Advanced Tags - Chỉ Khi CẦN THIẾT**

Đối với các file **phức tạp có dependencies hoặc execution order quan trọng**, có thể sử dụng thêm:

#### **✅ @dependencies - Mô tả phụ thuộc:**
```php
/**
 * @dependencies
 * - fong-force-default-role-hook.php (chạy trước với priority 99)
 * - fong_initialize_user_learning_progress_on_registration() (autoloaded helper)
 */
```

#### **✅ @execution_order - Mô tả thứ tự thực thi:**
```php
/**
 * @execution_order
 * 1. fong-force-default-role-hook.php (priority 99) - gán role trước
 * 2. fong-user-registration-proficiency-assignment-hook.php (priority 100) - gán learning progress sau
 */
```

#### **🎯 Khi nào sử dụng Advanced Tags:**
- **Hook controllers** có dependencies phức tạp với nhau
- **AJAX endpoints** phụ thuộc vào helper functions cụ thể
- **Cronjob handlers** có thứ tự thực thi quan trọng
- **Module init files** có chain loading dependencies

#### **✅ CHÍNH THỨC:**
```php
/**
 * Brief description of function purpose
 * Detailed description in Vietnamese if needed
 * @param       type $param_name Description
 * @return      type Description
 */
```

#### **❌ KHÔNG DÙNG TAGS NÀY (trừ exceptions):**
```php
// ❌ Bỏ các tags verbose này trong function/class bình thường
@throws      
@related_files
@author
@version
@todo

// ⚠️ EXCEPTIONS được phép:
// @package, @subpackage, @since - CHỈ dành cho helper functions
// @dependencies, @execution_order - CHỈ khi thực sự cần thiết cho logic phức tạp
```

### **Ví Dụ Chuẩn:**

#### **✅ ĐÚNG - Regular Function (Minimal):**
```php
/**
 * Clear user learning progress (set to empty array)
 * Dùng cho user không phải free/paid để clear cây học liệu
 * @param       int $user_id User ID to clear progress
 * @return      bool True if cleared successfully
 */
function fong_clear_user_learning_progress(int $user_id): bool {
    if ($user_id <= 0) {
        throw new InvalidArgumentException('Invalid user ID provided.');
    }
    
    $progress_manager = new Fong_User_Progress_Data_Manager();
    $cleared = $progress_manager->update_progress_data($user_id, []);
    
    if (!$cleared) {
        throw new Exception('Failed to clear learning progress for user_id: ' . $user_id);
    }
    
    return true;
}
```

#### **✅ ĐÚNG - Complex Hook với Advanced Tags:**
```php
/**
 * Assign proficiency-based learning progress cho user mới register
 * Hook này chạy sau khi role đã được gán để đảm bảo proper learning progress structure
 *
 * @dependencies
 * - fong-force-default-role-hook.php (chạy trước với priority 99)
 * - fong_initialize_user_learning_progress_on_registration() (autoloaded helper)
 *
 * @execution_order
 * 1. fong-force-default-role-hook.php (priority 99) - gán role trước
 * 2. fong-user-registration-proficiency-assignment-hook.php (priority 100) - gán learning progress sau
 */
add_action('user_register', function(int $user_id): void {
    try {
        // Hook logic here...
        fong_initialize_user_learning_progress_on_registration($user_id);
    } catch (Throwable $e) {
        error_log('User registration proficiency assignment failed: ' . $e->getMessage());
    }
}, 100);
```

## 💭 Inline Comments

### **Core Principle: No Inline Comments**

#### **❌ KHÔNG LÀM:**
```php
// Set learning progress to empty array (không xóa metadata key)
$empty_progress = [];

// Re-throw để caller xử lý  
throw $e;

// Check if user exists before processing
if ($user_id <= 0) {
```

#### **✅ LÀM:**
```php
$empty_progress = [];
throw $e;
if ($user_id <= 0) {
```

### **Exception: Complex Business Logic**
Chỉ comment khi có logic phức tạp cần giải thích:
```php
// ✅ OK - Complex business logic needs explanation
$sync_user_ids = array_map('intval', $sync_users);
$clear_users = array_filter($all_users, function($user_id) use ($sync_user_ids) {
    return !in_array((int)$user_id, $sync_user_ids, true);
});
```

## 📋 Class Documentation

### **✅ Classes Follow Same Minimal Pattern:**
```php
/**
 * Manages user learning progress data operations
 * Handle CRUD operations cho fong_learning_progress metadata
 */
class Fong_User_Progress_Data_Manager {
```

### **✅ Class Methods:**
```php
/**
 * Get user learning progress data as array
 * @param       int $user_id User ID
 * @param       bool $use_cache Whether to use cache
 * @return      array Progress data array
 */
public function get_progress_data(int $user_id, bool $use_cache = true): array {
```

## 🚀 WordPress Hook Implementation Standards

### **Nguyên tắc chung:**

1. **Callback là Anonymous Function:** Mọi lời gọi `add_action` hoặc `add_filter` PHẢI truyền vào một anonymous function (closure) làm callback.

2. **Hooks đơn giản (logic xử lý ≤30 dòng):**
   - Toàn bộ logic nên được đặt trực tiếp bên trong anonymous function.
   - Mục đích: Tránh ô nhiễm global namespace và giữ logic gần với nơi nó được sử dụng.

```php
// Ví dụ hook đơn giản
add_action('init', function(): void {
    try {
        // Mã triển khai ngắn gọn (≤30 dòng)
        if (get_option('some_option') === 'value') {
            // do something
        }
    } catch (Throwable $e) {
        error_log($e->getMessage());
    }
});
```

### **⚠️ Anti-Pattern: Lỗi Thường Gặp Cần Tránh (KHÔNG LÀM THEO)**

```php
// 🚨 SAI - KHÔNG ĐƯỢC LÀM THEO CÁCH NÀY
// Lý do: Mặc dù kỹ thuật này vẫn sử dụng closure, nó không tuân thủ quy tắc 
// định nghĩa hàm trực tiếp bên trong lời gọi hook
$force_cskh_fep_permissions = function (bool $can, string $cap, int $id): bool {
    // ... logic ...
};
add_filter('fep_current_user_can', $force_cskh_fep_permissions, 20, 3);
```

**Cách làm đúng luôn là định nghĩa hàm trực tiếp trong `add_action` hoặc `add_filter`.**

3. **Hooks phức tạp (logic xử lý >30 dòng), bao gồm cả AJAX Hooks (`wp_ajax_*`):**
   - **BẮT BUỘC:** Callback cho `add_action('wp_ajax_...', ...)` hoặc các hook phức tạp khác vẫn PHẢI là một anonymous function.
   - Toàn bộ logic xử lý của hook PHẢI được đặt trực tiếp bên trong anonymous function này, bất kể độ dài.

```php
// Ví dụ AJAX Hook phức tạp (>30 dòng)
add_action('wp_ajax_my_complex_action', function(): void {
    // Bước 1: Kiểm tra Nonce
    if (!/* nonce valid */) {
        wp_send_json_error(['message' => 'Invalid nonce.'], 403);
        return;
    }

    // Bước 2: Lấy và sanitize input
    if (!/* input valid */) {
        wp_send_json_error(['message' => 'Invalid input.'], 400);
        return;
    }

    // Bước 3: Kiểm tra quyền (Capabilities)
    if (!/* user has permission */) {
        wp_send_json_error(['message' => 'Permission denied.'], 403);
        return;
    }

    // Bước 4: Thực thi logic chính
    try {
        // ... (Toàn bộ logic nghiệp vụ ở đây) ...
        $result = []; // Giả sử kết quả
        wp_send_json_success(['data' => $result]);
    } catch (Throwable $e) {
        error_log('AJAX Error in my_complex_action: ' . $e->getMessage());
        wp_send_json_error(['message' => 'An unexpected error occurred.'], 500);
    }
});
```

### **Tối Ưu Hook Cho AJAX Request Với `wp_doing_ajax()`**

Kiểm tra `if (wp_doing_ajax()) { return; }` ở đầu callback của một hook là một kỹ thuật hữu ích để ngăn chặn việc thực thi code không cần thiết trong quá trình xử lý AJAX request.

#### **Khi NÊN sử dụng `if (wp_doing_ajax()) { return; }`:**

1. **Với các hook hiển thị giao diện (UI-related hooks):**
   - **`admin_notices`**: Các thông báo admin thường không cần thiết trong AJAX response.
   - Các hook thêm meta box (`add_meta_boxes`), tùy chỉnh cột admin (`manage_{$post_type}_posts_columns`), hoặc các hook thay đổi giao diện chung.

2. **Khi logic của hook không phục vụ mục đích của AJAX request:**
   - Nếu hook thực hiện tác vụ nền (ghi log chi tiết, gửi email không khẩn cấp) không đóng góp vào dữ liệu AJAX request cần.

#### **Khi KHÔNG NÊN hoặc CẦN CÂN NHẮC KỸ:**

1. **Trong chính các AJAX action hooks (`wp_ajax_{your_action}`, `wp_ajax_nopriv_{your_action}`):**
   - Sẽ làm cho AJAX action không bao giờ chạy.

2. **Khi logic của hook cần thiết cho cả request thường và AJAX:**
   - Ví dụ: Hook kiểm tra quyền, chuẩn bị/làm sạch dữ liệu.

## 🔧 Function Exists Rules

### **⚠️ LƯU Ý QUAN TRỌNG: PHÂN BIỆT ĐỊNH NGHĨA và GỌI HÀM ⚠️**

### **1. KHI GỌI HÀM (CALLING): KHÔNG KIỂM TRA FUNCTION_EXISTS**

- **TUYỆT ĐỐI KHÔNG BAO GIỜ** kiểm tra `function_exists()` (hoặc `class_exists()`) khi GỌI bất kỳ hàm/class nào được định nghĩa bên trong plugin `fong_de_lms` hoặc theme `astra-child-deutschfuns`.
- **CHỈ VÀ LUÔN LUÔN** kiểm tra `function_exists()` (hoặc `class_exists()`) khi GỌI các hàm/class **bên ngoài**.

**Lý do:**
- Tất cả các hàm/class nội bộ quan trọng đều được autoload, việc kiểm tra `exists` là thừa thãi.
- Việc kiểm tra dư thừa làm giảm hiệu năng không cần thiết.
- Code sẽ gọn gàng và dễ đọc hơn khi tin tưởng vào hệ thống autoload nội bộ.

### **2. KHI ĐỊNH NGHĨA HÀM (DEFINING): KHÔNG KIỂM TRA FUNCTION_EXISTS (QUY TẮC MỚI)**

- **BỎ QUY TẮC CŨ:** Quy tắc cũ yêu cầu bọc helper function trong `if(!function_exists(...))` đã được loại bỏ.
- **QUY TẮC MỚI:** Mọi helper function phải được định nghĩa trực tiếp.

**Lý do (Fail-Fast & Simplicity):**
- **Phát hiện lỗi sớm (Fail-Fast):** Việc định nghĩa trực tiếp sẽ gây ra lỗi PHP Fatal Error ngay lập tức nếu có sự trùng lặp tên hàm.
- **Tin tưởng vào Autoloader:** Hệ thống autoloader của dự án được thiết kế để đảm bảo mỗi file chỉ được nạp một lần duy nhất.
- **Code Gọn Gàng:** Loại bỏ các khối `if` không cần thiết giúp code sạch và dễ đọc hơn.

### **Ví dụ Minh Họa (ĐÚNG vs SAI)**

#### **Ví dụ 1: Khi GỌI hàm nội bộ**

```php
// ✅ ĐÚNG: Không check exist với hàm/class nội bộ (autoloaded) khi GỌI
fong_debug('Debug message', $data);
fong_enqueue_module_script(...);
$manager = new Fong_LearnDash_Course_Progression_Manager();

// ❌ SAI: Check exist với hàm nội bộ khi GỌI
if (function_exists('fong_debug')) { // KHÔNG CẦN THIẾT!
    fong_debug('Debug message', $data);
}
```

#### **Ví dụ 2: Khi GỌI hàm bên ngoài**

```php
// ✅ ĐÚNG: Check exist với hàm/class bên ngoài hoặc không chắc chắn
if (function_exists('some_external_plugin_function')) {
    some_external_plugin_function();
}

// ❌ SAI: Gọi trực tiếp hàm bên ngoài mà không kiểm tra
some_external_plugin_function(); // Có thể gây lỗi nếu plugin không được active!
```

#### **Ví dụ 3: Khi ĐỊNH NGHĨA helper function**

```php
// ✅ ĐÚNG: Định nghĩa hàm helper trực tiếp
function fong_my_helper($param) {
    // Implementation
    return $result;
}

// ❌ SAI: Bọc định nghĩa trong function_exists() (Quy tắc cũ, đã loại bỏ)
if (!function_exists('fong_another_helper')) { 
    function fong_another_helper($param) {
        // Implementation
        return $result;
    }
}
```

## 📁 Helper Function Template

### **Mẫu File Helper Function PHP**

```php
<?php declare(strict_types=1); if (!defined('ABSPATH')) { exit; }

/**
 * [Mô tả chức năng của helper function]
 * Helper file is autoloaded, no need to be required.
 * @package     Fong_De_LMS
 * @subpackage  Helpers
 * @since       1.0.0
 * @param type $param Mô tả tham số
 * @return type Mô tả giá trị trả về
 */
function fong_example_helper(type $param): returnType {
    // Implementation
}
```

**Lưu ý về Template:**
- **Header một dòng (Compact Header):** Phần mở đầu `<?php declare(strict_types=1); if (!defined('ABSPATH')) { exit; }` phải luôn được viết gọn trên một dòng duy nhất.
- Tên file phải khớp chính xác với tên hàm bên trong + hậu tố `-helper.php`.
- Ví dụ: Hàm `fong_example_helper()` thì tên file là `fong_example_helper-helper.php`.
- Mỗi file chỉ chứa một helper function duy nhất.
- Hàm được viết không cần `function_exists` để đảm bảo phát hiện lỗi sớm nếu có xung đột.

## 🏗️ Development Standards - Strict Types

### **1. Yêu Cầu Cốt Lõi (20% Nội Dung Quan Trọng Nhất)**

#### **1.1 Cấu Trúc File & PHPDoc (Bắt Buộc)**

- **Header một dòng (Compact Header):** Phần mở đầu `<?php ...` phải luôn được viết gọn trên một dòng duy nhất.
- **PHPDoc súc tích:** Khối PHPDoc phải ngắn gọn, không chứa các dòng trống không cần thiết.

**Ví dụ chuẩn:**
```php
<?php declare(strict_types=1); if (!defined('ABSPATH')) { exit; }
/**
 * Initializes a pre-populated 'fong_learning_progress' template.
 * Generates a complete learning progress structure from LearnDash courses
 * and their content, ready to be filled with actual user progress.
 * @package    Fong_De_LMS
 * @subpackage LearnDash_Middleware\Helpers
 * @since      1.1.0
 * @param      bool       $use_cache         Whether to use transient cache. Defaults to true.
 * @param      int[]|null $target_course_ids Specific course IDs to process. If null, all are processed.
 * @return     array The structured learning progress template.
 */
```

#### **1.2 Quy Tắc Về Comment**

- **Code Tự Giải Thích (Self-Documenting Code):** Luôn cố gắng viết code rõ ràng, dễ hiểu thông qua việc đặt tên biến, hàm, và class một cách có ý nghĩa.
- **Ngắn Gọn & Cần Thiết:** Comment chỉ nên được sử dụng khi thực sự cần thiết để giải thích những logic phức tạp hoặc "tại sao" một đoạn code được viết theo cách đó.
- **Không Comment Thừa:** Tránh các comment giải thích những điều đã quá rõ ràng từ code.

#### **1.3 Yêu Cầu Về Function**

Khi thiết kế và viết hàm PHP, cần tuân thủ các nguyên tắc sau:

1. **Clean Code & Đơn Trách Nhiệm (Single Responsibility Principle - SRP):**
   - Mỗi hàm chỉ nên thực hiện **một việc duy nhất** và làm việc đó thật tốt.
   - Tên hàm phải rõ ràng, mô tả chính xác công việc hàm đó thực hiện.

2. **DRY (Don't Repeat Yourself):**
   - Tránh lặp lại code. Nếu một đoạn logic được sử dụng ở nhiều nơi, hãy tách nó ra thành một hàm riêng.
   - **Sử Dụng Công Cụ Tìm Kiếm Hàm Hiện Có:** Trước khi viết một hàm mới, hãy tìm kiếm xem có hàm nào tương tự đã tồn tại trong codebase hay không.

3. **SOLID Principles:** Áp dụng các nguyên tắc khác của SOLID khi thiết kế hàm và class để tăng tính linh hoạt và khả năng bảo trì của code.

4. **Hàm Nhỏ Gọn & Ít Tham Số:**
   - Ưu tiên các hàm nhỏ, dễ đọc và dễ hiểu. Tuân thủ giới hạn số dòng code cho mỗi hàm (≤30 dòng).
   - Hạn chế số lượng tham số truyền vào hàm (≤3 tham số). Nếu cần nhiều hơn, cân nhắc truyền vào một đối tượng (object) hoặc một mảng (array).

5. **Tránh Tác Dụng Phụ (Side Effects):** Nếu có thể, hàm nên trả về một giá trị dựa trên input của nó và không làm thay đổi trạng thái của hệ thống một cách ngầm định.

**Yêu cầu cơ bản:**
- Tối đa 30 dòng mỗi function
- Tối đa 2 cấp lồng nhau
- Sử dụng kiểu dữ liệu cho tham số và giá trị trả về
- Triển khai xử lý lỗi thích hợp

#### **1.4 Mẫu Xử Lý Lỗi**

```php
try {
    $result = processData($input);
} catch (InvalidArgumentException $e) {
    error_log(sprintf(
        'Error: %s in %s at line %d',
        $e->getMessage(),
        __FILE__,
        __LINE__
    ));
    return false;
} catch (Throwable $e) {
    error_log('Unexpected: ' . $e->getMessage());
    return null;
}
```

#### **1.5 Quy Tắc Helper Functions (Bắt Buộc)**

##### **1.5.1 Mỗi Helper Function Trong File Riêng**

- Mỗi helper function phải được đặt trong một file riêng biệt
- Sử dụng đúng chuẩn đặt tên: `{function-name}-helper.php`
- Helper files là autoloaded, không cần require thủ công

**Ví dụ:**
- Hàm `fong_process_data()` → File: `fong_process_data-helper.php`
- Hàm `fong_dquiz46_construct_questions_and_input()` → File: `fong_dquiz46_construct_questions_and_input-helper.php`

**Lưu ý:** Tên file PHẢI chứa toàn bộ tên hàm, bao gồm cả tiền tố (prefix) nếu có.

### **2. Triển Khai Hệ Thống Kiểu Dữ Liệu**

#### **2.1 Khai Báo Kiểu Dữ Liệu**

```php
// Kiểu dữ liệu cơ bản với union types và nullable types
function getData(int $id, ?string $name = null): array|false {
    // Triển khai
}
```

## 📂 File Naming Conventions

### **Nguyên Tắc Chung**

1. **Nhất quán**: Tuân thủ quy tắc đặt tên trong toàn bộ dự án
2. **Có ý nghĩa**: Tên file phải mô tả rõ chức năng, mục đích
3. **Tiền tố**: Luôn sử dụng tiền tố `fong-` hoặc `fong_` tùy loại file

### **1. Files Trong Thư Mục Controllers**

#### **1.1 Hook Controllers**

**Cấu trúc tên file:** Quy tắc đặt tên file hook phải bao gồm **tên hook nguyên bản** và **mô tả ngắn gọn chức năng**.

1. **Với Hook của WordPress & Hệ thống (Không có tiền tố `fong_`)**
   
   Thêm tiền tố `fong-` vào trước tên hook, giữ nguyên tên hook, và thêm mô tả.
   
   ```
   fong-{hook-name}-{description}-hook.php
   ```

   **Ví dụ:**
   - Hook `init`: `fong-init-prevent-access-hook.php`
   - Hook `wp_loaded`: `fong-wp_loaded-prevent-download-hook.php`
   - Hook `admin_menu`: `fong-admin_menu-add-new-page-hook.php`

2. **Với Hook tùy chỉnh của Fong (Có tiền tố `fong_`)**
   
   Giữ nguyên **toàn bộ tên hook đầy đủ** (bao gồm cả `fong_` và dấu `_`), sau đó thêm mô tả.
   
   ```
   {full-hook-name}-{description}-hook.php
   ```

   **Ví dụ:**
   - Hook: `fong_update_user_profile` → File: `fong_update_user_profile-validation-hook.php`
   - Hook: `fong_learndash_content_access` → File: `fong_learndash_content_access-control-hook.php`

#### **Quy tắc cốt lõi:**
- **Một Hook, Một File**: Mỗi file controller chỉ được chứa **DUY NHẤT MỘT** hook.
- **Tên File theo Hook**: Tên file phải mô tả chính xác hook mà nó xử lý theo quy tắc trên.

#### **1.2 AJAX Controllers**

```
{hook_name}.php
```

**Lưu ý quan trọng:**
- Đặt tên file theo chính xác hook name mà file xử lý
- Không cần thêm bất kỳ hậu tố nào

**Ví dụ:**
- `wp_ajax_fong_get_user_locations.php`
- `wp_ajax_fong_save_quiz.php`
- `wp_ajax_nopriv_fong_check_answers.php`

### **2. Files Trong Thư Mục Helpers**

#### **2.1 Helper Functions**

```
{function_name}-helper.php
```

**Quy tắc bắt buộc:**
- Tên file PHẢI CHÍNH XÁC với tên hàm bên trong + `-helper.php`
- Giữ nguyên tên hàm khi đặt tên file (bao gồm cả tiền tố `fong_` nếu có)
- Mỗi helper file chỉ chứa MỘT hàm duy nhất
- Tên hàm và tên file PHẢI KHỚP NHAU HOÀN TOÀN (trừ hậu tố `-helper.php`)

**Ví dụ:**

| Tên hàm                           | Tên file                                   |
| --------------------------------- | ------------------------------------------ |
| `fong_get_user_progress()`        | `fong_get_user_progress-helper.php`        |
| `fong_validate_quiz()`            | `fong_validate_quiz-helper.php`            |
| `fong_process_user_online_time()` | `fong_process_user_online_time-helper.php` |

### **3. Files Trong Thư Mục Classes**

```
{class_name}-class.php
```

**Lưu ý quan trọng:**
- Tên file phải khớp chính xác với tên class đầy đủ
- Đuôi file sử dụng kebab-case (`-class.php`)

**Ví dụ:**
- `Fong_Quiz_Manager-class.php` (chứa class `Fong_Quiz_Manager`)
- `Fong_User_Progress-class.php` (chứa class `Fong_User_Progress`)

### **4. Files Trong Thư Mục Templates**

```
fong-{template-name}-template.php
```

**Ví dụ:**
- `fong-quiz-display-template.php`
- `fong-user-dashboard-template.php`

## 🏗️ Directory Structure & File Placement

### **Cấu Trúc Thư Mục (Tổng quát)**

```
/includes/         # Chứa các file dùng chung cho toàn plugin (helpers, classes cốt lõi)
/modules/          # Chứa các module chức năng chính
  /{module-name}/   # Thư mục cho một module cụ thể
    /admin/         # Các file liên quan đến khu vực admin
    /public/        # Các file liên quan đến frontend
    /includes/      # Các file dùng chung trong module (helpers, classes...)
    init-{module-name}.php # File khởi tạo module
```

### **File Placement Guidelines: Helpers vs. Services**

#### **1. Thư mục `helpers/`**
- **Mục đích:** Chứa các file PHP định nghĩa các hàm tiện ích (helper functions), các hàm logic nghiệp vụ thuần túy, hoặc các class tiện ích có thể tái sử dụng.
- **Quan trọng:** Các file này **KHÔNG** trực tiếp xử lý các HTTP request như AJAX hoặc API endpoints.
- **Ví dụ vị trí:**
  - `wp-content/plugins/fong_de_lms/modules/{module-name}/includes/helpers/`
  - `wp-content/plugins/fong_de_lms/modules/{module-name}/src/helpers/`

#### **2. Thư mục `services/`**
- **Mục đích:** Chỉ dành riêng cho các file PHP đóng vai trò là điểm cuối (endpoints) xử lý các request bất đồng bộ của WordPress.
- **Ví dụ:**
  - Các AJAX actions (được đăng ký qua `wp_ajax_{action}` và `wp_ajax_nopriv_{action}`).
  - Các custom API endpoints (ví dụ: REST API custom routes hoặc các file PHP được gọi trực tiếp qua URL để cung cấp dịch vụ).
- **Đặc điểm:** Các file này thường chứa logic để nhận request, xử lý, và trả về response (thường là JSON).

#### **3. Tránh Đặt Sai Vị Trí**
- **TUYỆT ĐỐI KHÔNG** đặt các file PHP chỉ chứa logic hàm thông thường, không phải là AJAX/API handler, vào thư mục `services/`.

### **Quy Tắc Scan Thư Mục Chuyên Biệt (Bắt Buộc)**

Khi cần đặt một file mới vào một thư mục chuyên biệt (ví dụ: `controllers`, `helpers`, `services`, `models`), Lập Trình Viên (hoặc AI) **BẮT BUỘC** phải thực hiện các bước sau:

1. **Xác định loại file và tên thư mục quy ước:** Dựa trên chức năng của file, xác định tên thư mục chuyên biệt thường dùng.
2. **Scan các vị trí ưu tiên trong module hiện tại:**
   - Sử dụng công cụ `list_dir` để kiểm tra sự tồn tại của thư mục quy ước đó tại các vị trí sau:
     1. `src/` (ví dụ: `[module_path]/src/controllers/`)
     2. `includes/` (ví dụ: `[module_path]/includes/controllers/`)
     3. Thư mục gốc của module (ví dụ: `[module_path]/controllers/`)
3. **Sử dụng thư mục hiện có:** Nếu thư mục quy ước được tìm thấy ở bất kỳ vị trí nào ở trên, **PHẢI** sử dụng thư mục đó để đặt file mới.
4. **Trường hợp không tìm thấy thư mục:**
   - Nếu sau khi scan tất cả các vị trí ưu tiên mà không tìm thấy thư mục quy ước, **KHÔNG ĐƯỢC TỰ Ý TẠO MỚI**.
   - **PHẢI** báo cáo lại cho người dùng về tình trạng này và xin ý kiến chỉ đạo về vị trí đặt file hoặc quyết định tạo thư mục mới.

## 🔍 Autoload System Mapping

### **AUTOLOAD STRUCTURE OVERVIEW**

Dự án này sử dụng autoload system phức tạp với 3 tầng:

```
1. WordPress Core
    ↓
2. Main Plugin (fong_de_lms.php)  
    ↓
3. Bootstrap Layer (fong-directory-loader.php)
    ↓
4. Module Loader (fong-module-auto-loader.php)
    ↓
5. Target Files (*.php trong modules/*, includes/*)
```

### **AUTOLOAD DIRECTORIES**

Directory Loader tự động load từ:
```
wp-content/plugins/fong_de_lms/
├── includes/
│   ├── interfaces/          ← Auto-loaded
│   ├── constants/           ← Auto-loaded  
│   ├── classes/             ← Auto-loaded
│   ├── helpers/             ← Auto-loaded
│   ├── models-autoload/     ← Auto-loaded
│   └── functions/           ← Auto-loaded
├── config/                  ← Auto-loaded
├── fong-debug/              ← Auto-loaded
├── scheduled/               ← Auto-loaded
├── services/                ← Auto-loaded
└── modules/                 
    └── */init-module.php    ← Module Loader pattern
```

### **Module Loader patterns:**
```
modules/*/init-module.php files được auto-require bởi:
wp-content/plugins/fong_de_lms/includes/module-loaders/fong-module-auto-loader.php

Mỗi init-module.php tự load các files trong module:
modules/toan_mini_classroom/
├── init-module.php          ← Entry point
└── src/
    ├── autoload-controllers/ ← Loaded by init-module.php
    ├── autoload-models/      ← Loaded by init-module.php  
    ├── autoload-helpers/     ← Loaded by init-module.php
    └── templates/            ← Included on-demand
```

### **File Location → Loading Method:**

| **Path Pattern** | **Loading Method** | **Loaded By** |
|------------------|-------------------|---------------|
| `includes/helpers/*.php` | Directory autoload | fong-directory-loader.php |
| `includes/functions/*.php` | Directory autoload | fong-directory-loader.php |
| `fong-debug/*.php` | Directory autoload | fong-directory-loader.php |
| `modules/*/init-module.php` | Module pattern | fong-module-auto-loader.php |
| `modules/*/src/autoload-*/*.php` | Module require | init-module.php |
| `modules/*/src/templates/*.php` | On-demand include | Controllers |
| `bootstrap/*.php` | Direct require | fong_de_lms.php |

## 🚫 Safe PHP File Deactivation Guide

### **Mục đích**

Hướng dẫn cách **deactivate** (vô hiệu hóa) file PHP không dùng nữa một cách an toàn, đảm bảo **tương thích ngược** khi upgrade đè.

### **⚠️ Vấn đề khi xóa file PHP**

#### **Lỗi thường gặp:**
- **"Headers already sent"** - Khi file có giữ lại nhưng thiếu `<?php` hoặc để file trắng
- **"Function already declared"** - Khi có file mới và cũ cùng tồn tại 
- **"Class already declared"** - Tương tự với classes
- **404 hoặc Fatal Error** - Khi còn có require/include tham chiếu

#### **Nguyên nhân:**
```text
❌ KHÔNG AN TOÀN:
Local: Xóa file cũ → Push lên server  
Server: File cũ vẫn còn (do không sync sạch)
→ Lỗi: File mới + File cũ cùng chạy → Function/Class conflict

❌ KHÔNG AN TOÀN:  
Local: Để file trắng (không có <?php) → Push lên server
Server: File trắng → Headers already sent warning
→ Lỗi: Output trước khi WordPress init
```

### **✅ Nguyên tắc Deactivate An toàn**

#### **📋 Checklist bắt buộc:**
1. **✅ KHÔNG xóa file**
2. **✅ KHÔNG để file trắng** 
3. **✅ Giữ nguyên filename**
4. **✅ Phải có `<?php`**
5. **✅ Comment đơn giản nói rõ lý do**

#### **🎯 Lý do:**
- **Tương thích ngược**: Khi upgrade đè, file sẽ được overwrite thay vì conflict
- **Không lỗi syntax**: File vẫn valid PHP
- **Không output rác**: Không có echo/print ngoài ý muốn
- **Dễ debug**: Dev biết file đã deprecated và chuyển đi đâu
- **AI-friendly**: Changelog tracking dễ dàng hơn

### **📝 Template Deactivate chuẩn**

#### **Template tối thiểu (chỉ cần `<?php` + comment):**
```php
<?php
// depreciated -> /new/path/to/replacement-file.php
// Reason: [lý do ngắn gọn]
```

#### **Template chi tiết hơn:**
```php
<?php
// depreciated -> \wp-content\plugins\fong_de_lms\modules\new-module\src\controllers\new-endpoint.php

/**
 * Old Function Name - DEPRECATED
 *
 * DEPRECATED: File này đã được deprecated và chuyển về file mới.
 * 
 * NEW LOCATION: \wp-content\plugins\fong_de_lms\modules\new-module\src\controllers\new-endpoint.php
 * 
 * REASON: Module consolidation - Gộp nhiều endpoints thành 1 controller
 * 
 * MIGRATION: 
 * - Old URL: /?debug=old_function&key=xxx  
 * - New URL: /?debug=new_function&key=xxx
 *
 * @package     Fong_De_LMS
 * @subpackage  [Module_Name]
 * @deprecated  Since 1.2.0
 * @see         \wp-content\plugins\fong_de_lms\modules\new-module\src\controllers\new-endpoint.php
 */
```

#### **Template with WordPress safety (optional):**
```php
<?php
// depreciated -> \wp-content\plugins\fong_de_lms\includes\helpers\fong-user-helpers.php

declare(strict_types=1);

if (!defined('ABSPATH')) {
    exit; // Exit if accessed directly.
}

/**
 * Old User Helper - DEPRECATED
 *
 * Functions đã được chuyển về fong-user-helpers.php để tập trung hóa.
 *
 * @deprecated Since 1.3.0
 * @see \wp-content\plugins\fong_de_lms\includes\helpers\fong-user-helpers.php
 */
```

## 📊 Code Quality Metrics

### **Metrics Chất Lượng Code (Bắt Buộc)**

| Metric                | Giới hạn | Hành động yêu cầu         |
| --------------------- | -------- | ------------------------- |
| Số dòng code          | ≤30      | Phân tách function        |
| Kích thước file       | ≤200     | Phân tách file (Bắt buộc) |
| Cyclomatic Complexity | ≤5       | Cấu trúc lại logic        |
| Tham số đầu vào       | ≤3       | Sử dụng object parameter  |
| Cấp độ lồng nhau      | ≤2       | Tách function             |

### **Nguyên Tắc Thiết Kế Hàm (Function Design Principles)**

1. **Clean Code & Đơn Trách Nhiệm (Single Responsibility Principle - SRP):**
   - Mỗi hàm chỉ nên thực hiện **một việc duy nhất** và làm việc đó thật tốt.
   - Tên hàm phải rõ ràng, mô tả chính xác công việc hàm đó thực hiện.
   - Tránh các hàm "đa năng" xử lý quá nhiều logic không liên quan.

2. **DRY (Don't Repeat Yourself):**
   - Tránh lặp lại code. Nếu một đoạn logic được sử dụng ở nhiều nơi, hãy tách nó ra thành một hàm riêng.
   - **Sử Dụng Công Cụ Tìm Kiếm Hàm Hiện Có:** Trước khi viết một hàm mới, hãy tìm kiếm xem có hàm nào tương tự đã tồn tại trong codebase hay không.

3. **SOLID Principles:** Áp dụng các nguyên tắc khác của SOLID khi thiết kế hàm và class để tăng tính linh hoạt và khả năng bảo trì của code.

4. **Hàm Nhỏ Gọn:** Ưu tiên các hàm nhỏ, dễ đọc và dễ hiểu. Tuân thủ giới hạn số dòng code cho mỗi hàm (≤30 dòng).

5. **Ít Tham Số:** Hạn chế số lượng tham số truyền vào hàm (≤3 tham số).

6. **Tránh Tác Dụng Phụ (Side Effects):** Nếu có thể, hàm nên trả về một giá trị dựa trên input của nó và không làm thay đổi trạng thái của hệ thống một cách ngầm định.

### **Quản Lý Kích Thước File (Bắt Buộc)**

**QUY ĐỊNH BẮT BUỘC**: Mỗi file PHP không được vượt quá 200 dòng code (LOC). Nếu vượt quá, PHẢI phân tách file ngay lập tức.

Các cách tiếp cận để tuân thủ quy định:

1. **Phân tách chức năng (Bắt buộc)**:
   - Mỗi file chỉ chứa một chức năng chính
   - Các chức năng phụ trợ phải được tách thành file riêng
   - Sử dụng namespace để quản lý các file liên quan

2. **Trích xuất class (Bắt buộc)**:
   - Chuyển chức năng liên quan vào class chuyên dụng
   - Mỗi class trong file riêng
   - Tuân thủ nguyên tắc Single Responsibility

3. **Tổ chức module (Bắt buộc)**:
   - Nhóm các file liên quan trong thư mục con
   - Đặt tên thư mục rõ ràng theo chức năng
   - Sử dụng autoloader để quản lý dependencies

4. **Helper functions (Bắt buộc)**:
   - Mỗi helper function trong file riêng
   - Đặt tên file theo chuẩn: `{function_name}-helper.php` (giữ nguyên tên hàm + "-helper.php")
   - Sử dụng autoloader để load tự động

5. **Tách biệt cấu hình (Bắt buộc)**:
   - Chuyển cấu hình tĩnh sang file riêng
   - Sử dụng constants hoặc config array
   - Đặt trong thư mục config riêng

## 🧪 Production Code Preparation

### **Quy Tắc Chuẩn Bị Code PHP Cho Môi Trường Production**

**Mục tiêu:** Đảm bảo code PHP triển khai lên môi trường production được gọn gàng, dễ đọc, tập trung vào logic cốt lõi và loại bỏ các yếu tố không cần thiết.

### **I. Nguyên Tắc Chung**

1. **Ưu tiên Code Tự Giải Thích**: Hạn chế tối đa comment trong dòng (inline comments). Logic của code nên rõ ràng thông qua cách đặt tên biến, hàm, và cấu trúc code.
2. **Tối Giản Comment và Code Debug**: Chỉ giữ lại những comment thực sự cần thiết và có giá trị cao. Loại bỏ hoàn toàn các lời gọi hàm debug.

### **II. Quy Tắc Cụ Thể**

#### **1. Loại Bỏ Comment Không Cần Thiết**

- **Khối Comment Lớn**: Xóa bỏ hoàn toàn các khối comment lớn dùng để giải thích chi tiết về việc load các tiện ích debug.
- **Comment Giải Thích Thừa**: Loại bỏ các comment mô tả những bước logic đã quá rõ ràng trong code.

#### **2. Loại Bỏ Code Debug**

- **Xóa Lời Gọi Hàm Debug**: Loại bỏ tất cả các lời gọi đến các hàm debug nội bộ.
  - Cụ thể: Xóa các dòng code gọi `fong_debug(...)` và `fong_trace(...)`.
  - Mục đích: Đảm bảo không có thông tin debug nhạy cảm hoặc không cần thiết nào bị lộ ra hoặc ảnh hưởng đến hiệu năng trên môi trường production.

#### **3. Quản Lý Dòng Trắng**

- **Loại Bỏ Dòng Trắng Thừa**: Giảm thiểu các dòng trắng không cần thiết để code liền mạch và cô đọng hơn. Có thể giữ lại một dòng trắng để phân tách các khối logic lớn, nhưng tránh để nhiều dòng trắng liên tiếp.

#### **4. Chiến Lược Tài Liệu Hóa (Documentation)**

- **Giữ Lại PHPDoc Đầu File/Class/Function**:
  - Duy trì các khối PHPDoc (`/** ... */`) ở đầu mỗi file, class, và function/method.
  - Mục đích: Cung cấp thông tin tổng quan, mô tả tham số, kiểu trả về, và phục vụ cho việc sinh tài liệu tự động hoặc hỗ trợ từ IDE.
- **Giữ Lại "Logic/Pipeline Comment" Cuối File (Hoặc Khối Lớn)**:
  - Duy trì các comment mang tính chất tổng kết logic hoặc mô tả luồng xử lý (pipeline) chính của một file hoặc một khối chức năng quan trọng.

#### **5. Xử Lý Hàm Nội Bộ**

- **Không Kiểm Tra `function_exists` Cho Hàm Nội Bộ**:
  - Đối với việc gọi các hàm được định nghĩa trong cùng dự án (hàm nội bộ), không cần thiết phải kiểm tra sự tồn tại của hàm đó bằng `function_exists()`.
  - Lý do: Điều này ngầm định rằng code đã được kiểm thử và các thành phần nội bộ luôn có sẵn.

## 🔗 File Relationship Documentation

### **Hệ thống quản lý metadata mối quan hệ file**

Ngoài việc giữ documentation trong file, dự án sẽ duy trì metadata mối quan hệ file trong thư mục `.memory/file-relationships/`. Mỗi file PHP quan trọng sẽ có file metadata tương ứng.

#### **Tạo và cập nhật metadata file**

- Sử dụng trigger `-> generate relationship data for [file_path]` để tự động tạo/cập nhật metadata
- Cập nhật metadata khi có thay đổi về cấu trúc, import/require, hoặc thêm/sửa function quan trọng
- Định kỳ kiểm tra tính chính xác của metadata khi có refactor lớn

#### **Cấu trúc metadata file PHP**

```json
{
  "filePath": "path/to/your/file.php",
  "description": "Mô tả chức năng file",
  "lastModified": "YYYY-MM-DD",
  "version": "1.0.0",
  "status": "stable|draft|deprecated",
  "requires": [
    {
      "path": "path/to/required/file.php",
      "type": "require|include|require_once|include_once",
      "details": "Lý do file này cần file kia"
    }
  ],
  "usedBy": [
    {
      "path": "path/to/consumer/file.php",
      "elements": ["functionName", "ClassName"],
      "details": "File này sử dụng phần tử gì từ file hiện tại"
    }
  ],
  "hooks": [
    {
      "type": "action|filter",
      "name": "hook_name",
      "callback": "function_name",
      "priority": 10,
      "details": "Mục đích của hook này"
    }
  ],
  "dependencies": [
    {
      "type": "WordPress|LearnDash|External API",
      "name": "dependency_name",
      "details": "Cách sử dụng dependency này"
    }
  ],
  "relatedFiles": [
    {
      "path": "path/to/related/file.php",
      "relationship": "Mô tả mối quan hệ",
      "details": "Chi tiết thêm về mối quan hệ"
    }
  ]
}
```

### **Lợi ích của việc quản lý mối quan hệ file**

- **Dễ dàng refactor**: Xác định được ảnh hưởng khi thay đổi một file
- **Hiểu rõ dependency**: Phát hiện dependency cycles và tối ưu kiến trúc
- **Dễ debug và bảo trì**: Nhanh chóng tìm ra nguồn gốc vấn đề
- **Onboarding hiệu quả**: Giúp developer mới hiểu cấu trúc project nhanh hơn
- **Quản lý kỹ thuật tốt hơn**: Đánh giá chất lượng code và technical debt

## 🔍 Dependency Analysis Tools

### **Available Scripts for PHP Analysis**

#### **1. Complete Analysis:**
```bash
./tools/lsp-setup/php_complete_analyzer.sh "path/to/file.php"
```

#### **2. Autoload Tracing:**
```bash  
./tools/lsp-setup/php_autoload_tracer.sh "path/to/file.php"
```

#### **3. Quick Dependencies:**
```bash
./tools/lsp-setup/php_dependency_check.sh "path/to/file.php"
```

### **Fallback Commands**

Nếu scripts không work, dùng commands cơ bản:

#### **Syntax Check:**
```bash
php -l "file.php"
```

#### **Find Includes:**
```bash
grep -n "include\|require" "file.php"
```

#### **Find Functions:**
```bash
grep -nE "function\s+[a-zA-Z_]" "file.php"
```

#### **Find Classes:**
```bash
grep -nE "class\s+[a-zA-Z_]" "file.php"
```

#### **Trace Autoload Chain:**
```bash
# 1. Check main plugin
grep -n "require\|include" "wp-content/plugins/fong_de_lms/fong_de_lms.php"

# 2. Check directory loader
grep -A 20 "autoload_config" "wp-content/plugins/fong_de_lms/bootstrap/fong-directory-loader.php"

# 3. Check module loader  
grep -n "glob.*modules" "wp-content/plugins/fong_de_lms/includes/module-loaders/fong-module-auto-loader.php"

# 4. Check specific module init
grep -n "require\|include" "wp-content/plugins/fong_de_lms/modules/*/init-module.php"
```

## 🎯 Summary - UNIFIED STANDARDS

1. **NO require_once** - trust autoload system completely
2. **Triple PHPDoc Standards**: 
   - **Regular functions/classes**: Minimal (@param, @return only)
   - **Helper functions**: Extended (@package, @subpackage, @since)
   - **Complex hooks/files**: Advanced (@dependencies, @execution_order when needed)
3. **NO inline comments** - let code speak
4. **Vietnamese descriptions OK** - bilingual support
5. **Keep it clean** - less is more
6. **File size limit** - ≤200 lines per file (MANDATORY)
7. **Function size limit** - ≤30 lines per function
8. **Safe file deactivation** - never delete, always deprecate properly
9. **One hook per file** - strict controller organization
10. **Helper functions in separate files** - one function per file with exact naming: `{function_name}-helper.php`

## 🔧 Integration with Development Flow

- **Autoload system**: Handles all dependencies automatically
- **Code analysis**: Focus on logic, not verbose documentation  
- **Maintainability**: Clean, readable, self-documenting code
- **Performance**: No overhead from unnecessary requires
- **Quality metrics**: Enforce strict limits on file and function sizes
- **Production preparation**: Remove debug code and minimize comments
- **Relationship tracking**: Maintain metadata for complex dependencies