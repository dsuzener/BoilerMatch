from pydantic import BaseModel, EmailStr
from typing import List, Optional
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    name: str

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: str
    created_at: datetime

class ProfileBase(BaseModel):
    bio: str
    interests: List[str]
    photos: List[str]

class ProfileCreate(ProfileBase):
    user_id: str

class Profile(ProfileBase):
    id: str
    user_id: str

class MatchBase(BaseModel):
    user1_id: str
    user2_id: str

class MatchCreate(MatchBase):
    pass

class Match(MatchBase):
    id: str
    created_at: datetime
    status: str

class MessageBase(BaseModel):
    content: str

class MessageCreate(MessageBase):
    sender_id: str
    receiver_id: str

class Message(MessageBase):
    id: str
    sender_id: str
    receiver_id: str
    timestamp: datetime

