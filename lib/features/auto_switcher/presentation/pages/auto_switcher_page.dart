import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tkit/l10n/app_localizations.dart';
import 'package:tkit/shared/theme/colors.dart';
import 'package:tkit/shared/theme/spacing.dart';
import 'package:tkit/shared/widgets/layout/page_header.dart';
import 'package:tkit/shared/widgets/layout/spacer.dart';
import 'package:tkit/shared/widgets/feedback/toast.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';
import 'package:tkit/features/settings/presentation/states/settings_state.dart';
import 'package:tkit/features/auto_switcher/presentation/providers/auto_switcher_providers.dart';
import 'package:tkit/features/auto_switcher/presentation/states/auto_switcher_state.dart';
import 'package:tkit/features/auto_switcher/presentation/widgets/control_panel.dart';
import 'package:tkit/features/auto_switcher/presentation/widgets/status_dashboard.dart';

/// Auto Switcher Page
///
/// Main page for the Auto Switcher feature displaying:
/// - Status dashboard (current process, category, last update)
/// - Control panel (start/stop monitoring, manual update)
/// - Two-column layout as specified in requirements
@RoutePage()
class AutoSwitcherPage extends ConsumerStatefulWidget {
  const AutoSwitcherPage({super.key});

  @override
  ConsumerState<AutoSwitcherPage> createState() => _AutoSwitcherPageState();
}

class _AutoSwitcherPageState extends ConsumerState<AutoSwitcherPage> {
  @override
  void initState() {
    super.initState();
    // Load settings to ensure hotkey is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsNotifier = ref.read(settingsProvider.notifier);
      if (ref.read(settingsProvider) is SettingsInitial) {
        settingsNotifier.loadSettings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const _AutoSwitcherPageContent();
  }
}

class _AutoSwitcherPageContent extends ConsumerWidget {
  const _AutoSwitcherPageContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final autoSwitcherAsync = ref.watch(autoSwitcherProvider);

    // Extract hotkey from settings
    String? manualUpdateHotkey;
    if (settingsState is SettingsLoaded) {
      manualUpdateHotkey = settingsState.settings.manualUpdateHotkey;
    } else if (settingsState is SettingsSaved) {
      manualUpdateHotkey = settingsState.settings.manualUpdateHotkey;
    }

    return Scaffold(
      backgroundColor: TKitColors.background,
      body: Padding(
        padding: const EdgeInsets.all(TKitSpacing.pagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            PageHeader(
              title: AppLocalizations.of(context)!.autoSwitcherPageTitle,
              subtitle: AppLocalizations.of(context)!.autoSwitcherPageDescription,
            ),
            const VSpace.lg(),

            // Two-column layout
            Expanded(
              child: autoSwitcherAsync.when(
                data: (state) {
                  // Show toast for errors
                  if (state is UpdateError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Toast.error(context, state.errorMessage);
                    });
                  }

                  // Show success message
                  if (state is UpdateSuccess && state.message != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Toast.success(context, state.message!);
                    });
                  }

                  final status = _getStatusFromState(state);
                  final isMonitoring = _isMonitoringActive(state);
                  final isLoading = state is AutoSwitcherLoading;

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left column - Status Dashboard (2/3 width)
                      Expanded(flex: 2, child: StatusDashboard(status: status)),

                      const HSpace.lg(),

                      // Right column - Control Panel (1/3 width)
                      Expanded(
                        flex: 1,
                        child: ControlPanel(
                          isMonitoring: isMonitoring,
                          isLoading: isLoading,
                          manualUpdateHotkey: manualUpdateHotkey,
                          onStartMonitoring: () {
                            ref.read(autoSwitcherProvider.notifier).startMonitoring();
                          },
                          onStopMonitoring: () {
                            ref.read(autoSwitcherProvider.notifier).stopMonitoring();
                          },
                          onManualUpdate: () {
                            ref.read(autoSwitcherProvider.notifier).manualUpdate();
                          },
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dynamic _getStatusFromState(AutoSwitcherState state) {
    return switch (state) {
      MonitoringActive(:final status) => status,
      MonitoringInactive(:final status) => status,
      Updating(:final status) => status,
      UpdateSuccess(:final status) => status,
      UpdateError(:final status) => status,
      HistoryLoaded(:final status) => status,
      AutoSwitcherLoading(:final status) => status,
      AutoSwitcherInitial() => null,
    };
  }

  bool _isMonitoringActive(AutoSwitcherState state) {
    return state is MonitoringActive ||
        (state is Updating && _getStatusFromState(state)?.isMonitoring == true);
  }
}
