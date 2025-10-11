import 'package:flutter/material.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/accent_button.dart';
import '../../domain/entities/category_mapping.dart';

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
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: TKitColors.border)),
                color: TKitColors.surfaceVariant,
              ),
              child: Row(
                children: [
                  Icon(
                    isEditMode ? Icons.edit : Icons.add_circle_outline,
                    color: TKitColors.accent,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isEditMode ? l10n.categoryMappingAddDialogEditTitle : l10n.categoryMappingAddDialogAddTitle,
                    style: TKitTextStyles.heading3,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    color: TKitColors.textSecondary,
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: l10n.categoryMappingAddDialogClose,
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(24),
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
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _processNameController,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.categoryMappingAddDialogProcessNameHint,
                        hintStyle: TKitTextStyles.bodyMedium.copyWith(
                          color: TKitColors.textMuted,
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.categoryMappingAddDialogProcessNameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Executable Path (Optional)
                    Text(
                      l10n.categoryMappingAddDialogExecutablePath,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _executablePathController,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.categoryMappingAddDialogExecutablePathHint,
                        hintStyle: TKitTextStyles.bodySmall.copyWith(
                          color: TKitColors.textMuted,
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category ID
                    Text(
                      l10n.categoryMappingAddDialogCategoryId,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _categoryIdController,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.categoryMappingAddDialogCategoryIdHint,
                        hintStyle: TKitTextStyles.bodyMedium.copyWith(
                          color: TKitColors.textMuted,
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.categoryMappingAddDialogCategoryIdRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Category Name
                    Text(
                      l10n.categoryMappingAddDialogCategoryName,
                      style: TKitTextStyles.labelSmall.copyWith(
                        color: TKitColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _categoryNameController,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: l10n.categoryMappingAddDialogCategoryNameHint,
                        hintStyle: TKitTextStyles.bodyMedium.copyWith(
                          color: TKitColors.textMuted,
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
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.categoryMappingAddDialogCategoryNameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.categoryMappingAddDialogTip,
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: TKitColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AccentButton(
                    text: l10n.categoryMappingAddDialogCancel,
                    onPressed: () => Navigator.of(context).pop(),
                    width: 120,
                  ),
                  const SizedBox(width: 12),
                  PrimaryButton(
                    text: isEditMode ? l10n.categoryMappingAddDialogUpdate : l10n.categoryMappingAddDialogAdd,
                    icon: isEditMode ? Icons.check : Icons.add,
                    onPressed: _handleSubmit,
                    width: 120,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final mapping = CategoryMapping(
        id: widget.mapping?.id,
        processName: _processNameController.text.trim(),
        executablePath: _executablePathController.text.trim().isEmpty
            ? null
            : _executablePathController.text.trim(),
        twitchCategoryId: _categoryIdController.text.trim(),
        twitchCategoryName: _categoryNameController.text.trim(),
        createdAt: widget.mapping?.createdAt ?? now,
        lastUsedAt: widget.mapping?.lastUsedAt,
        lastApiFetch: widget.mapping?.lastApiFetch ?? now,
        cacheExpiresAt: widget.mapping?.cacheExpiresAt ?? now.add(const Duration(hours: 24)),
        manualOverride: true,
      );

      Navigator.of(context).pop(mapping);
    }
  }
}
