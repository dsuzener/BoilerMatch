# Add this login endpoint above your existing routers
from fastapi import APIRouter, HTTPException, status, Header, Body
from datetime import datetime

from database import db
from obj import User, Conversation, Message, Location, MatchPreferences, Settings
from matching import MatchingService
from auth import hash_password
from base_models import LoginRequest, SignupRequest, UserUpdateRequest

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

@api_router.get("/feed")
async def feed_users(authorization: str = Header(...)):
    # The `authorization` header contains the username
    username = authorization  # Extract username from the Authorization header
    if not username:
        raise HTTPException(status_code=400, detail="Authorization header is missing")
    
    # Use the username to find potential matches
    user = db.find_user({"username": username})
    matched_users = MatchingService.find_potential_matches(user)
    return [user.to_dict() for user in matched_users]

@api_router.post("/like")
async def match_request(sender: str = Header(...), receiver: str = Header(...)):
    # The `authorization` header contains the username
    if not sender:
        raise HTTPException(status_code=400, detail="sender header is missing")
    if not receiver:
        raise HTTPException(status_code=400, detail="receiver header is missing")
    
    # Use the username to find potential matches
    sender_obj = db.find_user({"username": sender})
    receiver_obj = db.find_user({"username": receiver})
    if not sender_obj:
        raise HTTPException(status_code=404, detail="sender not found")
    if not receiver_obj:
        raise HTTPException(status_code=404, detail="receiver not found")

    receiver_obj.liked_profiles.append(sender)
    status = "continue"

    # match!
    if receiver in sender_obj.liked_profiles:
        sender_obj.matches.append(receiver)
        receiver_obj.matches.append(receiver)
        status = "MATCH!"

    db._save_collection("user", db.users)

    return status

@api_router.get("/matches")
async def matched_users(authorization: str = Header(...)):
    # The `authorization` header contains the username
    username = authorization  # Extract username from the Authorization header
    if not username:
        raise HTTPException(status_code=400, detail="Authorization header is missing")
    
    # Use the username to find potential matches
    user = db.find_user({"username": username})
    if not user:
        raise HTTPException(status_code=404, detail="user not found")
    return MatchingService._matched_users(user)

# Message sending endpoint
@api_router.post("/conversation/send")
async def send_message(
    message_content: str = Body(..., embed=True),
    sender: str = Header(...),
    receiver: str = Header(...)
):
    # Validate headers
    if not sender:
        raise HTTPException(400, "sender header missing")
    if not receiver:
        raise HTTPException(400, "receiver header missing")

    # Find users
    sender_obj = db.find_user({"username": sender})
    receiver_obj = db.find_user({"username": receiver})

    if not sender_obj or not receiver_obj:
        raise HTTPException(404, "User not found")

    # Check match status
    if receiver not in sender_obj.matches or sender not in receiver_obj.matches:
        raise HTTPException(403, "Users must be matched to message")

    # Create consistent chat ID
    participants = sorted([sender, receiver])
    chat_id = "_".join(participants)

    # Find or create conversation
    conversation = db.find_conversation(chat_id)
    if not conversation:
        conversation = Conversation(
            chat_id=chat_id,
            participants=participants,
            messages=[]
        )
        db.add_conversation(conversation)

    # Create and add message
    new_message = Message(
        sender=sender,
        content=message_content,
        timestamp=datetime.now()
    )
    conversation.messages.append(new_message)
    
    # Save updated conversation
    db._save_collection("conversations", db.conversations)

    return {"status": "Message sent", "message": new_message.to_dict()}

# Message history endpoint
@api_router.get("/conversation/history")
async def get_message_history(
    authorization: str = Header(...),
    other_user: str = Header(...),
    limit: int = 100,
    offset: int = 0
):
    # Validate headers
    if not authorization or not other_user:
        raise HTTPException(400, "Missing required headers")

    # Get current user
    current_user = db.find_user({"username": authorization})
    other_user_obj = db.find_user({"username": other_user})

    if not current_user or not other_user_obj:
        raise HTTPException(404, "User not found")

    # Check match status
    if other_user not in current_user.matches:
        raise HTTPException(403, "Users must be matched to view history")

    # Create chat ID
    participants = sorted([authorization, other_user])
    chat_id = "_".join(participants)

    # Get conversation
    conversation = db.find_conversation(chat_id)
    if not conversation:
        return {"messages": [], "total": 0}

    # Paginate messages
    total_messages = len(conversation.messages)
    paginated_messages = conversation.messages[offset:offset+limit]

    return {
        "messages": [msg.to_dict() for msg in paginated_messages],
        "total": total_messages,
        "limit": limit,
        "offset": offset
    }

