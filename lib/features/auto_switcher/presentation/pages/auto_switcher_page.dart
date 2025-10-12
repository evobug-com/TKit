import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tkit/l10n/app_localizations.dart';
import '../../../../shared/theme/colors.dart';
import '../../../../shared/theme/spacing.dart';
import '../../../../shared/widgets/layout/page_header.dart';
import '../../../../shared/widgets/layout/spacer.dart';
import '../../../../shared/widgets/feedback/toast.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../../settings/presentation/states/settings_state.dart';
import '../../domain/usecases/get_orchestration_status_usecase.dart';
import '../../domain/usecases/get_update_history_usecase.dart';
import '../../domain/usecases/manual_update_usecase.dart';
import '../../domain/usecases/start_monitoring_usecase.dart';
import '../../domain/usecases/stop_monitoring_usecase.dart';
import '../providers/auto_switcher_provider.dart';
import '../states/auto_switcher_state.dart';
import '../widgets/control_panel.dart';
import '../widgets/status_dashboard.dart';

/// Auto Switcher Page
///
/// Main page for the Auto Switcher feature displaying:
/// - Status dashboard (current process, category, last update)
/// - Control panel (start/stop monitoring, manual update)
/// - Two-column layout as specified in requirements
@RoutePage()
class AutoSwitcherPage extends StatefulWidget {
  const AutoSwitcherPage({super.key});

  @override
  State<AutoSwitcherPage> createState() => _AutoSwitcherPageState();
}

class _AutoSwitcherPageState extends State<AutoSwitcherPage> {
  @override
  void initState() {
    super.initState();
    // Load settings to ensure hotkey is displayed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsProvider = context.read<SettingsProvider>();
      if (settingsProvider.state is SettingsInitial) {
        settingsProvider.loadSettings();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final provider = AutoSwitcherProvider(
          context.read<StartMonitoringUseCase>(),
          context.read<StopMonitoringUseCase>(),
          context.read<ManualUpdateUseCase>(),
          context.read<GetOrchestrationStatusUseCase>(),
          context.read<GetUpdateHistoryUseCase>(),
        );
        provider.initialize();
        return provider;
      },
      child: const _AutoSwitcherPageContent(),
    );
  }
}

class _AutoSwitcherPageContent extends StatelessWidget {
  const _AutoSwitcherPageContent();

  @override
  Widget build(BuildContext context) {
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
              child: Consumer<SettingsProvider>(
                builder: (context, settingsProvider, child) {
                  // Extract hotkey from settings
                  final settingsState = settingsProvider.state;
                  String? manualUpdateHotkey;
                  if (settingsState is SettingsLoaded) {
                    manualUpdateHotkey = settingsState.settings.manualUpdateHotkey;
                  } else if (settingsState is SettingsSaved) {
                    manualUpdateHotkey = settingsState.settings.manualUpdateHotkey;
                  }

                  return Consumer<AutoSwitcherProvider>(
                    builder: (context, provider, child) {
                      final state = provider.state;

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
                                context.read<AutoSwitcherProvider>().startMonitoring();
                              },
                              onStopMonitoring: () {
                                context.read<AutoSwitcherProvider>().stopMonitoring();
                              },
                              onManualUpdate: () {
                                context.read<AutoSwitcherProvider>().manualUpdate();
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
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
