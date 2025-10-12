import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/widgets/buttons/buttons.dart';
import '../../data/models/device_code_response.dart';
import '../providers/auth_provider.dart';

/// Device Code Authentication Page
/// Displays the user code and guides the user through Twitch activation
class DeviceCodeAuthPage extends StatefulWidget {
  final DeviceCodeResponse deviceCodeResponse;
  final VoidCallback? onSuccess;
  final VoidCallback? onCancel;

  const DeviceCodeAuthPage({
    super.key,
    required this.deviceCodeResponse,
    this.onSuccess,
    this.onCancel,
  });

  @override
  State<DeviceCodeAuthPage> createState() => _DeviceCodeAuthPageState();
}

class _DeviceCodeAuthPageState extends State<DeviceCodeAuthPage> {
  late Timer _expiryTimer;
  late Timer _pollTimer;
  late Duration _timeRemaining;
  bool _codeCopied = false;
  bool _isPolling = true;

  @override
  void initState() {
    super.initState();
    _timeRemaining = Duration(seconds: widget.deviceCodeResponse.expiresIn);

    // Start expiry countdown timer
    _expiryTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeRemaining.inSeconds > 0) {
            _timeRemaining = _timeRemaining - const Duration(seconds: 1);
          } else {
            timer.cancel();
            _isPolling = false;
          }
        });
      }
    });

    // Start polling for authorization
    _startPolling();
  }

  void _startPolling() {
    // Poll every interval seconds
    _pollTimer = Timer.periodic(
      Duration(seconds: widget.deviceCodeResponse.interval),
      (_) => _poll(),
    );
  }

  Future<void> _poll() async {
    if (!_isPolling || !mounted) return;

    try {
      final authProvider = context.read<AuthProvider>();
      await authProvider.authenticateWithDeviceCode(widget.deviceCodeResponse.deviceCode);

      // Success!
      if (mounted) {
        _isPolling = false;
        _pollTimer.cancel();
        _expiryTimer.cancel();

        widget.onSuccess?.call();
      }
    } catch (e) {
      // Authorization still pending, expired, or other error
      // Error handling is done in auth provider
      if (e.toString().contains('EXPIRED_TOKEN') ||
          e.toString().contains('ACCESS_DENIED')) {
        if (mounted) {
          setState(() => _isPolling = false);
        }
        _pollTimer.cancel();
      }
    }
  }

  @override
  void dispose() {
    _expiryTimer.cancel();
    _pollTimer.cancel();
    super.dispose();
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: widget.deviceCodeResponse.userCode));
    setState(() => _codeCopied = true);

    // Reset copied state after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _codeCopied = false);
      }
    });
  }

  Future<void> _openBrowser() async {
    final uri = Uri.parse(widget.deviceCodeResponse.verificationUri);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isExpired = _timeRemaining.inSeconds <= 0;

    return Dialog(
      backgroundColor: TKitColors.surface,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.tv,
                  color: TKitColors.accent,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.authDeviceCodeTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TKitIconButton(
                  icon: Icons.close,
                  onPressed: widget.onCancel,
                  tooltip: l10n.authDeviceCodeCancel,
                  showBorder: false,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Instructions
            Text(
              l10n.authDeviceCodeInstructions,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),

            // Step 1: Go to URL
            _buildStep(
              context,
              number: '1',
              title: l10n.authDeviceCodeStep1,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: TKitColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: TKitColors.border),
                      ),
                      child: Text(
                        widget.deviceCodeResponse.verificationUri,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontFamily: 'monospace',
                          color: TKitColors.accent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  PrimaryButton(
                    text: l10n.authDeviceCodeOpenBrowser,
                    icon: Icons.open_in_browser,
                    onPressed: _openBrowser,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Step 2: Enter code
            _buildStep(
              context,
              number: '2',
              title: l10n.authDeviceCodeStep2,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: TKitColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: TKitColors.accent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            l10n.authDeviceCodeCodeLabel,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TKitColors.textMuted,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            widget.deviceCodeResponse.userCode,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                              color: TKitColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      PrimaryButton(
                        text: _codeCopied
                            ? l10n.authDeviceCodeCopied
                            : l10n.authDeviceCodeCopyCode,
                        icon: _codeCopied ? Icons.check : Icons.copy,
                        onPressed: _copyCode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Step 3: Authorize
            _buildStep(
              context,
              number: '3',
              title: l10n.authDeviceCodeStep3,
            ),
            const SizedBox(height: 24),

            // Status and timer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isExpired
                    ? TKitColors.error.withOpacity(0.1)
                    : TKitColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isExpired ? TKitColors.error : TKitColors.border,
                ),
              ),
              child: Row(
                children: [
                  if (!isExpired) ...[
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(TKitColors.accent),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.authDeviceCodeWaiting,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.authDeviceCodeExpiresIn(
                              (_timeRemaining.inMinutes % 60).toString().padLeft(2, '0'),
                              (_timeRemaining.inSeconds % 60).toString().padLeft(2, '0'),
                            ),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: TKitColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Icon(Icons.error_outline, color: TKitColors.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        l10n.authDeviceCodeExpired,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: TKitColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Help text
            Text(
              l10n.authDeviceCodeHelp,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: TKitColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(
    BuildContext context, {
    required String number,
    required String title,
    Widget? child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: TKitColors.accent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: TKitColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (child != null) ...[
                const SizedBox(height: 8),
                child,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
