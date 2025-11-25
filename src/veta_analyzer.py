"""
VETA Analyzer Core Module
Phân tích văn bản đa ngôn ngữ (Anh-Việt) với OpenAI API
"""
import os
import json
from openai import OpenAI, RateLimitError, APIError
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# JSON schema for analysis output
JSON_SCHEMA = {
    "total_words": "int",
    "english_word_count": "int",
    "vietnamese_word_count": "int",
    "untranslatable_english_words": [
        {
            "word": "string (Từ tiếng Anh)",
            "reason": "string (Lý do không có thuật ngữ chuyên môn Việt tương đương)"
        }
    ],
    "mixed_language_analysis": "string (Tóm tắt tổng quan về cách ngôn ngữ được sử dụng)"
}


def get_openai_client() -> OpenAI | None:
    """Initialize OpenAI client with error handling"""
    try:
        return OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
    except Exception as e:
        print(f"Lỗi khởi tạo OpenAI Client: {e}")
        return None


def analyze_mixed_text(input_text: str, model: str = "gpt-4o-mini") -> dict:
    """
    Gọi OpenAI API để phân tích văn bản đa ngôn ngữ (Anh-Việt)

    Args:
        input_text: Văn bản cần phân tích
        model: OpenAI model (default: gpt-4o-mini)

    Returns:
        dict: Kết quả phân tích theo JSON schema
    """
    client = get_openai_client()
    if not client:
        return {"error": "OpenAI Client chưa được khởi tạo. Vui lòng kiểm tra API Key."}

    # Build system prompt
    system_prompt = (
        "Bạn là một chuyên gia phân tích ngôn ngữ Anh-Việt, chuyên xử lý code-switching "
        "và xác định các thuật ngữ chuyên môn tiếng Anh KHÔNG thể Việt hóa. "
        "Phải trả về kết quả dưới định dạng JSON hợp lệ, TUYỆT ĐỐI tuân theo JSON schema sau: "
        f"{json.dumps(JSON_SCHEMA, indent=2)}"
    )

    # Build user prompt
    user_prompt = (
        "Phân tích chuỗi văn bản sau: "
        f"'{input_text}'\n\n"
        "Đảm bảo đếm chính xác số từ tiếng Anh và tiếng Việt. Đặc biệt, liệt kê các từ tiếng Anh "
        "mà mô hình tin rằng không có thuật ngữ chuyên môn tiếng Việt thay thế tương đương "
        "(ví dụ: 'prompt engineering', 'blockchain', 'startup' trong một số ngữ cảnh chuyên môn)."
    )

    try:
        # Call OpenAI API with JSON mode
        response = client.chat.completions.create(
            model=model,
            messages=[
                {"role": "system", "content": system_prompt},
                {"role": "user", "content": user_prompt}
            ],
            response_format={"type": "json_object"}
        )

        # Parse JSON response
        json_string = response.choices[0].message.content
        return json.loads(json_string)

    except RateLimitError:
        return {"error": "Lỗi giới hạn tốc độ (Rate Limit Error). Vui lòng chờ và thử lại."}
    except APIError as e:
        return {"error": f"Lỗi API OpenAI: {e}"}
    except json.JSONDecodeError:
        return {"error": "Lỗi phân tích JSON. Mô hình không trả về JSON hợp lệ."}
    except Exception as e:
        return {"error": f"Lỗi không xác định: {e}"}
