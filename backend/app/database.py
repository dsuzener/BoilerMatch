import json
import os
from typing import List, Dict, Any

class MockDatabase:
    def __init__(self):
        self.data_dir = "mock_data"
        os.makedirs(self.data_dir, exist_ok=True)

    def _get_file_path(self, collection: str) -> str:
        return os.path.join(self.data_dir, f"{collection}.json")

    def _load_data(self, collection: str) -> List[Dict[str, Any]]:
        file_path = self._get_file_path(collection)
        if not os.path.exists(file_path):
            return []
        with open(file_path, 'r') as f:
            return json.load(f)

    def _save_data(self, collection: str, data: List[Dict[str, Any]]):
        file_path = self._get_file_path(collection)
        with open(file_path, 'w') as f:
            json.dump(data, f, indent=2)

    def find_one(self, collection: str, query: Dict[str, Any]) -> Dict[str, Any]:
        data = self._load_data(collection)
        return next((item for item in data if all(item.get(k) == v for k, v in query.items())), None)

    def find(self, collection: str, query: Dict[str, Any]) -> List[Dict[str, Any]]:
        data = self._load_data(collection)
        return [item for item in data if all(item.get(k) == v for k, v in query.items())]

    def insert_one(self, collection: str, document: Dict[str, Any]) -> str:
        data = self._load_data(collection)
        document['id'] = str(len(data) + 1)  # Simple ID generation
        data.append(document)
        self._save_data(collection, data)
        return document['id']

    def update_one(self, collection: str, query: Dict[str, Any], update: Dict[str, Any]) -> bool:
        data = self._load_data(collection)
        for item in data:
            if all(item.get(k) == v for k, v in query.items()):
                item.update(update)
                self._save_data(collection, data)
                return True
        return False

    def delete_one(self, collection: str, query: Dict[str, Any]) -> bool:
        data = self._load_data(collection)
        initial_length = len(data)
        data = [item for item in data if not all(item.get(k) == v for k, v in query.items())]
        if len(data) < initial_length:
            self._save_data(collection, data)
            return True
        return False

# Create a global instance of the mock database
db = MockDatabase()
