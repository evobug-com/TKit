import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/widgets/layout/spacer.dart';
import '../../../../shared/widgets/layout/island.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/icon_button.dart';
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
      await authProvider.authenticateWithDeviceCode(
        widget.deviceCodeResponse.deviceCode,
      );

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
      backgroundColor: TKitColors.background,
      child: SizedBox(
        width: 500,
        child: Island.standard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  const Icon(
                    Icons.tv,
                    color: TKitColors.textSecondary,
                    size: 24,
                  ),
                  HSpace.sm(),
                  Expanded(
                    child: Text(
                      l10n.authDeviceCodeTitle,
                      style: TKitTextStyles.heading1,
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
              VSpace.xl(),

              // Instructions
              Text(
                l10n.authDeviceCodeInstructions,
                style: TKitTextStyles.bodyMedium.copyWith(
                  color: TKitColors.textSecondary,
                ),
              ),
              VSpace.xl(),

              // Step 1: Go to URL
              _buildStep(
                context,
                number: '1',
                title: l10n.authDeviceCodeStep1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IslandVariant.standard(
                      child: SelectableText(
                        widget.deviceCodeResponse.verificationUri,
                        style: TKitTextStyles.code.copyWith(
                          color: TKitColors.accent,
                        ),
                      ),
                    ),
                    VSpace.md(),
                    PrimaryButton(
                      text: l10n.authDeviceCodeOpenBrowser,
                      icon: Icons.open_in_browser,
                      onPressed: _openBrowser,
                    ),
                  ],
                ),
              ),
              VSpace.lg(),

              // Step 2: Enter code
              _buildStep(
                context,
                number: '2',
                title: l10n.authDeviceCodeStep2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    IslandVariant.standard(
                      child: Column(
                        children: [
                          Text(
                            l10n.authDeviceCodeCodeLabel,
                            style: TKitTextStyles.labelSmall.copyWith(
                              color: TKitColors.textMuted,
                            ),
                          ),
                          VSpace.sm(),
                          SelectableText(
                            widget.deviceCodeResponse.userCode,
                            style: TKitTextStyles.heading1.copyWith(
                              fontFamily: 'monospace',
                              letterSpacing: 4,
                              color: TKitColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    VSpace.md(),
                    PrimaryButton(
                      text: _codeCopied
                          ? l10n.authDeviceCodeCopied
                          : l10n.authDeviceCodeCopyCode,
                      icon: _codeCopied ? Icons.check : Icons.copy,
                      onPressed: _copyCode,
                    ),
                  ],
                ),
              ),
              VSpace.lg(),

              // Step 3: Authorize
              _buildStep(context, number: '3', title: l10n.authDeviceCodeStep3),
              VSpace.xl(),

              // Status and timer
              IslandVariant.standard(
                child: Row(
                  children: [
                    if (!isExpired) ...[
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(TKitColors.accent),
                        ),
                      ),
                      HSpace.md(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.authDeviceCodeWaiting,
                              style: TKitTextStyles.bodyMedium,
                            ),
                            VSpace.xs(),
                            Text(
                              l10n.authDeviceCodeExpiresIn(
                                (_timeRemaining.inMinutes % 60)
                                    .toString()
                                    .padLeft(2, '0'),
                                (_timeRemaining.inSeconds % 60)
                                    .toString()
                                    .padLeft(2, '0'),
                              ),
                              style: TKitTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      const Icon(
                        Icons.error_outline,
                        color: TKitColors.error,
                        size: 18,
                      ),
                      HSpace.md(),
                      Expanded(
                        child: Text(
                          l10n.authDeviceCodeExpired,
                          style: TKitTextStyles.bodyMedium.copyWith(
                            color: TKitColors.error,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              VSpace.md(),

              // Help text
              Text(
                l10n.authDeviceCodeHelp,
                style: TKitTextStyles.caption,
                textAlign: TextAlign.center,
              ),
            ],
          ),
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
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: TKitColors.accent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TKitTextStyles.labelMedium.copyWith(
                color: TKitColors.textPrimary,
              ),
            ),
          ),
        ),
        HSpace.md(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TKitTextStyles.labelLarge),
              if (child != null) ...[VSpace.sm(), child],
            ],
          ),
        ),
      ],
    );
  }
}
