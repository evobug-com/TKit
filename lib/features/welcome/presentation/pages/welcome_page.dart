import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'dart:async';
import '../../../../core/services/language_service.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/text_styles.dart';
import '../../../../shared/theme/spacing.dart';
import '../../../../shared/widgets/layout/spacer.dart';
import '../../../../shared/widgets/layout/island.dart';
import '../../../../shared/widgets/buttons/primary_button.dart';
import '../../../../shared/widgets/buttons/accent_button.dart';
import '../../../../shared/widgets/indicators/loading_indicator.dart';
import '../../../../core/config/app_config.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../auth/presentation/states/auth_state.dart';
import '../../../auth/presentation/pages/device_code_auth_page.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../settings/presentation/states/settings_state.dart';
import '../../../settings/presentation/widgets/settings_checkbox.dart';
import '../../../settings/domain/entities/window_controls_position.dart';

@RoutePage()
class WelcomePage extends StatefulWidget {
  final void Function(Locale)? onLocaleChange;

  const WelcomePage({super.key, this.onLocaleChange});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  late final LanguageService _languageService;

  int _currentGreetingIndex = 0;
  Timer? _greetingTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  String _selectedLanguage = 'en';
  int _currentStep = 0; // 0 = language, 1 = twitch, 2 = behavior

