// core/config/api_endpoints.dart

class ApiEndpoints {
  ApiEndpoints._();

  // ============================================================================
  // Authentication Endpoints
  // ============================================================================

  static const String auth = '/auth';

  // Auth - Basic
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String logout = '$auth/logout';
  static const String refreshToken = '$auth/refresh';

  // Auth - Password
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';
  static const String changePassword = '$auth/change-password';
  static const String verifyEmail = '$auth/verify-email';

  // Auth - Social
  static const String googleAuth = '$auth/google';
  static const String githubAuth = '$auth/github';
  static const String appleAuth = '$auth/apple';

  // Auth - Profile
  static const String me = '$auth/me';

  // ============================================================================
  // User Endpoints
  // ============================================================================

  static const String users = '/users';

  static String userById(String userId) => '$users/$userId';
  static String userProfile(String userId) => '$users/$userId/profile';
  static String userPosts(String userId) => '$users/$userId/posts';
  static String userFollowers(String userId) => '$users/$userId/followers';
  static String userFollowing(String userId) => '$users/$userId/following';
  static String followUser(String userId) => '$users/$userId/follow';
  static String unfollowUser(String userId) => '$users/$userId/unfollow';
  static String blockUser(String userId) => '$users/$userId/block';
  static String reportUser(String userId) => '$users/$userId/report';

  // ============================================================================
  // Post Endpoints
  // ============================================================================

  static const String posts = '/posts';

  static String postById(String postId) => '$posts/$postId';
  static String likePost(String postId) => '$posts/$postId/like';
  static String unlikePost(String postId) => '$posts/$postId/unlike';
  static String bookmarkPost(String postId) => '$posts/$postId/bookmark';
  static String sharePost(String postId) => '$posts/$postId/share';
  static String reportPost(String postId) => '$posts/$postId/report';

  // Post - Comments
  static String postComments(String postId) => '$posts/$postId/comments';
  static String postComment(String postId, String commentId) =>
      '$posts/$postId/comments/$commentId';

  // Post - Feed
  static const String feed = '/feed';
  static const String feedHome = '$feed/home';
  static const String feedTrending = '$feed/trending';
  static const String feedFollowing = '$feed/following';

  // ============================================================================
  // DevSnaps Endpoints (NEW)
  // ============================================================================

  static const String devSnaps = '/devsnaps';

  // Stories
  static const String devSnapStories = '$devSnaps/stories';
  static const String myDevSnapStories = '$devSnaps/stories/me';

  // Recent DevSnaps
  static const String recentDevSnaps = '$devSnaps/recent';
  static const String trendingDevSnaps = '$devSnaps/trending';

  // User DevSnaps
  static String userDevSnaps(String userId) => '$devSnaps/user/$userId';
  static const String myDevSnaps = '$devSnaps/me';

  // Single DevSnap
  static String devSnapById(String devSnapId) => '$devSnaps/$devSnapId';

  // DevSnap Actions
  static String viewDevSnap(String devSnapId) => '$devSnaps/$devSnapId/view';
  static String likeDevSnap(String devSnapId) => '$devSnaps/$devSnapId/like';
  static String unlikeDevSnap(String devSnapId) => '$devSnaps/$devSnapId/unlike';
  static String shareDevSnap(String devSnapId) => '$devSnaps/$devSnapId/share';
  static String reportDevSnap(String devSnapId) => '$devSnaps/$devSnapId/report';

  // DevSnap Comments
  static String devSnapComments(String devSnapId) => '$devSnaps/$devSnapId/comments';
  static String devSnapComment(String devSnapId, String commentId) =>
      '$devSnaps/$devSnapId/comments/$commentId';

  // DevSnap Upload
  static const String uploadDevSnap = '$devSnaps/upload';
  static const String uploadDevSnapMedia = '$devSnaps/upload/media';

  // ============================================================================
  // Tech Stack Endpoints
  // ============================================================================

  static const String techStacks = '/tech-stacks';

  static String techStackById(String techId) => '$techStacks/$techId';
  static const String userTechStacks = '/users/me/tech-stacks';
  static const String popularTechStacks = '$techStacks/popular';

  // ============================================================================
  // Goals Endpoints
  // ============================================================================

  static const String goals = '/goals';

