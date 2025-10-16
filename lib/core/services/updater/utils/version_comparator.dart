/// Utility for comparing semantic versions
class VersionComparator {
  /// Compare two version strings
  /// Returns:
  ///   1 if version1 > version2
  ///   0 if version1 == version2
  ///  -1 if version1 < version2
  static int compare(String version1, String version2) {
    final v1 = _parseVersion(version1);
    final v2 = _parseVersion(version2);

    // Compare major
    if (v1.major != v2.major) {
      return v1.major.compareTo(v2.major);
    }

    // Compare minor
    if (v1.minor != v2.minor) {
      return v1.minor.compareTo(v2.minor);
    }

    // Compare patch
    if (v1.patch != v2.patch) {
      return v1.patch.compareTo(v2.patch);
    }

    // Compare pre-release
    if (v1.preRelease != null && v2.preRelease == null) {
      return -1;
    }
    if (v1.preRelease == null && v2.preRelease != null) {
      return 1;
    }
    if (v1.preRelease != null && v2.preRelease != null) {
      return v1.preRelease!.compareTo(v2.preRelease!);
    }

    return 0;
  }

  /// Check if version1 is greater than version2
  static bool isGreaterThan(String version1, String version2) {
    return compare(version1, version2) > 0;
  }

  /// Check if version1 is less than version2
  static bool isLessThan(String version1, String version2) {
    return compare(version1, version2) < 0;
  }

  /// Check if version1 equals version2
  static bool isEqual(String version1, String version2) {
    return compare(version1, version2) == 0;
  }

  static _Version _parseVersion(String version) {
    // Remove 'v' prefix if present
    String cleaned = version.trim();
    if (cleaned.startsWith('v')) {
      cleaned = cleaned.substring(1);
    }

    // Split on '-' to separate pre-release
    final parts = cleaned.split('-');
    final mainVersion = parts[0];
    final preRelease = parts.length > 1 ? parts[1] : null;

    // Parse major.minor.patch
    final numbers = mainVersion.split('.');
    if (numbers.isEmpty || numbers.length > 3) {
      throw ArgumentError('Invalid version format: $version');
    }

    final major = int.tryParse(numbers[0]) ?? 0;
    final minor = numbers.length > 1 ? (int.tryParse(numbers[1]) ?? 0) : 0;
    final patch = numbers.length > 2 ? (int.tryParse(numbers[2]) ?? 0) : 0;

    return _Version(
      major: major,
      minor: minor,
      patch: patch,
      preRelease: preRelease,
    );
  }
}

class _Version {
  final int major;
  final int minor;
  final int patch;
  final String? preRelease;

  _Version({
    required this.major,
    required this.minor,
    required this.patch,
    this.preRelease,
  });

  @override
  String toString() {
    final base = '$major.$minor.$patch';
    return preRelease != null ? '$base-$preRelease' : base;
  }
}
