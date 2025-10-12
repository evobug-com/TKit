import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/widgets/cards/panel_card.dart';
import '../../../../shared/widgets/indicators/loading_indicator.dart';
import '../../../../shared/widgets/buttons/buttons.dart';
import '../providers/auth_provider.dart';
import '../states/auth_state.dart';
import '../widgets/auth_status_indicator.dart';

/// Authentication page with Twitch branding
/// Modal dialog (600x440) with two-column layout: instructions and Twitch branding
@RoutePage()
class AuthPage extends StatelessWidget {
  final VoidCallback? onAuthSuccess;

  const AuthPage({super.key, this.onAuthSuccess});

  @override
  Widget build(BuildContext context) {
    // Get AuthProvider from parent context
    final provider = context.read<AuthProvider>();
    provider.checkAuthStatus();

    return _AuthPageContent(onAuthSuccess: onAuthSuccess);
  }
}

class _AuthPageContent extends StatelessWidget {
  final VoidCallback? onAuthSuccess;

  const _AuthPageContent({this.onAuthSuccess});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: TKitColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Container(
        width: 600,
        height: 440,
        decoration: BoxDecoration(
          color: TKitColors.surface,
          border: Border.all(color: TKitColors.border, width: 1),
        ),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            final state = authProvider.state;

            // Handle state changes that require side effects
            if (state is Authenticated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Show success message briefly
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${AppLocalizations.of(context)!.authSuccessAuthenticatedAs} ${state.user.displayName}',
                      style: TKitTextStyles.bodyMedium,
                    ),
                    backgroundColor: TKitColors.success,
                    duration: const Duration(seconds: 2),
                  ),
                );

                // Call callback and close dialog
                Future.delayed(const Duration(seconds: 2), () {
                  onAuthSuccess?.call();
                  Navigator.of(context).pop();
                });
              });
            }

            return Column(
              children: [
                // Header
                _buildHeader(context, state),

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: _buildContent(context, state),
                  ),
                ),

                // Footer with status indicator
                _buildFooter(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthState state) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: TKitColors.border, width: 1)),
      ),
      child: Row(
        children: [
          // Twitch logo placeholder (would be replaced with actual logo)
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: TKitColors.accent,
              borderRadius: BorderRadius.zero,
            ),
            child: const Icon(
              Icons.videocam,
              color: TKitColors.textPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            AppLocalizations.of(context)!.authConnectToTwitch,
            style: TKitTextStyles.heading2,
          ),
          const Spacer(),
          TKitIconButton(
            icon: Icons.close,
            onPressed: () => Navigator.of(context).pop(),
            showBorder: false,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AuthState state) {
    if (state is AuthLoading || state is TokenRefreshing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const LoadingIndicator(),
            const SizedBox(height: 16),
            Text(
              state is AuthLoading
                  ? (state.message ?? AppLocalizations.of(context)!.authLoading)
                  : AppLocalizations.of(context)!.authRefreshingToken,
              style: TKitTextStyles.bodySmall,
            ),
          ],
        ),
      );
    }

    if (state is Authenticated) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: TKitColors.success, size: 64),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.authSuccessfullyAuthenticated,
              style: TKitTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.authLoggedInAs} ${state.user.displayName}',
              style: TKitTextStyles.bodySmall,
            ),
          ],
        ),
      );
    }

    if (state is AuthError) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: TKitColors.error, size: 64),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.authErrorAuthenticationFailed,
              style: TKitTextStyles.heading3,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                state.message,
                style: TKitTextStyles.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (state.code != null) ...[
              const SizedBox(height: 6),
              Text(
                '${AppLocalizations.of(context)!.authErrorErrorCode} ${state.code}',
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textMuted,
                ),
              ),
            ],
            const SizedBox(height: 28),
            PrimaryButton(
              text: AppLocalizations.of(context)!.authTryAgain,
              icon: Icons.refresh,
              onPressed: () {
                context.read<AuthProvider>().authenticate();
              },
            ),
          ],
        ),
      );
    }

    // Default: Unauthenticated state with two-column layout
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left column: Instructions
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.authAuthorizationSteps,
                style: TKitTextStyles.heading3.copyWith(
                  color: TKitColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              _buildStep(
                context: context,
                number: '1',
                text: AppLocalizations.of(context)!.authStep1,
              ),
              const SizedBox(height: 12),
              _buildStep(
                context: context,
                number: '2',
                text: AppLocalizations.of(context)!.authStep2,
              ),
              const SizedBox(height: 12),
              _buildStep(
                context: context,
                number: '3',
                text: AppLocalizations.of(context)!.authStep3,
              ),
              const SizedBox(height: 12),
              _buildStep(
                context: context,
                number: '4',
                text: AppLocalizations.of(context)!.authStep4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Right column: Twitch branding and button
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF9147FF), Color(0xFF772CE8)],
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Twitch logo
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.videocam,
                    color: Color(0xFF9147FF),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppLocalizations.of(context)!.authConnectToTwitch,
                  style: TKitTextStyles.heading3.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.authRequiresAccessMessage,
                  style: TKitTextStyles.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: AppLocalizations.of(context)!.authConnectToTwitchButton,
                  width: double.infinity,
                  onPressed: () {
                    context.read<AuthProvider>().authenticate();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep({
    required BuildContext context,
    required String number,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Color.fromRGBO(145, 71, 255, 0.2),
            border: Border.all(color: TKitColors.accent, width: 1),
            borderRadius: BorderRadius.zero,
          ),
          child: Center(
            child: Text(
              number,
              style: TKitTextStyles.caption.copyWith(
                color: TKitColors.accent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(text, style: TKitTextStyles.bodyMedium),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, AuthState state) {
    AuthIndicatorStatus indicatorStatus;
    String statusText;

    final l10n = AppLocalizations.of(context)!;

    if (state is Authenticated) {
      indicatorStatus = AuthIndicatorStatus.authenticated;
      statusText = l10n.authStatusAuthenticated;
    } else if (state is AuthLoading || state is TokenRefreshing) {
      indicatorStatus = AuthIndicatorStatus.loading;
      statusText = l10n.authStatusConnecting;
    } else if (state is AuthError) {
      indicatorStatus = AuthIndicatorStatus.unauthenticated;
      statusText = l10n.authStatusError;
    } else {
      indicatorStatus = AuthIndicatorStatus.idle;
      statusText = l10n.authStatusNotConnected;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: TKitColors.border, width: 1)),
      ),
      child: Row(
        children: [
          AuthStatusIndicator(status: indicatorStatus, tooltip: statusText),
          const SizedBox(width: 8),
          Text(statusText, style: TKitTextStyles.caption),
        ],
      ),
    );
  }
}
