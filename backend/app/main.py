from fastapi import FastAPI, WebSocket, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from routers import users, profiles, matches, messages
from server import api_router

app = FastAPI(
    title="BoilerMatch API",
    description="Dating app backend for Purdue students",
    version="0.1.0"
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Include routers
app.include_router(api_router, prefix="/api", tags=["auth"])

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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)