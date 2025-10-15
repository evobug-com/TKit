import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/text_styles.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/page_header.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/layout/island.dart';
import 'package:tkit/shared/widgets/feedback/toast.dart';
import 'package:tkit/shared/widgets/indicators/loading_indicator.dart';
import 'package:tkit/shared/widgets/buttons/buttons.dart';
import 'package:tkit/shared/widgets/forms/form_field_wrapper.dart';
import 'package:tkit/core/config/app_config.dart';
import 'package:tkit/core/services/locale_provider.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/features/settings/domain/entities/app_settings.dart';
import 'package:tkit/features/settings/domain/entities/fallback_behavior.dart';
import 'package:tkit/features/settings/domain/entities/update_channel.dart';
import 'package:tkit/features/settings/domain/entities/window_controls_position.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';
import 'package:tkit/features/settings/presentation/providers/window_controls_preview_provider.dart';
import 'package:tkit/features/settings/presentation/providers/unsaved_changes_notifier.dart';
import 'package:tkit/features/auth/presentation/providers/auth_providers.dart';
import 'package:tkit/features/settings/presentation/states/settings_state.dart';
import 'package:tkit/features/settings/presentation/widgets/settings_checkbox.dart';
import 'package:tkit/features/settings/presentation/widgets/settings_dropdown.dart';
import 'package:tkit/features/settings/presentation/widgets/custom_dropdown.dart';
import 'package:tkit/features/settings/presentation/widgets/settings_slider.dart';
import 'package:tkit/features/settings/presentation/widgets/hotkey_input.dart';
import 'package:tkit/features/auth/presentation/states/auth_state.dart';
import 'package:tkit/features/auth/presentation/pages/device_code_auth_page.dart';

/// Settings page for configuring application settings
@RoutePage()
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load settings after build completes to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).loadSettings();
    });

    return const _SettingsPageContent();
  }
}

class _SettingsPageContent extends ConsumerStatefulWidget {
  const _SettingsPageContent();

  @override
  ConsumerState<_SettingsPageContent> createState() => _SettingsPageContentState();
}

