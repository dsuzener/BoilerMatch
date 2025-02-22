import json
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_root():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {"message": "Welcome to BoilerMatch API"}

def test_user_registration():
    user_data = {
        "email": "test@example.com",
        "name": "Test User",
        "password": "testpassword"
    }
    response = client.post("/api/users/register", json=user_data)
    assert response.status_code == 200
    assert "message" in response.json()

def test_user_login():
    login_data = {
        "email": "test@example.com",
        "password": "testpassword"
    }
    response = client.post("/api/users/login", json=login_data)
    assert response.status_code == 200
    assert "message" in response.json()
    assert "user_id" in response.json()

def test_create_profile():
    profile_data = {
        "user_id": "1",
        "bio": "Test bio",
        "interests": ["coding", "dating"],
        "photos": ["photo1.jpg", "photo2.jpg"]
    }
    response = client.post("/api/profiles", json=profile_data)
    assert response.status_code == 200
    assert "message" in response.json()

def test_get_profile():
    response = client.get("/api/profiles/1")
    assert response.status_code == 200
    assert "bio" in response.json()
    assert "interests" in response.json()
    assert "photos" in response.json()

def test_update_profile():
    update_data = {
        "bio": "Updated bio"
    }
    response = client.put("/api/profiles/1", json=update_data)
    assert response.status_code == 200
    assert "message" in response.json()

def test_create_match():
    match_data = {
        "user1_id": "1",
        "user2_id": "2"
    }
    response = client.post("/api/matches", json=match_data)
    assert response.status_code == 200
    assert "message" in response.json()

def test_get_matches():
    response = client.get("/api/matches/1")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_update_match_status():
    status_data = {
        "status": "accepted"
    }
    response = client.put("/api/matches/1", json=status_data)
    assert response.status_code == 200
    assert "message" in response.json()

def test_send_message():
    message_data = {
        "sender_id": "1",
        "receiver_id": "2",
        "content": "Hello, this is a test message"
    }
    response = client.post("/api/messages", json=message_data)
    assert response.status_code == 200
    assert "message" in response.json()

def test_get_messages():
    response = client.get("/api/messages/1")
    assert response.status_code == 200
    assert isinstance(response.json(), list)

def test_socket_communication():
    from ..app.routers.socket_handler import send_socket_message_sync
    send_socket_message_sync("Test message")
    # Since we can't easily test the actual WebSocket communication in a unit test,
    # we'll just ensure the function runs without errors

def test_data_persistence():
    # Test that data is actually being saved to files
    with open("mock_data/users.json", "r") as f:
        users = json.load(f)
    assert len(users) > 0

    with open("mock_data/profiles.json", "r") as f:
        profiles = json.load(f)
    assert len(profiles) > 0

    with open("mock_data/matches.json", "r") as f:
        matches = json.load(f)
    assert len(matches) > 0

    with open("mock_data/messages.json", "r") as f:
        messages = json.load(f)
    assert len(messages) > 0
