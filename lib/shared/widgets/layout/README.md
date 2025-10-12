# Layout Components

Reusable UI building blocks for consistent, compact design.

## Quick Reference

```dart
import 'package:tkit/shared/theme/theme.dart';
import 'package:tkit/shared/widgets/layout/layout.dart';
```

## Components

### PageHeader
```dart
PageHeader(
  title: 'Settings',
  subtitle: 'Configure preferences',
  trailing: IconButton(...), // optional
)
```

### Island (Card/Container)
```dart
Island.compact(child: ...)    // 8px padding
Island.standard(child: ...)   // 12px padding
Island.comfortable(child: ...) // 16px padding

IslandVariant.standard(child: ...) // Lighter background
```

### Section
```dart
Section(
  title: 'Application',
  subtitle: 'Optional description',
  children: [
    Widget1(),
    Widget2(),
  ],
)
```

### StatItem
```dart
StatItem(
  label: 'Total',
  value: '42',
  valueColor: TKitColors.accent,
  icon: Icons.category,
)
```

### EmptyState
```dart
EmptyState(
  icon: Icons.inbox_outlined,
  message: 'No items',
  subtitle: 'Try adding one',
  action: Button(...),
)
```

### Spacers
```dart
VSpace.xs()  // 4px
VSpace.sm()  // 8px
VSpace.md()  // 12px
VSpace.lg()  // 16px
VSpace.xl()  // 20px

HSpace.sm()  // 8px horizontal
HSpace.md()  // 12px horizontal
```

## Standard Page Pattern

```dart
Scaffold(
  backgroundColor: TKitColors.background,
  body: Padding(
    padding: const EdgeInsets.all(TKitSpacing.pagePadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(title: 'Title', subtitle: 'Description'),
        const VSpace.md(),

        Section(
          title: 'Settings',
          children: [
            // Your content
          ],
        ),
      ],
    ),
  ),
)
```

## See Also

- Full documentation: `/DESIGN_SYSTEM.md`
- Migration guide: `/MIGRATION_GUIDE.md`
- Example: `category_mapping_editor_page_refactored.dart.example`