  @override
  void initState() {
    super.initState();

    // Get dependencies from Provider
    _languageService = context.read<LanguageService>();

    // Detect system language and set as default
    _selectedLanguage = _languageService.detectSystemLanguage();

    // Set initial locale after build completes
    if (widget.onLocaleChange != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onLocaleChange!(Locale(_selectedLanguage));
        }
      });
    }

    // Setup fade animation for step transitions
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _fadeController.forward();

    // Start cycling through greetings from all supported locales
    _greetingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentGreetingIndex =
              (_currentGreetingIndex + 1) % AppLocalizations.supportedLocales.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _greetingTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _onLanguageChanged(String languageCode) {
    // Update selected language
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Save language preference
    _languageService.saveLanguage(languageCode);

    // Notify parent to change locale - this triggers MaterialApp rebuild
    if (widget.onLocaleChange != null) {
      widget.onLocaleChange!(Locale(languageCode));
    }
  }

  void _goToNextStep() {
    _fadeController.reset();
    setState(() {
      if (_currentStep < 2) {
        _currentStep++;
      }
    });
    _fadeController.forward();
  }

  void _goToPreviousStep() {
    _fadeController.reset();
    setState(() {
      if (_currentStep > 0) {
        _currentStep--;
      }
    });
    _fadeController.forward();
  }

  Future<void> _onComplete() async {
    // Mark setup as completed
    await _languageService.markSetupCompleted();

    if (mounted) {
      // Navigate to the main app
      context.router.replace(const AutoSwitcherRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Get greetings from all supported locales dynamically
    final greetingsList = AppLocalizations.supportedLocales
        .map((locale) => lookupAppLocalizations(locale).hello)
        .toList();
    final greetingText = greetingsList[_currentGreetingIndex];

    return Scaffold(
        backgroundColor: TKitColors.background,
        body: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: TKitSpacing.xxl, horizontal: TKitSpacing.xxl),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: TKitColors.border, width: 1),
                ),
              ),
              child: Column(
                children: [
                  // App name
                  Text(
                    AppConfig.appName.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TKitTextStyles.heading1.copyWith(
                      letterSpacing: 4,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Animated greeting text
                  SizedBox(
                    height: 60,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.3),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          greetingText,
                          key: ValueKey<int>(_currentGreetingIndex),
                          style: TKitTextStyles.heading2.copyWith(
                            fontSize: 42,
                            fontWeight: FontWeight.w300,
                            color: TKitColors.textSecondary,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Step indicator
                  _buildStepIndicator(),
                ],
              ),
            ),

            // Main content area with fade transition
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(TKitSpacing.xxl),
                  child: Center(
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: _currentStep == 0
                          ? _buildLanguageStep(l10n)
                          : _currentStep == 1
                              ? _buildTwitchStep(l10n)
                              : _buildBehaviorStep(l10n),
                    ),
                  ),
                ),
              ),
            ),

            // Footer with action buttons
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(TKitSpacing.xxl),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: TKitColors.border, width: 1),
                ),
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 560),
                  child: _buildFooterButtons(l10n),
                ),
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildStepIndicator() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepDot(0, l10n.welcomeStepLanguage),
        Container(
          width: 40,
          height: 1,
          color: _currentStep >= 1 ? TKitColors.accent : TKitColors.border,
        ),
        _buildStepDot(1, l10n.welcomeStepTwitch),
        Container(
          width: 40,
          height: 1,
          color: _currentStep >= 2 ? TKitColors.accent : TKitColors.border,
        ),
        _buildStepDot(2, l10n.welcomeStepBehavior),
      ],
    );
  }

  Widget _buildStepDot(int step, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? TKitColors.accent
                : TKitColors.surface,
            border: Border.all(
              color: isActive || isCompleted
                  ? TKitColors.accent
                  : TKitColors.border,
              width: 2,
            ),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(
                    Icons.check,
                    size: 16,
                    color: TKitColors.textPrimary,
                  )
                : Text(
                    '${step + 1}',
                    style: TKitTextStyles.bodySmall.copyWith(
                      color: isActive
                          ? TKitColors.textPrimary
                          : TKitColors.textMuted,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            label.toUpperCase(),
            style: TKitTextStyles.bodySmall.copyWith(
              letterSpacing: 0.5,
              fontWeight: FontWeight.w600,
              color: isActive ? TKitColors.textPrimary : TKitColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.welcomeLanguageStepTitle,
          style: TKitTextStyles.bodySmall.copyWith(
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
            color: TKitColors.textMuted,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(TKitSpacing.xxl),
          decoration: BoxDecoration(
            color: TKitColors.surface,
            border: Border.all(
              color: TKitColors.border,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.languageLabel,
                style: TKitTextStyles.bodySmall.copyWith(
                  color: TKitColors.textMuted,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildLanguageDropdown(l10n),
              const SizedBox(height: 16),
              Text(
                l10n.welcomeLanguageChangeLater,
                style: TKitTextStyles.caption.copyWith(
                  color: TKitColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTwitchStep(AppLocalizations l10n) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final authState = authProvider.state;
        final isAuthenticated = authState is Authenticated;
        final isLoading = authState is AuthLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.welcomeTwitchStepTitle,
              style: TKitTextStyles.bodySmall.copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: TKitColors.textMuted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(TKitSpacing.xxl),
              decoration: BoxDecoration(
                color: TKitColors.surface,
                border: Border.all(
                  color: TKitColors.border,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with icon
                  Row(
                    children: [
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
                        l10n.welcomeTwitchConnectionTitle,
                        style: TKitTextStyles.heading3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Status or description
                  if (isAuthenticated) ...[
                    Container(
                      padding: const EdgeInsets.all(TKitSpacing.lg),
                      decoration: BoxDecoration(
                        color: TKitColors.success.withOpacity(0.1),
                        border: Border.all(
                          color: TKitColors.success,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: TKitColors.success,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              l10n.welcomeTwitchConnectedAs((authState as Authenticated).user.displayName),
                              style: TKitTextStyles.bodyMedium.copyWith(
                                color: TKitColors.success,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Text(
                      l10n.welcomeTwitchDescription,
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.welcomeTwitchOptionalInfo,
                      style: TKitTextStyles.bodySmall.copyWith(
                        color: TKitColors.textMuted,
                        height: 1.5,
                      ),
                    ),
                    const VSpace.xxl(),

                    // Authorize button
                    PrimaryButton(
                      text: l10n.welcomeTwitchAuthorizeButton,
                      icon: Icons.link,
                      onPressed: isLoading
                          ? null
                          : () async {
                              // Initiate Device Code Flow
                              final authProvider = context.read<AuthProvider>();
                              final deviceCodeResponse = await authProvider.initiateDeviceCodeAuth();

                              if (deviceCodeResponse != null && context.mounted) {
                                // Show Device Code auth page
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) => DeviceCodeAuthPage(
                                    deviceCodeResponse: deviceCodeResponse,
                                    onSuccess: () {
                                      Navigator.of(dialogContext).pop();
                                      context.read<AuthProvider>().checkAuthStatus();
                                    },
                                    onCancel: () {
                                      Navigator.of(dialogContext).pop();
                                    },
                                  ),
                                );
                              }
                            },
                    ),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBehaviorStep(AppLocalizations l10n) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final settingsState = settingsProvider.state;

        if (settingsState is! SettingsLoaded) {
          // Show loading or initialize settings
          return const Center(child: LoadingIndicator());
        }

        final settings = settingsState.settings;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.welcomeBehaviorStepTitle,
              style: TKitTextStyles.bodySmall.copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.bold,
                color: TKitColors.textMuted,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(TKitSpacing.xxl),
              decoration: BoxDecoration(
                color: TKitColors.surface,
                border: Border.all(
                  color: TKitColors.border,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: TKitColors.accent,
                          borderRadius: BorderRadius.zero,
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: TKitColors.textPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        l10n.welcomeBehaviorTitle,
                        style: TKitTextStyles.heading3.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    l10n.welcomeBehaviorDescription,
                    style: TKitTextStyles.bodyMedium.copyWith(
                      color: TKitColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Settings checkboxes
                  SettingsCheckbox(
                    label: l10n.settingsAutoStartWindowsLabel,
                    subtitle: l10n.settingsAutoStartWindowsSubtitle,
                    value: settings.autoStartWithWindows,
                    onChanged: (value) {
                      settingsProvider.updateSettings(
                        settings.copyWith(autoStartWithWindows: value),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  SettingsCheckbox(
                    label: l10n.settingsStartMinimizedLabel,
                    subtitle: l10n.settingsStartMinimizedSubtitle,
                    value: settings.startMinimized,
                    onChanged: (value) {
                      settingsProvider.updateSettings(
                        settings.copyWith(startMinimized: value),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  SettingsCheckbox(
                    label: l10n.settingsMinimizeToTrayLabel,
                    subtitle: l10n.settingsMinimizeToTraySubtitle,
                    value: settings.minimizeToTray,
                    onChanged: (value) {
                      settingsProvider.updateSettings(
                        settings.copyWith(minimizeToTray: value),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  SettingsCheckbox(
                    label: l10n.settingsShowNotificationsLabel,
                    subtitle: l10n.settingsShowNotificationsSubtitle,
                    value: settings.showNotifications,
                    onChanged: (value) {
                      settingsProvider.updateSettings(
                        settings.copyWith(showNotifications: value),
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Window controls position dropdown
                  Text(
                    l10n.settingsWindowControlsPositionLabel,
                    style: TKitTextStyles.bodySmall.copyWith(
                      color: TKitColors.textMuted,
                      fontSize: 11,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: TKitColors.surfaceVariant,
                      border: Border.all(
                        color: TKitColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<WindowControlsPosition>(
                        value: settings.windowControlsPosition,
                        isExpanded: true,
                        dropdownColor: TKitColors.surfaceVariant,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: TKitColors.textSecondary,
                        ),
                        style: TKitTextStyles.bodyMedium.copyWith(
                          color: TKitColors.textPrimary,
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.md, vertical: TKitSpacing.sm),
                        items: WindowControlsPosition.values.map((position) {
                          return DropdownMenuItem<WindowControlsPosition>(
                            value: position,
                            child: Text(position.localizedName(context)),
                          );
                        }).toList(),
                        onChanged: (WindowControlsPosition? newValue) {
                          if (newValue != null) {
                            settingsProvider.updateSettings(
                              settings.copyWith(windowControlsPosition: newValue),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsWindowControlsPositionDescription,
                    style: TKitTextStyles.caption.copyWith(
                      color: TKitColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    l10n.welcomeBehaviorOptionalInfo,
                    style: TKitTextStyles.bodySmall.copyWith(
                      color: TKitColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageDropdown(AppLocalizations l10n) {
    // Build language map dynamically from supported locales using languageNativeName
    final languages = Map.fromEntries(
      AppLocalizations.supportedLocales.map((locale) {
        final localizations = lookupAppLocalizations(locale);
        return MapEntry(locale.languageCode, localizations.languageNativeName);
      }),
    );

    return Container(
      decoration: BoxDecoration(
        color: TKitColors.surfaceVariant,
        border: Border.all(
          color: TKitColors.borderLight,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLanguage,
          isExpanded: true,
          dropdownColor: TKitColors.surfaceVariant,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: TKitColors.textSecondary,
          ),
          style: TKitTextStyles.bodyMedium.copyWith(
            color: TKitColors.textPrimary,
          ),
          padding: const EdgeInsets.symmetric(horizontal: TKitSpacing.md, vertical: TKitSpacing.sm),
          items: languages.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null && newValue != _selectedLanguage) {
              _onLanguageChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildFooterButtons(AppLocalizations l10n) {
    if (_currentStep == 0) {
      // Step 1: Next button
      return PrimaryButton(
        text: l10n.welcomeButtonNext,
        icon: Icons.arrow_forward,
        onPressed: _goToNextStep,
      );
    } else if (_currentStep == 1) {
      // Step 2: Back and Next buttons
      return Row(
        children: [
          SizedBox(
            width: 120,
            child: AccentButton(
              text: l10n.welcomeButtonBack,
              onPressed: _goToPreviousStep,
            ),
          ),
          const HSpace.md(),
          Expanded(
            child: PrimaryButton(
              text: l10n.welcomeButtonNext,
              icon: Icons.arrow_forward,
              onPressed: _goToNextStep,
            ),
          ),
        ],
      );
    } else {
      // Step 3: Back and Continue buttons
      return Row(
        children: [
          SizedBox(
            width: 120,
            child: AccentButton(
              text: l10n.welcomeButtonBack,
              onPressed: _goToPreviousStep,
            ),
          ),
          const HSpace.md(),
          Expanded(
            child: PrimaryButton(
              text: l10n.continueButton.toUpperCase(),
              icon: Icons.check,
              onPressed: _onComplete,
            ),
          ),
        ],
      );
    }
  }
}
