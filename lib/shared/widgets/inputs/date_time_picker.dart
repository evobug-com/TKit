import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/theme/text_styles.dart';

/// DatePickerField - Date picker with Flutter's built-in picker and TKit styling
class DatePickerField extends StatefulWidget {
  final String? label;
  final String? hint;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime?>? onDateChanged;
  final bool enabled;
  final String dateFormat;

  const DatePickerField({
    super.key,
    this.label,
    this.hint,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateChanged,
    this.enabled = true,
    this.dateFormat = 'MMM dd, yyyy',
  });

  @override
  State<DatePickerField> createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  Future<void> _showDatePicker() async {
    if (!widget.enabled) {
      return;
    }

    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: widget.firstDate ?? DateTime(1900),
      lastDate: widget.lastDate ?? DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: TKitColors.accent,
              onPrimary: TKitColors.textPrimary,
              surface: TKitColors.surface,
              onSurface: TKitColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TKitColors.textPrimary,
              ),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: TKitColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateChanged?.call(picked);
    }
  }

  void _clearDate() {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _selectedDate = null;
    });
    widget.onDateChanged?.call(null);
  }

  String _formatDate(DateTime date) {
    return DateFormat(widget.dateFormat).format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(widget.label!, style: TKitTextStyles.labelMedium),
          const SizedBox(height: TKitSpacing.xs),
        ],

        // Date input
        GestureDetector(
          onTap: _showDatePicker,
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.sm),
            decoration: BoxDecoration(
              color: TKitColors.surface,
              border: Border.all(color: TKitColors.border, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: widget.enabled
                      ? TKitColors.textSecondary
                      : TKitColors.textDisabled,
                ),
                const SizedBox(width: TKitSpacing.sm),
                Expanded(
                  child: Text(
                    _selectedDate != null
                        ? _formatDate(_selectedDate!)
                        : (widget.hint ?? 'Select date'),
                    style: TKitTextStyles.bodyMedium.copyWith(
                      color: _selectedDate != null
                          ? TKitColors.textPrimary
                          : TKitColors.textMuted,
                    ),
                  ),
                ),
                if (_selectedDate != null && widget.enabled)
                  GestureDetector(
                    onTap: _clearDate,
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: TKitColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// TimePickerField - Time picker with Flutter's built-in picker and TKit styling
class TimePickerField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TimeOfDay? initialTime;
  final ValueChanged<TimeOfDay?>? onTimeChanged;
  final bool enabled;
  final bool use24HourFormat;

  const TimePickerField({
    super.key,
    this.label,
    this.hint,
    this.initialTime,
    this.onTimeChanged,
    this.enabled = true,
    this.use24HourFormat = false,
  });

  @override
  State<TimePickerField> createState() => _TimePickerFieldState();
}

class _TimePickerFieldState extends State<TimePickerField> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
  }

  Future<void> _showTimePicker() async {
    if (!widget.enabled) {
      return;
    }

    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: TKitColors.accent,
              onPrimary: TKitColors.textPrimary,
              surface: TKitColors.surface,
              onSurface: TKitColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: TKitColors.textPrimary,
              ),
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: TKitColors.surface,
            ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(alwaysUse24HourFormat: widget.use24HourFormat),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
      widget.onTimeChanged?.call(picked);
    }
  }

  void _clearTime() {
    if (!widget.enabled) {
      return;
    }

    setState(() {
      _selectedTime = null;
    });
    widget.onTimeChanged?.call(null);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    if (widget.use24HourFormat) {
      return '${time.hour.toString().padLeft(2, '0')}:$minute';
    }

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(widget.label!, style: TKitTextStyles.labelMedium),
          const SizedBox(height: TKitSpacing.xs),
        ],

        // Time input
        GestureDetector(
          onTap: _showTimePicker,
          child: Container(
            height: 32,
            padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.sm),
            decoration: BoxDecoration(
              color: TKitColors.surface,
              border: Border.all(color: TKitColors.border, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: widget.enabled
                      ? TKitColors.textSecondary
                      : TKitColors.textDisabled,
                ),
                const SizedBox(width: TKitSpacing.sm),
                Expanded(
                  child: Text(
                    _selectedTime != null
                        ? _formatTime(_selectedTime!)
                        : (widget.hint ?? 'Select time'),
                    style: TKitTextStyles.bodyMedium.copyWith(
                      color: _selectedTime != null
                          ? TKitColors.textPrimary
                          : TKitColors.textMuted,
                    ),
                  ),
                ),
                if (_selectedTime != null && widget.enabled)
                  GestureDetector(
                    onTap: _clearTime,
                    child: const Icon(
                      Icons.close,
                      size: 14,
                      color: TKitColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
