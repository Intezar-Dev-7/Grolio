// core/config/api_config.dart

class ApiConfig {
  ApiConfig._();

  // ============================================================================
  // Environment Configuration
  // ============================================================================

  /// Current environment
  static const Environment currentEnvironment = Environment.development;

  // ============================================================================
  // Base URLs
  // ============================================================================

  /// Development base URL
  static const String developmentBaseUrl = 'http://localhost:3000/api/v1';

  /// Staging base URL
  static const String stagingBaseUrl = 'https://staging-api.grolio.dev/api/v1';

  /// Production base URL
  static const String productionBaseUrl = 'https://api.grolio.dev/api/v1';

  /// Get base URL based on current environment
  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return developmentBaseUrl;
      case Environment.staging:
        return stagingBaseUrl;
      case Environment.production:
        return productionBaseUrl;
    }
  }

  // ============================================================================
  // API Timeouts
  // ============================================================================

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ============================================================================
  // API Version
  // ============================================================================

  static const String apiVersion = 'v1';

  // ============================================================================
  // WebSocket URLs
  // ============================================================================

  static const String developmentWebSocketUrl = 'ws://localhost:3000';
  static const String stagingWebSocketUrl = 'wss://staging-api.grolio.dev';
  static const String productionWebSocketUrl = 'wss://api.grolio.dev';

  static String get webSocketUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return developmentWebSocketUrl;
      case Environment.staging:
        return stagingWebSocketUrl;
      case Environment.production:
        return productionWebSocketUrl;
    }
  }

  // ============================================================================
  // Headers
  // ============================================================================

  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'X-API-Version': apiVersion,
  };

  // ============================================================================
  // Debug Mode
  // ============================================================================

  static bool get isDebugMode => currentEnvironment != Environment.production;
}

/// Environment enum
enum Environment {
  development,
  staging,
  production,
}
