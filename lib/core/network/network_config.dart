/// Network configuration constants
///
/// Defines timeouts and other network-related settings for different
/// types of operations throughout the application
class NetworkConfig {
  NetworkConfig._();

  // Quick operations (search, lightweight API calls)
  static const Duration quickTimeout = Duration(seconds: 10);

  // Standard operations (most API calls, authentication)
  static const Duration standardTimeout = Duration(seconds: 30);

  // Long operations (file downloads, large data transfers)
  static const Duration longTimeout = Duration(seconds: 300);

  // Connectivity check timeout (should be very fast)
  static const Duration connectivityCheckTimeout = Duration(seconds: 3);

  // Retry configuration
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Rate limit configuration
  static const int maxRateLimitWaitSeconds = 60;
  static const int defaultRateLimitRetrySeconds = 5;
}
