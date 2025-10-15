import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tkit/core/providers/datasource_providers.dart';
import 'package:tkit/core/providers/providers.dart';
import 'package:tkit/features/auth/presentation/providers/auth_providers.dart';
import 'package:tkit/features/settings/presentation/providers/settings_providers.dart';
import 'package:tkit/features/category_mapping/presentation/providers/category_mapping_providers.dart';
import 'package:tkit/features/twitch_api/presentation/providers/twitch_api_providers.dart';
import 'package:tkit/features/twitch_api/domain/usecases/update_channel_category_usecase.dart';
import 'package:tkit/features/category_mapping/domain/usecases/update_last_used_usecase.dart';

part 'use_case_providers.g.dart';

// =============================================================================
// ADDITIONAL TWITCH API USE CASES
// =============================================================================

@Riverpod(keepAlive: true)
UpdateChannelCategoryUseCase updateChannelCategoryUseCase(Ref ref) {
  final repository = ref.watch(twitchApiRepositoryProvider);
  return UpdateChannelCategoryUseCase(repository);
}

// =============================================================================
// ADDITIONAL CATEGORY MAPPING USE CASES
// =============================================================================

@Riverpod(keepAlive: true)
UpdateLastUsedUseCase updateLastUsedUseCase(Ref ref) {
  final repository = ref.watch(categoryMappingRepositoryProvider);
  return UpdateLastUsedUseCase(repository);
}
