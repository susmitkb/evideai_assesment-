📱 App Overview
A Flutter application that displays bus stops with real-time ETA information, favorite management, and search functionality. The app loads data from local JSON files and persists user preferences across sessions.
✨ Features
Local JSON Data: Loads bus stop information from assets/mock/stops.json

Stop List: Displays stop names with short descriptions

Detail Screen: Shows complete information including coordinates and ETA

Favorite System: Toggle favorites with persistent storage using shared_preferences

Search Functionality: Filter stops by name in real-time

Smooth Animations: Enhanced UI with engaging animations and transitions

🎮 How to Use
Browse Stops: Scroll through the list of available bus stops

Search: Use the search bar to filter stops by name

View Details: Tap any stop to see detailed information including:

Coordinates (latitude/longitude)

Estimated Time of Arrival (ETA)

Time difference from previous stop

Manage Favorites:

Tap the heart icon to add/remove from favorites

Access favorites from the favorites screen (heart icon in app bar)

Favorites persist between app sessions

Swipe to Remove: In favorites screen, swipe left to remove items

🔧 Technical Details
Dependencies
getx: State management and navigation

shared_preferences: Local storage for favorites

Flutter built-in packages for animations and UI

Data Source
Local JSON file: assets/mock/stops.json

Format: Array of stop objects with name, coordinates, and timing data

State Management
GetX for reactive state management

Controllers for business logic separation

Observable variables for real-time updates

🎨 UI/UX Features
Material Design 3 compliant interface

Theming with consistent color scheme

Smooth animations for:

Favorite toggling (scale + rotation)

Page transitions (slide + fade)

List item entrances (staggered)

Loading states

Responsive layout for various screen sizes

Haptic feedback on interactions
