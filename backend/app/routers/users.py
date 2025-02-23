from fastapi import APIRouter, HTTPException
import json
import os
from .socket_handler import send_socket_message

router = APIRouter()

USER_FILE = "mock_data/users.json"

@router.post("/users/register")
async def register_user(user_data: dict):
    # Load existing users
    users = load_users()
    
    # Check if user already exists
    if any(u['email'] == user_data['email'] for u in users):
        raise HTTPException(status_code=400, detail="Email already registered")
    
    # Add new user
    user_data['id'] = str(len(users) + 1)
    users.append(user_data)
    
    # Save updated users
    save_users(users)
    
    send_socket_message("User registered")
    return {"message": "User registered successfully"}

@router.post("/users/login")
async def login_user(login_data: dict):
    users = load_users()
    user = next((u for u in users if u['email'] == login_data['email'] and u['password'] == login_data['password']), None)
    
    if not user:
        raise HTTPException(status_code=400, detail="Invalid credentials")
    
    send_socket_message("User logged in")
    return {"message": "Login successful", "user_id": user['id']}

def load_users():
    if not os.path.exists(USER_FILE):
        return []
    with open(USER_FILE, 'r') as f:
        return json.load(f)

def save_users(users):
    with open(USER_FILE, 'w') as f:
        json.dump(users, f)
