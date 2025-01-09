class UserSession {
  // Singleton instance
  static final UserSession _instance = UserSession._internal();
  // Factory constructor to always return the same instance
  factory UserSession() {
    return _instance;
  }
  // Private constructor
  UserSession._internal();
  // Field to store the current user's ID
  int? _userId;
  // Getter for the current user's ID
  int? get userId => _userId;
  // Method to set the logged-in user's ID (accepts nullable int?)
  void setUser(int? userId) {
    _userId = userId;
    print("[DEBUG] User logged in with userId: $_userId");
  }
  // Method to clear the user's session (logout)
  void clearUser() {
    print("[DEBUG] User with userId: $_userId is logging out");
    _userId = null;
    print("[DEBUG] User session cleared");
  }
  // Check if a user is logged in
  bool isLoggedIn() {
    final loggedIn = _userId != null;
    print("[DEBUG] isLoggedIn: $loggedIn");
    return loggedIn;
  }
}