# filename: local_openwebui_proxy.py
from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

OLLAMA_URL = "http://localhost:11434/api/generate"

@app.route("/api/v1/chat/completions", methods=["POST"])
def chat_completions():
    data = request.json
    model = data.get("model", "mistral:latest")
    messages = data.get("messages", [])
    knowledge = data.get("knowledge", [])  # 保留欄位，但目前不處理

    # 將 messages 合併成 prompt
    conversation = ""
    for msg in messages:
        role = msg.get("role", "")
        content = msg.get("content", "")
        conversation += f"{role}: {content}\n"
    
    # 拼出最終 prompt
    prompt = f"{conversation.strip()}\n請依照上述對話回答。"

    # 呼叫 Ollama
    payload = {
        "model": model,
        "prompt": prompt,
        "stream": False
    }

    res = requests.post(OLLAMA_URL, json=payload)
    result = res.json()
    content = result.get("response", "")

    # 模擬 OpenWebUI 格式
    return jsonify({
        "id": "chatcmpl-local",
        "object": "chat.completion",
        "choices": [
            {
                "index": 0,
                "message": {"role": "assistant", "content": content},
                "finish_reason": "stop"
            }
        ]
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=3000)