# user update
@api_router.put("/users/{user_id}/profile")
async def update_user_profile(
    update_data: UserUpdateRequest, 
    username: str = Header(...),
    user_id: str = Header(...)):
    if not username:
        raise HTTPException(status_code=400, detail="Authorization header is missing")

    # Use the username to find potential matches
    user = db.find_user({"username": username})
    if not user:
        raise HTTPException(status_code=404, detail="user not found")

    update_dict = {}

    # Validate and apply username update
    if update_data.username is not None and update_data.username != user.username:
        existing_user = db.find_user({"username": update_data.username})
        if existing_user and existing_user.user_id != user_id:
            raise HTTPException(status_code=400, detail="Username already taken")
        user.username = update_data.username
        update_dict["username"] = update_data.username

    # Validate and apply email update
    if update_data.email is not None and update_data.email != user.email:
        existing_user = db.find_user({"email": update_data.email})
        if existing_user and existing_user.user_id != user_id:
            raise HTTPException(status_code=400, detail="Email already registered")
        user.email = update_data.email
        user.verification_status = False
        update_dict["email"] = update_data.email
        update_dict["verification_status"] = False

    # Update top-level fields
    if update_data.full_name is not None:
        user.full_name = update_data.full_name
        update_dict["full_name"] = update_data.full_name
    if update_data.age is not None:
        user.age = update_data.age
        update_dict["age"] = update_data.age
    if update_data.gender is not None:
        user.gender = update_data.gender
        update_dict["gender"] = update_data.gender
    if update_data.sexual_orientation is not None:
        user.sexual_orientation = update_data.sexual_orientation
        update_dict["sexual_orientation"] = update_data.sexual_orientation
    if update_data.bio is not None:
        user.bio = update_data.bio
        update_dict["bio"] = update_data.bio
    if update_data.profile_pictures is not None:
        user.profile_pictures = update_data.profile_pictures
        update_dict["profile_pictures"] = update_data.profile_pictures
    if update_data.campus_affiliation is not None:
        user.campus_affiliation = update_data.campus_affiliation
        update_dict["campus_affiliation"] = update_data.campus_affiliation
    if update_data.interests is not None:
        user.interests = update_data.interests
        update_dict["interests"] = update_data.interests

    # Update location
    if update_data.location is not None:
        new_location = Location(
            latitude=update_data.location.latitude,
            longitude=update_data.location.longitude
        )
        user.location = new_location
        update_dict["location"] = new_location

    # Update match preferences
    if update_data.match_preferences is not None:
        mp_update = update_data.match_preferences
        current_mp = user.match_preferences
        new_mp = MatchPreferences(
            preferred_gender=mp_update.preferred_gender if mp_update.preferred_gender is not None else current_mp.preferred_gender,
            min_age=mp_update.min_age if mp_update.min_age is not None else current_mp.min_age,
            max_age=mp_update.max_age if mp_update.max_age is not None else current_mp.max_age,
            max_distance=mp_update.max_distance if mp_update.max_distance is not None else current_mp.max_distance
        )
        user.match_preferences = new_mp
        update_dict["match_preferences"] = new_mp

    # Update settings
    if update_data.settings is not None:
        s_update = update_data.settings
        current_settings = user.settings
        new_settings = Settings(
            notifications_enabled=s_update.notifications_enabled if s_update.notifications_enabled is not None else current_settings.notifications_enabled,
            theme=s_update.theme if s_update.theme is not None else current_settings.theme,
            language=s_update.language if s_update.language is not None else current_settings.language
        )
        user.settings = new_settings
        update_dict["settings"] = new_settings

    # Update timestamp
    user.updated_at = datetime.now().timestamp()
    update_dict["updated_at"] = user.updated_at

    # Persist changes using the database's update_user method
    success = db.update_user(user_id, update_dict)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to update user profile")

    return user.to_dict()