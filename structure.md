.
├── README.md
├── assets
│   ├── designs
│   │   ├── Store.png
│   │   ├── login.jpeg
│   │   ├── login_signup.jpeg
│   │   ├── profile.jpeg
│   │   ├── profile_edit.jpeg
│   │   ├── profile_settings.jpeg
│   │   ├── profile_view.jpeg
│   │   ├── signup.jpeg
│   │   └── store.jpeg
│   └── logos
│       ├── logo.png
│       ├── logo_dark.png
│       └── logo_light.png
├── backend
│   ├── app
│   │   ├── __init__.py
│   │   ├── __pycache__
│   │   │   ├── auth.cpython-312.pyc
│   │   │   ├── base_models.cpython-312.pyc
│   │   │   ├── database.cpython-312.pyc
│   │   │   ├── matching.cpython-312.pyc
│   │   │   ├── models.cpython-312.pyc
│   │   │   ├── obj.cpython-312.pyc
│   │   │   └── server.cpython-312.pyc
│   │   ├── auth.py
│   │   ├── base_models.py
│   │   ├── database.py
│   │   ├── main.py
│   │   ├── main1.py
│   │   ├── matching.py
│   │   ├── models.py
│   │   ├── obj.py
│   │   ├── routers
│   │   │   ├── __init__.py
│   │   │   ├── __pycache__
│   │   │   │   ├── __init__.cpython-312.pyc
│   │   │   │   ├── matches.cpython-312.pyc
│   │   │   │   ├── messages.cpython-312.pyc
│   │   │   │   ├── profiles.cpython-312.pyc
│   │   │   │   ├── socket_handler.cpython-312.pyc
│   │   │   │   └── users.cpython-312.pyc
│   │   │   ├── matches.py
│   │   │   ├── messages.py
│   │   │   ├── profiles.py
│   │   │   ├── socket_handler.py
│   │   │   └── users.py
│   │   ├── server.py
│   │   └── services
│   │       ├── __init__.py
│   │       ├── hnsw_matching.py
│   │       └── recommendation.py
│   ├── build
│   │   ├── lib.macosx-11.1-arm64-cpython-312
│   │   │   └── hnsw_matcher.cpython-312-darwin.so
│   │   └── temp.macosx-11.1-arm64-cpython-312
│   │       └── cpp_modules
│   │           ├── bindings.o
│   │           └── hnsw.o
│   ├── cpp_modules
│   │   ├── bindings.cpp
│   │   ├── hnsw.cpp
│   │   └── hnsw.h
│   ├── hnsw_matcher.cpython-312-darwin.so
│   ├── requirements.txt
│   ├── setup.py
│   └── tests
│       ├── __init__.py
│       └── test_main.py
├── frontend
│   └── BoilerMatch
│       ├── BoilerMatch
│       │   ├── Assets.xcassets
│       │   │   ├── AccentColor.colorset
│       │   │   │   └── Contents.json
│       │   │   ├── AppIcon.appiconset
│       │   │   │   ├── Contents.json
│       │   │   │   ├── logo.png
│       │   │   │   ├── logo_dark.png
│       │   │   │   └── logo_light.png
│       │   │   ├── Contents.json
│       │   │   └── HotChick.imageset
│       │   │       ├── Contents.json
│       │   │       ├── chick-photos-yellow-2 1.jpg
│       │   │       ├── chick-photos-yellow-2 2.jpg
│       │   │       └── chick-photos-yellow-2.jpg
│       │   ├── BoilerMatchApp.swift
│       │   ├── ContentView.swift
│       │   ├── Info.plist
│       │   ├── Models
│       │   │   ├── AppColors.swift
│       │   │   ├── FeedItem.swift
│       │   │   ├── Match.swift
│       │   │   ├── Message.swift
│       │   │   ├── Profile.swift
│       │   │   └── User.swift
│       │   ├── Networking
│       │   │   ├── APIClient.swift
│       │   │   ├── APIError.swift
│       │   │   ├── AuthenticationService.swift
│       │   │   └── Endpoint.swift
│       │   ├── Preview Content
│       │   │   └── Preview Assets.xcassets
│       │   │       └── Contents.json
│       │   ├── ViewModels
│       │   │   ├── ChatViewModel.swift
│       │   │   ├── FeedViewModel.swift
│       │   │   ├── LoginViewModel.swift
│       │   │   ├── MatchesViewModel.swift
│       │   │   ├── ProfileViewModel.swift
│       │   │   ├── SignupViewModel.swift
│       │   │   └── UserViewModel.swift
│       │   └── Views
│       │       ├── ChatView.swift
│       │       ├── EditProfileView.swift
│       │       ├── FeedView.swift
│       │       ├── LoginView.swift
│       │       ├── MainTabView.swift
│       │       ├── MatchesView.swift
│       │       ├── ProfileView.swift
│       │       ├── PublicProfileView.swift
│       │       ├── SettingsView.swift
│       │       ├── SignupView.swift
│       │       └── StoreView.swift
│       ├── BoilerMatch.xcodeproj
│       │   ├── project.pbxproj
│       │   ├── project.xcworkspace
│       │   │   ├── contents.xcworkspacedata
│       │   │   ├── xcshareddata
│       │   │   │   └── swiftpm
│       │   │   │       └── configuration
│       │   │   └── xcuserdata
│       │   │       └── omniscient.xcuserdatad
│       │   │           └── UserInterfaceState.xcuserstate
│       │   └── xcuserdata
│       │       └── omniscient.xcuserdatad
│       │           └── xcschemes
│       │               └── xcschememanagement.plist
│       ├── BoilerMatchTests
│       │   └── BoilerMatchTests.swift
│       └── BoilerMatchUITests
│           ├── BoilerMatchUITests.swift
│           └── BoilerMatchUITestsLaunchTests.swift
├── mock_data
│   └── user.json
└── structure.md