from fastapi import APIRouter, HTTPException
import json
import os
from .socket_handler import send_socket_message

router = APIRouter()

MATCH_FILE = "mock_data/matches.json"

@router.get("/matches/{user_id}")
async def get_matches(user_id: str):
    matches = load_matches()
    user_matches = [m for m in matches if m['user1_id'] == user_id or m['user2_id'] == user_id]
    
    send_socket_message(f"Matches retrieved for user {user_id}")
    return user_matches

@router.post("/matches")
async def create_match(match_data: dict):
    matches = load_matches()
    matches.append(match_data)
    save_matches(matches)
    
    send_socket_message(f"Match created between {match_data['user1_id']} and {match_data['user2_id']}")
    return {"message": "Match created successfully"}

@router.put("/matches/{match_id}")
async def update_match_status(match_id: str, status_data: dict):
    matches = load_matches()
    match_index = next((i for i, m in enumerate(matches) if m['id'] == match_id), None)
    
    if match_index is None:
        raise HTTPException(status_code=404, detail="Match not found")
    
    matches[match_index]['status'] = status_data['status']
    save_matches(matches)
    
    send_socket_message(f"Match status updated for match {match_id}")
    return {"message": "Match status updated successfully"}

def load_matches():
    if not os.path.exists(MATCH_FILE):
        return []
    with open(MATCH_FILE, 'r') as f:
        return json.load(f)

def save_matches(matches):
    with open(MATCH_FILE, 'w') as f:
        json.dump(matches, f)
