import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// FileUploadField - File upload with drag-and-drop support
/// Shows selected file name and supports file type filtering
class FileUploadField extends StatefulWidget {
  final String? label;
  final String? hint;
  final List<String>? allowedExtensions;
  final ValueChanged<File?>? onFileSelected;
  final File? initialFile;
  final bool enabled;

  const FileUploadField({
    super.key,
    this.label,
    this.hint,
    this.allowedExtensions,
    this.onFileSelected,
    this.initialFile,
    this.enabled = true,
  });

  @override
  State<FileUploadField> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends State<FileUploadField> {
  File? _selectedFile;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _selectedFile = widget.initialFile;
  }

  Future<void> _pickFile() async {
    if (!widget.enabled) return;

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: widget.allowedExtensions != null
            ? FileType.custom
            : FileType.any,
        allowedExtensions: widget.allowedExtensions,
      );

      if (result != null) {
        final file = File(result.files.single.path!);
        setState(() {
          _selectedFile = file;
        });
        widget.onFileSelected?.call(file);
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  void _clearFile() {
    if (!widget.enabled) return;

    setState(() {
      _selectedFile = null;
    });
    widget.onFileSelected?.call(null);
  }

  String _getFileName() {
    if (_selectedFile == null) return '';
    return _selectedFile!.path.split(Platform.pathSeparator).last;
  }

  String _getFileSize() {
    if (_selectedFile == null) return '';
    final bytes = _selectedFile!.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TKitTextStyles.labelMedium,
          ),
          const SizedBox(height: TKitSpacing.xs),
        ],

        // Upload area
        MouseRegion(
          onEnter: (_) {
            if (widget.enabled) {
              setState(() => _isDragging = true);
            }
          },
          onExit: (_) {
            setState(() => _isDragging = false);
          },
          child: GestureDetector(
            onTap: _selectedFile == null ? _pickFile : null,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: widget.enabled
                    ? (_isDragging
                        ? TKitColors.surfaceVariant
                        : TKitColors.surface)
                    : TKitColors.surface,
                border: Border.all(
                  color: _isDragging
                      ? TKitColors.accent
                      : TKitColors.border,
                  width: 1,
                ),
              ),
              child: _selectedFile == null
                  ? _buildEmptyState()
                  : _buildFilePreview(),
            ),
          ),
        ),

        // Hint text
        if (widget.hint != null) ...[
          const SizedBox(height: TKitSpacing.xs),
          Text(
            widget.hint!,
            style: TKitTextStyles.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.upload_file,
            size: 24,
            color: widget.enabled
                ? TKitColors.textSecondary
                : TKitColors.textDisabled,
          ),
          const SizedBox(height: TKitSpacing.xs),
          Text(
            'Click to upload file',
            style: TKitTextStyles.bodySmall.copyWith(
              color: widget.enabled
                  ? TKitColors.textSecondary
                  : TKitColors.textDisabled,
            ),
          ),
          if (widget.allowedExtensions != null) ...[
            const SizedBox(height: 2),
            Text(
              'Allowed: ${widget.allowedExtensions!.join(", ")}',
              style: TKitTextStyles.bodySmall.copyWith(
                color: TKitColors.textMuted,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFilePreview() {
    return Padding(
      padding: const EdgeInsets.all(TKitSpacing.md),
      child: Row(
        children: [
          // File icon
          Icon(
            Icons.insert_drive_file,
            size: 20,
            color: TKitColors.accent,
          ),
          const SizedBox(width: TKitSpacing.sm),

          // File info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getFileName(),
                  style: TKitTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _getFileSize(),
                  style: TKitTextStyles.bodySmall,
                ),
              ],
            ),
          ),

          // Clear button
          if (widget.enabled)
            IconButton(
              icon: const Icon(Icons.close, size: 16),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: _clearFile,
              color: TKitColors.textSecondary,
              hoverColor: TKitColors.error,
            ),
        ],
      ),
    );
  }
}
