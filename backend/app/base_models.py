from pydantic import BaseModel
from typing import Optional, List, Literal
import datetime

class LoginRequest(BaseModel):
    username: str
    password: str

class SignupRequest(BaseModel):
    username: str
    email: str
    password: str

class Token(BaseModel):
    access_token: str

# Pydantic models for update requests
class LocationUpdate(BaseModel):
    latitude: float
    longitude: float

class MatchPreferencesUpdate(BaseModel):
    preferred_gender: Optional[Literal["Male", "Female", "Other", "Unspecified"]] = None
    min_age: Optional[int] = None
    max_age: Optional[int] = None
    max_distance: Optional[float] = None

class SettingsUpdate(BaseModel):
    notifications_enabled: Optional[bool] = None
    theme: Optional[str] = None
    language: Optional[str] = None

class UserUpdateRequest(BaseModel):
    username: Optional[str] = None
    email: Optional[str] = None
    full_name: Optional[str] = None
    age: Optional[int] = None
    gender: Optional[Literal["Male", "Female", "Other", "Unspecified"]] = None
    sexual_orientation: Optional[Literal["Heterosexual", "Homosexual", "Bisexual", "Other", "Unspecified"]] = None
    bio: Optional[str] = None
    profile_pictures: Optional[List[str]] = None
    location: Optional[LocationUpdate] = None
    campus_affiliation: Optional[str] = None
    interests: Optional[List[str]] = None
    match_preferences: Optional[MatchPreferencesUpdate] = None
    settings: Optional[SettingsUpdate] = None