  static String goalById(String goalId) => '$goals/$goalId';
  static const String userGoals = '/users/me/goals';
  static String goalProgress(String goalId) => '$goals/$goalId/progress';

  // ============================================================================
  // Onboarding Endpoints
  // ============================================================================

  static const String onboarding = '/onboarding';
  static const String onboardingComplete = '$onboarding/complete';
  static const String onboardingSkip = '$onboarding/skip';

  // ============================================================================
  // Notification Endpoints
  // ============================================================================

  static const String notifications = '/notifications';

  static String notificationById(String notificationId) =>
      '$notifications/$notificationId';
  static const String markAllRead = '$notifications/mark-all-read';
  static String markAsReadNotification(String notificationId) =>
      '$notifications/$notificationId/read';

  // ============================================================================
  // Search Endpoints
  // ============================================================================

  static const String search = '/search';
  static const String searchUsers = '$search/users';
  static const String searchPosts = '$search/posts';
  static const String searchDevSnaps = '$search/devsnaps';
  static const String searchTechStacks = '$search/tech-stacks';
  static const String searchAll = '$search/all';

  // ============================================================================
  // Profile Endpoints
  // ============================================================================

  static const String profile = '/profile';
  static const String updateProfile = '$profile/update';
  static const String uploadAvatar = '$profile/avatar';
  static const String uploadCover = '$profile/cover';

  // ============================================================================
  // Settings Endpoints
  // ============================================================================

  static const String settings = '/settings';
  static const String privacySettings = '$settings/privacy';
  static const String notificationSettings = '$settings/notifications';
  static const String accountSettings = '$settings/account';
  static const String deleteAccount = '$settings/delete-account';

  // ============================================================================
  // Analytics Endpoints
  // ============================================================================

  static const String analytics = '/analytics';
  static const String userAnalytics = '$analytics/user';
  static const String postAnalytics = '$analytics/posts';
  static const String devSnapAnalytics = '$analytics/devsnaps';

  // ============================================================================
  // Leaderboard Endpoints
  // ============================================================================

  static const String leaderboard = '/leaderboard';
  static const String leaderboardGlobal = '$leaderboard/global';
  static const String leaderboardWeekly = '$leaderboard/weekly';
  static const String leaderboardMonthly = '$leaderboard/monthly';

  // ============================================================================
  // Achievement Endpoints
  // ============================================================================

  static const String achievements = '/achievements';
  static String achievementById(String achievementId) =>
      '$achievements/$achievementId';
  static const String userAchievements = '/users/me/achievements';

  // ============================================================================
  // Upload Endpoints
  // ============================================================================

  static const String upload = '/upload';
  static const String uploadImage = '$upload/image';
  static const String uploadVideo = '$upload/video';
  static const String uploadFile = '$upload/file';

  // ============================================================================
  // Report & Moderation Endpoints
  // ============================================================================

  static const String reports = '/reports';
  static const String moderationQueue = '/moderation/queue';

  // ============================================================================
  // Discover Endpoints
  // ============================================================================

  static const String discover = '/discover';

  // Recommended Developers
  static const String recommendedDevelopers = '$discover/developers/recommended';
  static const String trendingDevelopers = '$discover/developers/trending';

  // Projects
  static const String trendingProjects = '$discover/projects/trending';
  static const String recommendedProjects = '$discover/projects/recommended';

  // Events
  static const String upcomingEvents = '$discover/events/upcoming';
  static const String trendingEvents = '$discover/events/trending';

  // Content
  static const String trendingContent = '$discover/content/trending';
  static const String exploreTopics = '$discover/topics';

  // ============================================================================
  // Chat Endpoints
  // ============================================================================

  static const String chat = '/chat';

  // Conversations
  static const String conversations = '$chat/conversations';
  static String conversationById(String conversationId) =>
      '$conversations/$conversationId';

  // Messages
  static const String messages = '$chat/messages';
  static String conversationMessages(String conversationId) =>
      '$conversations/$conversationId/messages';
  static String messageById(String messageId) => '$messages/$messageId';

  // Actions
  static String markAsReadConversation(String conversationId) =>
      '$conversations/$conversationId/read';
  static String typing(String conversationId) =>
      '$conversations/$conversationId/typing';

  // File upload
  static const String uploadChatFile = '$chat/upload';
}
