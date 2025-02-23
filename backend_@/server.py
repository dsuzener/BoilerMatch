from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from pydantic import BaseModel
from typing import Optional
from datetime import timedelta
from typing import List

from obj import User
from database import db  # Import mock database
from services.matching import MatchingService
from services.conversation import ConversationService
# Import existing auth functions
from auth import (
    get_password_hash,
    verify_password,
    create_access_token,
    get_current_user,
    ACCESS_TOKEN_EXPIRE_MINUTES
)


router = APIRouter()

# Pydantic models
class UserCreate(BaseModel):
    username: str
    email: str
    password: str
    full_name: Optional[str] = None

class UserResponse(BaseModel):
    username: str
    email: str
    full_name: Optional[str] = None

class Token(BaseModel):
    access_token: str
    token_type: str

# Auth endpoints
@router.post("/signup", response_model=UserResponse)
async def signup(user_data: UserCreate):
    # Check if user exists
    existing_user = db.find_user({"email": user_data.email})
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Create new user
    hashed_password = get_password_hash(user_data.password)
    new_user = User(
        user_id=str(len(db.users) + 1),
        username=user_data.username,
        email=user_data.email,
        password_hash=hashed_password,
        full_name=user_data.full_name,
        verification_status=False  # Add real verification later
    )
    
    db.add_user(new_user)
    return new_user

@router.post("/login", response_model=Token)
async def login(form_data: OAuth2PasswordRequestForm = Depends()):
    user = db.find_user({"email": form_data.username})
    if not user or not verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect email or password"
        )
    
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(
        data={"sub": user.email},
        expires_delta=access_token_expires
    )
    return {"access_token": access_token, "token_type": "bearer"}

# Protected endpoint example
@router.get("/me", response_model=UserResponse)
async def read_users_me(current_user: str = Depends(get_current_user)):
    user = db.find_user({"email": current_user})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user


#### Matching
class MatchResponse(BaseModel):
    user_id: str
    username: str
    age: int
    bio: str
    profile_pictures: List[str]
    distance_km: float

@router.get("/matches", response_model=List[MatchResponse])
async def get_potential_matches(
    current_user: User = Depends(get_current_user),
    limit: int = 100
):
    user = db.find_user({"email": current_user})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    raw_matches = MatchingService.find_potential_matches(user, limit)
    
    return [{
        "user_id": m.user_id,
        "username": m.username,
        "age": m.age,
        "bio": m.bio,
        "profile_pictures": m.profile_pictures,
        "distance_km": MatchingService._calculate_distance(user, m)
    } for m in raw_matches]


#### MESSAGING
# Add new Pydantic models
class MessageCreate(BaseModel):
    content: str
    receiver_id: str

class MessageResponse(BaseModel):
    message_id: str
    sender: str
    content: str
    timestamp: str
    read: bool

class ConversationResponse(BaseModel):
    chat_id: str
    participants: List[str]
    last_message: Optional[MessageResponse]

# Conversation endpoints
@router.post("/conversations", response_model=ConversationResponse)
async def start_conversation(
    message_data: MessageCreate,
    current_user: str = Depends(get_current_user)
):
    user = db.find_user({"email": current_user})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    # Check receiver exists
    receiver = db.find_user({"user_id": message_data.receiver_id})
    if not receiver:
        raise HTTPException(status_code=404, detail="Receiver not found")

    # Start or get existing conversation
    conv = ConversationService.start_conversation(user.user_id, message_data.receiver_id)
    
    # Send initial message if content provided
    if message_data.content:
        message = ConversationService.send_message(
            conv.chat_id,
            user.user_id,
            message_data.content
        )
        
    return {
        "chat_id": conv.chat_id,
        "participants": conv.participants,
        "last_message": message if message_data.content else None
    }

@router.post("/conversations/{chat_id}/messages", response_model=MessageResponse)
async def send_message(
    chat_id: str,
    message_data: MessageCreate,
    current_user: str = Depends(get_current_user)
):
    user = db.find_user({"email": current_user})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    try:
        message = ConversationService.send_message(
            chat_id,
            user.user_id,
            message_data.content
        )
        return message
    except ValueError:
        raise HTTPException(status_code=404, detail="Conversation not found")
    except PermissionError:
        raise HTTPException(status_code=403, detail="Not part of conversation")

@router.get("/conversations", response_model=List[ConversationResponse])
async def list_conversations(current_user: str = Depends(get_current_user)):
    user = db.find_user({"email": current_user})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    conversations = ConversationService.list_user_conversations(user.user_id)
    
    response = []
    for conv in conversations:
        last_message = conv.messages[-1] if conv.messages else None
        response.append({
            "chat_id": conv.chat_id,
            "participants": conv.participants,
            "last_message": last_message
        })
        
    return response

@router.get("/conversations/{chat_id}", response_model=List[MessageResponse])
async def get_conversation_history(
    chat_id: str,
    current_user: str = Depends(get_current_user)
):
    user = db.find_user({"email": current_user})
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
        
    try:
        messages = ConversationService.get_conversation_history(user.user_id, chat_id)
        return messages
    except ValueError:
        raise HTTPException(status_code=404, detail="Conversation not found")
    except PermissionError:
        raise HTTPException(status_code=403, detail="Unauthorized access")