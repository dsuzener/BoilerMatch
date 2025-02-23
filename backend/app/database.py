import json
import os
from typing import List, Dict, Any
from obj import User, Conversation


class MockDatabase:
    def __init__(self):
        self.data_dir = "mock_data"
        os.makedirs(self.data_dir, exist_ok=True)
        
        # Initialize collections
        self.users: List[User] = self._load_collection("user", User)
        self.conversations: List[Conversation] = self._load_collection("conversations", Conversation)

    def _load_collection(self, collection_name: str, model_class: Any) -> List[Any]:
        file_path = os.path.join(self.data_dir, f"{collection_name}.json")
        if not os.path.exists(file_path):
            return []
        with open(file_path, "r") as f:
            raw_data = json.load(f)
        return [model_class.from_dict(item) for item in raw_data]

    def _save_collection(self, collection_name: str, data: List[Any]):
        file_path = os.path.join(self.data_dir, f"{collection_name}.json")
        with open(file_path, "w") as f:
            json.dump([item.to_dict() for item in data], f, indent=2)

    # User Operations
    def find_user(self, query: Dict) -> User:
        for user in self.users:
            if all(getattr(user, key) == value for key, value in query.items()):
                return user
        return None

    def add_user(self, user: User):
        self.users.append(user)
        self._save_collection("users", self.users)

    def update_user(self, user_id: str, update_data: Dict) -> bool:
        for user in self.users:
            if user.user_id == user_id:
                for key, value in update_data.items():
                    setattr(user, key, value)
                self._save_collection("users", self.users)
                return True
        return False

    # Conversation Operations
    def find_conversation(self, chat_id: str) -> Conversation:
        for conv in self.conversations:
            if conv.chat_id == chat_id:
                return conv
        return None

    def add_conversation(self, conversation: Conversation):
        self.conversations.append(conversation)
        self._save_collection("conversations", self.conversations)

# Global Database Instance
db = MockDatabase()