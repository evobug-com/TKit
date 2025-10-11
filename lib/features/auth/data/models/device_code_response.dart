/// Response from Twitch Device Code Flow initial request
class DeviceCodeResponse {
  /// The device code for polling
  final String deviceCode;

  /// The user code to display to the user
  final String userCode;

  /// The verification URI where user enters the code
  final String verificationUri;

  /// Number of seconds before the codes expire
  final int expiresIn;

  /// Recommended polling interval in seconds
  final int interval;

  const DeviceCodeResponse({
    required this.deviceCode,
    required this.userCode,
    required this.verificationUri,
    required this.expiresIn,
    required this.interval,
  });

  /// Create from Twitch API response
  factory DeviceCodeResponse.fromJson(Map<String, dynamic> json) {
    return DeviceCodeResponse(
      deviceCode: json['device_code'] as String,
      userCode: json['user_code'] as String,
      verificationUri: json['verification_uri'] as String,
      expiresIn: json['expires_in'] as int,
      interval: json['interval'] as int,
    );
  }

  /// Calculate expiration time from now
  DateTime get expiresAt => DateTime.now().add(Duration(seconds: expiresIn));
}
