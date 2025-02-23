from typing import List
from database import db
from obj import User, Gender


class MatchingService:
    @staticmethod
    def find_potential_matches(user: User, limit: int = 50) -> List[User]:
        """Core matching algorithm implementation"""
        candidates = []

        for candidate in db.users:
            if candidate.user_id == user.user_id or candidate.user_id in user.matches:
                continue  # Skip self or matched user
            
            # Basic filters
            if not MatchingService._passes_gender_filter(user, candidate):
                continue
                
            if not MatchingService._passes_age_filter(user, candidate):
                continue
                
            # if not MatchingService._passes_distance_filter(user, candidate):
            #     continue
                
            if candidate.account_status != "Active":
                continue
                
            candidates.append(candidate)
            
            if len(candidates) >= limit:
                break
        
        # Add scoring/ranking logic here
        return sorted(candidates, key=lambda x: x.last_active, reverse=True)

    @staticmethod
    def _passes_gender_filter(user: User, candidate: User) -> bool:
        return (
            user.match_preferences.preferred_gender in [Gender.Unspecified, candidate.gender]
            and candidate.match_preferences.preferred_gender in [Gender.Unspecified, user.gender]
        )

    @staticmethod
    def _passes_age_filter(user: User, candidate: User) -> bool:
        return (
            user.age >= candidate.match_preferences.min_age and
            user.age <= candidate.match_preferences.max_age and
            candidate.age >= user.match_preferences.min_age and
            candidate.age <= user.match_preferences.max_age
        )

    @staticmethod
    def _passes_distance_filter(user: User, candidate: User) -> bool:
        # Haversine distance calculation
        from math import radians, sin, cos, sqrt, atan2
        
        lat1 = radians(user.location.latitude)
        lon1 = radians(user.location.longitude)
        lat2 = radians(candidate.location.latitude)
        lon2 = radians(candidate.location.longitude)
        
        dlon = lon2 - lon1
        dlat = lat2 - lat1
        
        a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
        c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        distance = 6371 * c  # Earth radius in km
        
        return distance <= min(
            user.match_preferences.max_distance,
            candidate.match_preferences.max_distance
        )
    
    @staticmethod
    def _matched_users(user: User) -> List[User]:
        return [db.find_user(user).to_dict() for user in user.matches]