class _SettingsPageContentState extends ConsumerState<_SettingsPageContent>
    with TickerProviderStateMixin {
  AppSettings? _currentSettings;
  var _hasChanges = false;
  var _isInitialized = false;
  var _resetKey = 0;
  late TabController _tabController;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);

    // Setup shake animation
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 10.0), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: 10.0, end: -10.0), weight: 2),
          TweenSequenceItem(tween: Tween(begin: -10.0, end: 0.0), weight: 1),
        ]).animate(
          CurvedAnimation(parent: _shakeController, curve: Curves.easeInOut),
        );

    // Register shake callback with unsaved changes notifier
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(unsavedChangesProvider.notifier).setOnNavigationAttempt(() {
          _shakeController.forward(from: 0.0);
        });
      }
    });
  }

  @override
  void dispose() {
    // Note: Intentionally not cleaning up unsavedChangesProvider here to avoid
    // accessing ref during dispose. The provider manages its own lifecycle.
    _tabController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _updateSettings(AppSettings settings) {
    final hasChanges = ref.read(settingsProvider.notifier).hasUnsavedChanges(
      settings,
    );
    setState(() {
      _currentSettings = settings;
      _hasChanges = hasChanges;
    });
    // Update the unsaved changes notifier
    ref.read(unsavedChangesProvider.notifier).setHasChanges(hasChanges);
  }

  void _saveSettings() {
    if (_currentSettings != null) {
      ref.read(settingsProvider.notifier).updateSettings(_currentSettings!);
      // Clear the window controls preview after saving
      ref.read(windowControlsPreviewProvider.notifier).clearPreview();
    }
  }

  Future<void> _discardChanges() async {
    final state = ref.read(settingsProvider);

    // Clear the window controls preview to revert to saved position
    ref.read(windowControlsPreviewProvider.notifier).clearPreview();

    setState(() {
      _hasChanges = false;
      _isInitialized = false;
      _resetKey++; // Force widget recreation
      // Reset to original settings from provider immediately
      if (state is SettingsLoaded) {
        _currentSettings = state.settings;
      } else if (state is SettingsSaved) {
        _currentSettings = state.settings;
      }
    });
    // Clear unsaved changes flag
    ref.read(unsavedChangesProvider.notifier).setHasChanges(false);
    // Load settings after the current frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(settingsProvider.notifier).loadSettings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsProvider);

    // Handle state changes (similar to BlocConsumer listener)
    ref.listen<SettingsState>(settingsProvider, (previous, next) {
      if (next is SettingsSaved) {
        final l10n = AppLocalizations.of(context)!;
        Toast.success(context, l10n.settingsSavedSuccessfully);
        setState(() {
          _hasChanges = false;
          _isInitialized = false;
        });
        // Clear unsaved changes flag
        ref.read(unsavedChangesProvider.notifier).setHasChanges(false);
      } else if (next is SettingsError) {
        Toast.error(context, next.message);
      }
    });

    return Scaffold(
      body: Builder(
        builder: (context) {
          if (state is SettingsLoading) {
            return const Center(child: LoadingIndicator());
          }

          if (state is SettingsError && state.currentSettings == null) {
            final l10n = AppLocalizations.of(context)!;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: TKitColors.error),
                  const VSpace.lg(),
                  Text(state.message, style: TKitTextStyles.bodyMedium),
                  const VSpace.lg(),
                  PrimaryButton(
                    text: l10n.settingsRetry,
                    onPressed: () {
                      ref.read(settingsProvider.notifier).loadSettings();
                    },
                  ),
                ],
              ),
            );
          }

          // Only update _currentSettings from bloc when not already editing
          if (!_isInitialized) {
            if (state is SettingsLoaded) {
              _currentSettings = state.settings;
              _isInitialized = true;
            } else if (state is SettingsSaving) {
              _currentSettings = state.settings;
              _isInitialized = true;
            } else if (state is SettingsSaved) {
              _currentSettings = state.settings;
              _isInitialized = true;
            } else if (state is SettingsError &&
                state.currentSettings != null) {
              _currentSettings = state.currentSettings;
              _isInitialized = true;
            } else {
              _currentSettings = AppSettings.defaults(
                appVersion: AppConfig.appVersion,
              );
              _isInitialized = true;
            }
          }

          // Use _currentSettings for all UI rendering
          final settings =
              _currentSettings ??
              AppSettings.defaults(appVersion: AppConfig.appVersion);
          final l10n = AppLocalizations.of(context)!;

          return PopScope(
            canPop: !_hasChanges,
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop && _hasChanges) {
                // Trigger shake animation when navigation is blocked
                _shakeController.forward(from: 0.0);
              }
            },
            child: Column(
              children: [
                // Page Header
                Island.comfortable(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageHeader(
                        title: l10n.settingsPageTitle,
                        subtitle: l10n.settingsPageDescription,
                      ),
                      const VSpace.lg(),
                      // Tabs
                      _buildTabs(l10n),
                    ],
                  ),
                ),

                // Tab Content
                Expanded(
                  child: Stack(
                    children: [
                      TabBarView(
                        controller: _tabController,
                        children: [
                          _buildGeneralTab(settings, l10n),
                          _buildAutoSwitcherTab(settings, l10n),
                          _buildMappingsTab(settings, l10n),
                          _buildKeyboardTab(settings, l10n),
                          _buildThemeTab(settings, l10n),
                          _buildTwitchTab(l10n),
                          _buildAdvancedTab(l10n),
                        ],
                      ),

                      // Save/Discard bar
                      if (_hasChanges)
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: _buildSaveBar(l10n),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabs(AppLocalizations l10n) {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      indicatorColor: TKitColors.accent,
      indicatorWeight: 2,
      labelColor: TKitColors.textPrimary,
      unselectedLabelColor: TKitColors.textSecondary,
      labelStyle: TKitTextStyles.labelMedium,
      unselectedLabelStyle: TKitTextStyles.labelMedium,
      dividerColor: TKitColors.border,
      tabs: [
        Tab(text: l10n.settingsTabGeneral),
        Tab(text: l10n.settingsTabAutoSwitcher),
        const Tab(text: 'Mappings'),
        Tab(text: l10n.settingsTabKeyboard),
        const Tab(text: 'Theme'),
        Tab(text: l10n.settingsTabTwitch),
        Tab(text: l10n.settingsTabAdvanced),
      ],
    );
  }

  Widget _buildGeneralTab(AppSettings settings, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(l10n.settingsApplication, [
            // Language selection
            Consumer(
              builder: (context, ref, child) {
                final languageServiceAsync = ref.watch(languageServiceProvider);

                return languageServiceAsync.when(
                  data: (languageService) {
                    final l10n = AppLocalizations.of(context)!;
                    final currentLocale = languageService.getCurrentLocale();

                    // Map of language codes to their localized names
                    final languageNames = <String, String>{
                      'en': l10n.languageEnglish,
                      'cs': l10n.languageCzech,
                      'pl': l10n.languagePolish,
                      'es': l10n.languageSpanish,
                      'fr': l10n.languageFrench,
                      'de': l10n.languageGerman,
                      'pt': l10n.languagePortuguese,
                      'ja': l10n.languageJapanese,
                      'ko': l10n.languageKorean,
                      'zh': l10n.languageChinese,
                    };

                    return SettingsDropdown<String>(
                      label: l10n.settingsLanguage,
                      description: l10n.settingsLanguageDescription,
                      value: currentLocale.languageCode,
                      items: AppLocalizations.supportedLocales
                          .map(
                            (locale) => DropdownMenuItem(
                              value: locale.languageCode,
                              child: Text(
                                languageNames[locale.languageCode] ??
                                    locale.languageCode.toUpperCase(),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (languageCode) async {
                        if (languageCode != null) {
                          await languageService.saveLanguage(languageCode);
                          ref.read(localeProvider.notifier).setLocale(Locale(languageCode));

                          if (context.mounted) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (context.mounted) {
                                final newL10n = AppLocalizations.of(context)!;
                                Toast.success(
                                  context,
                                  newL10n.languageChangeNotice,
                                );
                              }
                            });
                          }
                        }
                      },
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (error, stack) => const SizedBox.shrink(),
                );
              },
            ),
            const VSpace.md(),
            SettingsCheckbox(
              label: l10n.settingsAutoStartWindowsLabel,
              subtitle: l10n.settingsAutoStartWindowsSubtitle,
              value: settings.autoStartWithWindows,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(autoStartWithWindows: value ?? false),
                );
              },
            ),
            const VSpace.sm(),
            SettingsCheckbox(
              label: l10n.settingsStartMinimizedLabel,
              subtitle: l10n.settingsStartMinimizedSubtitle,
              value: settings.startMinimized,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(startMinimized: value ?? false),
                );
              },
            ),
            const VSpace.sm(),
            SettingsCheckbox(
              label: l10n.settingsMinimizeToTrayLabel,
              subtitle: l10n.settingsMinimizeToTraySubtitle,
              value: settings.minimizeToTray,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(minimizeToTray: value ?? false),
                );
              },
            ),
            const VSpace.sm(),
            SettingsCheckbox(
              label: l10n.settingsShowNotificationsLabel,
              subtitle: l10n.settingsShowNotificationsSubtitle,
              value: settings.showNotifications,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(showNotifications: value ?? false),
                );
              },
            ),
            const VSpace.sm(),
            SettingsCheckbox(
              label: l10n.settingsNotifyMissingCategoryLabel,
              subtitle: l10n.settingsNotifyMissingCategorySubtitle,
              value: settings.notifyOnMissingCategory,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(notifyOnMissingCategory: value ?? false),
                );
              },
            ),
            const VSpace.md(),
            CustomDropdown<WindowControlsPosition>(
              label: l10n.settingsWindowControlsPositionLabel,
              description: l10n.settingsWindowControlsPositionDescription,
              value: settings.windowControlsPosition,
              items: WindowControlsPosition.values
                  .map(
                    (position) => CustomDropdownItem(
                      value: position,
                      title: position.localizedName(context),
                      subtitle: null,
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  final updatedSettings = settings.copyWith(
                    windowControlsPosition: value,
                  );
                  _updateSettings(updatedSettings);
                  ref.read(windowControlsPreviewProvider.notifier).setPreviewPosition(value);
                }
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildAutoSwitcherTab(AppSettings settings, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(l10n.settingsMonitoring, [
            SettingsSlider(
              label: l10n.settingsScanIntervalLabel,
              description: l10n.settingsScanIntervalDescription,
              value: settings.scanIntervalSeconds.toDouble(),
              min: 1,
              max: 60,
              divisions: 59,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(scanIntervalSeconds: value.toInt()),
                );
              },
            ),
            const VSpace.md(),
            SettingsSlider(
              label: l10n.settingsDebounceTimeLabel,
              description: l10n.settingsDebounceTimeDescription,
              value: settings.debounceSeconds.toDouble(),
              min: 0,
              max: 60,
              divisions: 60,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(debounceSeconds: value.toInt()),
                );
              },
            ),
            const VSpace.md(),
            _buildTimingExplanation(
              settings.scanIntervalSeconds,
              settings.debounceSeconds,
            ),
            const VSpace.md(),
            SettingsCheckbox(
              label: l10n.settingsAutoStartMonitoringLabel,
              subtitle: l10n.settingsAutoStartMonitoringSubtitle,
              value: settings.autoStartMonitoring,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(autoStartMonitoring: value ?? false),
                );
              },
            ),
          ]),
          const VSpace.lg(),
          _buildSection(l10n.settingsFallbackBehavior, [
            SettingsDropdown<FallbackBehavior>(
              label: l10n.settingsFallbackBehaviorLabel,
              description: l10n.settingsFallbackBehaviorDescription,
              value: settings.fallbackBehavior,
              items: FallbackBehavior.values
                  .map(
                    (behavior) => DropdownMenuItem(
                      value: behavior,
                      child: Text(behavior.localizedName(context)),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  _updateSettings(settings.copyWith(fallbackBehavior: value));
                }
              },
            ),
            if (settings.fallbackBehavior == FallbackBehavior.custom) ...[
              const VSpace.md(),
              FormFieldWrapper(
                label: l10n.settingsCustomCategory,
                child: TKitTextField(
                  hintText: l10n.settingsCustomCategoryHint,
                  controller: TextEditingController(
                    text: settings.customFallbackCategoryName ?? '',
                  ),
                  readOnly: true,
                  onTap: () {
                    Toast.info(context, l10n.settingsCategorySearchUnavailable);
                  },
                ),
              ),
            ],
          ]),
        ],
      ),
    );
  }

  Widget _buildMappingsTab(AppSettings settings, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('AUTOMATIC SYNCHRONIZATION', [
            SettingsCheckbox(
              label: 'Auto-sync mappings on app start',
              subtitle: 'Automatically sync mapping lists when the application starts',
              value: settings.autoSyncMappingsOnStart,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(autoSyncMappingsOnStart: value ?? true),
                );
              },
            ),
            const VSpace.md(),
            SettingsSlider(
              label: 'Auto-sync interval',
              description: 'How often to automatically sync mapping lists (0 = never)',
              value: settings.mappingsSyncIntervalHours.toDouble(),
              min: 0,
              max: 168,
              divisions: 168,
              valueFormatter: (value) => _formatSyncInterval(value.toInt()),
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(mappingsSyncIntervalHours: value.toInt()),
                );
              },
            ),
          ]),
        ],
      ),
    );
  }

  String _formatSyncInterval(int hours) {
    if (hours == 0) {
      return 'Never';
    } else if (hours < 24) {
      return '${hours}h';
    } else {
      final days = hours ~/ 24;
      final remainingHours = hours % 24;

      if (remainingHours == 0) {
        return '${days}d';
      } else {
        return '${days}d ${remainingHours}h';
      }
    }
  }

  Widget _buildTimingExplanation(int scanInterval, int debounce) {
    return Container(
      padding: const EdgeInsets.all(TKitSpacing.md),
      decoration: BoxDecoration(
        color: TKitColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: TKitColors.accent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule,
                size: 16,
                color: TKitColors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'HOW THESE SETTINGS WORK TOGETHER',
                style: TKitTextStyles.labelSmall.copyWith(
                  color: TKitColors.accent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildTimingStep(
            '1',
            'App checks for focused window every ${scanInterval}s',
            TKitColors.accent,
          ),
          const SizedBox(height: 4),
          _buildTimingStep(
            '2',
            debounce == 0
                ? 'Category switches immediately when new app detected'
                : 'Waits ${debounce}s after detecting new app (debounce)',
            TKitColors.accent,
          ),
          const SizedBox(height: 4),
          _buildTimingStep(
            '→',
            debounce == 0
                ? 'Total switch time: ${scanInterval}s (instant after detection)'
                : 'Total switch time: ${scanInterval}s to ${scanInterval + debounce}s',
            TKitColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildTimingStep(String number, String text, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            number,
            style: TKitTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TKitTextStyles.bodySmall.copyWith(
              color: TKitColors.textPrimary,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyboardTab(AppSettings settings, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(l10n.settingsKeyboardShortcuts, [
            HotkeyInput(
              key: ValueKey('hotkey_${settings.manualUpdateHotkey}_$_resetKey'),
              label: l10n.settingsManualUpdateHotkeyLabel,
              description: l10n.settingsManualUpdateHotkeyDescription,
              currentHotkey: settings.manualUpdateHotkey,
              onChanged: (hotkey) {
                _updateSettings(settings.copyWith(manualUpdateHotkey: hotkey));
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildThemeTab(AppSettings settings, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection('WINDOW APPEARANCE', [
            SettingsCheckbox(
              label: 'Use Frameless Window',
              subtitle: 'Remove the Windows title bar for a modern, borderless look with rounded corners',
              value: settings.useFramelessWindow,
              onChanged: (value) async {
                final newValue = value ?? false;
                _updateSettings(settings.copyWith(useFramelessWindow: newValue));

                // Apply window style immediately
                if (newValue) {
                  await windowManager.setAsFrameless();
                } else {
                  await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
                }
              },
            ),
            const VSpace.sm(),
            SettingsCheckbox(
              label: 'Invert Footer/Header',
              subtitle: 'Swap the positions of the header and footer sections',
              value: settings.invertFooterHeader,
              onChanged: (value) {
                _updateSettings(
                  settings.copyWith(invertFooterHeader: value ?? false),
                );
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildTwitchTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildTwitchAuthSection(context)],
      ),
    );
  }

  Widget _buildAdvancedTab(AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(TKitSpacing.pagePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(l10n.settingsUpdates, [
            CustomDropdown<UpdateChannel>(
              label: l10n.settingsUpdateChannelLabel,
              description: l10n.settingsUpdateChannelDescription,
              value: _currentSettings?.updateChannel ?? UpdateChannel.stable,
              items: UpdateChannel.values
                  .map(
                    (channel) => CustomDropdownItem(
                      value: channel,
                      title: channel.localizedName(context),
                      subtitle: channel.localizedDescription(context),
                    ),
                  )
                  .toList(),
              onChanged: (value) async {
                if (value != null && _currentSettings != null) {
                  // Capture context-dependent values before async gap
                  final localizedChannelName = value.localizedName(context);
                  final successMessage = l10n.settingsUpdateChannelChanged(localizedChannelName);

                  final updatedSettings = _currentSettings!.copyWith(
                    updateChannel: value,
                  );
                  _updateSettings(updatedSettings);

                  await ref.read(settingsProvider.notifier).updateSettings(
                    updatedSettings,
                  );

                  if (!mounted) return;

                  final updateService = ref.read(githubUpdateServiceProvider);
                  await updateService.checkForUpdates(
                    silent: false,
                    channel: value,
                  );

                  if (!mounted) return;

                  Toast.success(context, successMessage);
                }
              },
            ),
          ]),
          const VSpace.lg(),
          _buildFactoryResetSection(context),
        ],
      ),
    );
  }

  Widget _buildSaveBar(AppLocalizations l10n) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(TKitSpacing.lg),
        decoration: BoxDecoration(
          color: TKitColors.surfaceVariant,
          border: const Border(
            top: BorderSide(color: TKitColors.border, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 16, color: TKitColors.warning),
            const HSpace.sm(),
            Text(
              l10n.settingsUnsavedChanges,
              style: TKitTextStyles.caption.copyWith(
                color: TKitColors.textSecondary,
              ),
            ),
            const Spacer(),
            AccentButton(
              text: l10n.settingsDiscard,
              onPressed: _discardChanges,
            ),
            const HSpace.sm(),
            PrimaryButton(text: l10n.settingsSave, onPressed: _saveSettings),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: TKitTextStyles.labelSmall.copyWith(
            letterSpacing: 1.0,
            color: TKitColors.textSecondary,
          ),
        ),
        const VSpace.md(),
        Island.standard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildTwitchAuthSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authProvider);
        final isAuthenticated = authState is Authenticated;
        final isLoading = authState is AuthLoading;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.settingsTwitchConnection.toUpperCase(),
              style: TKitTextStyles.labelSmall.copyWith(
                letterSpacing: 1.0,
                color: TKitColors.textSecondary,
              ),
            ),
            const VSpace.md(),
            Island.standard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isAuthenticated
                              ? TKitColors.success
                              : TKitColors.textDisabled,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const HSpace.md(),
                      Text(
                        isAuthenticated
                            ? l10n.settingsTwitchStatusConnected
                            : l10n.settingsTwitchStatusNotConnected,
                        style: TKitTextStyles.labelLarge,
                      ),
                    ],
                  ),
                  const VSpace.md(),
                  if (isAuthenticated) ...[
                    Text(
                      l10n.settingsTwitchLoggedInAs,
                      style: TKitTextStyles.caption,
                    ),
                    const VSpace.xs(),
                    Row(
                      children: [
                        const Icon(
                          Icons.person,
                          size: 16,
                          color: TKitColors.accent,
                        ),
                        const HSpace.sm(),
                        Text(
                          authState.user.displayName,
                          style: TKitTextStyles.bodyMedium,
                        ),
                        const HSpace.sm(),
                        Text(
                          '(@${authState.user.login})',
                          style: TKitTextStyles.caption,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    FutureBuilder<DateTime?>(
                      future: ref.read(authProvider.notifier).getTokenExpiration(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final expiresAt = snapshot.data!;
                          final now = DateTime.now();
                          final isExpired = expiresAt.isBefore(now);
                          final timeRemaining = expiresAt.difference(now);

                          String expiryText;
                          if (isExpired) {
                            expiryText = 'Expired';
                          } else if (timeRemaining.inDays > 0) {
                            expiryText =
                                'Expires in ${timeRemaining.inDays}d ${timeRemaining.inHours % 24}h';
                          } else if (timeRemaining.inHours > 0) {
                            expiryText =
                                'Expires in ${timeRemaining.inHours}h ${timeRemaining.inMinutes % 60}m';
                          } else {
                            expiryText =
                                'Expires in ${timeRemaining.inMinutes}m';
                          }

                          return Row(
                            children: [
                              Icon(
                                Icons.schedule,
                                size: 14,
                                color: isExpired
                                    ? TKitColors.error
                                    : TKitColors.textMuted,
                              ),
                              const HSpace.xs(),
                              Text(
                                expiryText,
                                style: TKitTextStyles.caption.copyWith(
                                  color: isExpired
                                      ? TKitColors.error
                                      : TKitColors.textMuted,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AccentButton(
                            text: l10n.settingsTwitchDisconnect,
                            icon: Icons.logout,
                            onPressed: isLoading
                                ? null
                                : () {
                                    ref.read(authProvider.notifier).logout();
                                  },
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Text(
                      l10n.settingsTwitchConnectDescription,
                      style: TKitTextStyles.caption,
                    ),
                    const VSpace.md(),
                    PrimaryButton(
                      text: l10n.settingsTwitchConnect,
                      icon: Icons.link,
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () async {
                              final notifier = ref.read(authProvider.notifier);
                              final deviceCodeResponse = await notifier.initiateDeviceCodeAuth();

                              if (deviceCodeResponse != null &&
                                  context.mounted) {
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (dialogContext) =>
                                      DeviceCodeAuthPage(
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
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFactoryResetSection(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DANGER ZONE',
          style: TKitTextStyles.labelSmall.copyWith(
            letterSpacing: 1.0,
            color: TKitColors.error,
          ),
        ),
        const VSpace.md(),
        Container(
          decoration: BoxDecoration(
            color: TKitColors.surface,
            border: Border.all(color: TKitColors.error, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(TKitSpacing.lg),
          child: Row(
            children: [
              const Icon(
                Icons.warning_rounded,
                size: 20,
                color: TKitColors.error,
              ),
              const HSpace.md(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsFactoryReset,
                      style: TKitTextStyles.labelMedium.copyWith(
                        color: TKitColors.error,
                      ),
                    ),
                    const VSpace.xs(),
                    Text(
                      'Reset all settings and data to factory defaults',
                      style: TKitTextStyles.caption.copyWith(
                        color: TKitColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const HSpace.md(),
              AccentButton(
                text: 'Reset',
                icon: Icons.restore,
                onPressed: () => _showFactoryResetDialog(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showFactoryResetDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: TKitColors.warning),
            const SizedBox(width: 8),
            Text(l10n.settingsFactoryResetDialogTitle),
          ],
        ),
        content: Text(l10n.settingsFactoryResetDialogMessage),
        actions: [
          AccentButton(
            text: l10n.commonCancel,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
          PrimaryButton(
            text: l10n.settingsFactoryResetDialogConfirm,
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              await _performFactoryReset(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _performFactoryReset(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;

    // Show loading indicator
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      // Get the FactoryResetUseCase from Riverpod
      final factoryResetUseCase = await ref.read(factoryResetUseCaseProvider.future);

      final result = await factoryResetUseCase();

      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      result.fold(
        (failure) {
          // Show error message
          if (context.mounted) {
            Toast.error(context, failure.message);
          }
        },
        (_) {
          // Show success message
          if (context.mounted) {
            Toast.success(context, l10n.settingsFactoryResetSuccess);
          }
        },
      );
    } catch (e) {
      // Close loading dialog
      if (context.mounted) {
        Navigator.of(context).pop();
      }

      // Show error message
      if (context.mounted) {
        Toast.error(context, 'Error: ${e.toString()}');
      }
    }
  }
}
