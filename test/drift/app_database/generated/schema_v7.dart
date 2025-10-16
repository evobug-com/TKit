// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class CategoryMappings extends Table
    with TableInfo<CategoryMappings, CategoryMappingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CategoryMappings(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> processName = GeneratedColumn<String>(
    'process_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> executablePath = GeneratedColumn<String>(
    'executable_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> normalizedInstallPaths =
      GeneratedColumn<String>(
        'normalized_install_paths',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<String> twitchCategoryId = GeneratedColumn<String>(
    'twitch_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> twitchCategoryName =
      GeneratedColumn<String>(
        'twitch_category_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
  );
  late final GeneratedColumn<DateTime> lastUsedAt = GeneratedColumn<DateTime>(
    'last_used_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> lastApiFetch = GeneratedColumn<DateTime>(
    'last_api_fetch',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
  );
  late final GeneratedColumn<DateTime> cacheExpiresAt =
      GeneratedColumn<DateTime>(
        'cache_expires_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<bool> manualOverride = GeneratedColumn<bool>(
    'manual_override',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("manual_override" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('1'),
  );
  late final GeneratedColumn<bool> pendingSubmission = GeneratedColumn<bool>(
    'pending_submission',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pending_submission" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<String> listId = GeneratedColumn<String>(
    'list_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    pendingSubmission,
    listId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_mappings';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryMappingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryMappingsData(
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
      pendingSubmission: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pending_submission'],
      )!,
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}list_id'],
      ),
    );
  }

  @override
  CategoryMappings createAlias(String alias) {
    return CategoryMappings(attachedDatabase, alias);
  }
}

class CategoryMappingsData extends DataClass
    implements Insertable<CategoryMappingsData> {
  final int id;
  final String processName;
  final String? executablePath;
  final String? normalizedInstallPaths;
  final String twitchCategoryId;
  final String twitchCategoryName;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final DateTime lastApiFetch;
  final DateTime cacheExpiresAt;
  final bool manualOverride;
  final bool isEnabled;
  final bool pendingSubmission;
  final String? listId;
  const CategoryMappingsData({
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
    required this.pendingSubmission,
    this.listId,
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
    map['pending_submission'] = Variable<bool>(pendingSubmission);
    if (!nullToAbsent || listId != null) {
      map['list_id'] = Variable<String>(listId);
    }
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
      pendingSubmission: Value(pendingSubmission),
      listId: listId == null && nullToAbsent
          ? const Value.absent()
          : Value(listId),
    );
  }

  factory CategoryMappingsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryMappingsData(
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
      pendingSubmission: serializer.fromJson<bool>(json['pendingSubmission']),
      listId: serializer.fromJson<String?>(json['listId']),
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
      'pendingSubmission': serializer.toJson<bool>(pendingSubmission),
      'listId': serializer.toJson<String?>(listId),
    };
  }

  CategoryMappingsData copyWith({
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
    bool? pendingSubmission,
    Value<String?> listId = const Value.absent(),
  }) => CategoryMappingsData(
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
    pendingSubmission: pendingSubmission ?? this.pendingSubmission,
    listId: listId.present ? listId.value : this.listId,
  );
  CategoryMappingsData copyWithCompanion(CategoryMappingsCompanion data) {
    return CategoryMappingsData(
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
      pendingSubmission: data.pendingSubmission.present
          ? data.pendingSubmission.value
          : this.pendingSubmission,
      listId: data.listId.present ? data.listId.value : this.listId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryMappingsData(')
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
          ..write('isEnabled: $isEnabled, ')
          ..write('pendingSubmission: $pendingSubmission, ')
          ..write('listId: $listId')
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
    pendingSubmission,
    listId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryMappingsData &&
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
          other.isEnabled == this.isEnabled &&
          other.pendingSubmission == this.pendingSubmission &&
          other.listId == this.listId);
}

class CategoryMappingsCompanion extends UpdateCompanion<CategoryMappingsData> {
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
  final Value<bool> pendingSubmission;
  final Value<String?> listId;
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
    this.pendingSubmission = const Value.absent(),
    this.listId = const Value.absent(),
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
    this.pendingSubmission = const Value.absent(),
    this.listId = const Value.absent(),
  }) : processName = Value(processName),
       twitchCategoryId = Value(twitchCategoryId),
       twitchCategoryName = Value(twitchCategoryName),
       cacheExpiresAt = Value(cacheExpiresAt);
  static Insertable<CategoryMappingsData> custom({
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
    Expression<bool>? pendingSubmission,
    Expression<String>? listId,
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
      if (pendingSubmission != null) 'pending_submission': pendingSubmission,
      if (listId != null) 'list_id': listId,
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
    Value<bool>? pendingSubmission,
    Value<String?>? listId,
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
      pendingSubmission: pendingSubmission ?? this.pendingSubmission,
      listId: listId ?? this.listId,
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
    if (pendingSubmission.present) {
      map['pending_submission'] = Variable<bool>(pendingSubmission.value);
    }
    if (listId.present) {
      map['list_id'] = Variable<String>(listId.value);
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
          ..write('isEnabled: $isEnabled, ')
          ..write('pendingSubmission: $pendingSubmission, ')
          ..write('listId: $listId')
          ..write(')'))
        .toString();
  }
}

