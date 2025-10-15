/// TKit spacing constants for consistent layout
/// Use these values instead of hardcoded numbers throughout the app
class TKitSpacing {
  TKitSpacing._();

  // Base spacing unit (4px)
  static const unit = 4.0;

  // Common spacing values
  static const xs = 4.0;   // Extra small - tight spacing
  static const sm = 8.0;   // Small - compact spacing
  static const md = 12.0;  // Medium - default spacing
  static const lg = 16.0;  // Large - comfortable spacing
  static const xl = 20.0;  // Extra large - generous spacing
  static const xxl = 24.0; // Double extra large - section spacing

  // Specific use cases
  static const double padding = md;         // Default padding
  static const double margin = md;          // Default margin
  static const double gap = sm;             // Gap between elements
  static const double sectionGap = lg;      // Gap between sections
  static const double cardPadding = md;     // Padding inside cards
  static const double pagePadding = lg;     // Padding around pages
  static const headerGap = 3.0;      // Gap between header title and subtitle
}

/// Type alias for backwards compatibility
typedef AppSpacing = TKitSpacing;
