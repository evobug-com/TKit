// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoryMappingsTable extends CategoryMappings
    with TableInfo<$CategoryMappingsTable, CategoryMappingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _processNameMeta = const VerificationMeta(
    'processName',
  );
  @override
  late final GeneratedColumn<String> processName = GeneratedColumn<String>(
    'process_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _executablePathMeta = const VerificationMeta(
    'executablePath',
  );
  @override
  late final GeneratedColumn<String> executablePath = GeneratedColumn<String>(
    'executable_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _normalizedInstallPathsMeta =
      const VerificationMeta('normalizedInstallPaths');
  @override
  late final GeneratedColumn<String> normalizedInstallPaths =
      GeneratedColumn<String>(
        'normalized_install_paths',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _twitchCategoryIdMeta = const VerificationMeta(
    'twitchCategoryId',
  );
  @override
  late final GeneratedColumn<String> twitchCategoryId = GeneratedColumn<String>(
    'twitch_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _twitchCategoryNameMeta =
      const VerificationMeta('twitchCategoryName');
  @override
  late final GeneratedColumn<String> twitchCategoryName =
      GeneratedColumn<String>(
        'twitch_category_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _lastUsedAtMeta = const VerificationMeta(
    'lastUsedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastApiFetchMeta = const VerificationMeta(
    'lastApiFetch',
  );
  @override
  late final GeneratedColumn<DateTime> lastApiFetch = GeneratedColumn<DateTime>(
    'last_api_fetch',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _cacheExpiresAtMeta = const VerificationMeta(
    'cacheExpiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> cacheExpiresAt =
      GeneratedColumn<DateTime>(
        'cache_expires_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _manualOverrideMeta = const VerificationMeta(
    'manualOverride',
  );
  @override
  late final GeneratedColumn<bool> manualOverride = GeneratedColumn<bool>(
    'manual_override',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("manual_override" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isEnabledMeta = const VerificationMeta(
    'isEnabled',
  );
  @override
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    processName,
    executablePath,
    normalizedInstallPaths,
    twitchCategoryId,
    twitchCategoryName,
    createdAt,
    lastUsedAt,
    lastApiFetch,
    cacheExpiresAt,
    manualOverride,
    isEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_mappings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryMappingEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('process_name')) {
      context.handle(
        _processNameMeta,
        processName.isAcceptableOrUnknown(
          data['process_name']!,
          _processNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processNameMeta);
    }
    if (data.containsKey('executable_path')) {
      context.handle(
        _executablePathMeta,
        executablePath.isAcceptableOrUnknown(
          data['executable_path']!,
          _executablePathMeta,
        ),
      );
    }
    if (data.containsKey('normalized_install_paths')) {
      context.handle(
        _normalizedInstallPathsMeta,
        normalizedInstallPaths.isAcceptableOrUnknown(
          data['normalized_install_paths']!,
          _normalizedInstallPathsMeta,
        ),
      );
    }
    if (data.containsKey('twitch_category_id')) {
      context.handle(
        _twitchCategoryIdMeta,
        twitchCategoryId.isAcceptableOrUnknown(
          data['twitch_category_id']!,
          _twitchCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_twitchCategoryIdMeta);
    }
    if (data.containsKey('twitch_category_name')) {
      context.handle(
        _twitchCategoryNameMeta,
        twitchCategoryName.isAcceptableOrUnknown(
          data['twitch_category_name']!,
          _twitchCategoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_twitchCategoryNameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('last_used_at')) {
      context.handle(
        _lastUsedAtMeta,
        lastUsedAt.isAcceptableOrUnknown(
          data['last_used_at']!,
          _lastUsedAtMeta,
        ),
      );
    }
    if (data.containsKey('last_api_fetch')) {
      context.handle(
        _lastApiFetchMeta,
        lastApiFetch.isAcceptableOrUnknown(
          data['last_api_fetch']!,
          _lastApiFetchMeta,
        ),
      );
    }
    if (data.containsKey('cache_expires_at')) {
      context.handle(
        _cacheExpiresAtMeta,
        cacheExpiresAt.isAcceptableOrUnknown(
          data['cache_expires_at']!,
          _cacheExpiresAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cacheExpiresAtMeta);
    }
    if (data.containsKey('manual_override')) {
      context.handle(
        _manualOverrideMeta,
        manualOverride.isAcceptableOrUnknown(
          data['manual_override']!,
          _manualOverrideMeta,
        ),
      );
    }
    if (data.containsKey('is_enabled')) {
      context.handle(
        _isEnabledMeta,
        isEnabled.isAcceptableOrUnknown(data['is_enabled']!, _isEnabledMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryMappingEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryMappingEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      processName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}process_name'],
      )!,
      executablePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}executable_path'],
      ),
      normalizedInstallPaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_install_paths'],
      ),
      twitchCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}twitch_category_id'],
      )!,
      twitchCategoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}twitch_category_name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastUsedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_used_at'],
      ),
      lastApiFetch: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_api_fetch'],
      )!,
      cacheExpiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cache_expires_at'],
      )!,
      manualOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}manual_override'],
      )!,
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
    );
  }

  @override
  $CategoryMappingsTable createAlias(String alias) {
    return $CategoryMappingsTable(attachedDatabase, alias);
  }
}

