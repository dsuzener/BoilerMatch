from fastapi import APIRouter, HTTPException
import json
import os
from .socket_handler import send_socket_message

router = APIRouter()

MESSAGE_FILE = "mock_data/messages.json"

@router.get("/messages/{user_id}")
async def get_messages(user_id: str):
    messages = load_messages()
    user_messages = [m for m in messages if m['sender_id'] == user_id or m['receiver_id'] == user_id]
    
    send_socket_message(f"Messages retrieved for user {user_id}")
    return user_messages

@router.post("/messages")
async def send_message(message_data: dict):
    messages = load_messages()
    message_data['id'] = str(len(messages) + 1)
    messages.append(message_data)
    save_messages(messages)
    
    send_socket_message(f"Message sent from {message_data['sender_id']} to {message_data['receiver_id']}")
    return {"message": "Message sent successfully"}

def load_messages():
    if not os.path.exists(MESSAGE_FILE):
        return []
    with open(MESSAGE_FILE, 'r') as f:
        return json.load(f)

def save_messages(messages):
    with open(MESSAGE_FILE, 'w') as f:
        json.dump(messages, f)
