# Add this login endpoint above your existing routers
from fastapi import APIRouter, HTTPException, status
from auth import hash_password
from base_models import LoginRequest, SignupRequest, Token

from database import db
from obj import User
from matching import MatchingService

api_router = APIRouter()

@api_router.post("/login")
async def login(credentials: LoginRequest):
    print(f"Login attempt: {credentials.username} / {credentials.password}")
    if db.find_user({"username": credentials.username, "password_hash": credentials.password}):
        return {"token": credentials.username}

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

@api_router.post("/signup")
async def signup(user_data: SignupRequest):
    print(f"Signup attempt: {user_data.username} / {user_data.email} / {user_data.password}")
    existing_user = db.find_user({"email": user_data.email})

    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered",
            headers={"WWW-Authenticate": "Bearer"},
        )
    
    # Create new user
    new_user = User(
        user_id=str(len(db.users) + 1),
        username=user_data.username,
        email=user_data.email,
        password_hash=user_data.password,
        # full_name=user_data.full_name,
        verification_status=False  # Add real verification later
    )
    
    db.add_user(new_user)
    return {"token": user_data.username}

# @api_router.get("/feed")
# async def feed_users(token: Token):
#     matched_users = MatchingService.find_potential_matches(token.access_token)

#     return [user.to_dict for user in matched_users]

from fastapi import APIRouter, Depends, Header, HTTPException

api_router = APIRouter()

@api_router.get("/feed")
async def feed_users(authorization: str = Header(...)):
    # The `authorization` header contains the username
    username = authorization  # Extract username from the Authorization header
    if not username:
        raise HTTPException(status_code=400, detail="Authorization header is missing")
    
    # Use the username to find potential matches
    user = db.find_user({"username": username})
    matched_users = MatchingService.find_potential_matches(user)
    return [user.to_dict for user in matched_users]