class CategoryMappingEntity extends DataClass
    implements Insertable<CategoryMappingEntity> {
  final int id;
  final String processName;

  /// @deprecated Use normalizedInstallPaths instead
  final String? executablePath;

  /// JSON array of normalized, privacy-safe installation paths
  /// Example: ["steamapps/common/dota 2", "program files (x86)/ea games/battlefield"]
  final String? normalizedInstallPaths;
  final String twitchCategoryId;
  final String twitchCategoryName;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final DateTime lastApiFetch;
  final DateTime cacheExpiresAt;
  final bool manualOverride;
  final bool isEnabled;
  const CategoryMappingEntity({
    required this.id,
    required this.processName,
    this.executablePath,
    this.normalizedInstallPaths,
    required this.twitchCategoryId,
    required this.twitchCategoryName,
    required this.createdAt,
    this.lastUsedAt,
    required this.lastApiFetch,
    required this.cacheExpiresAt,
    required this.manualOverride,
    required this.isEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['process_name'] = Variable<String>(processName);
    if (!nullToAbsent || executablePath != null) {
      map['executable_path'] = Variable<String>(executablePath);
    }
    if (!nullToAbsent || normalizedInstallPaths != null) {
      map['normalized_install_paths'] = Variable<String>(
        normalizedInstallPaths,
      );
    }
    map['twitch_category_id'] = Variable<String>(twitchCategoryId);
    map['twitch_category_name'] = Variable<String>(twitchCategoryName);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || lastUsedAt != null) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt);
    }
    map['last_api_fetch'] = Variable<DateTime>(lastApiFetch);
    map['cache_expires_at'] = Variable<DateTime>(cacheExpiresAt);
    map['manual_override'] = Variable<bool>(manualOverride);
    map['is_enabled'] = Variable<bool>(isEnabled);
    return map;
  }

  CategoryMappingsCompanion toCompanion(bool nullToAbsent) {
    return CategoryMappingsCompanion(
      id: Value(id),
      processName: Value(processName),
      executablePath: executablePath == null && nullToAbsent
          ? const Value.absent()
          : Value(executablePath),
      normalizedInstallPaths: normalizedInstallPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(normalizedInstallPaths),
      twitchCategoryId: Value(twitchCategoryId),
      twitchCategoryName: Value(twitchCategoryName),
      createdAt: Value(createdAt),
      lastUsedAt: lastUsedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUsedAt),
      lastApiFetch: Value(lastApiFetch),
      cacheExpiresAt: Value(cacheExpiresAt),
      manualOverride: Value(manualOverride),
      isEnabled: Value(isEnabled),
    );
  }

  factory CategoryMappingEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryMappingEntity(
      id: serializer.fromJson<int>(json['id']),
      processName: serializer.fromJson<String>(json['processName']),
      executablePath: serializer.fromJson<String?>(json['executablePath']),
      normalizedInstallPaths: serializer.fromJson<String?>(
        json['normalizedInstallPaths'],
      ),
      twitchCategoryId: serializer.fromJson<String>(json['twitchCategoryId']),
      twitchCategoryName: serializer.fromJson<String>(
        json['twitchCategoryName'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastUsedAt: serializer.fromJson<DateTime?>(json['lastUsedAt']),
      lastApiFetch: serializer.fromJson<DateTime>(json['lastApiFetch']),
      cacheExpiresAt: serializer.fromJson<DateTime>(json['cacheExpiresAt']),
      manualOverride: serializer.fromJson<bool>(json['manualOverride']),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'processName': serializer.toJson<String>(processName),
      'executablePath': serializer.toJson<String?>(executablePath),
      'normalizedInstallPaths': serializer.toJson<String?>(
        normalizedInstallPaths,
      ),
      'twitchCategoryId': serializer.toJson<String>(twitchCategoryId),
      'twitchCategoryName': serializer.toJson<String>(twitchCategoryName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastUsedAt': serializer.toJson<DateTime?>(lastUsedAt),
      'lastApiFetch': serializer.toJson<DateTime>(lastApiFetch),
      'cacheExpiresAt': serializer.toJson<DateTime>(cacheExpiresAt),
      'manualOverride': serializer.toJson<bool>(manualOverride),
      'isEnabled': serializer.toJson<bool>(isEnabled),
    };
  }

  CategoryMappingEntity copyWith({
    int? id,
    String? processName,
    Value<String?> executablePath = const Value.absent(),
    Value<String?> normalizedInstallPaths = const Value.absent(),
    String? twitchCategoryId,
    String? twitchCategoryName,
    DateTime? createdAt,
    Value<DateTime?> lastUsedAt = const Value.absent(),
    DateTime? lastApiFetch,
    DateTime? cacheExpiresAt,
    bool? manualOverride,
    bool? isEnabled,
  }) => CategoryMappingEntity(
    id: id ?? this.id,
    processName: processName ?? this.processName,
    executablePath: executablePath.present
        ? executablePath.value
        : this.executablePath,
    normalizedInstallPaths: normalizedInstallPaths.present
        ? normalizedInstallPaths.value
        : this.normalizedInstallPaths,
    twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
    twitchCategoryName: twitchCategoryName ?? this.twitchCategoryName,
    createdAt: createdAt ?? this.createdAt,
    lastUsedAt: lastUsedAt.present ? lastUsedAt.value : this.lastUsedAt,
    lastApiFetch: lastApiFetch ?? this.lastApiFetch,
    cacheExpiresAt: cacheExpiresAt ?? this.cacheExpiresAt,
    manualOverride: manualOverride ?? this.manualOverride,
    isEnabled: isEnabled ?? this.isEnabled,
  );
  CategoryMappingEntity copyWithCompanion(CategoryMappingsCompanion data) {
    return CategoryMappingEntity(
      id: data.id.present ? data.id.value : this.id,
      processName: data.processName.present
          ? data.processName.value
          : this.processName,
      executablePath: data.executablePath.present
          ? data.executablePath.value
          : this.executablePath,
      normalizedInstallPaths: data.normalizedInstallPaths.present
          ? data.normalizedInstallPaths.value
          : this.normalizedInstallPaths,
      twitchCategoryId: data.twitchCategoryId.present
          ? data.twitchCategoryId.value
          : this.twitchCategoryId,
      twitchCategoryName: data.twitchCategoryName.present
          ? data.twitchCategoryName.value
          : this.twitchCategoryName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastUsedAt: data.lastUsedAt.present
          ? data.lastUsedAt.value
          : this.lastUsedAt,
      lastApiFetch: data.lastApiFetch.present
          ? data.lastApiFetch.value
          : this.lastApiFetch,
      cacheExpiresAt: data.cacheExpiresAt.present
          ? data.cacheExpiresAt.value
          : this.cacheExpiresAt,
      manualOverride: data.manualOverride.present
          ? data.manualOverride.value
          : this.manualOverride,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryMappingEntity(')
          ..write('id: $id, ')
          ..write('processName: $processName, ')
          ..write('executablePath: $executablePath, ')
          ..write('normalizedInstallPaths: $normalizedInstallPaths, ')
          ..write('twitchCategoryId: $twitchCategoryId, ')
          ..write('twitchCategoryName: $twitchCategoryName, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('lastApiFetch: $lastApiFetch, ')
          ..write('cacheExpiresAt: $cacheExpiresAt, ')
          ..write('manualOverride: $manualOverride, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    processName,
    executablePath,
    normalizedInstallPaths,
    twitchCategoryId,
    twitchCategoryName,
    createdAt,
    lastUsedAt,
    lastApiFetch,
    cacheExpiresAt,
    manualOverride,
    isEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryMappingEntity &&
          other.id == this.id &&
          other.processName == this.processName &&
          other.executablePath == this.executablePath &&
          other.normalizedInstallPaths == this.normalizedInstallPaths &&
          other.twitchCategoryId == this.twitchCategoryId &&
          other.twitchCategoryName == this.twitchCategoryName &&
          other.createdAt == this.createdAt &&
          other.lastUsedAt == this.lastUsedAt &&
          other.lastApiFetch == this.lastApiFetch &&
          other.cacheExpiresAt == this.cacheExpiresAt &&
          other.manualOverride == this.manualOverride &&
          other.isEnabled == this.isEnabled);
}

class CategoryMappingsCompanion extends UpdateCompanion<CategoryMappingEntity> {
  final Value<int> id;
  final Value<String> processName;
  final Value<String?> executablePath;
  final Value<String?> normalizedInstallPaths;
  final Value<String> twitchCategoryId;
  final Value<String> twitchCategoryName;
  final Value<DateTime> createdAt;
  final Value<DateTime?> lastUsedAt;
  final Value<DateTime> lastApiFetch;
  final Value<DateTime> cacheExpiresAt;
  final Value<bool> manualOverride;
  final Value<bool> isEnabled;
  const CategoryMappingsCompanion({
    this.id = const Value.absent(),
    this.processName = const Value.absent(),
    this.executablePath = const Value.absent(),
    this.normalizedInstallPaths = const Value.absent(),
    this.twitchCategoryId = const Value.absent(),
    this.twitchCategoryName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.lastApiFetch = const Value.absent(),
    this.cacheExpiresAt = const Value.absent(),
    this.manualOverride = const Value.absent(),
    this.isEnabled = const Value.absent(),
  });
  CategoryMappingsCompanion.insert({
    this.id = const Value.absent(),
    required String processName,
    this.executablePath = const Value.absent(),
    this.normalizedInstallPaths = const Value.absent(),
    required String twitchCategoryId,
    required String twitchCategoryName,
    this.createdAt = const Value.absent(),
    this.lastUsedAt = const Value.absent(),
    this.lastApiFetch = const Value.absent(),
    required DateTime cacheExpiresAt,
    this.manualOverride = const Value.absent(),
    this.isEnabled = const Value.absent(),
  }) : processName = Value(processName),
       twitchCategoryId = Value(twitchCategoryId),
       twitchCategoryName = Value(twitchCategoryName),
       cacheExpiresAt = Value(cacheExpiresAt);
  static Insertable<CategoryMappingEntity> custom({
    Expression<int>? id,
    Expression<String>? processName,
    Expression<String>? executablePath,
    Expression<String>? normalizedInstallPaths,
    Expression<String>? twitchCategoryId,
    Expression<String>? twitchCategoryName,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastUsedAt,
    Expression<DateTime>? lastApiFetch,
    Expression<DateTime>? cacheExpiresAt,
    Expression<bool>? manualOverride,
    Expression<bool>? isEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (processName != null) 'process_name': processName,
      if (executablePath != null) 'executable_path': executablePath,
      if (normalizedInstallPaths != null)
        'normalized_install_paths': normalizedInstallPaths,
      if (twitchCategoryId != null) 'twitch_category_id': twitchCategoryId,
      if (twitchCategoryName != null)
        'twitch_category_name': twitchCategoryName,
      if (createdAt != null) 'created_at': createdAt,
      if (lastUsedAt != null) 'last_used_at': lastUsedAt,
      if (lastApiFetch != null) 'last_api_fetch': lastApiFetch,
      if (cacheExpiresAt != null) 'cache_expires_at': cacheExpiresAt,
      if (manualOverride != null) 'manual_override': manualOverride,
      if (isEnabled != null) 'is_enabled': isEnabled,
    });
  }

  CategoryMappingsCompanion copyWith({
    Value<int>? id,
    Value<String>? processName,
    Value<String?>? executablePath,
    Value<String?>? normalizedInstallPaths,
    Value<String>? twitchCategoryId,
    Value<String>? twitchCategoryName,
    Value<DateTime>? createdAt,
    Value<DateTime?>? lastUsedAt,
    Value<DateTime>? lastApiFetch,
    Value<DateTime>? cacheExpiresAt,
    Value<bool>? manualOverride,
    Value<bool>? isEnabled,
  }) {
    return CategoryMappingsCompanion(
      id: id ?? this.id,
      processName: processName ?? this.processName,
      executablePath: executablePath ?? this.executablePath,
      normalizedInstallPaths:
          normalizedInstallPaths ?? this.normalizedInstallPaths,
      twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
      twitchCategoryName: twitchCategoryName ?? this.twitchCategoryName,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      lastApiFetch: lastApiFetch ?? this.lastApiFetch,
      cacheExpiresAt: cacheExpiresAt ?? this.cacheExpiresAt,
      manualOverride: manualOverride ?? this.manualOverride,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (processName.present) {
      map['process_name'] = Variable<String>(processName.value);
    }
    if (executablePath.present) {
      map['executable_path'] = Variable<String>(executablePath.value);
    }
    if (normalizedInstallPaths.present) {
      map['normalized_install_paths'] = Variable<String>(
        normalizedInstallPaths.value,
      );
    }
    if (twitchCategoryId.present) {
      map['twitch_category_id'] = Variable<String>(twitchCategoryId.value);
    }
    if (twitchCategoryName.present) {
      map['twitch_category_name'] = Variable<String>(twitchCategoryName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastUsedAt.present) {
      map['last_used_at'] = Variable<DateTime>(lastUsedAt.value);
    }
    if (lastApiFetch.present) {
      map['last_api_fetch'] = Variable<DateTime>(lastApiFetch.value);
    }
    if (cacheExpiresAt.present) {
      map['cache_expires_at'] = Variable<DateTime>(cacheExpiresAt.value);
    }
    if (manualOverride.present) {
      map['manual_override'] = Variable<bool>(manualOverride.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryMappingsCompanion(')
          ..write('id: $id, ')
          ..write('processName: $processName, ')
          ..write('executablePath: $executablePath, ')
          ..write('normalizedInstallPaths: $normalizedInstallPaths, ')
          ..write('twitchCategoryId: $twitchCategoryId, ')
          ..write('twitchCategoryName: $twitchCategoryName, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastUsedAt: $lastUsedAt, ')
          ..write('lastApiFetch: $lastApiFetch, ')
          ..write('cacheExpiresAt: $cacheExpiresAt, ')
          ..write('manualOverride: $manualOverride, ')
          ..write('isEnabled: $isEnabled')
          ..write(')'))
        .toString();
  }
}

class $UpdateHistoryTable extends UpdateHistory
    with TableInfo<$UpdateHistoryTable, UpdateHistoryEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UpdateHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _processNameMeta = const VerificationMeta(
    'processName',
  );
  @override
  late final GeneratedColumn<String> processName = GeneratedColumn<String>(
    'process_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryNameMeta = const VerificationMeta(
    'categoryName',
  );
  @override
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _successMeta = const VerificationMeta(
    'success',
  );
  @override
  late final GeneratedColumn<bool> success = GeneratedColumn<bool>(
    'success',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("success" IN (0, 1))',
    ),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    processName,
    categoryId,
    categoryName,
    success,
    errorMessage,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'update_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<UpdateHistoryEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('process_name')) {
      context.handle(
        _processNameMeta,
        processName.isAcceptableOrUnknown(
          data['process_name']!,
          _processNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processNameMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('category_name')) {
      context.handle(
        _categoryNameMeta,
        categoryName.isAcceptableOrUnknown(
          data['category_name']!,
          _categoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryNameMeta);
    }
    if (data.containsKey('success')) {
      context.handle(
        _successMeta,
        success.isAcceptableOrUnknown(data['success']!, _successMeta),
      );
    } else if (isInserting) {
      context.missing(_successMeta);
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UpdateHistoryEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UpdateHistoryEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      processName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}process_name'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      categoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_name'],
      )!,
      success: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}success'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UpdateHistoryTable createAlias(String alias) {
    return $UpdateHistoryTable(attachedDatabase, alias);
  }
}

class UpdateHistoryEntity extends DataClass
    implements Insertable<UpdateHistoryEntity> {
  final int id;
  final String processName;
  final String categoryId;
  final String categoryName;
  final bool success;
  final String? errorMessage;
  final DateTime updatedAt;
  const UpdateHistoryEntity({
    required this.id,
    required this.processName,
    required this.categoryId,
    required this.categoryName,
    required this.success,
    this.errorMessage,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['process_name'] = Variable<String>(processName);
    map['category_id'] = Variable<String>(categoryId);
    map['category_name'] = Variable<String>(categoryName);
    map['success'] = Variable<bool>(success);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UpdateHistoryCompanion toCompanion(bool nullToAbsent) {
    return UpdateHistoryCompanion(
      id: Value(id),
      processName: Value(processName),
      categoryId: Value(categoryId),
      categoryName: Value(categoryName),
      success: Value(success),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      updatedAt: Value(updatedAt),
    );
  }

  factory UpdateHistoryEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UpdateHistoryEntity(
      id: serializer.fromJson<int>(json['id']),
      processName: serializer.fromJson<String>(json['processName']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      categoryName: serializer.fromJson<String>(json['categoryName']),
      success: serializer.fromJson<bool>(json['success']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'processName': serializer.toJson<String>(processName),
      'categoryId': serializer.toJson<String>(categoryId),
      'categoryName': serializer.toJson<String>(categoryName),
      'success': serializer.toJson<bool>(success),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UpdateHistoryEntity copyWith({
    int? id,
    String? processName,
    String? categoryId,
    String? categoryName,
    bool? success,
    Value<String?> errorMessage = const Value.absent(),
    DateTime? updatedAt,
  }) => UpdateHistoryEntity(
    id: id ?? this.id,
    processName: processName ?? this.processName,
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    success: success ?? this.success,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UpdateHistoryEntity copyWithCompanion(UpdateHistoryCompanion data) {
    return UpdateHistoryEntity(
      id: data.id.present ? data.id.value : this.id,
      processName: data.processName.present
          ? data.processName.value
          : this.processName,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      categoryName: data.categoryName.present
          ? data.categoryName.value
          : this.categoryName,
      success: data.success.present ? data.success.value : this.success,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UpdateHistoryEntity(')
          ..write('id: $id, ')
          ..write('processName: $processName, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    processName,
    categoryId,
    categoryName,
    success,
    errorMessage,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UpdateHistoryEntity &&
          other.id == this.id &&
          other.processName == this.processName &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.success == this.success &&
          other.errorMessage == this.errorMessage &&
          other.updatedAt == this.updatedAt);
}

class UpdateHistoryCompanion extends UpdateCompanion<UpdateHistoryEntity> {
  final Value<int> id;
  final Value<String> processName;
  final Value<String> categoryId;
  final Value<String> categoryName;
  final Value<bool> success;
  final Value<String?> errorMessage;
  final Value<DateTime> updatedAt;
  const UpdateHistoryCompanion({
    this.id = const Value.absent(),
    this.processName = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.categoryName = const Value.absent(),
    this.success = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UpdateHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String processName,
    required String categoryId,
    required String categoryName,
    required bool success,
    this.errorMessage = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : processName = Value(processName),
       categoryId = Value(categoryId),
       categoryName = Value(categoryName),
       success = Value(success);
  static Insertable<UpdateHistoryEntity> custom({
    Expression<int>? id,
    Expression<String>? processName,
    Expression<String>? categoryId,
    Expression<String>? categoryName,
    Expression<bool>? success,
    Expression<String>? errorMessage,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (processName != null) 'process_name': processName,
      if (categoryId != null) 'category_id': categoryId,
      if (categoryName != null) 'category_name': categoryName,
      if (success != null) 'success': success,
      if (errorMessage != null) 'error_message': errorMessage,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UpdateHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? processName,
    Value<String>? categoryId,
    Value<String>? categoryName,
    Value<bool>? success,
    Value<String?>? errorMessage,
    Value<DateTime>? updatedAt,
  }) {
    return UpdateHistoryCompanion(
      id: id ?? this.id,
      processName: processName ?? this.processName,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      success: success ?? this.success,
      errorMessage: errorMessage ?? this.errorMessage,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (processName.present) {
      map['process_name'] = Variable<String>(processName.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (categoryName.present) {
      map['category_name'] = Variable<String>(categoryName.value);
    }
    if (success.present) {
      map['success'] = Variable<bool>(success.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UpdateHistoryCompanion(')
          ..write('id: $id, ')
          ..write('processName: $processName, ')
          ..write('categoryId: $categoryId, ')
          ..write('categoryName: $categoryName, ')
          ..write('success: $success, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UnknownProcessesTable extends UnknownProcesses
    with TableInfo<$UnknownProcessesTable, UnknownProcessEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnknownProcessesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _executableNameMeta = const VerificationMeta(
    'executableName',
  );
  @override
  late final GeneratedColumn<String> executableName = GeneratedColumn<String>(
    'executable_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _windowTitleMeta = const VerificationMeta(
    'windowTitle',
  );
  @override
  late final GeneratedColumn<String> windowTitle = GeneratedColumn<String>(
    'window_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstDetectedMeta = const VerificationMeta(
    'firstDetected',
  );
  @override
  late final GeneratedColumn<DateTime> firstDetected =
      GeneratedColumn<DateTime>(
        'first_detected',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: currentDateAndTime,
      );
  static const VerificationMeta _occurrenceCountMeta = const VerificationMeta(
    'occurrenceCount',
  );
  @override
  late final GeneratedColumn<int> occurrenceCount = GeneratedColumn<int>(
    'occurrence_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _resolvedMeta = const VerificationMeta(
    'resolved',
  );
  @override
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
    'resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resolved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    executableName,
    windowTitle,
    firstDetected,
    occurrenceCount,
    resolved,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unknown_processes';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnknownProcessEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('executable_name')) {
      context.handle(
        _executableNameMeta,
        executableName.isAcceptableOrUnknown(
          data['executable_name']!,
          _executableNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_executableNameMeta);
    }
    if (data.containsKey('window_title')) {
      context.handle(
        _windowTitleMeta,
        windowTitle.isAcceptableOrUnknown(
          data['window_title']!,
          _windowTitleMeta,
        ),
      );
    }
    if (data.containsKey('first_detected')) {
      context.handle(
        _firstDetectedMeta,
        firstDetected.isAcceptableOrUnknown(
          data['first_detected']!,
          _firstDetectedMeta,
        ),
      );
    }
    if (data.containsKey('occurrence_count')) {
      context.handle(
        _occurrenceCountMeta,
        occurrenceCount.isAcceptableOrUnknown(
          data['occurrence_count']!,
          _occurrenceCountMeta,
        ),
      );
    }
    if (data.containsKey('resolved')) {
      context.handle(
        _resolvedMeta,
        resolved.isAcceptableOrUnknown(data['resolved']!, _resolvedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnknownProcessEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnknownProcessEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      executableName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}executable_name'],
      )!,
      windowTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}window_title'],
      ),
      firstDetected: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_detected'],
      )!,
      occurrenceCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}occurrence_count'],
      )!,
      resolved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}resolved'],
      )!,
    );
  }

  @override
  $UnknownProcessesTable createAlias(String alias) {
    return $UnknownProcessesTable(attachedDatabase, alias);
  }
}

class UnknownProcessEntity extends DataClass
    implements Insertable<UnknownProcessEntity> {
  final int id;
  final String executableName;
  final String? windowTitle;
  final DateTime firstDetected;
  final int occurrenceCount;
  final bool resolved;
  const UnknownProcessEntity({
    required this.id,
    required this.executableName,
    this.windowTitle,
    required this.firstDetected,
    required this.occurrenceCount,
    required this.resolved,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['executable_name'] = Variable<String>(executableName);
    if (!nullToAbsent || windowTitle != null) {
      map['window_title'] = Variable<String>(windowTitle);
    }
    map['first_detected'] = Variable<DateTime>(firstDetected);
    map['occurrence_count'] = Variable<int>(occurrenceCount);
    map['resolved'] = Variable<bool>(resolved);
    return map;
  }

  UnknownProcessesCompanion toCompanion(bool nullToAbsent) {
    return UnknownProcessesCompanion(
      id: Value(id),
      executableName: Value(executableName),
      windowTitle: windowTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(windowTitle),
      firstDetected: Value(firstDetected),
      occurrenceCount: Value(occurrenceCount),
      resolved: Value(resolved),
    );
  }

  factory UnknownProcessEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnknownProcessEntity(
      id: serializer.fromJson<int>(json['id']),
      executableName: serializer.fromJson<String>(json['executableName']),
      windowTitle: serializer.fromJson<String?>(json['windowTitle']),
      firstDetected: serializer.fromJson<DateTime>(json['firstDetected']),
      occurrenceCount: serializer.fromJson<int>(json['occurrenceCount']),
      resolved: serializer.fromJson<bool>(json['resolved']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'executableName': serializer.toJson<String>(executableName),
      'windowTitle': serializer.toJson<String?>(windowTitle),
      'firstDetected': serializer.toJson<DateTime>(firstDetected),
      'occurrenceCount': serializer.toJson<int>(occurrenceCount),
      'resolved': serializer.toJson<bool>(resolved),
    };
  }

  UnknownProcessEntity copyWith({
    int? id,
    String? executableName,
    Value<String?> windowTitle = const Value.absent(),
    DateTime? firstDetected,
    int? occurrenceCount,
    bool? resolved,
  }) => UnknownProcessEntity(
    id: id ?? this.id,
    executableName: executableName ?? this.executableName,
    windowTitle: windowTitle.present ? windowTitle.value : this.windowTitle,
    firstDetected: firstDetected ?? this.firstDetected,
    occurrenceCount: occurrenceCount ?? this.occurrenceCount,
    resolved: resolved ?? this.resolved,
  );
  UnknownProcessEntity copyWithCompanion(UnknownProcessesCompanion data) {
    return UnknownProcessEntity(
      id: data.id.present ? data.id.value : this.id,
      executableName: data.executableName.present
          ? data.executableName.value
          : this.executableName,
      windowTitle: data.windowTitle.present
          ? data.windowTitle.value
          : this.windowTitle,
      firstDetected: data.firstDetected.present
          ? data.firstDetected.value
          : this.firstDetected,
      occurrenceCount: data.occurrenceCount.present
          ? data.occurrenceCount.value
          : this.occurrenceCount,
      resolved: data.resolved.present ? data.resolved.value : this.resolved,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnknownProcessEntity(')
          ..write('id: $id, ')
          ..write('executableName: $executableName, ')
          ..write('windowTitle: $windowTitle, ')
          ..write('firstDetected: $firstDetected, ')
          ..write('occurrenceCount: $occurrenceCount, ')
          ..write('resolved: $resolved')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    executableName,
    windowTitle,
    firstDetected,
    occurrenceCount,
    resolved,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnknownProcessEntity &&
          other.id == this.id &&
          other.executableName == this.executableName &&
          other.windowTitle == this.windowTitle &&
          other.firstDetected == this.firstDetected &&
          other.occurrenceCount == this.occurrenceCount &&
          other.resolved == this.resolved);
}

class UnknownProcessesCompanion extends UpdateCompanion<UnknownProcessEntity> {
  final Value<int> id;
  final Value<String> executableName;
  final Value<String?> windowTitle;
  final Value<DateTime> firstDetected;
  final Value<int> occurrenceCount;
  final Value<bool> resolved;
  const UnknownProcessesCompanion({
    this.id = const Value.absent(),
    this.executableName = const Value.absent(),
    this.windowTitle = const Value.absent(),
    this.firstDetected = const Value.absent(),
    this.occurrenceCount = const Value.absent(),
    this.resolved = const Value.absent(),
  });
  UnknownProcessesCompanion.insert({
    this.id = const Value.absent(),
    required String executableName,
    this.windowTitle = const Value.absent(),
    this.firstDetected = const Value.absent(),
    this.occurrenceCount = const Value.absent(),
    this.resolved = const Value.absent(),
  }) : executableName = Value(executableName);
  static Insertable<UnknownProcessEntity> custom({
    Expression<int>? id,
    Expression<String>? executableName,
    Expression<String>? windowTitle,
    Expression<DateTime>? firstDetected,
    Expression<int>? occurrenceCount,
    Expression<bool>? resolved,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (executableName != null) 'executable_name': executableName,
      if (windowTitle != null) 'window_title': windowTitle,
      if (firstDetected != null) 'first_detected': firstDetected,
      if (occurrenceCount != null) 'occurrence_count': occurrenceCount,
      if (resolved != null) 'resolved': resolved,
    });
  }

  UnknownProcessesCompanion copyWith({
    Value<int>? id,
    Value<String>? executableName,
    Value<String?>? windowTitle,
    Value<DateTime>? firstDetected,
    Value<int>? occurrenceCount,
    Value<bool>? resolved,
  }) {
    return UnknownProcessesCompanion(
      id: id ?? this.id,
      executableName: executableName ?? this.executableName,
      windowTitle: windowTitle ?? this.windowTitle,
      firstDetected: firstDetected ?? this.firstDetected,
      occurrenceCount: occurrenceCount ?? this.occurrenceCount,
      resolved: resolved ?? this.resolved,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (executableName.present) {
      map['executable_name'] = Variable<String>(executableName.value);
    }
    if (windowTitle.present) {
      map['window_title'] = Variable<String>(windowTitle.value);
    }
    if (firstDetected.present) {
      map['first_detected'] = Variable<DateTime>(firstDetected.value);
    }
    if (occurrenceCount.present) {
      map['occurrence_count'] = Variable<int>(occurrenceCount.value);
    }
    if (resolved.present) {
      map['resolved'] = Variable<bool>(resolved.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnknownProcessesCompanion(')
          ..write('id: $id, ')
          ..write('executableName: $executableName, ')
          ..write('windowTitle: $windowTitle, ')
          ..write('firstDetected: $firstDetected, ')
          ..write('occurrenceCount: $occurrenceCount, ')
          ..write('resolved: $resolved')
          ..write(')'))
        .toString();
  }
}

class $TopGamesCacheTable extends TopGamesCache
    with TableInfo<$TopGamesCacheTable, TopGameEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TopGamesCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _twitchCategoryIdMeta = const VerificationMeta(
    'twitchCategoryId',
  );
  @override
  late final GeneratedColumn<String> twitchCategoryId = GeneratedColumn<String>(
    'twitch_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gameNameMeta = const VerificationMeta(
    'gameName',
  );
  @override
  late final GeneratedColumn<String> gameName = GeneratedColumn<String>(
    'game_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boxArtUrlMeta = const VerificationMeta(
    'boxArtUrl',
  );
  @override
  late final GeneratedColumn<String> boxArtUrl = GeneratedColumn<String>(
    'box_art_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    twitchCategoryId,
    gameName,
    boxArtUrl,
    lastUpdated,
    expiresAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'top_games_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<TopGameEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('twitch_category_id')) {
      context.handle(
        _twitchCategoryIdMeta,
        twitchCategoryId.isAcceptableOrUnknown(
          data['twitch_category_id']!,
          _twitchCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_twitchCategoryIdMeta);
    }
    if (data.containsKey('game_name')) {
      context.handle(
        _gameNameMeta,
        gameName.isAcceptableOrUnknown(data['game_name']!, _gameNameMeta),
      );
    } else if (isInserting) {
      context.missing(_gameNameMeta);
    }
    if (data.containsKey('box_art_url')) {
      context.handle(
        _boxArtUrlMeta,
        boxArtUrl.isAcceptableOrUnknown(data['box_art_url']!, _boxArtUrlMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {twitchCategoryId};
  @override
  TopGameEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TopGameEntity(
      twitchCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}twitch_category_id'],
      )!,
      gameName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_name'],
      )!,
      boxArtUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}box_art_url'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
    );
  }

  @override
  $TopGamesCacheTable createAlias(String alias) {
    return $TopGamesCacheTable(attachedDatabase, alias);
  }
}

class TopGameEntity extends DataClass implements Insertable<TopGameEntity> {
  final String twitchCategoryId;
  final String gameName;
  final String? boxArtUrl;
  final DateTime lastUpdated;
  final DateTime expiresAt;
  const TopGameEntity({
    required this.twitchCategoryId,
    required this.gameName,
    this.boxArtUrl,
    required this.lastUpdated,
    required this.expiresAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['twitch_category_id'] = Variable<String>(twitchCategoryId);
    map['game_name'] = Variable<String>(gameName);
    if (!nullToAbsent || boxArtUrl != null) {
      map['box_art_url'] = Variable<String>(boxArtUrl);
    }
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    return map;
  }

  TopGamesCacheCompanion toCompanion(bool nullToAbsent) {
    return TopGamesCacheCompanion(
      twitchCategoryId: Value(twitchCategoryId),
      gameName: Value(gameName),
      boxArtUrl: boxArtUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(boxArtUrl),
      lastUpdated: Value(lastUpdated),
      expiresAt: Value(expiresAt),
    );
  }

  factory TopGameEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TopGameEntity(
      twitchCategoryId: serializer.fromJson<String>(json['twitchCategoryId']),
      gameName: serializer.fromJson<String>(json['gameName']),
      boxArtUrl: serializer.fromJson<String?>(json['boxArtUrl']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'twitchCategoryId': serializer.toJson<String>(twitchCategoryId),
      'gameName': serializer.toJson<String>(gameName),
      'boxArtUrl': serializer.toJson<String?>(boxArtUrl),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
    };
  }

  TopGameEntity copyWith({
    String? twitchCategoryId,
    String? gameName,
    Value<String?> boxArtUrl = const Value.absent(),
    DateTime? lastUpdated,
    DateTime? expiresAt,
  }) => TopGameEntity(
    twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
    gameName: gameName ?? this.gameName,
    boxArtUrl: boxArtUrl.present ? boxArtUrl.value : this.boxArtUrl,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  TopGameEntity copyWithCompanion(TopGamesCacheCompanion data) {
    return TopGameEntity(
      twitchCategoryId: data.twitchCategoryId.present
          ? data.twitchCategoryId.value
          : this.twitchCategoryId,
      gameName: data.gameName.present ? data.gameName.value : this.gameName,
      boxArtUrl: data.boxArtUrl.present ? data.boxArtUrl.value : this.boxArtUrl,
      lastUpdated: data.lastUpdated.present
          ? data.lastUpdated.value
          : this.lastUpdated,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TopGameEntity(')
          ..write('twitchCategoryId: $twitchCategoryId, ')
          ..write('gameName: $gameName, ')
          ..write('boxArtUrl: $boxArtUrl, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('expiresAt: $expiresAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    twitchCategoryId,
    gameName,
    boxArtUrl,
    lastUpdated,
    expiresAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TopGameEntity &&
          other.twitchCategoryId == this.twitchCategoryId &&
          other.gameName == this.gameName &&
          other.boxArtUrl == this.boxArtUrl &&
          other.lastUpdated == this.lastUpdated &&
          other.expiresAt == this.expiresAt);
}

class TopGamesCacheCompanion extends UpdateCompanion<TopGameEntity> {
  final Value<String> twitchCategoryId;
  final Value<String> gameName;
  final Value<String?> boxArtUrl;
  final Value<DateTime> lastUpdated;
  final Value<DateTime> expiresAt;
  final Value<int> rowid;
  const TopGamesCacheCompanion({
    this.twitchCategoryId = const Value.absent(),
    this.gameName = const Value.absent(),
    this.boxArtUrl = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TopGamesCacheCompanion.insert({
    required String twitchCategoryId,
    required String gameName,
    this.boxArtUrl = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    required DateTime expiresAt,
    this.rowid = const Value.absent(),
  }) : twitchCategoryId = Value(twitchCategoryId),
       gameName = Value(gameName),
       expiresAt = Value(expiresAt);
  static Insertable<TopGameEntity> custom({
    Expression<String>? twitchCategoryId,
    Expression<String>? gameName,
    Expression<String>? boxArtUrl,
    Expression<DateTime>? lastUpdated,
    Expression<DateTime>? expiresAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (twitchCategoryId != null) 'twitch_category_id': twitchCategoryId,
      if (gameName != null) 'game_name': gameName,
      if (boxArtUrl != null) 'box_art_url': boxArtUrl,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TopGamesCacheCompanion copyWith({
    Value<String>? twitchCategoryId,
    Value<String>? gameName,
    Value<String?>? boxArtUrl,
    Value<DateTime>? lastUpdated,
    Value<DateTime>? expiresAt,
    Value<int>? rowid,
  }) {
    return TopGamesCacheCompanion(
      twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
      gameName: gameName ?? this.gameName,
      boxArtUrl: boxArtUrl ?? this.boxArtUrl,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      expiresAt: expiresAt ?? this.expiresAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (twitchCategoryId.present) {
      map['twitch_category_id'] = Variable<String>(twitchCategoryId.value);
    }
    if (gameName.present) {
      map['game_name'] = Variable<String>(gameName.value);
    }
    if (boxArtUrl.present) {
      map['box_art_url'] = Variable<String>(boxArtUrl.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TopGamesCacheCompanion(')
          ..write('twitchCategoryId: $twitchCategoryId, ')
          ..write('gameName: $gameName, ')
          ..write('boxArtUrl: $boxArtUrl, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CommunityMappingsTable extends CommunityMappings
    with TableInfo<$CommunityMappingsTable, CommunityMappingEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CommunityMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _processNameMeta = const VerificationMeta(
    'processName',
  );
  @override
  late final GeneratedColumn<String> processName = GeneratedColumn<String>(
    'process_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedInstallPathsMeta =
      const VerificationMeta('normalizedInstallPaths');
  @override
  late final GeneratedColumn<String> normalizedInstallPaths =
      GeneratedColumn<String>(
        'normalized_install_paths',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _twitchCategoryIdMeta = const VerificationMeta(
    'twitchCategoryId',
  );
  @override
  late final GeneratedColumn<String> twitchCategoryId = GeneratedColumn<String>(
    'twitch_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _twitchCategoryNameMeta =
      const VerificationMeta('twitchCategoryName');
  @override
  late final GeneratedColumn<String> twitchCategoryName =
      GeneratedColumn<String>(
        'twitch_category_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _verificationCountMeta = const VerificationMeta(
    'verificationCount',
  );
  @override
  late final GeneratedColumn<int> verificationCount = GeneratedColumn<int>(
    'verification_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _lastVerifiedMeta = const VerificationMeta(
    'lastVerified',
  );
  @override
  late final GeneratedColumn<DateTime> lastVerified = GeneratedColumn<DateTime>(
    'last_verified',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('community'),
  );
  static const VerificationMeta _syncedAtMeta = const VerificationMeta(
    'syncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    processName,
    normalizedInstallPaths,
    twitchCategoryId,
    twitchCategoryName,
    verificationCount,
    lastVerified,
    source,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'community_mappings';
  @override
  VerificationContext validateIntegrity(
    Insertable<CommunityMappingEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('process_name')) {
      context.handle(
        _processNameMeta,
        processName.isAcceptableOrUnknown(
          data['process_name']!,
          _processNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processNameMeta);
    }
    if (data.containsKey('normalized_install_paths')) {
      context.handle(
        _normalizedInstallPathsMeta,
        normalizedInstallPaths.isAcceptableOrUnknown(
          data['normalized_install_paths']!,
          _normalizedInstallPathsMeta,
        ),
      );
    }
    if (data.containsKey('twitch_category_id')) {
      context.handle(
        _twitchCategoryIdMeta,
        twitchCategoryId.isAcceptableOrUnknown(
          data['twitch_category_id']!,
          _twitchCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_twitchCategoryIdMeta);
    }
    if (data.containsKey('twitch_category_name')) {
      context.handle(
        _twitchCategoryNameMeta,
        twitchCategoryName.isAcceptableOrUnknown(
          data['twitch_category_name']!,
          _twitchCategoryNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_twitchCategoryNameMeta);
    }
    if (data.containsKey('verification_count')) {
      context.handle(
        _verificationCountMeta,
        verificationCount.isAcceptableOrUnknown(
          data['verification_count']!,
          _verificationCountMeta,
        ),
      );
    }
    if (data.containsKey('last_verified')) {
      context.handle(
        _lastVerifiedMeta,
        lastVerified.isAcceptableOrUnknown(
          data['last_verified']!,
          _lastVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('synced_at')) {
      context.handle(
        _syncedAtMeta,
        syncedAt.isAcceptableOrUnknown(data['synced_at']!, _syncedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {processName, twitchCategoryId},
  ];
  @override
  CommunityMappingEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommunityMappingEntity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      processName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}process_name'],
      )!,
      normalizedInstallPaths: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized_install_paths'],
      ),
      twitchCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}twitch_category_id'],
      )!,
      twitchCategoryName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}twitch_category_name'],
      )!,
      verificationCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}verification_count'],
      )!,
      lastVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_verified'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  $CommunityMappingsTable createAlias(String alias) {
    return $CommunityMappingsTable(attachedDatabase, alias);
  }
}

class CommunityMappingEntity extends DataClass
    implements Insertable<CommunityMappingEntity> {
  final int id;
  final String processName;

  /// JSON array of normalized, privacy-safe installation paths from community
  /// Example: ["steamapps/common/dota 2", "program files (x86)/ea games/battlefield"]
  final String? normalizedInstallPaths;
  final String twitchCategoryId;
  final String twitchCategoryName;
  final int verificationCount;
  final DateTime? lastVerified;
  final String source;
  final DateTime syncedAt;
  const CommunityMappingEntity({
    required this.id,
    required this.processName,
    this.normalizedInstallPaths,
    required this.twitchCategoryId,
    required this.twitchCategoryName,
    required this.verificationCount,
    this.lastVerified,
    required this.source,
    required this.syncedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['process_name'] = Variable<String>(processName);
    if (!nullToAbsent || normalizedInstallPaths != null) {
      map['normalized_install_paths'] = Variable<String>(
        normalizedInstallPaths,
      );
    }
    map['twitch_category_id'] = Variable<String>(twitchCategoryId);
    map['twitch_category_name'] = Variable<String>(twitchCategoryName);
    map['verification_count'] = Variable<int>(verificationCount);
    if (!nullToAbsent || lastVerified != null) {
      map['last_verified'] = Variable<DateTime>(lastVerified);
    }
    map['source'] = Variable<String>(source);
    map['synced_at'] = Variable<DateTime>(syncedAt);
    return map;
  }

  CommunityMappingsCompanion toCompanion(bool nullToAbsent) {
    return CommunityMappingsCompanion(
      id: Value(id),
      processName: Value(processName),
      normalizedInstallPaths: normalizedInstallPaths == null && nullToAbsent
          ? const Value.absent()
          : Value(normalizedInstallPaths),
      twitchCategoryId: Value(twitchCategoryId),
      twitchCategoryName: Value(twitchCategoryName),
      verificationCount: Value(verificationCount),
      lastVerified: lastVerified == null && nullToAbsent
          ? const Value.absent()
          : Value(lastVerified),
      source: Value(source),
      syncedAt: Value(syncedAt),
    );
  }

  factory CommunityMappingEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommunityMappingEntity(
      id: serializer.fromJson<int>(json['id']),
      processName: serializer.fromJson<String>(json['processName']),
      normalizedInstallPaths: serializer.fromJson<String?>(
        json['normalizedInstallPaths'],
      ),
      twitchCategoryId: serializer.fromJson<String>(json['twitchCategoryId']),
      twitchCategoryName: serializer.fromJson<String>(
        json['twitchCategoryName'],
      ),
      verificationCount: serializer.fromJson<int>(json['verificationCount']),
      lastVerified: serializer.fromJson<DateTime?>(json['lastVerified']),
      source: serializer.fromJson<String>(json['source']),
      syncedAt: serializer.fromJson<DateTime>(json['syncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'processName': serializer.toJson<String>(processName),
      'normalizedInstallPaths': serializer.toJson<String?>(
        normalizedInstallPaths,
      ),
      'twitchCategoryId': serializer.toJson<String>(twitchCategoryId),
      'twitchCategoryName': serializer.toJson<String>(twitchCategoryName),
      'verificationCount': serializer.toJson<int>(verificationCount),
      'lastVerified': serializer.toJson<DateTime?>(lastVerified),
      'source': serializer.toJson<String>(source),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  CommunityMappingEntity copyWith({
    int? id,
    String? processName,
    Value<String?> normalizedInstallPaths = const Value.absent(),
    String? twitchCategoryId,
    String? twitchCategoryName,
    int? verificationCount,
    Value<DateTime?> lastVerified = const Value.absent(),
    String? source,
    DateTime? syncedAt,
  }) => CommunityMappingEntity(
    id: id ?? this.id,
    processName: processName ?? this.processName,
    normalizedInstallPaths: normalizedInstallPaths.present
        ? normalizedInstallPaths.value
        : this.normalizedInstallPaths,
    twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
    twitchCategoryName: twitchCategoryName ?? this.twitchCategoryName,
    verificationCount: verificationCount ?? this.verificationCount,
    lastVerified: lastVerified.present ? lastVerified.value : this.lastVerified,
    source: source ?? this.source,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  CommunityMappingEntity copyWithCompanion(CommunityMappingsCompanion data) {
    return CommunityMappingEntity(
      id: data.id.present ? data.id.value : this.id,
      processName: data.processName.present
          ? data.processName.value
          : this.processName,
      normalizedInstallPaths: data.normalizedInstallPaths.present
          ? data.normalizedInstallPaths.value
          : this.normalizedInstallPaths,
      twitchCategoryId: data.twitchCategoryId.present
          ? data.twitchCategoryId.value
          : this.twitchCategoryId,
      twitchCategoryName: data.twitchCategoryName.present
          ? data.twitchCategoryName.value
          : this.twitchCategoryName,
      verificationCount: data.verificationCount.present
          ? data.verificationCount.value
          : this.verificationCount,
      lastVerified: data.lastVerified.present
          ? data.lastVerified.value
          : this.lastVerified,
      source: data.source.present ? data.source.value : this.source,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommunityMappingEntity(')
          ..write('id: $id, ')
          ..write('processName: $processName, ')
          ..write('normalizedInstallPaths: $normalizedInstallPaths, ')
          ..write('twitchCategoryId: $twitchCategoryId, ')
          ..write('twitchCategoryName: $twitchCategoryName, ')
          ..write('verificationCount: $verificationCount, ')
          ..write('lastVerified: $lastVerified, ')
          ..write('source: $source, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    processName,
    normalizedInstallPaths,
    twitchCategoryId,
    twitchCategoryName,
    verificationCount,
    lastVerified,
    source,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommunityMappingEntity &&
          other.id == this.id &&
          other.processName == this.processName &&
          other.normalizedInstallPaths == this.normalizedInstallPaths &&
          other.twitchCategoryId == this.twitchCategoryId &&
          other.twitchCategoryName == this.twitchCategoryName &&
          other.verificationCount == this.verificationCount &&
          other.lastVerified == this.lastVerified &&
          other.source == this.source &&
          other.syncedAt == this.syncedAt);
}

class CommunityMappingsCompanion
    extends UpdateCompanion<CommunityMappingEntity> {
  final Value<int> id;
  final Value<String> processName;
  final Value<String?> normalizedInstallPaths;
  final Value<String> twitchCategoryId;
  final Value<String> twitchCategoryName;
  final Value<int> verificationCount;
  final Value<DateTime?> lastVerified;
  final Value<String> source;
  final Value<DateTime> syncedAt;
  const CommunityMappingsCompanion({
    this.id = const Value.absent(),
    this.processName = const Value.absent(),
    this.normalizedInstallPaths = const Value.absent(),
    this.twitchCategoryId = const Value.absent(),
    this.twitchCategoryName = const Value.absent(),
    this.verificationCount = const Value.absent(),
    this.lastVerified = const Value.absent(),
    this.source = const Value.absent(),
    this.syncedAt = const Value.absent(),
  });
  CommunityMappingsCompanion.insert({
    this.id = const Value.absent(),
    required String processName,
    this.normalizedInstallPaths = const Value.absent(),
    required String twitchCategoryId,
    required String twitchCategoryName,
    this.verificationCount = const Value.absent(),
    this.lastVerified = const Value.absent(),
    this.source = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : processName = Value(processName),
       twitchCategoryId = Value(twitchCategoryId),
       twitchCategoryName = Value(twitchCategoryName);
  static Insertable<CommunityMappingEntity> custom({
    Expression<int>? id,
    Expression<String>? processName,
    Expression<String>? normalizedInstallPaths,
    Expression<String>? twitchCategoryId,
    Expression<String>? twitchCategoryName,
    Expression<int>? verificationCount,
    Expression<DateTime>? lastVerified,
    Expression<String>? source,
    Expression<DateTime>? syncedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (processName != null) 'process_name': processName,
      if (normalizedInstallPaths != null)
        'normalized_install_paths': normalizedInstallPaths,
      if (twitchCategoryId != null) 'twitch_category_id': twitchCategoryId,
      if (twitchCategoryName != null)
        'twitch_category_name': twitchCategoryName,
      if (verificationCount != null) 'verification_count': verificationCount,
      if (lastVerified != null) 'last_verified': lastVerified,
      if (source != null) 'source': source,
      if (syncedAt != null) 'synced_at': syncedAt,
    });
  }

  CommunityMappingsCompanion copyWith({
    Value<int>? id,
    Value<String>? processName,
    Value<String?>? normalizedInstallPaths,
    Value<String>? twitchCategoryId,
    Value<String>? twitchCategoryName,
    Value<int>? verificationCount,
    Value<DateTime?>? lastVerified,
    Value<String>? source,
    Value<DateTime>? syncedAt,
  }) {
    return CommunityMappingsCompanion(
      id: id ?? this.id,
      processName: processName ?? this.processName,
      normalizedInstallPaths:
          normalizedInstallPaths ?? this.normalizedInstallPaths,
      twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
      twitchCategoryName: twitchCategoryName ?? this.twitchCategoryName,
      verificationCount: verificationCount ?? this.verificationCount,
      lastVerified: lastVerified ?? this.lastVerified,
      source: source ?? this.source,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (processName.present) {
      map['process_name'] = Variable<String>(processName.value);
    }
    if (normalizedInstallPaths.present) {
      map['normalized_install_paths'] = Variable<String>(
        normalizedInstallPaths.value,
      );
    }
    if (twitchCategoryId.present) {
      map['twitch_category_id'] = Variable<String>(twitchCategoryId.value);
    }
    if (twitchCategoryName.present) {
      map['twitch_category_name'] = Variable<String>(twitchCategoryName.value);
    }
    if (verificationCount.present) {
      map['verification_count'] = Variable<int>(verificationCount.value);
    }
    if (lastVerified.present) {
      map['last_verified'] = Variable<DateTime>(lastVerified.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (syncedAt.present) {
      map['synced_at'] = Variable<DateTime>(syncedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CommunityMappingsCompanion(')
          ..write('id: $id, ')
          ..write('processName: $processName, ')
          ..write('normalizedInstallPaths: $normalizedInstallPaths, ')
          ..write('twitchCategoryId: $twitchCategoryId, ')
          ..write('twitchCategoryName: $twitchCategoryName, ')
          ..write('verificationCount: $verificationCount, ')
          ..write('lastVerified: $lastVerified, ')
          ..write('source: $source, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoryMappingsTable categoryMappings = $CategoryMappingsTable(
    this,
  );
  late final $UpdateHistoryTable updateHistory = $UpdateHistoryTable(this);
  late final $UnknownProcessesTable unknownProcesses = $UnknownProcessesTable(
    this,
  );
  late final $TopGamesCacheTable topGamesCache = $TopGamesCacheTable(this);
  late final $CommunityMappingsTable communityMappings =
      $CommunityMappingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categoryMappings,
    updateHistory,
    unknownProcesses,
    topGamesCache,
    communityMappings,
  ];
}

typedef $$CategoryMappingsTableCreateCompanionBuilder =
    CategoryMappingsCompanion Function({
      Value<int> id,
      required String processName,
      Value<String?> executablePath,
      Value<String?> normalizedInstallPaths,
      required String twitchCategoryId,
      required String twitchCategoryName,
      Value<DateTime> createdAt,
      Value<DateTime?> lastUsedAt,
      Value<DateTime> lastApiFetch,
      required DateTime cacheExpiresAt,
      Value<bool> manualOverride,
      Value<bool> isEnabled,
    });
typedef $$CategoryMappingsTableUpdateCompanionBuilder =
    CategoryMappingsCompanion Function({
      Value<int> id,
      Value<String> processName,
      Value<String?> executablePath,
      Value<String?> normalizedInstallPaths,
      Value<String> twitchCategoryId,
      Value<String> twitchCategoryName,
      Value<DateTime> createdAt,
      Value<DateTime?> lastUsedAt,
      Value<DateTime> lastApiFetch,
      Value<DateTime> cacheExpiresAt,
      Value<bool> manualOverride,
      Value<bool> isEnabled,
    });

class $$CategoryMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryMappingsTable> {
  $$CategoryMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processName => $composableBuilder(
    column: $table.processName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get executablePath => $composableBuilder(
    column: $table.executablePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedInstallPaths => $composableBuilder(
    column: $table.normalizedInstallPaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get twitchCategoryId => $composableBuilder(
    column: $table.twitchCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get twitchCategoryName => $composableBuilder(
    column: $table.twitchCategoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastApiFetch => $composableBuilder(
    column: $table.lastApiFetch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cacheExpiresAt => $composableBuilder(
    column: $table.cacheExpiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get manualOverride => $composableBuilder(
    column: $table.manualOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoryMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryMappingsTable> {
  $$CategoryMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processName => $composableBuilder(
    column: $table.processName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get executablePath => $composableBuilder(
    column: $table.executablePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedInstallPaths => $composableBuilder(
    column: $table.normalizedInstallPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get twitchCategoryId => $composableBuilder(
    column: $table.twitchCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get twitchCategoryName => $composableBuilder(
    column: $table.twitchCategoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastApiFetch => $composableBuilder(
    column: $table.lastApiFetch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cacheExpiresAt => $composableBuilder(
    column: $table.cacheExpiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get manualOverride => $composableBuilder(
    column: $table.manualOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEnabled => $composableBuilder(
    column: $table.isEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoryMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryMappingsTable> {
  $$CategoryMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get processName => $composableBuilder(
    column: $table.processName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get executablePath => $composableBuilder(
    column: $table.executablePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedInstallPaths => $composableBuilder(
    column: $table.normalizedInstallPaths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get twitchCategoryId => $composableBuilder(
    column: $table.twitchCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get twitchCategoryName => $composableBuilder(
    column: $table.twitchCategoryName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUsedAt => $composableBuilder(
    column: $table.lastUsedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastApiFetch => $composableBuilder(
    column: $table.lastApiFetch,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cacheExpiresAt => $composableBuilder(
    column: $table.cacheExpiresAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get manualOverride => $composableBuilder(
    column: $table.manualOverride,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEnabled =>
      $composableBuilder(column: $table.isEnabled, builder: (column) => column);
}

class $$CategoryMappingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryMappingsTable,
          CategoryMappingEntity,
          $$CategoryMappingsTableFilterComposer,
          $$CategoryMappingsTableOrderingComposer,
          $$CategoryMappingsTableAnnotationComposer,
          $$CategoryMappingsTableCreateCompanionBuilder,
          $$CategoryMappingsTableUpdateCompanionBuilder,
          (
            CategoryMappingEntity,
            BaseReferences<
              _$AppDatabase,
              $CategoryMappingsTable,
              CategoryMappingEntity
            >,
          ),
          CategoryMappingEntity,
          PrefetchHooks Function()
        > {
  $$CategoryMappingsTableTableManager(
    _$AppDatabase db,
    $CategoryMappingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryMappingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> processName = const Value.absent(),
                Value<String?> executablePath = const Value.absent(),
                Value<String?> normalizedInstallPaths = const Value.absent(),
                Value<String> twitchCategoryId = const Value.absent(),
                Value<String> twitchCategoryName = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime> lastApiFetch = const Value.absent(),
                Value<DateTime> cacheExpiresAt = const Value.absent(),
                Value<bool> manualOverride = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
              }) => CategoryMappingsCompanion(
                id: id,
                processName: processName,
                executablePath: executablePath,
                normalizedInstallPaths: normalizedInstallPaths,
                twitchCategoryId: twitchCategoryId,
                twitchCategoryName: twitchCategoryName,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
                lastApiFetch: lastApiFetch,
                cacheExpiresAt: cacheExpiresAt,
                manualOverride: manualOverride,
                isEnabled: isEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String processName,
                Value<String?> executablePath = const Value.absent(),
                Value<String?> normalizedInstallPaths = const Value.absent(),
                required String twitchCategoryId,
                required String twitchCategoryName,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> lastUsedAt = const Value.absent(),
                Value<DateTime> lastApiFetch = const Value.absent(),
                required DateTime cacheExpiresAt,
                Value<bool> manualOverride = const Value.absent(),
                Value<bool> isEnabled = const Value.absent(),
              }) => CategoryMappingsCompanion.insert(
                id: id,
                processName: processName,
                executablePath: executablePath,
                normalizedInstallPaths: normalizedInstallPaths,
                twitchCategoryId: twitchCategoryId,
                twitchCategoryName: twitchCategoryName,
                createdAt: createdAt,
                lastUsedAt: lastUsedAt,
                lastApiFetch: lastApiFetch,
                cacheExpiresAt: cacheExpiresAt,
                manualOverride: manualOverride,
                isEnabled: isEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoryMappingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryMappingsTable,
      CategoryMappingEntity,
      $$CategoryMappingsTableFilterComposer,
      $$CategoryMappingsTableOrderingComposer,
      $$CategoryMappingsTableAnnotationComposer,
      $$CategoryMappingsTableCreateCompanionBuilder,
      $$CategoryMappingsTableUpdateCompanionBuilder,
      (
        CategoryMappingEntity,
        BaseReferences<
          _$AppDatabase,
          $CategoryMappingsTable,
          CategoryMappingEntity
        >,
      ),
      CategoryMappingEntity,
      PrefetchHooks Function()
    >;
typedef $$UpdateHistoryTableCreateCompanionBuilder =
    UpdateHistoryCompanion Function({
      Value<int> id,
      required String processName,
      required String categoryId,
      required String categoryName,
      required bool success,
      Value<String?> errorMessage,
      Value<DateTime> updatedAt,
    });
typedef $$UpdateHistoryTableUpdateCompanionBuilder =
    UpdateHistoryCompanion Function({
      Value<int> id,
      Value<String> processName,
      Value<String> categoryId,
      Value<String> categoryName,
      Value<bool> success,
      Value<String?> errorMessage,
      Value<DateTime> updatedAt,
    });

class $$UpdateHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $UpdateHistoryTable> {
  $$UpdateHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processName => $composableBuilder(
    column: $table.processName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UpdateHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $UpdateHistoryTable> {
  $$UpdateHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processName => $composableBuilder(
    column: $table.processName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get success => $composableBuilder(
    column: $table.success,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UpdateHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $UpdateHistoryTable> {
  $$UpdateHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get processName => $composableBuilder(
    column: $table.processName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get categoryName => $composableBuilder(
    column: $table.categoryName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get success =>
      $composableBuilder(column: $table.success, builder: (column) => column);

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UpdateHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UpdateHistoryTable,
          UpdateHistoryEntity,
          $$UpdateHistoryTableFilterComposer,
          $$UpdateHistoryTableOrderingComposer,
          $$UpdateHistoryTableAnnotationComposer,
          $$UpdateHistoryTableCreateCompanionBuilder,
          $$UpdateHistoryTableUpdateCompanionBuilder,
          (
            UpdateHistoryEntity,
            BaseReferences<
              _$AppDatabase,
              $UpdateHistoryTable,
              UpdateHistoryEntity
            >,
          ),
          UpdateHistoryEntity,
          PrefetchHooks Function()
        > {
  $$UpdateHistoryTableTableManager(_$AppDatabase db, $UpdateHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UpdateHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UpdateHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UpdateHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> processName = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> categoryName = const Value.absent(),
                Value<bool> success = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UpdateHistoryCompanion(
                id: id,
                processName: processName,
                categoryId: categoryId,
                categoryName: categoryName,
                success: success,
                errorMessage: errorMessage,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String processName,
                required String categoryId,
                required String categoryName,
                required bool success,
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UpdateHistoryCompanion.insert(
                id: id,
                processName: processName,
                categoryId: categoryId,
                categoryName: categoryName,
                success: success,
                errorMessage: errorMessage,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UpdateHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UpdateHistoryTable,
      UpdateHistoryEntity,
      $$UpdateHistoryTableFilterComposer,
      $$UpdateHistoryTableOrderingComposer,
      $$UpdateHistoryTableAnnotationComposer,
      $$UpdateHistoryTableCreateCompanionBuilder,
      $$UpdateHistoryTableUpdateCompanionBuilder,
      (
        UpdateHistoryEntity,
        BaseReferences<_$AppDatabase, $UpdateHistoryTable, UpdateHistoryEntity>,
      ),
      UpdateHistoryEntity,
      PrefetchHooks Function()
    >;
typedef $$UnknownProcessesTableCreateCompanionBuilder =
    UnknownProcessesCompanion Function({
      Value<int> id,
      required String executableName,
      Value<String?> windowTitle,
      Value<DateTime> firstDetected,
      Value<int> occurrenceCount,
      Value<bool> resolved,
    });
typedef $$UnknownProcessesTableUpdateCompanionBuilder =
    UnknownProcessesCompanion Function({
      Value<int> id,
      Value<String> executableName,
      Value<String?> windowTitle,
      Value<DateTime> firstDetected,
      Value<int> occurrenceCount,
      Value<bool> resolved,
    });

class $$UnknownProcessesTableFilterComposer
    extends Composer<_$AppDatabase, $UnknownProcessesTable> {
  $$UnknownProcessesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get executableName => $composableBuilder(
    column: $table.executableName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get windowTitle => $composableBuilder(
    column: $table.windowTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstDetected => $composableBuilder(
    column: $table.firstDetected,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnknownProcessesTableOrderingComposer
    extends Composer<_$AppDatabase, $UnknownProcessesTable> {
  $$UnknownProcessesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get executableName => $composableBuilder(
    column: $table.executableName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get windowTitle => $composableBuilder(
    column: $table.windowTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstDetected => $composableBuilder(
    column: $table.firstDetected,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get resolved => $composableBuilder(
    column: $table.resolved,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnknownProcessesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnknownProcessesTable> {
  $$UnknownProcessesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get executableName => $composableBuilder(
    column: $table.executableName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get windowTitle => $composableBuilder(
    column: $table.windowTitle,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get firstDetected => $composableBuilder(
    column: $table.firstDetected,
    builder: (column) => column,
  );

  GeneratedColumn<int> get occurrenceCount => $composableBuilder(
    column: $table.occurrenceCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get resolved =>
      $composableBuilder(column: $table.resolved, builder: (column) => column);
}

class $$UnknownProcessesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnknownProcessesTable,
          UnknownProcessEntity,
          $$UnknownProcessesTableFilterComposer,
          $$UnknownProcessesTableOrderingComposer,
          $$UnknownProcessesTableAnnotationComposer,
          $$UnknownProcessesTableCreateCompanionBuilder,
          $$UnknownProcessesTableUpdateCompanionBuilder,
          (
            UnknownProcessEntity,
            BaseReferences<
              _$AppDatabase,
              $UnknownProcessesTable,
              UnknownProcessEntity
            >,
          ),
          UnknownProcessEntity,
          PrefetchHooks Function()
        > {
  $$UnknownProcessesTableTableManager(
    _$AppDatabase db,
    $UnknownProcessesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnknownProcessesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnknownProcessesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnknownProcessesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> executableName = const Value.absent(),
                Value<String?> windowTitle = const Value.absent(),
                Value<DateTime> firstDetected = const Value.absent(),
                Value<int> occurrenceCount = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
              }) => UnknownProcessesCompanion(
                id: id,
                executableName: executableName,
                windowTitle: windowTitle,
                firstDetected: firstDetected,
                occurrenceCount: occurrenceCount,
                resolved: resolved,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String executableName,
                Value<String?> windowTitle = const Value.absent(),
                Value<DateTime> firstDetected = const Value.absent(),
                Value<int> occurrenceCount = const Value.absent(),
                Value<bool> resolved = const Value.absent(),
              }) => UnknownProcessesCompanion.insert(
                id: id,
                executableName: executableName,
                windowTitle: windowTitle,
                firstDetected: firstDetected,
                occurrenceCount: occurrenceCount,
                resolved: resolved,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnknownProcessesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnknownProcessesTable,
      UnknownProcessEntity,
      $$UnknownProcessesTableFilterComposer,
      $$UnknownProcessesTableOrderingComposer,
      $$UnknownProcessesTableAnnotationComposer,
      $$UnknownProcessesTableCreateCompanionBuilder,
      $$UnknownProcessesTableUpdateCompanionBuilder,
      (
        UnknownProcessEntity,
        BaseReferences<
          _$AppDatabase,
          $UnknownProcessesTable,
          UnknownProcessEntity
        >,
      ),
      UnknownProcessEntity,
      PrefetchHooks Function()
    >;
typedef $$TopGamesCacheTableCreateCompanionBuilder =
    TopGamesCacheCompanion Function({
      required String twitchCategoryId,
      required String gameName,
      Value<String?> boxArtUrl,
      Value<DateTime> lastUpdated,
      required DateTime expiresAt,
      Value<int> rowid,
    });
typedef $$TopGamesCacheTableUpdateCompanionBuilder =
    TopGamesCacheCompanion Function({
      Value<String> twitchCategoryId,
      Value<String> gameName,
      Value<String?> boxArtUrl,
      Value<DateTime> lastUpdated,
      Value<DateTime> expiresAt,
      Value<int> rowid,
    });

class $$TopGamesCacheTableFilterComposer
    extends Composer<_$AppDatabase, $TopGamesCacheTable> {
  $$TopGamesCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get twitchCategoryId => $composableBuilder(
    column: $table.twitchCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gameName => $composableBuilder(
    column: $table.gameName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get boxArtUrl => $composableBuilder(
    column: $table.boxArtUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TopGamesCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $TopGamesCacheTable> {
  $$TopGamesCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get twitchCategoryId => $composableBuilder(
    column: $table.twitchCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gameName => $composableBuilder(
    column: $table.gameName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get boxArtUrl => $composableBuilder(
    column: $table.boxArtUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TopGamesCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $TopGamesCacheTable> {
  $$TopGamesCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get twitchCategoryId => $composableBuilder(
    column: $table.twitchCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gameName =>
      $composableBuilder(column: $table.gameName, builder: (column) => column);

  GeneratedColumn<String> get boxArtUrl =>
      $composableBuilder(column: $table.boxArtUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);
}

class $$TopGamesCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TopGamesCacheTable,
          TopGameEntity,
          $$TopGamesCacheTableFilterComposer,
          $$TopGamesCacheTableOrderingComposer,
          $$TopGamesCacheTableAnnotationComposer,
          $$TopGamesCacheTableCreateCompanionBuilder,
          $$TopGamesCacheTableUpdateCompanionBuilder,
          (
            TopGameEntity,
            BaseReferences<_$AppDatabase, $TopGamesCacheTable, TopGameEntity>,
          ),
          TopGameEntity,
          PrefetchHooks Function()
        > {
  $$TopGamesCacheTableTableManager(_$AppDatabase db, $TopGamesCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TopGamesCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TopGamesCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TopGamesCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> twitchCategoryId = const Value.absent(),
                Value<String> gameName = const Value.absent(),
                Value<String?> boxArtUrl = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TopGamesCacheCompanion(
                twitchCategoryId: twitchCategoryId,
                gameName: gameName,
                boxArtUrl: boxArtUrl,
                lastUpdated: lastUpdated,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String twitchCategoryId,
                required String gameName,
                Value<String?> boxArtUrl = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                required DateTime expiresAt,
                Value<int> rowid = const Value.absent(),
              }) => TopGamesCacheCompanion.insert(
                twitchCategoryId: twitchCategoryId,
                gameName: gameName,
                boxArtUrl: boxArtUrl,
                lastUpdated: lastUpdated,
                expiresAt: expiresAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TopGamesCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TopGamesCacheTable,
      TopGameEntity,
      $$TopGamesCacheTableFilterComposer,
      $$TopGamesCacheTableOrderingComposer,
      $$TopGamesCacheTableAnnotationComposer,
      $$TopGamesCacheTableCreateCompanionBuilder,
      $$TopGamesCacheTableUpdateCompanionBuilder,
      (
        TopGameEntity,
        BaseReferences<_$AppDatabase, $TopGamesCacheTable, TopGameEntity>,
      ),
      TopGameEntity,
      PrefetchHooks Function()
    >;
typedef $$CommunityMappingsTableCreateCompanionBuilder =
    CommunityMappingsCompanion Function({
      Value<int> id,
      required String processName,
      Value<String?> normalizedInstallPaths,
      required String twitchCategoryId,
      required String twitchCategoryName,
      Value<int> verificationCount,
      Value<DateTime?> lastVerified,
      Value<String> source,
      Value<DateTime> syncedAt,
    });
typedef $$CommunityMappingsTableUpdateCompanionBuilder =
    CommunityMappingsCompanion Function({
      Value<int> id,
      Value<String> processName,
      Value<String?> normalizedInstallPaths,
      Value<String> twitchCategoryId,
      Value<String> twitchCategoryName,
      Value<int> verificationCount,
      Value<DateTime?> lastVerified,
      Value<String> source,
      Value<DateTime> syncedAt,
    });

class $$CommunityMappingsTableFilterComposer
    extends Composer<_$AppDatabase, $CommunityMappingsTable> {
  $$CommunityMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get processName => $composableBuilder(
    column: $table.processName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalizedInstallPaths => $composableBuilder(
    column: $table.normalizedInstallPaths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get twitchCategoryId => $composableBuilder(
    column: $table.twitchCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get twitchCategoryName => $composableBuilder(
    column: $table.twitchCategoryName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get verificationCount => $composableBuilder(
    column: $table.verificationCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastVerified => $composableBuilder(
    column: $table.lastVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CommunityMappingsTableOrderingComposer
    extends Composer<_$AppDatabase, $CommunityMappingsTable> {
  $$CommunityMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get processName => $composableBuilder(
    column: $table.processName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalizedInstallPaths => $composableBuilder(
    column: $table.normalizedInstallPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get twitchCategoryId => $composableBuilder(
    column: $table.twitchCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get twitchCategoryName => $composableBuilder(
    column: $table.twitchCategoryName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get verificationCount => $composableBuilder(
    column: $table.verificationCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastVerified => $composableBuilder(
    column: $table.lastVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncedAt => $composableBuilder(
    column: $table.syncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CommunityMappingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CommunityMappingsTable> {
  $$CommunityMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get processName => $composableBuilder(
    column: $table.processName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get normalizedInstallPaths => $composableBuilder(
    column: $table.normalizedInstallPaths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get twitchCategoryId => $composableBuilder(
    column: $table.twitchCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get twitchCategoryName => $composableBuilder(
    column: $table.twitchCategoryName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get verificationCount => $composableBuilder(
    column: $table.verificationCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastVerified => $composableBuilder(
    column: $table.lastVerified,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<DateTime> get syncedAt =>
      $composableBuilder(column: $table.syncedAt, builder: (column) => column);
}

class $$CommunityMappingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CommunityMappingsTable,
          CommunityMappingEntity,
          $$CommunityMappingsTableFilterComposer,
          $$CommunityMappingsTableOrderingComposer,
          $$CommunityMappingsTableAnnotationComposer,
          $$CommunityMappingsTableCreateCompanionBuilder,
          $$CommunityMappingsTableUpdateCompanionBuilder,
          (
            CommunityMappingEntity,
            BaseReferences<
              _$AppDatabase,
              $CommunityMappingsTable,
              CommunityMappingEntity
            >,
          ),
          CommunityMappingEntity,
          PrefetchHooks Function()
        > {
  $$CommunityMappingsTableTableManager(
    _$AppDatabase db,
    $CommunityMappingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CommunityMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CommunityMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CommunityMappingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> processName = const Value.absent(),
                Value<String?> normalizedInstallPaths = const Value.absent(),
                Value<String> twitchCategoryId = const Value.absent(),
                Value<String> twitchCategoryName = const Value.absent(),
                Value<int> verificationCount = const Value.absent(),
                Value<DateTime?> lastVerified = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => CommunityMappingsCompanion(
                id: id,
                processName: processName,
                normalizedInstallPaths: normalizedInstallPaths,
                twitchCategoryId: twitchCategoryId,
                twitchCategoryName: twitchCategoryName,
                verificationCount: verificationCount,
                lastVerified: lastVerified,
                source: source,
                syncedAt: syncedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String processName,
                Value<String?> normalizedInstallPaths = const Value.absent(),
                required String twitchCategoryId,
                required String twitchCategoryName,
                Value<int> verificationCount = const Value.absent(),
                Value<DateTime?> lastVerified = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<DateTime> syncedAt = const Value.absent(),
              }) => CommunityMappingsCompanion.insert(
                id: id,
                processName: processName,
                normalizedInstallPaths: normalizedInstallPaths,
                twitchCategoryId: twitchCategoryId,
                twitchCategoryName: twitchCategoryName,
                verificationCount: verificationCount,
                lastVerified: lastVerified,
                source: source,
                syncedAt: syncedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CommunityMappingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CommunityMappingsTable,
      CommunityMappingEntity,
      $$CommunityMappingsTableFilterComposer,
      $$CommunityMappingsTableOrderingComposer,
      $$CommunityMappingsTableAnnotationComposer,
      $$CommunityMappingsTableCreateCompanionBuilder,
      $$CommunityMappingsTableUpdateCompanionBuilder,
      (
        CommunityMappingEntity,
        BaseReferences<
          _$AppDatabase,
          $CommunityMappingsTable,
          CommunityMappingEntity
        >,
      ),
      CommunityMappingEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoryMappingsTableTableManager get categoryMappings =>
      $$CategoryMappingsTableTableManager(_db, _db.categoryMappings);
  $$UpdateHistoryTableTableManager get updateHistory =>
      $$UpdateHistoryTableTableManager(_db, _db.updateHistory);
  $$UnknownProcessesTableTableManager get unknownProcesses =>
      $$UnknownProcessesTableTableManager(_db, _db.unknownProcesses);
  $$TopGamesCacheTableTableManager get topGamesCache =>
      $$TopGamesCacheTableTableManager(_db, _db.topGamesCache);
  $$CommunityMappingsTableTableManager get communityMappings =>
      $$CommunityMappingsTableTableManager(_db, _db.communityMappings);
}
