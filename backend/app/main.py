from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
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

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)