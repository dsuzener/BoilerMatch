from fastapi import APIRouter, HTTPException
import json
import os
from .socket_handler import send_socket_message

router = APIRouter()

PROFILE_FILE = "mock_data/profiles.json"

@router.get("/profiles/{user_id}")
async def get_profile(user_id: str):
    profiles = load_profiles()
    profile = next((p for p in profiles if p['user_id'] == user_id), None)
    
    if not profile:
        raise HTTPException(status_code=404, detail="Profile not found")
    
    send_socket_message(f"Profile retrieved for user {user_id}")
    return profile

@router.post("/profiles")
async def create_profile(profile_data: dict):
    profiles = load_profiles()
    
    if any(p['user_id'] == profile_data['user_id'] for p in profiles):
        raise HTTPException(status_code=400, detail="Profile already exists")
    
    profiles.append(profile_data)
    save_profiles(profiles)
    
    send_socket_message(f"Profile created for user {profile_data['user_id']}")
    return {"message": "Profile created successfully"}

@router.put("/profiles/{user_id}")
async def update_profile(user_id: str, profile_data: dict):
    profiles = load_profiles()
    profile_index = next((i for i, p in enumerate(profiles) if p['user_id'] == user_id), None)
    
    if profile_index is None:
        raise HTTPException(status_code=404, detail="Profile not found")
    
    profiles[profile_index] = {**profiles[profile_index], **profile_data}
    save_profiles(profiles)
    
    send_socket_message(f"Profile updated for user {user_id}")
    return {"message": "Profile updated successfully"}

def load_profiles():
    if not os.path.exists(PROFILE_FILE):
        return []
    with open(PROFILE_FILE, 'r') as f:
        return json.load(f)

def save_profiles(profiles):
    with open(PROFILE_FILE, 'w') as f:
        json.dump(profiles, f)
