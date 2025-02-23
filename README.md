# BoilerMatch - Dating at Purdue

Welcome to **BoilerMatch**, a modern dating app designed to help people connect, match, and build meaningful relationships. This README provides an overview of the project structure, features, and instructions for setting up and contributing to the project.

---

## Table of Contents

- [Features](#features)
- [Project Structure](#project-structure)
- [Setup and Installation](#setup-and-installation)
- [Usage](#usage)

---

## Features

BoilerMatch offers the following features:

- **User Authentication**: Secure login and signup functionality.
- **Profile Management**: Create, edit, and view user profiles.
- **Matching Algorithm**: Advanced recommendation system for finding compatible matches.
- **Messaging System**: Real-time chat functionality for matched users.
- **Feed View**: Browse potential matches through an intuitive feed.
- **Settings**: Customize your preferences and account settings.
- **In-App Store**: Purchase premium features or subscriptions.

---

## Project Structure

The project is organized into three main components: `frontend`, `backend`, and `assets`.

### 1. **Frontend**
The frontend is built using Swift for iOS development. It includes:
- **Views**: UI components such as `LoginView.swift`, `FeedView.swift`, and `ProfileView.swift`.
- **ViewModels**: Logic for managing data and state, such as `ChatViewModel.swift` and `SignupViewModel.swift`.
- **Networking**: API integration with services like `AuthenticationService.swift`.
- **Assets**: Icons, images, and color configurations for the app.

Path: `frontend/BoilerMatch`

### 2. **Backend**
The backend is implemented in Python using FastAPI. It includes:
- **APIs**: Endpoints for user authentication, matching, messaging, and profile management.
- **Services**: Core logic such as `hnsw_matching.py` for recommendations.
- **Database Integration**: Models and database setup via `database.py`.
- **Tests**: Unit tests to ensure backend functionality.

Path: `backend/app`

### 3. **Assets**
Contains designs (mockups) and logos used in the app:
- Designs: Screenshots/mockups of key app screens (e.g., login, profile).
- Logos: App branding assets in light/dark modes.

Path: `assets/`

### 4. **Mock Data**
Sample user data for testing purposes.

Path: `mock_data/user.json`

---

## Setup and Installation

Follow these steps to set up the project locally:

### Prerequisites
1. Install Python 3.12 or higher.
2. Install Xcode (for iOS development).
3. Install dependencies using `pip` (backend) and Swift Package Manager (frontend).

### Backend Setup
1. Navigate to the backend directory:
```
cd backend
```
2. Install dependencies to environment:
```
pip install -r requirements.txt
```
3. Run the server:
python app/main.py
4. The API will be available at `http://127.0.0.1:8000`.

### Frontend Setup
1. Open the Xcode project file located at: `frontend/BoilerMatch/BoilerMatch.xcodeproj`
2. Build and run the app on a simulator or connected device.

---

## Usage

1. Launch the backend server as described above.
2. Run the frontend app on a simulator or device.
3. Use the app to sign up, create a profile, browse matches, chat with users, and explore other features.

---

Thank you for checking out BoilerMatch! If you have any questions or feedback, feel free to open an issue or contact us directly. Happy matching! ❤️