class UpdateHistory extends Table
    with TableInfo<UpdateHistory, UpdateHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UpdateHistory(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> processName = GeneratedColumn<String>(
    'process_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> categoryName = GeneratedColumn<String>(
    'category_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
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
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UpdateHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UpdateHistoryData(
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
  UpdateHistory createAlias(String alias) {
    return UpdateHistory(attachedDatabase, alias);
  }
}

class UpdateHistoryData extends DataClass
    implements Insertable<UpdateHistoryData> {
  final int id;
  final String processName;
  final String categoryId;
  final String categoryName;
  final bool success;
  final String? errorMessage;
  final DateTime updatedAt;
  const UpdateHistoryData({
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

  factory UpdateHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UpdateHistoryData(
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

  UpdateHistoryData copyWith({
    int? id,
    String? processName,
    String? categoryId,
    String? categoryName,
    bool? success,
    Value<String?> errorMessage = const Value.absent(),
    DateTime? updatedAt,
  }) => UpdateHistoryData(
    id: id ?? this.id,
    processName: processName ?? this.processName,
    categoryId: categoryId ?? this.categoryId,
    categoryName: categoryName ?? this.categoryName,
    success: success ?? this.success,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UpdateHistoryData copyWithCompanion(UpdateHistoryCompanion data) {
    return UpdateHistoryData(
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
    return (StringBuffer('UpdateHistoryData(')
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
      (other is UpdateHistoryData &&
          other.id == this.id &&
          other.processName == this.processName &&
          other.categoryId == this.categoryId &&
          other.categoryName == this.categoryName &&
          other.success == this.success &&
          other.errorMessage == this.errorMessage &&
          other.updatedAt == this.updatedAt);
}

class UpdateHistoryCompanion extends UpdateCompanion<UpdateHistoryData> {
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
  static Insertable<UpdateHistoryData> custom({
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

class UnknownProcesses extends Table
    with TableInfo<UnknownProcesses, UnknownProcessesData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  UnknownProcesses(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> executableName = GeneratedColumn<String>(
    'executable_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> windowTitle = GeneratedColumn<String>(
    'window_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> firstDetected =
      GeneratedColumn<DateTime>(
        'first_detected',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
        defaultValue: const CustomExpression(
          'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
        ),
      );
  late final GeneratedColumn<int> occurrenceCount = GeneratedColumn<int>(
    'occurrence_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('1'),
  );
  late final GeneratedColumn<bool> resolved = GeneratedColumn<bool>(
    'resolved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("resolved" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
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
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnknownProcessesData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnknownProcessesData(
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
  UnknownProcesses createAlias(String alias) {
    return UnknownProcesses(attachedDatabase, alias);
  }
}

class UnknownProcessesData extends DataClass
    implements Insertable<UnknownProcessesData> {
  final int id;
  final String executableName;
  final String? windowTitle;
  final DateTime firstDetected;
  final int occurrenceCount;
  final bool resolved;
  const UnknownProcessesData({
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

  factory UnknownProcessesData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnknownProcessesData(
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

  UnknownProcessesData copyWith({
    int? id,
    String? executableName,
    Value<String?> windowTitle = const Value.absent(),
    DateTime? firstDetected,
    int? occurrenceCount,
    bool? resolved,
  }) => UnknownProcessesData(
    id: id ?? this.id,
    executableName: executableName ?? this.executableName,
    windowTitle: windowTitle.present ? windowTitle.value : this.windowTitle,
    firstDetected: firstDetected ?? this.firstDetected,
    occurrenceCount: occurrenceCount ?? this.occurrenceCount,
    resolved: resolved ?? this.resolved,
  );
  UnknownProcessesData copyWithCompanion(UnknownProcessesCompanion data) {
    return UnknownProcessesData(
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
    return (StringBuffer('UnknownProcessesData(')
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
      (other is UnknownProcessesData &&
          other.id == this.id &&
          other.executableName == this.executableName &&
          other.windowTitle == this.windowTitle &&
          other.firstDetected == this.firstDetected &&
          other.occurrenceCount == this.occurrenceCount &&
          other.resolved == this.resolved);
}

class UnknownProcessesCompanion extends UpdateCompanion<UnknownProcessesData> {
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
  static Insertable<UnknownProcessesData> custom({
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

class TopGamesCache extends Table
    with TableInfo<TopGamesCache, TopGamesCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TopGamesCache(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> twitchCategoryId = GeneratedColumn<String>(
    'twitch_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> gameName = GeneratedColumn<String>(
    'game_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> boxArtUrl = GeneratedColumn<String>(
    'box_art_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
  );
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
  Set<GeneratedColumn> get $primaryKey => {twitchCategoryId};
  @override
  TopGamesCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TopGamesCacheData(
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
  TopGamesCache createAlias(String alias) {
    return TopGamesCache(attachedDatabase, alias);
  }
}

class TopGamesCacheData extends DataClass
    implements Insertable<TopGamesCacheData> {
  final String twitchCategoryId;
  final String gameName;
  final String? boxArtUrl;
  final DateTime lastUpdated;
  final DateTime expiresAt;
  const TopGamesCacheData({
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

  factory TopGamesCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TopGamesCacheData(
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

  TopGamesCacheData copyWith({
    String? twitchCategoryId,
    String? gameName,
    Value<String?> boxArtUrl = const Value.absent(),
    DateTime? lastUpdated,
    DateTime? expiresAt,
  }) => TopGamesCacheData(
    twitchCategoryId: twitchCategoryId ?? this.twitchCategoryId,
    gameName: gameName ?? this.gameName,
    boxArtUrl: boxArtUrl.present ? boxArtUrl.value : this.boxArtUrl,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    expiresAt: expiresAt ?? this.expiresAt,
  );
  TopGamesCacheData copyWithCompanion(TopGamesCacheCompanion data) {
    return TopGamesCacheData(
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
    return (StringBuffer('TopGamesCacheData(')
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
      (other is TopGamesCacheData &&
          other.twitchCategoryId == this.twitchCategoryId &&
          other.gameName == this.gameName &&
          other.boxArtUrl == this.boxArtUrl &&
          other.lastUpdated == this.lastUpdated &&
          other.expiresAt == this.expiresAt);
}

class TopGamesCacheCompanion extends UpdateCompanion<TopGamesCacheData> {
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
  static Insertable<TopGamesCacheData> custom({
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

class CommunityMappings extends Table
    with TableInfo<CommunityMappings, CommunityMappingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  CommunityMappings(this.attachedDatabase, [this._alias]);
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
  late final GeneratedColumn<String> processName = GeneratedColumn<String>(
    'process_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> normalizedInstallPaths =
      GeneratedColumn<String>(
        'normalized_install_paths',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<String> twitchCategoryId = GeneratedColumn<String>(
    'twitch_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> twitchCategoryName =
      GeneratedColumn<String>(
        'twitch_category_name',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  late final GeneratedColumn<int> verificationCount = GeneratedColumn<int>(
    'verification_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('1'),
  );
  late final GeneratedColumn<DateTime> lastVerified = GeneratedColumn<DateTime>(
    'last_verified',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'community\''),
  );
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> syncedAt = GeneratedColumn<DateTime>(
    'synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
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
    category,
    syncedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'community_mappings';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {processName, twitchCategoryId},
  ];
  @override
  CommunityMappingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CommunityMappingsData(
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
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      ),
      syncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}synced_at'],
      )!,
    );
  }

  @override
  CommunityMappings createAlias(String alias) {
    return CommunityMappings(attachedDatabase, alias);
  }
}

class CommunityMappingsData extends DataClass
    implements Insertable<CommunityMappingsData> {
  final int id;
  final String processName;
  final String? normalizedInstallPaths;
  final String twitchCategoryId;
  final String twitchCategoryName;
  final int verificationCount;
  final DateTime? lastVerified;
  final String source;
  final String? category;
  final DateTime syncedAt;
  const CommunityMappingsData({
    required this.id,
    required this.processName,
    this.normalizedInstallPaths,
    required this.twitchCategoryId,
    required this.twitchCategoryName,
    required this.verificationCount,
    this.lastVerified,
    required this.source,
    this.category,
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
    if (!nullToAbsent || category != null) {
      map['category'] = Variable<String>(category);
    }
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
      category: category == null && nullToAbsent
          ? const Value.absent()
          : Value(category),
      syncedAt: Value(syncedAt),
    );
  }

  factory CommunityMappingsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CommunityMappingsData(
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
      category: serializer.fromJson<String?>(json['category']),
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
      'category': serializer.toJson<String?>(category),
      'syncedAt': serializer.toJson<DateTime>(syncedAt),
    };
  }

  CommunityMappingsData copyWith({
    int? id,
    String? processName,
    Value<String?> normalizedInstallPaths = const Value.absent(),
    String? twitchCategoryId,
    String? twitchCategoryName,
    int? verificationCount,
    Value<DateTime?> lastVerified = const Value.absent(),
    String? source,
    Value<String?> category = const Value.absent(),
    DateTime? syncedAt,
  }) => CommunityMappingsData(
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
    category: category.present ? category.value : this.category,
    syncedAt: syncedAt ?? this.syncedAt,
  );
  CommunityMappingsData copyWithCompanion(CommunityMappingsCompanion data) {
    return CommunityMappingsData(
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
      category: data.category.present ? data.category.value : this.category,
      syncedAt: data.syncedAt.present ? data.syncedAt.value : this.syncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CommunityMappingsData(')
          ..write('id: $id, ')
          ..write('processName: $processName, ')
          ..write('normalizedInstallPaths: $normalizedInstallPaths, ')
          ..write('twitchCategoryId: $twitchCategoryId, ')
          ..write('twitchCategoryName: $twitchCategoryName, ')
          ..write('verificationCount: $verificationCount, ')
          ..write('lastVerified: $lastVerified, ')
          ..write('source: $source, ')
          ..write('category: $category, ')
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
    category,
    syncedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CommunityMappingsData &&
          other.id == this.id &&
          other.processName == this.processName &&
          other.normalizedInstallPaths == this.normalizedInstallPaths &&
          other.twitchCategoryId == this.twitchCategoryId &&
          other.twitchCategoryName == this.twitchCategoryName &&
          other.verificationCount == this.verificationCount &&
          other.lastVerified == this.lastVerified &&
          other.source == this.source &&
          other.category == this.category &&
          other.syncedAt == this.syncedAt);
}

class CommunityMappingsCompanion
    extends UpdateCompanion<CommunityMappingsData> {
  final Value<int> id;
  final Value<String> processName;
  final Value<String?> normalizedInstallPaths;
  final Value<String> twitchCategoryId;
  final Value<String> twitchCategoryName;
  final Value<int> verificationCount;
  final Value<DateTime?> lastVerified;
  final Value<String> source;
  final Value<String?> category;
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
    this.category = const Value.absent(),
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
    this.category = const Value.absent(),
    this.syncedAt = const Value.absent(),
  }) : processName = Value(processName),
       twitchCategoryId = Value(twitchCategoryId),
       twitchCategoryName = Value(twitchCategoryName);
  static Insertable<CommunityMappingsData> custom({
    Expression<int>? id,
    Expression<String>? processName,
    Expression<String>? normalizedInstallPaths,
    Expression<String>? twitchCategoryId,
    Expression<String>? twitchCategoryName,
    Expression<int>? verificationCount,
    Expression<DateTime>? lastVerified,
    Expression<String>? source,
    Expression<String>? category,
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
      if (category != null) 'category': category,
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
    Value<String?>? category,
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
      category: category ?? this.category,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
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
          ..write('category: $category, ')
          ..write('syncedAt: $syncedAt')
          ..write(')'))
        .toString();
  }
}

class MappingLists extends Table
    with TableInfo<MappingLists, MappingListsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  MappingLists(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('\'\''),
  );
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  late final GeneratedColumn<String> sourceUrl = GeneratedColumn<String>(
    'source_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> submissionHookUrl =
      GeneratedColumn<String>(
        'submission_hook_url',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  late final GeneratedColumn<bool> isEnabled = GeneratedColumn<bool>(
    'is_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_enabled" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('1'),
  );
  late final GeneratedColumn<bool> isReadOnly = GeneratedColumn<bool>(
    'is_read_only',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_read_only" IN (0, 1))',
    ),
    defaultValue: const CustomExpression('0'),
  );
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression('100'),
  );
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<String> lastSyncError = GeneratedColumn<String>(
    'last_sync_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: const CustomExpression(
      'CAST(strftime(\'%s\', CURRENT_TIMESTAMP) AS INTEGER)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    sourceType,
    sourceUrl,
    submissionHookUrl,
    isEnabled,
    isReadOnly,
    priority,
    lastSyncedAt,
    lastSyncError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mapping_lists';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MappingListsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MappingListsData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      sourceUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_url'],
      ),
      submissionHookUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}submission_hook_url'],
      ),
      isEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_enabled'],
      )!,
      isReadOnly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_read_only'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      ),
      lastSyncError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  MappingLists createAlias(String alias) {
    return MappingLists(attachedDatabase, alias);
  }
}

class MappingListsData extends DataClass
    implements Insertable<MappingListsData> {
  final String id;
  final String name;
  final String description;
  final String sourceType;
  final String? sourceUrl;
  final String? submissionHookUrl;
  final bool isEnabled;
  final bool isReadOnly;
  final int priority;
  final DateTime? lastSyncedAt;
  final String? lastSyncError;
  final DateTime createdAt;
  const MappingListsData({
    required this.id,
    required this.name,
    required this.description,
    required this.sourceType,
    this.sourceUrl,
    this.submissionHookUrl,
    required this.isEnabled,
    required this.isReadOnly,
    required this.priority,
    this.lastSyncedAt,
    this.lastSyncError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['source_type'] = Variable<String>(sourceType);
    if (!nullToAbsent || sourceUrl != null) {
      map['source_url'] = Variable<String>(sourceUrl);
    }
    if (!nullToAbsent || submissionHookUrl != null) {
      map['submission_hook_url'] = Variable<String>(submissionHookUrl);
    }
    map['is_enabled'] = Variable<bool>(isEnabled);
    map['is_read_only'] = Variable<bool>(isReadOnly);
    map['priority'] = Variable<int>(priority);
    if (!nullToAbsent || lastSyncedAt != null) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    }
    if (!nullToAbsent || lastSyncError != null) {
      map['last_sync_error'] = Variable<String>(lastSyncError);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MappingListsCompanion toCompanion(bool nullToAbsent) {
    return MappingListsCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      sourceType: Value(sourceType),
      sourceUrl: sourceUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceUrl),
      submissionHookUrl: submissionHookUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(submissionHookUrl),
      isEnabled: Value(isEnabled),
      isReadOnly: Value(isReadOnly),
      priority: Value(priority),
      lastSyncedAt: lastSyncedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncedAt),
      lastSyncError: lastSyncError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncError),
      createdAt: Value(createdAt),
    );
  }

  factory MappingListsData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MappingListsData(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceUrl: serializer.fromJson<String?>(json['sourceUrl']),
      submissionHookUrl: serializer.fromJson<String?>(
        json['submissionHookUrl'],
      ),
      isEnabled: serializer.fromJson<bool>(json['isEnabled']),
      isReadOnly: serializer.fromJson<bool>(json['isReadOnly']),
      priority: serializer.fromJson<int>(json['priority']),
      lastSyncedAt: serializer.fromJson<DateTime?>(json['lastSyncedAt']),
      lastSyncError: serializer.fromJson<String?>(json['lastSyncError']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceUrl': serializer.toJson<String?>(sourceUrl),
      'submissionHookUrl': serializer.toJson<String?>(submissionHookUrl),
      'isEnabled': serializer.toJson<bool>(isEnabled),
      'isReadOnly': serializer.toJson<bool>(isReadOnly),
      'priority': serializer.toJson<int>(priority),
      'lastSyncedAt': serializer.toJson<DateTime?>(lastSyncedAt),
      'lastSyncError': serializer.toJson<String?>(lastSyncError),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MappingListsData copyWith({
    String? id,
    String? name,
    String? description,
    String? sourceType,
    Value<String?> sourceUrl = const Value.absent(),
    Value<String?> submissionHookUrl = const Value.absent(),
    bool? isEnabled,
    bool? isReadOnly,
    int? priority,
    Value<DateTime?> lastSyncedAt = const Value.absent(),
    Value<String?> lastSyncError = const Value.absent(),
    DateTime? createdAt,
  }) => MappingListsData(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    sourceType: sourceType ?? this.sourceType,
    sourceUrl: sourceUrl.present ? sourceUrl.value : this.sourceUrl,
    submissionHookUrl: submissionHookUrl.present
        ? submissionHookUrl.value
        : this.submissionHookUrl,
    isEnabled: isEnabled ?? this.isEnabled,
    isReadOnly: isReadOnly ?? this.isReadOnly,
    priority: priority ?? this.priority,
    lastSyncedAt: lastSyncedAt.present ? lastSyncedAt.value : this.lastSyncedAt,
    lastSyncError: lastSyncError.present
        ? lastSyncError.value
        : this.lastSyncError,
    createdAt: createdAt ?? this.createdAt,
  );
  MappingListsData copyWithCompanion(MappingListsCompanion data) {
    return MappingListsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      sourceUrl: data.sourceUrl.present ? data.sourceUrl.value : this.sourceUrl,
      submissionHookUrl: data.submissionHookUrl.present
          ? data.submissionHookUrl.value
          : this.submissionHookUrl,
      isEnabled: data.isEnabled.present ? data.isEnabled.value : this.isEnabled,
      isReadOnly: data.isReadOnly.present
          ? data.isReadOnly.value
          : this.isReadOnly,
      priority: data.priority.present ? data.priority.value : this.priority,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
      lastSyncError: data.lastSyncError.present
          ? data.lastSyncError.value
          : this.lastSyncError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MappingListsData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('submissionHookUrl: $submissionHookUrl, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isReadOnly: $isReadOnly, ')
          ..write('priority: $priority, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    sourceType,
    sourceUrl,
    submissionHookUrl,
    isEnabled,
    isReadOnly,
    priority,
    lastSyncedAt,
    lastSyncError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MappingListsData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.sourceType == this.sourceType &&
          other.sourceUrl == this.sourceUrl &&
          other.submissionHookUrl == this.submissionHookUrl &&
          other.isEnabled == this.isEnabled &&
          other.isReadOnly == this.isReadOnly &&
          other.priority == this.priority &&
          other.lastSyncedAt == this.lastSyncedAt &&
          other.lastSyncError == this.lastSyncError &&
          other.createdAt == this.createdAt);
}

class MappingListsCompanion extends UpdateCompanion<MappingListsData> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> sourceType;
  final Value<String?> sourceUrl;
  final Value<String?> submissionHookUrl;
  final Value<bool> isEnabled;
  final Value<bool> isReadOnly;
  final Value<int> priority;
  final Value<DateTime?> lastSyncedAt;
  final Value<String?> lastSyncError;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MappingListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceUrl = const Value.absent(),
    this.submissionHookUrl = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isReadOnly = const Value.absent(),
    this.priority = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MappingListsCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required String sourceType,
    this.sourceUrl = const Value.absent(),
    this.submissionHookUrl = const Value.absent(),
    this.isEnabled = const Value.absent(),
    this.isReadOnly = const Value.absent(),
    this.priority = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.lastSyncError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       sourceType = Value(sourceType);
  static Insertable<MappingListsData> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? sourceType,
    Expression<String>? sourceUrl,
    Expression<String>? submissionHookUrl,
    Expression<bool>? isEnabled,
    Expression<bool>? isReadOnly,
    Expression<int>? priority,
    Expression<DateTime>? lastSyncedAt,
    Expression<String>? lastSyncError,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceUrl != null) 'source_url': sourceUrl,
      if (submissionHookUrl != null) 'submission_hook_url': submissionHookUrl,
      if (isEnabled != null) 'is_enabled': isEnabled,
      if (isReadOnly != null) 'is_read_only': isReadOnly,
      if (priority != null) 'priority': priority,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (lastSyncError != null) 'last_sync_error': lastSyncError,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MappingListsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? sourceType,
    Value<String?>? sourceUrl,
    Value<String?>? submissionHookUrl,
    Value<bool>? isEnabled,
    Value<bool>? isReadOnly,
    Value<int>? priority,
    Value<DateTime?>? lastSyncedAt,
    Value<String?>? lastSyncError,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MappingListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sourceType: sourceType ?? this.sourceType,
      sourceUrl: sourceUrl ?? this.sourceUrl,
      submissionHookUrl: submissionHookUrl ?? this.submissionHookUrl,
      isEnabled: isEnabled ?? this.isEnabled,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      priority: priority ?? this.priority,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      lastSyncError: lastSyncError ?? this.lastSyncError,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceUrl.present) {
      map['source_url'] = Variable<String>(sourceUrl.value);
    }
    if (submissionHookUrl.present) {
      map['submission_hook_url'] = Variable<String>(submissionHookUrl.value);
    }
    if (isEnabled.present) {
      map['is_enabled'] = Variable<bool>(isEnabled.value);
    }
    if (isReadOnly.present) {
      map['is_read_only'] = Variable<bool>(isReadOnly.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (lastSyncError.present) {
      map['last_sync_error'] = Variable<String>(lastSyncError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MappingListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceUrl: $sourceUrl, ')
          ..write('submissionHookUrl: $submissionHookUrl, ')
          ..write('isEnabled: $isEnabled, ')
          ..write('isReadOnly: $isReadOnly, ')
          ..write('priority: $priority, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('lastSyncError: $lastSyncError, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV7 extends GeneratedDatabase {
  DatabaseAtV7(QueryExecutor e) : super(e);
  late final CategoryMappings categoryMappings = CategoryMappings(this);
  late final UpdateHistory updateHistory = UpdateHistory(this);
  late final UnknownProcesses unknownProcesses = UnknownProcesses(this);
  late final TopGamesCache topGamesCache = TopGamesCache(this);
  late final CommunityMappings communityMappings = CommunityMappings(this);
  late final MappingLists mappingLists = MappingLists(this);
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
    mappingLists,
  ];
  @override
  int get schemaVersion => 7;
}
