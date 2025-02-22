#include <string>
#include <vector>
#include <ctime>

// gender, sexual orientation, account status
enum class Gender { Male, Female, Other, Unspecified };
enum class SexualOrientation { Heterosexual, Homosexual, Bisexual, Other, Unspecified };
enum class AccountStatus { Active, Suspended, Banned };

// location
struct Location {
    double latitude = 0.0;
    double longitude = 0.0;
};

// match preferences
struct MatchPreferences {
    Gender preferredGender = Gender::Unspecified;
    int minAge = 18;
    int maxAge = 100;
    double maxDistance = 10.0; // km
};

// app settings
struct Settings {
    bool notificationsEnabled = true;
    std::string theme = "light"; // light or dark mode
    std::string language = "en"; // language
};

class User {
    public:
        User(const std::string &id, const std::string &uname, const std::string &mail)
            : user_id(id), username(uname), email(mail), age(0),
            gender(Gender::Unspecified), sexual_orientation(SexualOrientation::Unspecified),
            gem_balance(0), account_status(AccountStatus::Active) {
            created_at = std::time(nullptr);
            updated_at = created_at;
            last_active = created_at;
        }

        // setters for password and verification status
        void setPasswordHash(const std::string &hash) { password_hash = hash; }
        void setVerificationStatus(bool status) { verification_status = status; }

        // setters for profile information
        void setFullName(const std::string &name) { full_name = name; }
        void setAge(int a) { age = a; }
        void setGender(Gender g) { gender = g; }
        void setSexualOrientation(SexualOrientation so) { sexual_orientation = so; }
        void setBio(const std::string &b) { bio = b; }
        void addProfilePicture(const std::string &url) { profile_pictures.push_back(url); }

        // setters for location and campus affiliation
        void setLocation(double lat, double lon) { location = {lat, lon}; }
        void setCampusAffiliation(const std::string &affiliation) { campus_affiliation = affiliation; }

        // methods for user preferences
        void addInterest(const std::string &interest) { interests.push_back(interest); }
        void setMatchPreferences(const MatchPreferences &prefs) { match_preferences = prefs; }

        // methods for managing gem balance and app metrics
        void updateGemBalance(int amount) { gem_balance += amount; }
        void updateLastActive() { last_active = std::time(nullptr); }
        void setAccountStatus(AccountStatus status) { account_status = status; }

        // social and interaction methods
        void addMatch(const std::string &matchUserId) { matches.push_back(matchUserId); }
        void addLikedProfile(const std::string &profileId) { liked_profiles.push_back(profileId); }
        void addDislikedProfile(const std::string &profileId) { disliked_profiles.push_back(profileId); }
        void addChatHistoryId(const std::string &chatId) { chat_history_ids.push_back(chatId); }

        // set user settings.
        void setSettings(const Settings &s) { settings = s; }

    private:
        // identity & authentication
        std::string user_id;
        std::string username;
        std::string email;
        std::string password_hash;
        bool verification_status = false;

        // profile info
        std::string full_name;
        int age;
        Gender gender;
        SexualOrientation sexual_orientation;
        std::string bio;
        std::vector<std::string> profile_pictures;

        // location & campus affiliation
        Location location;
        std::string campus_affiliation;  // e.g., student ID or graduation year

        // user preferences & match criteria
        std::vector<std::string> interests;
        MatchPreferences match_preferences;

        // app-specific metrics & status
        int gem_balance;
        std::time_t last_active;
        AccountStatus account_status;
        std::time_t created_at;
        std::time_t updated_at;

        // social & interaction data
        std::vector<std::string> matches;
        std::vector<std::string> liked_profiles;
        std::vector<std::string> disliked_profiles;
        std::vector<std::string> chat_history_ids;

        // settings & preferences
        Settings settings;
    };
