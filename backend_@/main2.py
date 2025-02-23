from fastapi import FastAPI, WebSocket, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from routers import users, profiles, matches, messages

app = FastAPI()

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Include routers
app.include_router(users.router, prefix="/api", tags=["users"])
app.include_router(profiles.router, prefix="/api", tags=["profiles"])
app.include_router(matches.router, prefix="/api", tags=["matches"])
app.include_router(messages.router, prefix="/api", tags=["messages"])

@app.get("/")
async def root():
    return {"message": "Welcome to BoilerMatch API"}

# WebSocket endpoint added here
@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    try:
        while True:
            data = await websocket.receive_json()
            print(f"Received JSON: {data}")  # Print to terminal
            await websocket.send_json({"status": "Received", "data": data})
    except Exception as e:
        print(f"WebSocket error: {e}")
    finally:
        await websocket.close()

# Add Pydantic model for login data
class LoginRequest(BaseModel):
    username: str
    password: str

# Add this login endpoint above your existing routers
@app.post("/login")
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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)