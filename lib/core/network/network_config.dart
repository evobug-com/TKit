/// Network configuration constants
///
/// Defines timeouts and other network-related settings for different
/// types of operations throughout the application
class NetworkConfig {
  NetworkConfig._();

  // Quick operations (search, lightweight API calls)
  static const quickTimeout = Duration(seconds: 10);

  // Standard operations (most API calls, authentication)
  static const standardTimeout = Duration(seconds: 30);

  // Long operations (file downloads, large data transfers)
  static const longTimeout = Duration(seconds: 300);

  // Connectivity check timeout (should be very fast)
  static const connectivityCheckTimeout = Duration(seconds: 3);

  // Retry configuration
  static const maxRetries = 3;
  static const retryDelay = Duration(seconds: 2);

  // Rate limit configuration
  static const maxRateLimitWaitSeconds = 60;
  static const defaultRateLimitRetrySeconds = 5;
}
