import json
import random
from faker import Faker

from obj import User, SexualOrientation, Gender, Location, MatchPreferences, AccountStatus, Settings

fake = Faker()

def generate_fake_users(num_users: int):
    users = []
    for i in range(1, num_users + 1):
        user = User(
            user_id=f"user_{i}",
            username=fake.user_name(),
            email=f"pretttyp{i}@purdue.edu",
            password_hash=f"hashed_password_1",
            verification_status=random.choice([True, False]),
            full_name=f"PrettyPete_{i}",
            age=random.randint(18, 50),
            gender=random.choice([Gender.Male, Gender.Female, Gender.Other]),
            sexual_orientation=random.choice([
                SexualOrientation.Heterosexual,
                SexualOrientation.Homosexual,
                SexualOrientation.Bisexual,
                SexualOrientation.Other
            ]),
            bio=fake.sentence(),
            profile_pictures=[fake.image_url() for _ in range(random.randint(1, 6))],
            location=Location(random.uniform(-90, 90), random.uniform(-180, 180)),
            campus_affiliation=fake.company(),
            interests=random.sample(["Gaming", "Music", "Sports", "Coding", "Travel"], k=random.randint(1, 3)),
            match_preferences=MatchPreferences(
                preferred_gender=random.choice([Gender.Male, Gender.Female, Gender.Other, Gender.Unspecified]),
                min_age=random.randint(18, 25),
                max_age=random.randint(26, 50),
                max_distance=random.uniform(1, 50),
            ),
            gem_balance=random.randint(0, 1000),
            account_status=random.choice([AccountStatus.Active, AccountStatus.Suspended, AccountStatus.Banned]),
            settings=Settings(
                notifications_enabled=random.choice([True, False]),
                theme=random.choice(["light", "dark"]),
                language=random.choice(["en", "es", "fr"])
            ),
            matches=[],
            liked_profiles=[],
            disliked_profiles=[],
            chat_history_ids=[]
        )
        users.append(user.to_dict())

    return users

# Generate and save 10 fake users to a JSON file
fake_users = generate_fake_users(100)

with open("backend_@/data/user.json", "w") as file:
    json.dump(fake_users, file, indent=4)

print("Fake users data saved to fake_users.json!")
