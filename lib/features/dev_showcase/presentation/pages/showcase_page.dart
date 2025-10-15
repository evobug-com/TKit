import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tkit/shared/theme/theme.dart';
import 'package:tkit/shared/widgets/layout/layout.dart';
import 'package:tkit/shared/widgets/buttons/buttons.dart';
import 'package:tkit/shared/widgets/forms/forms.dart';
import 'package:tkit/shared/widgets/lists/lists.dart';
import 'package:tkit/shared/widgets/dialogs/dialogs.dart';
import 'package:tkit/shared/widgets/feedback/feedback.dart';
import 'package:tkit/shared/widgets/indicators/indicators.dart';
import 'package:tkit/shared/widgets/tables/tables.dart';
import 'package:tkit/shared/widgets/badges/badges.dart';
import 'package:tkit/shared/widgets/tooltips/tooltips.dart';
import 'package:tkit/shared/widgets/menus/menus.dart';
import 'package:tkit/shared/widgets/navigation/navigation.dart';
import 'package:tkit/shared/widgets/inputs/inputs.dart';
import 'package:tkit/shared/widgets/display/display.dart';

/// Design System Showcase
/// Only visible in development builds
@RoutePage()
class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  bool _showFormError = false;
  bool _showLoading = false;
  double _progressValue = 0.65;
  int _currentStep = 1;

  // Form controls
  bool _checkboxValue = false;
  bool _switchValue = true;
  String? _radioValue = 'option1';
  String? _dropdownValue;
  double _stepperValue = 10;

  // Table
  int _currentPage = 1;
  final int _totalPages = 5;

  // Searchable
  String _searchQuery = '';

  // Color picker
  Color _selectedColor = TKitColors.accent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TKitColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(TKitSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            PageHeader(
              title: '🎨 Design System Showcase',
              subtitle: 'All UI components and design tokens (Dev Only)',
            ),
            const VSpace.lg(),

            // Typography Section
            Section(
              title: 'Typography',
              subtitle: 'TKitTextStyles - All available text styles',
              children: [
                _buildTypographyExample('Heading 1', TKitTextStyles.heading1),
                _buildTypographyExample('Heading 2', TKitTextStyles.heading2),
                _buildTypographyExample('Heading 3', TKitTextStyles.heading3),
                _buildTypographyExample('Heading 4', TKitTextStyles.heading4),
                const VSpace.sm(),
                _buildTypographyExample('Body Large', TKitTextStyles.bodyLarge),
                _buildTypographyExample('Body Medium', TKitTextStyles.bodyMedium),
                _buildTypographyExample('Body Small', TKitTextStyles.bodySmall),
                const VSpace.sm(),
                _buildTypographyExample('Label Large', TKitTextStyles.labelLarge),
                _buildTypographyExample('Label Medium', TKitTextStyles.labelMedium),
                _buildTypographyExample('Label Small', TKitTextStyles.labelSmall),
                const VSpace.sm(),
                _buildTypographyExample('Button', TKitTextStyles.button),
                _buildTypographyExample('Button Small', TKitTextStyles.buttonSmall),
                _buildTypographyExample('Caption', TKitTextStyles.caption),
                _buildTypographyExample('Code: const value = 42;', TKitTextStyles.code),
              ],
            ),
            const VSpace.xl(),

            // Colors Section
            Section(
              title: 'Colors',
              subtitle: 'TKitColors - All available colors',
              children: [
                _buildColorRow('Background', TKitColors.background),
                _buildColorRow('Surface', TKitColors.surface),
                _buildColorRow('Surface Variant', TKitColors.surfaceVariant),
                const VSpace.sm(),
                _buildColorRow('Border', TKitColors.border),
                _buildColorRow('Border Light', TKitColors.borderLight),
                _buildColorRow('Border Subtle', TKitColors.borderSubtle),
                const VSpace.sm(),
                _buildColorRow('Text Primary', TKitColors.textPrimary),
                _buildColorRow('Text Secondary', TKitColors.textSecondary),
                _buildColorRow('Text Muted', TKitColors.textMuted),
                _buildColorRow('Text Disabled', TKitColors.textDisabled),
                const VSpace.sm(),
                _buildColorRow('Accent', TKitColors.accent),
                _buildColorRow('Accent Hover', TKitColors.accentHover),
                _buildColorRow('Accent Bright', TKitColors.accentBright),
                const VSpace.sm(),
                _buildColorRow('Success', TKitColors.success),
                _buildColorRow('Error', TKitColors.error),
                _buildColorRow('Warning', TKitColors.warning),
                _buildColorRow('Info', TKitColors.info),
              ],
            ),
            const VSpace.xl(),

            // Spacing Section
            Section(
              title: 'Spacing',
              subtitle: 'TKitSpacing - Consistent spacing values',
              children: [
                _buildSpacingExample('XS', TKitSpacing.xs),
                _buildSpacingExample('SM', TKitSpacing.sm),
                _buildSpacingExample('MD', TKitSpacing.md),
                _buildSpacingExample('LG', TKitSpacing.lg),
                _buildSpacingExample('XL', TKitSpacing.xl),
                _buildSpacingExample('XXL', TKitSpacing.xxl),
              ],
            ),
            const VSpace.xl(),

            // Islands Section
            Section(
              title: 'Islands',
              subtitle: 'Container components with consistent styling',
              wrapped: false,
              children: [
                Text('Island.compact (8px padding):', style: TKitTextStyles.labelSmall),
                const VSpace.xs(),
                Island.compact(
                  child: Text('Compact island content', style: TKitTextStyles.bodyMedium),
                ),
                const VSpace.md(),
                Text('Island.standard (12px padding):', style: TKitTextStyles.labelSmall),
                const VSpace.xs(),
                Island.standard(
                  child: Text('Standard island content', style: TKitTextStyles.bodyMedium),
                ),
                const VSpace.md(),
                Text('Island.comfortable (16px padding):', style: TKitTextStyles.labelSmall),
                const VSpace.xs(),
                Island.comfortable(
                  child: Text('Comfortable island content', style: TKitTextStyles.bodyMedium),
                ),
                const VSpace.md(),
                Text('IslandVariant.standard (lighter background):', style: TKitTextStyles.labelSmall),
                const VSpace.xs(),
                IslandVariant.standard(
                  child: Text('Variant island with surfaceVariant color', style: TKitTextStyles.bodyMedium),
                ),
              ],
            ),
            const VSpace.xl(),

            // Spacers Section
            Section(
              title: 'Spacers',
              subtitle: 'Named spacing widgets for vertical and horizontal gaps',
              children: [
                Text('Vertical Spacers:', style: TKitTextStyles.labelMedium),
                const VSpace.xs(),
                _buildSpacerDemo('VSpace.xs', const VSpace.xs()),
                _buildSpacerDemo('VSpace.sm', const VSpace.sm()),
                _buildSpacerDemo('VSpace.md', const VSpace.md()),
                _buildSpacerDemo('VSpace.lg', const VSpace.lg()),
                _buildSpacerDemo('VSpace.xl', const VSpace.xl()),
                const VSpace.md(),
                Text('Horizontal Spacers:', style: TKitTextStyles.labelMedium),
                const VSpace.xs(),
                Row(
                  children: [
                    Container(width: 50, height: 20, color: TKitColors.accent),
                    const HSpace.sm(),
                    Container(width: 50, height: 20, color: TKitColors.accent),
                    const HSpace.md(),
                    Container(width: 50, height: 20, color: TKitColors.accent),
                    const HSpace.lg(),
                    Container(width: 50, height: 20, color: TKitColors.accent),
                  ],
                ),
                const VSpace.xs(),
                Text('HSpace.sm → HSpace.md → HSpace.lg',
                  style: TKitTextStyles.bodySmall.copyWith(color: TKitColors.textMuted)),
              ],
            ),
            const VSpace.xl(),

            // StatItems Section
            Section(
              title: 'Stat Items',
              subtitle: 'Display statistics and metrics',
              wrapped: false,
              children: [
                IslandVariant.standard(
                  child: Row(
                    children: [
                      const StatItem(
                        label: 'Total Items',
                        value: '156',
                      ),
                      const HSpace.xxl(),
                      StatItem(
                        label: 'Active',
                        value: '42',
                        valueColor: TKitColors.success,
                      ),
                      const HSpace.xxl(),
                      StatItem(
                        label: 'Errors',
                        value: '3',
                        valueColor: TKitColors.error,
                        icon: Icons.error_outline,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Empty State Section
            Section(
              title: 'Empty State',
              subtitle: 'Show when there\'s no content',
              wrapped: false,
              children: [
                Island.standard(
                  child: SizedBox(
                    height: 250,
                    child: EmptyState(
                      icon: Icons.inbox_outlined,
                      message: 'No items found',
                      subtitle: 'Try adding your first item to get started',
                      action: PrimaryButton(
                        text: 'Add Item',
                        icon: Icons.add,
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Buttons Section
            Section(
              title: 'Buttons',
              subtitle: 'Compact primary and accent buttons (32px height)',
              children: [
                Row(
                  children: [
                    PrimaryButton(
                      text: 'Primary Button',
                      icon: Icons.check,
                      onPressed: () {},
                    ),
                    const HSpace.md(),
                    AccentButton(
                      text: 'Accent Button',
                      onPressed: () {},
                    ),
                  ],
                ),
                const VSpace.md(),
                Row(
                  children: [
                    PrimaryButton(
                      text: 'With Icon',
                      icon: Icons.add,
                      onPressed: () {},
                      width: 130,
                    ),
                    const HSpace.md(),
                    PrimaryButton(
                      text: 'Disabled',
                      onPressed: null,
                      width: 130,
                    ),
                  ],
                ),
                const VSpace.sm(),
                Text(
                  'Default: 32px height, 16px horizontal padding, 12px font',
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: TKitColors.textMuted,
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Form Components Section
            Section(
              title: 'Form Components',
              subtitle: 'Consistent form fields with labels, help text, and validation',
              wrapped: false,
              children: [
                Island.standard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FormFieldWrapper(
                        label: 'Username',
                        helpText: 'Choose a unique username',
                        required: true,
                        child: const TKitTextField(
                          hintText: 'Enter username',
                        ),
                      ),
                      const VSpace.md(),
                      FormFieldWrapper(
                        label: 'Email',
                        required: true,
                        errorText: _showFormError ? 'Invalid email address' : null,
                        child: const TKitTextField(
                          hintText: 'Enter email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const VSpace.md(),
                      FormFieldWrapper(
                        label: 'Description',
                        helpText: 'Optional description',
                        child: const TKitTextField(
                          hintText: 'Enter description',
                          maxLines: 3,
                        ),
                      ),
                      const VSpace.md(),
                      AccentButton(
                        text: _showFormError ? 'Hide Error' : 'Show Error',
                        onPressed: () {
                          setState(() {
                            _showFormError = !_showFormError;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // List Components Section
            Section(
              title: 'List Components',
              subtitle: 'Styled list items with consistent appearance',
              wrapped: false,
              children: [
                DataList(
                  children: [
                    DataListItem(
                      title: 'First Item',
                      subtitle: 'This is a description of the first item',
                      leading: const Icon(Icons.folder, size: 20, color: TKitColors.accent),
                      trailing: const Icon(Icons.arrow_forward, size: 16, color: TKitColors.textMuted),
                      onTap: () {},
                    ),
                    DataListItem(
                      title: 'Selected Item',
                      subtitle: 'This item is marked as selected',
                      leading: const Icon(Icons.check_circle, size: 20, color: TKitColors.success),
                      selected: true,
                      onTap: () {},
                    ),
                    DataListItem(
                      title: 'Third Item',
                      leading: const Icon(Icons.file_present, size: 20, color: TKitColors.textSecondary),
                      trailing: const Icon(Icons.more_vert, size: 16, color: TKitColors.textMuted),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
            const VSpace.xl(),

            // Dialog Components Section
            Section(
              title: 'Dialog Components',
              subtitle: 'Modal dialogs with consistent styling',
              children: [
                Row(
                  children: [
                    PrimaryButton(
                      text: 'Confirm Dialog',
                      icon: Icons.help_outline,
                      onPressed: () async {
                        final confirmed = await QuickActionDialog.confirm(
                          context: context,
                          title: 'Confirm Action',
                          message: 'Are you sure you want to proceed with this action?',
                        );
                        if (!context.mounted) return;
                        Toast.info(context, 'Result: ${confirmed ? "Confirmed" : "Cancelled"}');
                      },
                    ),
                    const HSpace.md(),
                    PrimaryButton(
                      text: 'Info Dialog',
                      icon: Icons.info_outline,
                      onPressed: () async {
                        await QuickActionDialog.info(
                          context: context,
                          title: 'Information',
                          message: 'This is an informational message for the user.',
                        );
                      },
                    ),
                  ],
                ),
                const VSpace.sm(),
                Row(
                  children: [
                    PrimaryButton(
                      text: 'Error Dialog',
                      icon: Icons.error_outline,
                      onPressed: () async {
                        await QuickActionDialog.error(
                          context: context,
                          title: 'Error Occurred',
                          message: 'An error has occurred. Please try again.',
                        );
                      },
                    ),
                    const HSpace.md(),
                    PrimaryButton(
                      text: 'Custom Dialog',
                      icon: Icons.settings,
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => BaseDialog(
                            title: 'Custom Dialog',
                            icon: Icons.settings,
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FormFieldWrapper(
                                  label: 'Setting Name',
                                  child: TKitTextField(hintText: 'Enter name'),
                                ),
                                const VSpace.md(),
                                FormFieldWrapper(
                                  label: 'Value',
                                  child: const TKitTextField(hintText: 'Enter value'),
                                ),
                              ],
                            ),
                            actions: [
                              AccentButton(
                                text: 'Cancel',
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              const HSpace.sm(),
                              PrimaryButton(
                                text: 'Save',
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            const VSpace.xl(),

            // Toast Components Section
            Section(
              title: 'Toast Notifications',
              subtitle: 'Quick feedback messages for user actions',
              children: [
                Row(
                  children: [
                    PrimaryButton(
                      text: 'Success',
                      icon: Icons.check_circle,
                      onPressed: () {
                        Toast.success(context, 'Operation completed successfully!');
                      },
                    ),
                    const HSpace.md(),
                    PrimaryButton(
                      text: 'Error',
                      icon: Icons.error,
                      onPressed: () {
                        Toast.error(context, 'An error occurred during the operation.');
                      },
                    ),
                  ],
                ),
                const VSpace.sm(),
                Row(
                  children: [
                    PrimaryButton(
                      text: 'Warning',
                      icon: Icons.warning,
                      onPressed: () {
                        Toast.warning(context, 'Please review your settings before continuing.');
                      },
                    ),
                    const HSpace.md(),
                    PrimaryButton(
                      text: 'Info',
                      icon: Icons.info,
                      onPressed: () {
                        Toast.info(context, 'Your changes have been saved automatically.');
                      },
                    ),
                  ],
                ),
              ],
            ),
            const VSpace.xl(),

            // Loading States Section
            Section(
              title: 'Loading States',
              subtitle: 'Various loading indicators and skeleton loaders',
              wrapped: false,
              children: [
                Island.standard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Inline Loading:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      const InlineLoading(message: 'Loading data...'),
                      const VSpace.lg(),
                      Text('Skeleton Loaders:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      Row(
                        children: [
                          const SkeletonLoader(
                            width: 100,
                            height: 100,
                          ),
                          const HSpace.md(),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SkeletonLoader(width: double.infinity, height: 16),
                                VSpace.xs(),
                                SkeletonLoader(width: 200, height: 14),
                                VSpace.xs(),
                                SkeletonLoader(width: 150, height: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const VSpace.lg(),
                      Text('Loading Overlay Preview:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: TKitColors.border),
                          color: TKitColors.background,
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Text(
                                'Background Content',
                                style: TKitTextStyles.bodyMedium.copyWith(
                                  color: TKitColors.textMuted,
                                ),
                              ),
                            ),
                            if (_showLoading)
                              const LoadingOverlay(
                                message: 'Loading data...',
                              ),
                          ],
                        ),
                      ),
                      const VSpace.sm(),
                      AccentButton(
                        text: _showLoading ? 'Hide Overlay' : 'Show Overlay',
                        onPressed: () {
                          setState(() {
                            _showLoading = !_showLoading;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Progress Indicators Section
            Section(
              title: 'Progress Indicators',
              subtitle: 'Linear, circular, and step-based progress displays',
              wrapped: false,
              children: [
                Island.standard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Linear Progress:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      ProgressBar(
                        progress: _progressValue,
                        label: 'Uploading',
                      ),
                      const VSpace.md(),
                      Row(
                        children: [
                          AccentButton(
                            text: 'Decrease',
                            onPressed: () {
                              setState(() {
                                _progressValue = (_progressValue - 0.1).clamp(0.0, 1.0);
                              });
                            },
                          ),
                          const HSpace.sm(),
                          AccentButton(
                            text: 'Increase',
                            onPressed: () {
                              setState(() {
                                _progressValue = (_progressValue + 0.1).clamp(0.0, 1.0);
                              });
                            },
                          ),
                        ],
                      ),
                      const VSpace.lg(),
                      Text('Circular Progress:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      CircularProgress(
                        progress: _progressValue,
                        size: 64,
                      ),
                      const VSpace.lg(),
                      Text('Step Progress:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      StepProgress(
                        currentStep: _currentStep,
                        totalSteps: 4,
                        labels: const ['Setup', 'Configure', 'Review', 'Complete'],
                      ),
                      const VSpace.md(),
                      Row(
                        children: [
                          AccentButton(
                            text: 'Previous',
                            onPressed: _currentStep > 0
                                ? () {
                                    setState(() {
                                      _currentStep = (_currentStep - 1).clamp(0, 3);
                                    });
                                  }
                                : null,
                          ),
                          const HSpace.sm(),
                          AccentButton(
                            text: 'Next',
                            onPressed: _currentStep < 3
                                ? () {
                                    setState(() {
                                      _currentStep = (_currentStep + 1).clamp(0, 3);
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Form Controls Section
            Section(
              title: 'Form Controls',
              subtitle: 'Checkboxes, switches, radio buttons, dropdowns, and steppers',
              wrapped: false,
              children: [
                Island.standard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Checkbox:', style: TKitTextStyles.labelMedium),
                      const VSpace.xs(),
                      TKitCheckbox(
                        value: _checkboxValue,
                        onChanged: (value) => setState(() => _checkboxValue = value ?? false),
                        label: 'Enable notifications',
                      ),
                      const VSpace.lg(),
                      Text('Switch:', style: TKitTextStyles.labelMedium),
                      const VSpace.xs(),
                      TKitSwitch(
                        value: _switchValue,
                        onChanged: (value) => setState(() => _switchValue = value),
                        label: 'Dark Mode',
                      ),
                      const VSpace.lg(),
                      Text('Radio Group:', style: TKitTextStyles.labelMedium),
                      const VSpace.xs(),
                      TKitRadioGroup<String>(
                        value: _radioValue,
                        onChanged: (value) => setState(() => _radioValue = value),
                        options: const [
                          TKitRadioOption(value: 'option1', label: 'Option 1'),
                          TKitRadioOption(value: 'option2', label: 'Option 2'),
                          TKitRadioOption(value: 'option3', label: 'Option 3'),
                        ],
                      ),
                      const VSpace.lg(),
                      Text('Dropdown:', style: TKitTextStyles.labelMedium),
                      const VSpace.xs(),
                      TKitDropdown<String>(
                        value: _dropdownValue,
                        onChanged: (value) => setState(() => _dropdownValue = value),
                        placeholder: 'Select an option',
                        options: const [
                          TKitDropdownOption(value: 'item1', label: 'Item 1'),
                          TKitDropdownOption(value: 'item2', label: 'Item 2'),
                          TKitDropdownOption(value: 'item3', label: 'Item 3'),
                        ],
                      ),
                      const VSpace.lg(),
                      Text('Number Stepper:', style: TKitTextStyles.labelMedium),
                      const VSpace.xs(),
                      TKitNumberStepper(
                        value: _stepperValue,
                        onChanged: (value) => setState(() => _stepperValue = value),
                        min: 0,
                        max: 100,
                        step: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Tables & Pagination Section
            Section(
              title: 'Tables & Pagination',
              subtitle: 'Data tables with sorting and pagination',
              wrapped: false,
              children: [
                TKitDataTable<Map<String, String>>(
                  items: [
                    {'name': 'Item 1', 'status': 'Active', 'count': '42'},
                    {'name': 'Item 2', 'status': 'Inactive', 'count': '15'},
                    {'name': 'Item 3', 'status': 'Active', 'count': '73'},
                  ],
                  columns: [
                    TKitTableColumn(
                      label: 'Name',
                      id: 'name',
                      cellBuilder: (item) => Text(item['name']!, style: TKitTextStyles.bodyMedium),
                      sortable: true,
                      comparator: (a, b) => a['name']!.compareTo(b['name']!),
                    ),
                    TKitTableColumn(
                      label: 'Status',
                      id: 'status',
                      cellBuilder: (item) => StatusBadge(
                        status: item['status'] == 'Active' ? StatusBadgeType.success : StatusBadgeType.idle,
                        label: item['status'],
                        compact: true,
                      ),
                    ),
                    TKitTableColumn(
                      label: 'Count',
                      id: 'count',
                      cellBuilder: (item) => Text(item['count']!, style: TKitTextStyles.bodyMedium),
                      width: 100,
                      textAlign: TextAlign.right,
                    ),
                  ],
                  compact: true,
                ),
                const VSpace.md(),
                Pagination(
                  currentPage: _currentPage,
                  totalPages: _totalPages,
                  onPageChanged: (page) => setState(() => _currentPage = page),
                  compact: true,
                ),
              ],
            ),
            const VSpace.xl(),

            // Badges & Tags Section
            Section(
              title: 'Badges & Tags',
              subtitle: 'Status indicators and removable tags',
              children: [
                Text('Badges:', style: TKitTextStyles.labelMedium),
                const VSpace.sm(),
                Wrap(
                  spacing: TKitSpacing.md,
                  runSpacing: TKitSpacing.sm,
                  children: const [
                    TKitBadge(text: 'Default'),
                    TKitBadge(text: 'Success', variant: TKitBadgeVariant.success),
                    TKitBadge(text: 'Error', variant: TKitBadgeVariant.error),
                    TKitBadge(text: 'Warning', variant: TKitBadgeVariant.warning),
                    TKitBadge(text: 'Info', variant: TKitBadgeVariant.info),
                    TKitCountBadge(count: 5, variant: TKitBadgeVariant.error),
                    TKitBadge(dotOnly: true, variant: TKitBadgeVariant.success),
                  ],
                ),
                const VSpace.lg(),
                Text('Tags:', style: TKitTextStyles.labelMedium),
                const VSpace.sm(),
                TKitTagGroup(
                  tags: [
                    const TKitTag(label: 'Flutter'),
                    const TKitTag(label: 'Dart', icon: Icons.code),
                    TKitTag(label: 'Removable', removable: true, onRemove: () {}),
                    const TKitTag(label: 'Error', variant: TKitTagVariant.error),
                    const TKitTag(label: 'Success', variant: TKitTagVariant.success),
                  ],
                ),
              ],
            ),
            const VSpace.xl(),

            // Tooltips & Icon Buttons Section
            Section(
              title: 'Tooltips & Icon Buttons',
              subtitle: 'Hover information and compact icon actions',
              children: [
                Row(
                  children: [
                    TKitTooltip(
                      message: 'This is a helpful tooltip',
                      child: Container(
                        padding: const EdgeInsets.all(TKitSpacing.sm),
                        decoration: BoxDecoration(
                          border: Border.all(color: TKitColors.border),
                        ),
                        child: Text('Hover me', style: TKitTextStyles.bodyMedium),
                      ),
                    ),
                    const HSpace.md(),
                    const InfoTooltip(message: 'Click for help information'),
                  ],
                ),
                const VSpace.md(),
                Text('Icon Buttons:', style: TKitTextStyles.labelMedium),
                const VSpace.sm(),
                Row(
                  children: [
                    TKitIconButton(
                      icon: Icons.edit,
                      onPressed: () {},
                      size: TKitIconButtonSize.small,
                      tooltip: 'Edit (Small)',
                    ),
                    const HSpace.sm(),
                    TKitIconButton(
                      icon: Icons.delete,
                      onPressed: () {},
                      size: TKitIconButtonSize.medium,
                      tooltip: 'Delete (Medium)',
                    ),
                    const HSpace.sm(),
                    TKitIconButton(
                      icon: Icons.save,
                      onPressed: () {},
                      size: TKitIconButtonSize.large,
                      tooltip: 'Save (Large)',
                    ),
                    const HSpace.sm(),
                    IconToggleButton(
                      isActive: _switchValue,
                      icon: Icons.favorite_border,
                      activeIcon: Icons.favorite,
                      onPressed: () => setState(() => _switchValue = !_switchValue),
                      tooltip: 'Toggle Favorite',
                    ),
                  ],
                ),
              ],
            ),
            const VSpace.xl(),

            // Menus Section
            Section(
              title: 'Menus & Dropdowns',
              subtitle: 'Context menus, dropdown menus, and menu buttons',
              children: [
                Row(
                  children: [
                    MenuButton.overflow(
                      actions: [
                        MenuAction(label: 'Edit', icon: Icons.edit, onTap: () {}),
                        MenuAction(label: 'Copy', icon: Icons.copy, onTap: () {}),
                        MenuAction.divider(),
                        MenuAction(label: 'Delete', icon: Icons.delete, onTap: () {}, textColor: TKitColors.error),
                      ],
                    ),
                    const HSpace.md(),
                    MenuButton(
                      label: 'Actions',
                      icon: Icons.arrow_drop_down,
                      actions: [
                        MenuAction(label: 'Save', icon: Icons.save, onTap: () {}),
                        MenuAction(label: 'Export', icon: Icons.download, onTap: () {}),
                      ],
                    ),
                    const HSpace.md(),
                    SplitButton(
                      text: 'Save',
                      icon: Icons.save,
                      onPressed: () {},
                      actions: [
                        SplitButtonAction(label: 'Save As...', icon: Icons.save_as, onPressed: () {}),
                        SplitButtonAction(label: 'Save All', icon: Icons.save_alt, onPressed: () {}),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const VSpace.xl(),

            // Search Components Section
            Section(
              title: 'Search Components',
              subtitle: 'Search fields and searchable dropdowns',
              wrapped: false,
              children: [
                Island.standard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Search Field:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      SearchField(
                        hintText: 'Search...',
                        onSearch: (query) => setState(() => _searchQuery = query),
                      ),
                      if (_searchQuery.isNotEmpty) ...[
                        const VSpace.xs(),
                        Text('Searching for: $_searchQuery', style: TKitTextStyles.bodySmall.copyWith(color: TKitColors.textMuted)),
                      ],
                      const VSpace.lg(),
                      Text('Searchable Dropdown:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      SearchableDropdown<String>(
                        items: ['Apple', 'Banana', 'Cherry', 'Date', 'Elderberry', 'Fig', 'Grape'],
                        itemLabel: (item) => item,
                        value: _dropdownValue,
                        onChanged: (value) => setState(() => _dropdownValue = value),
                        hintText: 'Select a fruit',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Alerts & Banners Section
            Section(
              title: 'Alerts & Banners',
              subtitle: 'Persistent notifications and contextual alerts',
              wrapped: false,
              children: [
                Alert.info(message: 'This is an informational alert'),
                const VSpace.sm(),
                Alert.success(message: 'Operation completed successfully!'),
                const VSpace.sm(),
                Alert.warning(message: 'Please review your settings', dismissible: true, onDismiss: () {}),
                const VSpace.sm(),
                Alert.error(message: 'An error occurred', actionLabel: 'RETRY', onAction: () {}),
                const VSpace.md(),
                Text('Inline Alerts:', style: TKitTextStyles.labelMedium),
                const VSpace.sm(),
                Island.standard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      InlineAlert.info(message: 'Helpful tip: Save often'),
                      VSpace.xs(),
                      InlineAlert.warning(message: 'This field is required'),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Navigation Components Section
            Section(
              title: 'Navigation',
              subtitle: 'Tabs and breadcrumbs for navigation',
              wrapped: false,
              children: [
                Island.standard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tabs:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      SizedBox(
                        height: 200,
                        child: TKitTabController(
                          tabs: const [
                            TKitTab(label: 'Overview', icon: Icons.dashboard),
                            TKitTab(label: 'Settings', icon: Icons.settings),
                            TKitTab(label: 'Help', icon: Icons.help_outline),
                          ],
                          compact: true,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(TKitSpacing.md),
                              child: Text('Overview content', style: TKitTextStyles.bodyMedium),
                            ),
                            Container(
                              padding: const EdgeInsets.all(TKitSpacing.md),
                              child: Text('Settings content', style: TKitTextStyles.bodyMedium),
                            ),
                            Container(
                              padding: const EdgeInsets.all(TKitSpacing.md),
                              child: Text('Help content', style: TKitTextStyles.bodyMedium),
                            ),
                          ],
                        ),
                      ),
                      const VSpace.lg(),
                      Text('Breadcrumbs:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      Breadcrumb(
                        items: [
                          BreadcrumbItem(label: 'Home', icon: Icons.home, onTap: () {}),
                          BreadcrumbItem(label: 'Products', onTap: () {}),
                          BreadcrumbItem(label: 'Widget'),
                        ],
                        compact: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Collapsible & Accordion Section
            Section(
              title: 'Collapsible & Accordion',
              subtitle: 'Expandable content sections',
              wrapped: false,
              children: [
                CollapsiblePanel(
                  title: 'Collapsible Panel',
                  subtitle: 'Click to expand or collapse',
                  icon: Icons.info_outline,
                  child: Text('This is the content inside the collapsible panel. It can contain any widgets.', style: TKitTextStyles.bodyMedium),
                ),
                const VSpace.md(),
                Accordion(
                  items: [
                    AccordionItem(
                      title: 'Section 1',
                      subtitle: 'First section',
                      icon: Icons.folder,
                      child: Text('Content for section 1', style: TKitTextStyles.bodyMedium),
                    ),
                    AccordionItem(
                      title: 'Section 2',
                      subtitle: 'Second section',
                      icon: Icons.settings,
                      child: Text('Content for section 2', style: TKitTextStyles.bodyMedium),
                    ),
                  ],
                ),
              ],
            ),
            const VSpace.xl(),

            // Advanced Inputs Section
            Section(
              title: 'Advanced Inputs',
              subtitle: 'Color picker, date/time pickers, and file upload',
              wrapped: false,
              children: [
                Island.standard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Color Picker:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      ColorPickerField(
                        label: 'Choose Color',
                        initialColor: _selectedColor,
                        onColorChanged: (color) => setState(() => _selectedColor = color),
                      ),
                      const VSpace.lg(),
                      Text('Date & Time Pickers:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      DatePickerField(
                        label: 'Select Date',
                        hint: 'Choose a date',
                        onDateChanged: (date) {},
                      ),
                      const VSpace.md(),
                      TimePickerField(
                        label: 'Select Time',
                        hint: 'Choose a time',
                        onTimeChanged: (time) {},
                      ),
                      const VSpace.lg(),
                      Text('File Upload:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      FileUploadField(
                        label: 'Upload Document',
                        hint: 'PDF, DOC, or DOCX',
                        allowedExtensions: const ['pdf', 'doc', 'docx'],
                        onFileSelected: (file) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Display Components Section
            Section(
              title: 'Display Components',
              subtitle: 'TreeView, avatars, and dividers',
              wrapped: false,
              children: [
                Island.standard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Avatars:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      Row(
                        children: [
                          const Avatar.small(name: 'John Doe'),
                          const HSpace.sm(),
                          const Avatar.medium(name: 'Jane Smith'),
                          const HSpace.sm(),
                          const Avatar.large(name: 'Bob Johnson'),
                          const HSpace.md(),
                          AvatarGroup(
                            avatars: const [
                              Avatar.small(name: 'User 1'),
                              Avatar.small(name: 'User 2'),
                              Avatar.small(name: 'User 3'),
                              Avatar.small(name: 'User 4'),
                            ],
                            maxVisible: 3,
                          ),
                        ],
                      ),
                      const VSpace.lg(),
                      Text('Dividers:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      const TKitDivider(),
                      const VSpace.sm(),
                      const TKitDivider.labeled(label: 'Section'),
                      const VSpace.sm(),
                      const TKitDivider.subtle(),
                      const VSpace.lg(),
                      Text('Tree View:', style: TKitTextStyles.labelMedium),
                      const VSpace.sm(),
                      TreeView<String>(
                        nodes: [
                          TreeNodeData(
                            value: 'root1',
                            label: 'Folder 1',
                            icon: Icons.folder,
                            children: [
                              TreeNodeData(value: 'file1', label: 'File 1.txt', icon: Icons.insert_drive_file),
                              TreeNodeData(value: 'file2', label: 'File 2.txt', icon: Icons.insert_drive_file),
                            ],
                          ),
                          TreeNodeData(
                            value: 'root2',
                            label: 'Folder 2',
                            icon: Icons.folder,
                            children: [
                              TreeNodeData(value: 'file3', label: 'File 3.txt', icon: Icons.insert_drive_file),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Usage Example Section
            Section(
              title: 'Usage Example',
              subtitle: 'Standard page layout pattern',
              children: [
                Container(
                  padding: const EdgeInsets.all(TKitSpacing.md),
                  decoration: BoxDecoration(
                    color: TKitColors.background,
                    border: Border.all(color: TKitColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '// Standard page pattern',
                        style: TKitTextStyles.code,
                      ),
                      const VSpace.xs(),
                      Text(
                        '''
Scaffold(
  backgroundColor: TKitColors.background,
  body: Padding(
    padding: EdgeInsets.all(TKitSpacing.pagePadding),
    child: Column(
      children: [
        PageHeader(title: 'Title', subtitle: 'Description'),
        const VSpace.md(),
        Section(title: 'Section', children: [...]),
      ],
    ),
  ),
)''',
                        style: TKitTextStyles.code.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VSpace.xl(),

            // Documentation Links
            IslandVariant.standard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline, size: 20, color: TKitColors.info),
                      const HSpace.sm(),
                      Text('Documentation', style: TKitTextStyles.labelLarge),
                    ],
                  ),
                  const VSpace.sm(),
                  Text(
                    '📚 Full documentation: /DESIGN_SYSTEM.md\n'
                    '🔄 Migration guide: /MIGRATION_GUIDE.md\n'
                    '📝 Example: category_mapping_editor_page_refactored.dart.example\n\n'
                    'Complete Component Library:\n\n'
                    'Layout: Islands, Sections, Spacers, Accordion, Collapsible\n'
                    'Forms: TextField, Checkbox, Switch, Radio, Dropdown, Stepper, Search, FileUpload\n'
                    'Inputs: ColorPicker, DatePicker, TimePicker\n'
                    'Buttons: Primary, Accent, Icon, Toggle, Split, Menu\n'
                    'Tables: DataTable, Pagination\n'
                    'Lists: DataList, DataListItem\n'
                    'Dialogs: BaseDialog, QuickActionDialog\n'
                    'Feedback: Toast, Alert, InlineAlert\n'
                    'Indicators: Loading, Progress, Badges, Status\n'
                    'Navigation: Tabs, Breadcrumbs\n'
                    'Menus: Context, Dropdown, MenuButton\n'
                    'Display: TreeView, Avatar, Divider\n'
                    'Tooltips: TKitTooltip, InfoTooltip',
                    style: TKitTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
            const VSpace.xxl(),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographyExample(String label, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: TKitTextStyles.bodySmall.copyWith(color: TKitColors.textMuted),
            ),
          ),
          const HSpace.md(),
          Expanded(
            child: Text(
              'The quick brown fox jumps over the lazy dog',
              style: style,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: TKitColors.border),
            ),
          ),
          const HSpace.md(),
          SizedBox(
            width: 150,
            child: Text(label, style: TKitTextStyles.bodySmall),
          ),
          const HSpace.md(),
          Text(
            '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
            style: TKitTextStyles.code.copyWith(
              fontSize: 11,
              color: TKitColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpacingExample(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TKitTextStyles.bodySmall.copyWith(color: TKitColors.textMuted),
            ),
          ),
          const HSpace.md(),
          Container(
            width: value,
            height: 20,
            color: TKitColors.accent,
          ),
          const HSpace.md(),
          Text(
            '${value.toInt()}px',
            style: TKitTextStyles.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSpacerDemo(String label, Widget spacer) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: TKitTextStyles.bodySmall),
        ),
        Container(
          width: 30,
          height: 20,
          color: TKitColors.accent,
        ),
        spacer,
        Container(
          width: 30,
          height: 20,
          color: TKitColors.accent,
        ),
      ],
    );
  }
}
