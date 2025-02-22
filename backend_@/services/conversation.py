from datetime import datetime
from typing import List
import json

from database import db
from obj import Conversation
from services.connection import manager


class ConversationService:
    @staticmethod
    def start_conversation(sender_id: str, receiver_id: str) -> Conversation:
        """Create a new conversation between two users"""
        # Check if conversation already exists
        existing = next(
            (conv for conv in db.conversations 
             if set(conv.participants) == {sender_id, receiver_id}),
            None
        )
        if existing:
            return existing
            
        new_conv = Conversation(
            chat_id=str(len(db.conversations) + 1),
            participants=[sender_id, receiver_id],
            messages=[]
        )
        db.add_conversation(new_conv)
        return new_conv

    @staticmethod
    async def send_message(chat_id: str, sender_id: str, content: str) -> dict:
        """Add a message to an existing conversation"""
        conv = db.find_conversation(chat_id)
        if not conv:
            raise ValueError("Conversation not found")
            
        if sender_id not in conv.participants:
            raise PermissionError("User not in conversation")
            
        message = {
            "message_id": str(len(conv.messages) + 1),
            "sender": sender_id,
            "content": content,
            "timestamp": datetime.now().isoformat(),
            "read": False
        }
        conv.messages.append(message)
        db._save_collection("conversations", db.conversations)

        # Broadcast to all conversation participants
        for participant in conv.participants:
            if participant != sender_id:  # Don't send to self
                await manager.send_personal_message(
                    json.dumps(message),
                    participant
                )

        return message

    @staticmethod
    def get_conversation_history(user_id: str, chat_id: str) -> List[dict]:
        """Get message history for a conversation"""
        conv = db.find_conversation(chat_id)
        if not conv:
            raise ValueError("Conversation not found")
            
        if user_id not in conv.participants:
            raise PermissionError("Unauthorized access")
            
        return conv.messages

    @staticmethod
    def list_user_conversations(user_id: str) -> List[Conversation]:
        """Get all conversations for a user"""
        return [conv for conv in db.conversations if user_id in conv.participants]