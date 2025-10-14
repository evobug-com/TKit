import 'package:equatable/equatable.dart';

/// Represents a single mapping within a list.
/// This is used during import/sync operations before converting to CategoryMapping.
class MappingListItem extends Equatable {
  final String processName;
  final List<String> normalizedInstallPaths;
  final String twitchCategoryId;
  final String twitchCategoryName;
  final int verificationCount;
  final String? category; // 'game', 'launcher', 'system', 'browser', etc.

  const MappingListItem({
    required this.processName,
    required this.normalizedInstallPaths,
    required this.twitchCategoryId,
    required this.twitchCategoryName,
    this.verificationCount = 1,
    this.category,
  });

  /// Returns true if this is an ignored process (not a game)
  bool get isIgnored => twitchCategoryId == 'IGNORE';

  /// Returns true if this is a game mapping
  bool get isGame => !isIgnored;

  MappingListItem copyWith({
    String? processName,
    List<String>? normalizedInstallPaths,
    String? twitchCategoryId,
    String? twitchCategoryName,
    int? verificationCount,
    String? category,
  }) {
    return MappingListItem(
      processName: processName ?? this.processName,
      normalizedInstallPaths: normalizedInstallPaths ?? this.normalizedInstallPaths,
      twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
      twitchCategoryName: twitchCategoryName ?? this.twitchCategoryName,
      verificationCount: verificationCount ?? this.verificationCount,
      category: category ?? this.category,
    );
  }

  @override
  List<Object?> get props => [
        processName,
        normalizedInstallPaths,
        twitchCategoryId,
        twitchCategoryName,
        verificationCount,
        category,
      ];
}
