class Routes {
  //! User Routes
  // Auth Routes - Separate login for each role
  static const String travelerLogin = "/traveler-login";
  static const String adminLogin = "/admin-login";
  static const String businessLogin = "/business-login";

  // Common auth routes
  static const String register = "/register";
  static const String forgotPassword = "/forgot-password";

  // Main App Routes - Traveler
  static const String host = "/host";
  static const String home = "/home";
  static const String chatBot = "/chat-bot";
  static const String explore = "/explore";
  static const String payment = '/payment';
  static const String profile = "/profile";
  static const String editProfile = "/edit-profile";
  static const String favorites = "/favorites";
  static const String preferences = '/preferences';
  static const String flightBooking = '/flight-booking-screen';
  static const String myBookings = "/my-Bookings";

  // Feature Routes
  static const String destinationDetails = "/destination-details";
  static const String bookingDetails = "/booking-details";
  static const String searchResults = "/search-results";
  static const String categoryView = "/category-view";
  static const String settings = "/settings";
  static const String notifications = "/notifications";
  static const String enhancedThemeSwitchTile = "/EnhancedThemeSwitchTile";
  static const String aboutUs = "/about-us";
  static const String termsAndConditions = "/terms-and-conditions";
  static const String privacyPolicy = "/privacy-policy";

  //! Onboarding & Role Selection Routes
  static const String onboarding1 = '/onboarding1';
  static const String onboarding2 = '/onboarding2';
  static const String onboarding3 = '/onboarding3';
  static const String roleSelection = '/role-selection';

  //! Owner Routes
  static const String information = '/information';
  static const String personalInformation = '/personal-info';

  //! Admin Routes
  static const String adminHome = '/admin-home';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminUsers = '/admin-users';
  static const String adminReports = '/admin-reports';
  static const String adminSettings = '/admin-settings';

  //! Business Routes
  static const String businessHome = '/business-home';
  static const String businessDashboard = '/business-dashboard';
  static const String businessBookings = '/business-bookings';
  static const String businessProfile = '/business-profile';
  static const String businessAnalytics = '/business-analytics';

  // Legacy routes (keep for backward compatibility)
  static const String login = "/login"; // Default to traveler login
}
