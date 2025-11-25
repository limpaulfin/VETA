# Mem0 API Direct Usage Guide

**Version**: 2025-10-20  
**Maintainers**: Fong & Codex CLI  
**Scope**: Operate mem0.ai memories via raw REST calls (no shell wrappers).

---

## 1. Authentication & Base Endpoints

- **Base URL**: `https://api.mem0.ai`
- **Auth header**: `Authorization: Token m0-J3CpMHULXA7lBMUTElyEDzgngIlnvovFqIFN8gjS`
- **Content-Type**: `application/json`
- **Verified status (2025-10-20)**  
  - `POST /v1/memories/` → ✅ working (create memory)  
  - `POST /v2/memories/search/` → ✅ working (semantic search; filters required)  
  - `DELETE /v1/memories/{id}/` → ✅ working (single delete, trailing slash mandatory)  
  - `PATCH /v1/memories/{id}/` → 405 Method Not Allowed  
  - `PUT /v1/memories/batch/` → 400 “memory_id should be a valid UUID” (treat as broken)  
  - `DELETE /v1/memories/batch/`, history/export/feedback routes → 404/405 (unsupported)

> Only **add**, **search**, and **delete** are production-ready today. Prefer delete + re-add when content changes.

---

## 2. User ID Naming Convention

Use the project directory name (lowercase, slashes → dashes) as `user_id`.

| Project Path | Derived `user_id` |
|--------------|-------------------|
| `/home/fong/Projects/MCPs` | `mcps` |
| `/home/fong/Projects/qtdnd-duythanh` | `qtdnd-duythanh` |
| `/home/fong/Projects/foo/bar` | `foo-bar` |

Nếu đang làm việc trong `/home/fong/Projects/MCPs`, dùng thẳng `user_id = "mcps"`. Với repo khác, chỉ cần lấy tên thư mục gốc rồi chuyển thành chữ thường, thay mọi dấu gạch chéo bằng gạch ngang (ví dụ `/home/fong/Projects/foo/bar` → `foo-bar`).

---

## 3. `curl` Recipes (dùng giá trị cụ thể)

### 3.1 Add Memory (`POST /v1/memories/`)

```bash
curl -sS -X POST https://api.mem0.ai/v1/memories/ \
  -H "Authorization: Token m0-J3CpMHULXA7lBMUTElyEDzgngIlnvovFqIFN8gjS" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "user", "content": "Codex CLI revalidated add/search/delete on 2025-10-20"}
    ],
    "user_id": "mcps",
    "metadata": {
      "source": "codex-cli",
      "project_path": "/home/fong/Projects/MCPs",
      "timestamp": "2025-10-20T06:50:00Z"
    }
  }'
```

**Response shape**: array of events. If you get `[]`, immediately run search to confirm creation (memories still persist).

---

### 3.2 Search Memories (`POST /v2/memories/search/`)

```bash
curl -sS -X POST https://api.mem0.ai/v2/memories/search/ \
  -H "Authorization: Token m0-J3CpMHULXA7lBMUTElyEDzgngIlnvovFqIFN8gjS" \
  -H "Content-Type: application/json" \
  -d '{
    "query": "add/search/delete verification 2025-10-20",
    "filters": {
      "OR": [
        {"user_id": "mcps"}
      ]
    },
    "limit": 5
  }'
```

- `filters.OR` must contain at least one constraint (`user_id` or `session_id`), else the API rejects the call.
- Response is an array of memory objects (`id`, `memory`, `metadata`, `categories`, `structured_attributes`, `score`).

---

### 3.3 Delete Memory (`DELETE /v1/memories/{id}/`)

```bash
curl -sS -X DELETE https://api.mem0.ai/v1/memories/REPLACE_WITH_ID/ \
  -H "Authorization: Token m0-J3CpMHULXA7lBMUTElyEDzgngIlnvovFqIFN8gjS"
```

- Trailing `/` required or mem0 responds `301`.
- Response: `{ "message": "Memory deleted successfully!" }`

---

## 5. Troubleshooting Notes (2025-10-20)

- Update requests (`PATCH`) are blocked; prefer delete + fresh add.
- Batch update/delete return validation errors despite valid UUIDs (mem0 bug). Avoid until fixed.
- History/export/feedback endpoints return 404/405 in production environment.
- Always use `Authorization: Token …` (not `Bearer`).
- If search produces zero results, verify `user_id` spelling (lowercase, hyphenated).

---

## 6. Workflow Checklist

1. Determine `MEM0_USER_ID` from project/repo name.  
2. After each significant change, call **add** với cú pháp curl phía trên (giữ nguyên API key & `user_id`).  
3. Verify persistence bằng **search**; lưu lại ID từ response nếu cần xoá.  
4. Remove obsolete memories via **delete** dùng đúng Authorization header.  
5. Log API anomalies or format changes to `.fong/.memory/` and notify via git history.

---

## 7. References

- API keys: https://app.mem0.ai/dashboard/api-keys  
- Captured docs snapshot: `/home/fong/Projects/web-dom-capture-chrome-extension/captured_doms/dom_2025-10-20_13-45-12-153204.html`  
- Historical learnings: `smart-search-fz-rg-bm25 "mem0" .fong/.memory/ --show-content` (fallback: `rg "mem0" .fong/.memory`)

This file is the single source of truth for mem0 usage in MCP projects. Update immediately if mem0 stabilises new endpoints or response formats.
