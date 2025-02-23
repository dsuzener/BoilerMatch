from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi import WebSocket, WebSocketDisconnect
import os
from datetime import datetime 
import uvicorn

from server import router as api_router
from database import db
from obj import User, Conversation, AccountStatus
from auth import get_password_hash
from services.connection import manager


app = FastAPI(
    title="BoilerMatch API",
    description="Dating app backend for Purdue students",
    version="0.1.0"
)

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(api_router, prefix="/api/v1")

# Database initialization
@app.on_event("startup")
async def startup_db():
    # 1. Ensure data directory exists
    os.makedirs("mock_data", exist_ok=True)
    
    # 2. Initialize collections with default data if empty
    if not db.users:
        # Create initial admin/test user
        hashed_password = get_password_hash("admin123")
        admin_user = User(
            user_id="0",
            username="admin",
            email="admin@boilermatch.com",
            password_hash=hashed_password,
            verification_status=True,
            account_status=AccountStatus.Active,
            campus_affiliation="Purdue University"
        )
        db.add_user(admin_user)
        print("Created initial admin user")

    # 3. Initialize default conversations if needed
    if not db.conversations:
        # System welcome conversation
        welcome_conv = Conversation(
            chat_id="0",
            participants=["system", "0"],
            messages=[{
                "sender": "system",
                "content": "Welcome to BoilerMatch!",
                "timestamp": datetime.now().isoformat()
            }]
        )
        db.add_conversation(welcome_conv)

    # 4. Add other initial dataset if needed
    if len(db.users) < 5:  # Seed sample users for testing
        sample_users = [
            User(
                user_id=str(i+1),
                username=f"user{i+1}",
                email=f"user{i+1}@purdue.edu",
                password_hash=get_password_hash(f"password{i+1}"),
                campus_affiliation="Purdue University"
            ) for i in range(4)
        ]
        for user in sample_users:
            db.add_user(user)
        print("Added 4 sample Purdue users")

    # 5. Future-proofing for real database
    # if using_real_db:
    #     await database.connect()
    #     await check_migrations()
    
    # 6. Initialize search indexes
    db._save_collection("users", db.users)  # Force index rebuild
    print("Database initialization complete")

@app.get("/")
def read_root():
    return {"message": "Welcome to BoilerMatch API!"}

@app.on_event("shutdown")
async def shutdown_db():
    # For mock DB, ensure all changes are flushed
    db._save_collection("users", db.users)
    db._save_collection("conversations", db.conversations)
    # if using_real_db:
    #     await database.disconnect()

@app.websocket("/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    await manager.connect(websocket, user_id)
    try:
        while True:
            # Keep connection open
            await websocket.receive_text()
    except WebSocketDisconnect:
        manager.disconnect(user_id)


if __name__ == "__main__":
    uvicorn.run(app, host="127.0.0.1", port=8000)