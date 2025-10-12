import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/colors.dart';
import '../../theme/spacing.dart';
import '../../theme/text_styles.dart';

/// ColorPickerField - Color picker input with preview
/// Shows color preview and allows hex input
class ColorPickerField extends StatefulWidget {
  final String? label;
  final Color initialColor;
  final ValueChanged<Color>? onColorChanged;
  final bool enabled;

  const ColorPickerField({
    super.key,
    this.label,
    this.initialColor = Colors.white,
    this.onColorChanged,
    this.enabled = true,
  });

  @override
  State<ColorPickerField> createState() => _ColorPickerFieldState();
}

class _ColorPickerFieldState extends State<ColorPickerField> {
  late Color _selectedColor;
  late TextEditingController _hexController;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _hexController = TextEditingController(
      text: _colorToHex(_selectedColor),
    );
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).substring(2).toUpperCase()}';
  }

  Color? _hexToColor(String hex) {
    try {
      final cleanHex = hex.replaceAll('#', '');
      if (cleanHex.length == 6) {
        return Color(int.parse('FF$cleanHex', radix: 16));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void _updateColor(Color color) {
    setState(() {
      _selectedColor = color;
      _hexController.text = _colorToHex(color);
    });
    widget.onColorChanged?.call(color);
  }

  void _showColorPicker() {
    if (!widget.enabled) return;

    showDialog(
      context: context,
      builder: (context) => _ColorPickerDialog(
        initialColor: _selectedColor,
        onColorSelected: _updateColor,
      ),
    );
  }

  void _onHexChanged() {
    final color = _hexToColor(_hexController.text);
    if (color != null) {
      setState(() {
        _selectedColor = color;
      });
      widget.onColorChanged?.call(color);
    }
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

        // Color input row
        Row(
          children: [
            // Color preview button
            GestureDetector(
              onTap: _showColorPicker,
              child: Container(
                width: 48,
                height: 32,
                decoration: BoxDecoration(
                  color: _selectedColor,
                  border: Border.all(color: TKitColors.border, width: 1),
                ),
                child: widget.enabled
                    ? const Icon(
                        Icons.colorize,
                        size: 16,
                        color: Colors.black54,
                      )
                    : null,
              ),
            ),
            const SizedBox(width: TKitSpacing.sm),

            // Hex input
            Expanded(
              child: SizedBox(
                height: 32,
                child: TextField(
                  controller: _hexController,
                  enabled: widget.enabled,
                  style: TKitTextStyles.bodyMedium,
                  decoration: InputDecoration(
                    hintText: '#FFFFFF',
                    hintStyle: TKitTextStyles.bodyMedium.copyWith(
                      color: TKitColors.textMuted,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: TKitSpacing.sm,
                      vertical: TKitSpacing.xs,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: TKitColors.border,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: TKitColors.border,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: TKitColors.accent,
                        width: 1,
                      ),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(
                        color: TKitColors.border,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: TKitColors.surface,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Fa-f#]')),
                    LengthLimitingTextInputFormatter(7),
                  ],
                  onSubmitted: (_) => _onHexChanged(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const _ColorPickerDialog({
    required this.initialColor,
    required this.onColorSelected,
  });

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color _currentColor;
  late double _hue;
  late double _saturation;
  late double _value;

  @override
  void initState() {
    super.initState();
    _currentColor = widget.initialColor;
    final hsv = HSVColor.fromColor(_currentColor);
    _hue = hsv.hue;
    _saturation = hsv.saturation;
    _value = hsv.value;
  }

  void _updateColor() {
    setState(() {
      _currentColor = HSVColor.fromAHSV(1.0, _hue, _saturation, _value).toColor();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TKitColors.surface,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(TKitSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pick Color',
              style: TKitTextStyles.heading3,
            ),
            const SizedBox(height: TKitSpacing.md),

            // Color preview
            Container(
              height: 60,
              decoration: BoxDecoration(
                color: _currentColor,
                border: Border.all(color: TKitColors.border, width: 1),
              ),
            ),
            const SizedBox(height: TKitSpacing.md),

            // Hue slider
            _buildSlider('Hue', _hue, 0, 360, (value) {
              setState(() => _hue = value);
              _updateColor();
            }),

            // Saturation slider
            _buildSlider('Saturation', _saturation, 0, 1, (value) {
              setState(() => _saturation = value);
              _updateColor();
            }),

            // Value slider
            _buildSlider('Value', _value, 0, 1, (value) {
              setState(() => _value = value);
              _updateColor();
            }),

            const SizedBox(height: TKitSpacing.md),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TKitTextStyles.buttonSmall.copyWith(
                      color: TKitColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(width: TKitSpacing.sm),
                ElevatedButton(
                  onPressed: () {
                    widget.onColorSelected(_currentColor);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TKitColors.accent,
                    foregroundColor: TKitColors.textPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    minimumSize: const Size(0, 32),
                  ),
                  child: Text(
                    'Select',
                    style: TKitTextStyles.buttonSmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TKitTextStyles.labelSmall,
        ),
        const SizedBox(height: TKitSpacing.xs),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: TKitColors.accent,
            inactiveTrackColor: TKitColors.border,
            thumbColor: TKitColors.accentBright,
            overlayColor: TKitColors.accent.withOpacity(0.2),
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
