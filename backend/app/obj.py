from datetime import datetime
from typing import List, Dict
from pydantic import BaseModel

# Enums (mapped to strings for JSON compatibility)
class Gender:
    Male = "Male"
    Female = "Female"
    Other = "Other"
    Unspecified = "Unspecified"

class SexualOrientation:
    Heterosexual = "Heterosexual"
    Homosexual = "Homosexual"
    Bisexual = "Bisexual"
    Other = "Other"
    Unspecified = "Unspecified"

class AccountStatus:
    Active = "Active"
    Suspended = "Suspended"
    Banned = "Banned"

# Sub-structures
class Location:
    def __init__(self, latitude: float, longitude: float):
        self.latitude = latitude
        self.longitude = longitude

    @classmethod
    def from_dict(cls, data: Dict) -> 'Location':
        return cls(data["latitude"], data["longitude"])

    def to_dict(self) -> Dict:
        return {"latitude": self.latitude, "longitude": self.longitude}

class MatchPreferences:
    def __init__(
        self,
        preferred_gender: str = Gender.Unspecified,
        min_age: int = 18,
        max_age: int = 100,
        max_distance: float = 10.0
    ):
        self.preferred_gender = preferred_gender
        self.min_age = min_age
        self.max_age = max_age
        self.max_distance = max_distance

    @classmethod
    def from_dict(cls, data: Dict) -> 'MatchPreferences':
        return cls(
            data.get("preferred_gender", Gender.Unspecified),
            data.get("min_age", 18),
            data.get("max_age", 100),
            data.get("max_distance", 10.0)
        )

    def to_dict(self) -> Dict:
        return {
            "preferred_gender": self.preferred_gender,
            "min_age": self.min_age,
            "max_age": self.max_age,
            "max_distance": self.max_distance
        }

class Settings:
    def __init__(
        self,
        notifications_enabled: bool = True,
        theme: str = "light",
        language: str = "en"
    ):
        self.notifications_enabled = notifications_enabled
        self.theme = theme
        self.language = language

    @classmethod
    def from_dict(cls, data: Dict) -> 'Settings':
        return cls(
            data.get("notifications_enabled", True),
            data.get("theme", "light"),
            data.get("language", "en")
        )

    def to_dict(self) -> Dict:
        return {
            "notifications_enabled": self.notifications_enabled,
            "theme": self.theme,
            "language": self.language
        }

# Main User Class
class User:
    def __init__(
        self,
        user_id: str,
        username: str,
        email: str,
        password_hash: str = "",
        verification_status: bool = False,
        full_name: str = "",
        age: int = 0,
        gender: str = Gender.Unspecified,
        sexual_orientation: str = SexualOrientation.Unspecified,
        bio: str = "",
        profile_pictures: List[str] = None,
        location: Location = None,
        campus_affiliation: str = "",
        interests: List[str] = None,
        match_preferences: MatchPreferences = None,
        gem_balance: int = 0,
        last_active: float = None,
        account_status: str = AccountStatus.Active,
        created_at: float = None,
        updated_at: float = None,
        settings: Settings = None,
        matches: List[str] = None,
        liked_profiles: List[str] = None,
        disliked_profiles: List[str] = None,
        chat_history_ids: List[str] = None
    ):
        self.user_id = user_id
        self.username = username
        self.email = email
        self.password_hash = password_hash
        self.verification_status = verification_status
        self.full_name = full_name
        self.age = age
        self.gender = gender
        self.sexual_orientation = sexual_orientation
        self.bio = bio
        self.profile_pictures = profile_pictures or []
        self.location = location or Location(0.0, 0.0)
        self.campus_affiliation = campus_affiliation
        self.interests = interests or []
        self.match_preferences = match_preferences or MatchPreferences()
        self.gem_balance = gem_balance
        self.last_active = last_active or datetime.now().timestamp()
        self.account_status = account_status
        self.created_at = created_at or datetime.now().timestamp()
        self.updated_at = updated_at or datetime.now().timestamp()
        self.settings = settings or Settings()
        self.matches = matches or []
        self.liked_profiles = liked_profiles or []
        self.disliked_profiles = disliked_profiles or []
        self.chat_history_ids = chat_history_ids or []

    @classmethod
    def from_dict(cls, data: Dict) -> 'User':
        return cls(
            user_id=data["user_id"],
            username=data["username"],
            email=data["email"],
            password_hash=data.get("password_hash", ""),
            verification_status=data.get("verification_status", False),
            full_name=data.get("full_name", ""),
            age=data.get("age", 0),
            gender=data.get("gender", Gender.Unspecified),
            sexual_orientation=data.get("sexual_orientation", SexualOrientation.Unspecified),
            bio=data.get("bio", ""),
            profile_pictures=data.get("profile_pictures", []),
            location=Location.from_dict(data.get("location", {})),
            campus_affiliation=data.get("campus_affiliation", ""),
            interests=data.get("interests", []),
            match_preferences=MatchPreferences.from_dict(data.get("match_preferences", {})),
            gem_balance=data.get("gem_balance", 0),
            last_active=data.get("last_active"),
            account_status=data.get("account_status", AccountStatus.Active),
            created_at=data.get("created_at"),
            updated_at=data.get("updated_at"),
            settings=Settings.from_dict(data.get("settings", {})),
            matches=data.get("matches", []),
            liked_profiles=data.get("liked_profiles", []),
            disliked_profiles=data.get("disliked_profiles", []),
            chat_history_ids=data.get("chat_history_ids", [])
        )

    def to_dict(self) -> Dict:
        return {
            "user_id": self.user_id,
            "username": self.username,
            "email": self.email,
            "password_hash": self.password_hash,
            "verification_status": self.verification_status,
            "full_name": self.full_name,
            "age": self.age,
            "gender": self.gender,
            "sexual_orientation": self.sexual_orientation,
            "bio": self.bio,
            "profile_pictures": self.profile_pictures,
            "location": self.location.to_dict(),
            "campus_affiliation": self.campus_affiliation,
            "interests": self.interests,
            "match_preferences": self.match_preferences.to_dict(),
            "gem_balance": self.gem_balance,
            "last_active": self.last_active,
            "account_status": self.account_status,
            "created_at": self.created_at,
            "updated_at": self.updated_at,
            "settings": self.settings.to_dict(),
            "matches": self.matches,
            "liked_profiles": self.liked_profiles,
            "disliked_profiles": self.disliked_profiles,
            "chat_history_ids": self.chat_history_ids
        }

class Message(BaseModel):
    sender: str
    content: str
    timestamp: datetime = datetime.now()

    def to_dict(self):
        return {
            "sender": self.sender,
            "content": self.content,
            "timestamp": self.timestamp.isoformat()
        }

    @classmethod
    def from_dict(cls, data: dict):
        return cls(
            sender=data["sender"],
            content=data["content"],
            timestamp=datetime.fromisoformat(data["timestamp"])
        )

# conversation Class
class Conversation:
    def __init__(self, chat_id: str, participants: List[str], messages: List[Message]):
        self.chat_id = chat_id
        self.participants = participants
        self.messages = messages

    @classmethod
    def from_dict(cls, data: Dict) -> 'Conversation':
        return cls(
            data["chat_id"],
            data["participants"],
            [Message.from_dict(msg) for msg in data["messages"]]
        )

    def to_dict(self) -> Dict:
        return {
            "chat_id": self.chat_id,
            "participants": self.participants,
            "messages": [msg.to_dict() for msg in self.messages]
        }
