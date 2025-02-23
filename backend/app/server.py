# Add this login endpoint above your existing routers
from fastapi import APIRouter, HTTPException, status
from base_models import LoginRequest, SignupRequest
import database

api_router = APIRouter()

@api_router.post("/login")
async def login(credentials: LoginRequest):
    # Replace with actual database check
    print(f"Login attempt: {credentials.username} / {credentials.password}")
    if credentials.username == "test" and credentials.password == "password":
        return {"token": "generated_jwt_token", "user_id": 123}

    raise HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Invalid credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

@api_router.post("/signup")
async def signup(user_data: SignupRequest):
    # Check if user exists
    existing_user = database.find_user({"email": user_data.email})
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    
    # Create new user
    hashed_password = hash(user_data.password)
    # new_user = User(
    #     user_id=str(len(database.users) + 1),
    #     username=user_data.username,
    #     email=user_data.email,
    #     password_hash=hashed_password,
    #     full_name=user_data.full_name,
    #     verification_status=False  # Add real verification later
    # )
    
    # database.add_user(new_user)
    return {"token": "generated_jwt_token", "user_id": 123}