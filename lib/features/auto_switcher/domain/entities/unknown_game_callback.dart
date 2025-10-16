import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';

/// Callback signature for handling unknown games
///
/// When invoked, should show UI to let user select a category.
/// Returns a CategoryMapping if user selected one, null if cancelled.
///
/// Parameters:
/// - processName: Name of the unknown process
/// - executablePath: Full path to the executable (optional)
/// - windowTitle: Window title if available (optional)
typedef UnknownGameCallback =
    Future<CategoryMapping?> Function({
      required String processName,
      String? executablePath,
      String? windowTitle,
    });
