import 'package:flutter/material.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/features/category_mapping/domain/entities/category_mapping.dart';
import 'package:tkit/features/category_mapping/data/utils/path_normalizer.dart';

/// Dialog for adding or editing a category mapping
class AddMappingDialog extends StatefulWidget {
  final CategoryMapping? mapping; // null for new, non-null for edit

  const AddMappingDialog({super.key, this.mapping});

  @override
  State<AddMappingDialog> createState() => _AddMappingDialogState();
}

class _AddMappingDialogState extends State<AddMappingDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _processNameController;
  late TextEditingController _executablePathController;
  late TextEditingController _categoryIdController;
  late TextEditingController _categoryNameController;

  bool get isEditMode => widget.mapping != null;

  @override
  void initState() {
    super.initState();
    _processNameController = TextEditingController(
      text: widget.mapping?.processName ?? '',
    );
    _executablePathController = TextEditingController(
      text: widget.mapping?.executablePath ?? '',
    );
    _categoryIdController = TextEditingController(
      text: widget.mapping?.twitchCategoryId ?? '',
    );
    _categoryNameController = TextEditingController(
      text: widget.mapping?.twitchCategoryName ?? '',
    );

    // Listen to executable path changes to update path preview
    _executablePathController.addListener(() {
      setState(() {
        // Trigger rebuild to update path preview
      });
    });
  }

  @override
  void dispose() {
    _processNameController.dispose();
    _executablePathController.dispose();
    _categoryIdController.dispose();
    _categoryNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Dialog(
      backgroundColor: TKitColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Sharp corners
      ),
      child: Container(
        width: 600,
        decoration: BoxDecoration(
          border: Border.all(color: TKitColors.border),
          color: TKitColors.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(TKitSpacing.lg),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: TKitColors.border)),
                color: TKitColors.surfaceVariant,
              ),
              child: Row(
                children: [
                  Icon(
                    isEditMode ? Icons.edit : Icons.add_circle_outline,
                    color: TKitColors.accent,
                    size: 20,
                  ),
                  const HSpace.sm(),
                  Text(
                    isEditMode ? l10n.categoryMappingAddDialogEditTitle : l10n.categoryMappingAddDialogAddTitle,
                    style: TKitTextStyles.heading3,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    color: TKitColors.textSecondary,
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: l10n.categoryMappingAddDialogClose,
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(TKitSpacing.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Process Name
                    Text(
                      l10n.categoryMappingAddDialogProcessName,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                        fontSize: 11,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const VSpace.sm(),
                    TextFormField(
                      controller: _processNameController,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textPrimary,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.categoryMappingAddDialogProcessNameHint,
                        hintStyle: TKitTextStyles.bodyMedium.copyWith(
                          color: TKitColors.textMuted,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: TKitColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.accent,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(color: TKitColors.error),
                        ),
                        contentPadding: const EdgeInsets.all(TKitSpacing.sm),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.categoryMappingAddDialogProcessNameRequired;
                        }
                        return null;
                      },
                    ),
                    const VSpace.md(),

                    // Executable Path (Optional)
                    Text(
                      l10n.categoryMappingAddDialogExecutablePath,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                        fontSize: 11,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const VSpace.sm(),
                    TextFormField(
                      controller: _executablePathController,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textPrimary,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.categoryMappingAddDialogExecutablePathHint,
                        hintStyle: TKitTextStyles.bodySmall.copyWith(
                          color: TKitColors.textMuted,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: TKitColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.accent,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(TKitSpacing.sm),
                      ),
                    ),
                    const VSpace.sm(),

                    // Privacy-safe path preview
                    _buildPathPreview(),
                    const VSpace.md(),

                    // Category ID
                    Text(
                      l10n.categoryMappingAddDialogCategoryId,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                        fontSize: 11,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const VSpace.sm(),
                    TextFormField(
                      controller: _categoryIdController,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textPrimary,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.categoryMappingAddDialogCategoryIdHint,
                        hintStyle: TKitTextStyles.bodyMedium.copyWith(
                          color: TKitColors.textMuted,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: TKitColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.accent,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(color: TKitColors.error),
                        ),
                        contentPadding: const EdgeInsets.all(TKitSpacing.sm),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.categoryMappingAddDialogCategoryIdRequired;
                        }
                        return null;
                      },
                    ),
                    const VSpace.md(),

                    // Category Name
                    Text(
                      l10n.categoryMappingAddDialogCategoryName,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                        fontSize: 11,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const VSpace.sm(),
                    TextFormField(
                      controller: _categoryNameController,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textPrimary,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.categoryMappingAddDialogCategoryNameHint,
                        hintStyle: TKitTextStyles.bodyMedium.copyWith(
                          color: TKitColors.textMuted,
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: TKitColors.background,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.border,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.border,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(
                            color: TKitColors.accent,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: const BorderSide(color: TKitColors.error),
                        ),
                        contentPadding: const EdgeInsets.all(TKitSpacing.sm),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.categoryMappingAddDialogCategoryNameRequired;
                        }
                        return null;
                      },
                    ),
                    const VSpace.sm(),
                    Text(
                      l10n.categoryMappingAddDialogTip,
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(TKitSpacing.lg),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: TKitColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AccentButton(
                    text: l10n.categoryMappingAddDialogCancel,
                    onPressed: () => Navigator.of(context).pop(),
                    width: 110,
                  ),
                  const HSpace.sm(),
                  PrimaryButton(
                    text: isEditMode ? l10n.categoryMappingAddDialogUpdate : l10n.categoryMappingAddDialogAdd,
                    icon: isEditMode ? Icons.check : Icons.add,
                    onPressed: _handleSubmit,
                    width: 110,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPathPreview() {
    final executablePath = _executablePathController.text.trim();

    // Only show preview if path is provided
    if (executablePath.isEmpty) {
      return const SizedBox.shrink();
    }

    // Extract normalized path
    final normalizedPath = PathNormalizer.extractGamePath(executablePath);
    final hasRecognizedPath = normalizedPath != null;

    return Container(
      padding: const EdgeInsets.all(TKitSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(
          color: hasRecognizedPath ? TKitColors.success : TKitColors.warning,
        ),
        color: hasRecognizedPath
            ? TKitColors.success.withValues(alpha: 0.05)
            : TKitColors.warning.withValues(alpha: 0.05),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            hasRecognizedPath ? Icons.check_circle_outline : Icons.info_outline,
            size: 16,
            color: hasRecognizedPath ? TKitColors.success : TKitColors.warning,
          ),
          const HSpace.xs(),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasRecognizedPath
                      ? 'Privacy-Safe Path'
                      : 'Custom Location',
                  style: TKitTextStyles.labelSmall.copyWith(
                    color: TKitColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
                const VSpace.xs(),
                if (hasRecognizedPath) ...[
                  Text(
                    normalizedPath,
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.textSecondary,
                      fontFamily: 'monospace',
                      fontSize: 10,
                    ),
                  ),
                  const VSpace.xs(),
                  Text(
                    'Only game folder names stored',
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ] else ...[
                  Text(
                    'Path not stored for privacy',
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.textMuted,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();

      // Extract normalized path from the executable path
      final executablePath = _executablePathController.text.trim().isEmpty
          ? null
          : _executablePathController.text.trim();

      String? normalizedPath;
      if (executablePath != null) {
        normalizedPath = PathNormalizer.extractGamePath(executablePath);
      }

      // Build list of normalized install paths
      List<String> normalizedPaths = [];

      // If editing, preserve existing paths
      if (widget.mapping != null) {
        normalizedPaths = List.from(widget.mapping!.normalizedInstallPaths);
      }

      // Add new path if it's valid and not already in the list
      if (normalizedPath != null && !normalizedPaths.contains(normalizedPath)) {
        normalizedPaths.add(normalizedPath);
      }

      final mapping = CategoryMapping(
        id: widget.mapping?.id,
        processName: _processNameController.text.trim(),
        executablePath: executablePath,
        normalizedInstallPaths: normalizedPaths,
        twitchCategoryId: _categoryIdController.text.trim(),
        twitchCategoryName: _categoryNameController.text.trim(),
        createdAt: widget.mapping?.createdAt ?? now,
        lastUsedAt: widget.mapping?.lastUsedAt,
        lastApiFetch: widget.mapping?.lastApiFetch ?? now,
        cacheExpiresAt: widget.mapping?.cacheExpiresAt ?? now.add(const Duration(hours: 24)),
        manualOverride: true,
        listId: widget.mapping?.listId ?? 'my-custom-mappings', // Default to custom list
      );

      Navigator.of(context).pop(mapping);
    }
  }
}
