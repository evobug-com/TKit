import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'dart:async';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/core/routing/app_router.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/buttons/primary_button.dart';
import 'package:tkit/shared/widgets/buttons/accent_button.dart';
import 'package:tkit/shared/widgets/indicators/loading_indicator.dart';
import 'package:tkit/shared/widgets/forms/form_field_wrapper.dart';
import 'package:tkit/shared/widgets/forms/dropdown.dart';
import 'package:tkit/features/auth/presentation/providers/auth_providers.dart';
import 'package:tkit/features/auth/presentation/states/auth_state.dart';
import 'package:tkit/features/auth/presentation/pages/device_code_auth_page.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';
import 'package:tkit/features/settings/presentation/states/settings_state.dart';
import 'package:tkit/features/settings/presentation/widgets/settings_checkbox.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';

@RoutePage()
class WelcomePage extends ConsumerStatefulWidget {
  final void Function(Locale)? onLocaleChange;

  const WelcomePage({super.key, this.onLocaleChange});

  @override
  ConsumerState<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends ConsumerState<WelcomePage>
    with SingleTickerProviderStateMixin {
  var _currentGreetingIndex = 0;
  Timer? _greetingTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  var _selectedLanguage = 'en';
  var _currentStep = 0; // 0 = language, 1 = twitch, 2 = behavior

  @override
  void initState() {
    super.initState();

    // Detect system language and set as default
    _initializeLanguage();

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
              (_currentGreetingIndex + 1) %
              AppLocalizations.supportedLocales.length;
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

  Future<void> _initializeLanguage() async {
    final languageService = await ref.read(languageServiceProvider.future);
    final detectedLanguage = languageService.detectSystemLanguage();

    if (mounted) {
      setState(() {
        _selectedLanguage = detectedLanguage;
      });
    }
  }

  Future<void> _onLanguageChanged(String languageCode) async {
    // Update selected language
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Save language preference
    final languageService = await ref.read(languageServiceProvider.future);
    await languageService.saveLanguage(languageCode);

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
    final languageService = await ref.read(languageServiceProvider.future);
    await languageService.markSetupCompleted();

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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TKitSpacing.xxl),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                        style: TKitTextStyles.heading1.copyWith(
                          fontSize: 36,
                          fontWeight: FontWeight.w300,
                          color: TKitColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                const VSpace.xl(),

                // Simple step dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: TKitSpacing.xs,
                      ),
                      child: Container(
                        width: _currentStep == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentStep == index
                              ? TKitColors.accent
                              : TKitColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
                const VSpace.xl(),

                // Main card with fade transition
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Island.standard(
                    child: _currentStep == 0
                        ? _buildLanguageStep(l10n)
                        : _currentStep == 1
                        ? _buildTwitchStep(l10n)
                        : _buildBehaviorStep(l10n),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageStep(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.welcomeStepLanguage,
          style: TKitTextStyles.heading2,
          textAlign: TextAlign.center,
        ),
        const VSpace.xl(),
        FormFieldWrapper(
          label: l10n.languageLabel,
          child: _buildLanguageDropdown(l10n),
        ),
        const VSpace.md(),
        Text(
          l10n.welcomeLanguageChangeLater,
          style: TKitTextStyles.caption,
          textAlign: TextAlign.center,
        ),
        const VSpace.xxl(),
        _buildFooterButtons(l10n),
      ],
    );
  }

  Widget _buildTwitchStep(AppLocalizations l10n) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);
        final isAuthenticated = authState is Authenticated;
        final isLoading = authState is AuthLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.welcomeStepTwitch,
              style: TKitTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const VSpace.md(),
            Text(
              l10n.welcomeTwitchDescription,
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const VSpace.xl(),

            // Status or auth button
            if (isAuthenticated) ...[
              IslandVariant.standard(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: TKitColors.success,
                      size: 18,
                    ),
                    const HSpace.sm(),
                    Text(
                      l10n.welcomeTwitchConnectedAs(
                        authState.user.displayName,
                      ),
                      style: TKitTextStyles.bodyMedium.copyWith(
                        color: TKitColors.success,
                      ),
                    ),
                  ],
                ),
              ),
              const VSpace.xl(),
            ] else ...[
              PrimaryButton(
                text: l10n.welcomeTwitchAuthorizeButton,
                icon: Icons.link,
                width: double.infinity,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () async {
                        final notifier = ref.read(authProvider.notifier);
                        final deviceCodeResponse = await notifier
                            .initiateDeviceCodeAuth();

                        if (deviceCodeResponse != null && context.mounted) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (dialogContext) => DeviceCodeAuthPage(
                              deviceCodeResponse: deviceCodeResponse,
                              onSuccess: () {
                                Navigator.of(dialogContext).pop();
                                ref.read(authProvider.notifier).checkAuthStatus();
                              },
                              onCancel: () {
                                Navigator.of(dialogContext).pop();
                                ref.read(authProvider.notifier).checkAuthStatus();
                              },
                            ),
                          );
                        }
                      },
              ),
              const VSpace.md(),
              Text(
                l10n.welcomeTwitchOptionalInfo,
                style: TKitTextStyles.caption,
                textAlign: TextAlign.center,
              ),
              const VSpace.xl(),
            ],

            _buildFooterButtons(l10n),
          ],
        );
      },
    );
  }

  Widget _buildBehaviorStep(AppLocalizations l10n) {
    return Consumer(
      builder: (context, ref, child) {
        final settingsState = ref.watch(settingsProvider);

        if (settingsState is! SettingsLoaded) {
          return const Center(child: LoadingIndicator());
        }

        final settings = settingsState.settings;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.welcomeStepBehavior,
              style: TKitTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const VSpace.md(),
            Text(
              l10n.welcomeBehaviorDescription,
              style: TKitTextStyles.bodyMedium.copyWith(
                color: TKitColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const VSpace.xl(),

            // Settings checkboxes
            SettingsCheckbox(
              label: l10n.settingsAutoStartWindowsLabel,
              subtitle: l10n.settingsAutoStartWindowsSubtitle,
              value: settings.autoStartWithWindows,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                  settings.copyWith(autoStartWithWindows: value),
                );
              },
            ),
            const VSpace.sm(),

            SettingsCheckbox(
              label: l10n.settingsStartMinimizedLabel,
              subtitle: l10n.settingsStartMinimizedSubtitle,
              value: settings.startMinimized,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                  settings.copyWith(startMinimized: value),
                );
              },
            ),
            const VSpace.sm(),

            SettingsCheckbox(
              label: l10n.settingsMinimizeToTrayLabel,
              subtitle: l10n.settingsMinimizeToTraySubtitle,
              value: settings.minimizeToTray,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).updateSettings(
                  settings.copyWith(minimizeToTray: value),
                );
              },
            ),
            const VSpace.xl(),

            // Window controls position
            FormFieldWrapper(
              label: l10n.settingsWindowControlsPositionLabel,
              helpText: l10n.settingsWindowControlsPositionDescription,
              child: TKitDropdown<WindowControlsPosition>(
                value: settings.windowControlsPosition,
                options: WindowControlsPosition.values.map((position) {
                  return TKitDropdownOption<WindowControlsPosition>(
                    value: position,
                    label: position.localizedName(context),
                  );
                }).toList(),
                onChanged: (WindowControlsPosition? newValue) {
                  if (newValue != null) {
                    ref.read(settingsProvider.notifier).updateSettings(
                      settings.copyWith(windowControlsPosition: newValue),
                    );
                  }
                },
              ),
            ),
            const VSpace.xl(),

            Text(
              l10n.welcomeBehaviorOptionalInfo,
              style: TKitTextStyles.caption,
              textAlign: TextAlign.center,
            ),
            const VSpace.xxl(),

            _buildFooterButtons(l10n),
          ],
        );
      },
    );
  }

  Widget _buildLanguageDropdown(AppLocalizations l10n) {
    // Build language options dynamically from supported locales
    final languageOptions = AppLocalizations.supportedLocales.map((locale) {
      final localizations = lookupAppLocalizations(locale);
      return TKitDropdownOption<String>(
        value: locale.languageCode,
        label: localizations.languageNativeName,
      );
    }).toList();

    return TKitDropdown<String>(
      value: _selectedLanguage,
      options: languageOptions,
      onChanged: (String? newValue) {
        if (newValue != null && newValue != _selectedLanguage) {
          _onLanguageChanged(newValue);
        }
      },
    );
  }

  Widget _buildFooterButtons(AppLocalizations l10n) {
    if (_currentStep == 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          PrimaryButton(
            text: l10n.welcomeButtonNext,
            icon: Icons.arrow_forward,
            onPressed: _goToNextStep,
          ),
        ],
      );
    } else if (_currentStep == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AccentButton(
            text: l10n.welcomeButtonBack,
            onPressed: _goToPreviousStep,
          ),
          const HSpace.md(),
          PrimaryButton(
            text: l10n.welcomeButtonNext,
            icon: Icons.arrow_forward,
            onPressed: _goToNextStep,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AccentButton(
            text: l10n.welcomeButtonBack,
            onPressed: _goToPreviousStep,
          ),
          const HSpace.md(),
          PrimaryButton(
            text: l10n.continueButton,
            icon: Icons.check,
            onPressed: _onComplete,
          ),
        ],
      );
    }
  }
}
