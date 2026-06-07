// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuadrantsTable extends Quadrants
    with TableInfo<$QuadrantsTable, QuadrantRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuadrantsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'quadrants';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuadrantRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuadrantRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuadrantRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $QuadrantsTable createAlias(String alias) {
    return $QuadrantsTable(attachedDatabase, alias);
  }
}

class QuadrantRow extends DataClass implements Insertable<QuadrantRow> {
  final int id;
  final String label;
  const QuadrantRow({required this.id, required this.label});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    return map;
  }

  QuadrantsCompanion toCompanion(bool nullToAbsent) {
    return QuadrantsCompanion(id: Value(id), label: Value(label));
  }

  factory QuadrantRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuadrantRow(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
    };
  }

  QuadrantRow copyWith({int? id, String? label}) =>
      QuadrantRow(id: id ?? this.id, label: label ?? this.label);
  QuadrantRow copyWithCompanion(QuadrantsCompanion data) {
    return QuadrantRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuadrantRow(')
          ..write('id: $id, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuadrantRow &&
          other.id == this.id &&
          other.label == this.label);
}

class QuadrantsCompanion extends UpdateCompanion<QuadrantRow> {
  final Value<int> id;
  final Value<String> label;
  const QuadrantsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
  });
  QuadrantsCompanion.insert({
    this.id = const Value.absent(),
    required String label,
  }) : label = Value(label);
  static Insertable<QuadrantRow> custom({
    Expression<int>? id,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
    });
  }

  QuadrantsCompanion copyWith({Value<int>? id, Value<String>? label}) {
    return QuadrantsCompanion(id: id ?? this.id, label: label ?? this.label);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuadrantsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $EmotionsTable extends Emotions
    with TableInfo<$EmotionsTable, EmotionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmotionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quadrantIdMeta = const VerificationMeta(
    'quadrantId',
  );
  @override
  late final GeneratedColumn<int> quadrantId = GeneratedColumn<int>(
    'quadrant_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES quadrants (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, quadrantId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emotions';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmotionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quadrant_id')) {
      context.handle(
        _quadrantIdMeta,
        quadrantId.isAcceptableOrUnknown(data['quadrant_id']!, _quadrantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_quadrantIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmotionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmotionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quadrantId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quadrant_id'],
      )!,
    );
  }

  @override
  $EmotionsTable createAlias(String alias) {
    return $EmotionsTable(attachedDatabase, alias);
  }
}

class EmotionRow extends DataClass implements Insertable<EmotionRow> {
  final int id;
  final String name;
  final int quadrantId;
  const EmotionRow({
    required this.id,
    required this.name,
    required this.quadrantId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['quadrant_id'] = Variable<int>(quadrantId);
    return map;
  }

  EmotionsCompanion toCompanion(bool nullToAbsent) {
    return EmotionsCompanion(
      id: Value(id),
      name: Value(name),
      quadrantId: Value(quadrantId),
    );
  }

  factory EmotionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmotionRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      quadrantId: serializer.fromJson<int>(json['quadrantId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'quadrantId': serializer.toJson<int>(quadrantId),
    };
  }

  EmotionRow copyWith({int? id, String? name, int? quadrantId}) => EmotionRow(
    id: id ?? this.id,
    name: name ?? this.name,
    quadrantId: quadrantId ?? this.quadrantId,
  );
  EmotionRow copyWithCompanion(EmotionsCompanion data) {
    return EmotionRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      quadrantId: data.quadrantId.present
          ? data.quadrantId.value
          : this.quadrantId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmotionRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quadrantId: $quadrantId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, quadrantId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmotionRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.quadrantId == this.quadrantId);
}

class EmotionsCompanion extends UpdateCompanion<EmotionRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> quadrantId;
  const EmotionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.quadrantId = const Value.absent(),
  });
  EmotionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int quadrantId,
  }) : name = Value(name),
       quadrantId = Value(quadrantId);
  static Insertable<EmotionRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? quadrantId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (quadrantId != null) 'quadrant_id': quadrantId,
    });
  }

  EmotionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? quadrantId,
  }) {
    return EmotionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      quadrantId: quadrantId ?? this.quadrantId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quadrantId.present) {
      map['quadrant_id'] = Variable<int>(quadrantId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmotionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('quadrantId: $quadrantId')
          ..write(')'))
        .toString();
  }
}

class $StagesTable extends Stages with TableInfo<$StagesTable, StageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, code, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stages';
  @override
  VerificationContext validateIntegrity(
    Insertable<StageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $StagesTable createAlias(String alias) {
    return $StagesTable(attachedDatabase, alias);
  }
}

class StageRow extends DataClass implements Insertable<StageRow> {
  final int id;
  final String code;
  final String label;
  const StageRow({required this.id, required this.code, required this.label});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['label'] = Variable<String>(label);
    return map;
  }

  StagesCompanion toCompanion(bool nullToAbsent) {
    return StagesCompanion(
      id: Value(id),
      code: Value(code),
      label: Value(label),
    );
  }

  factory StageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StageRow(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'label': serializer.toJson<String>(label),
    };
  }

  StageRow copyWith({int? id, String? code, String? label}) => StageRow(
    id: id ?? this.id,
    code: code ?? this.code,
    label: label ?? this.label,
  );
  StageRow copyWithCompanion(StagesCompanion data) {
    return StageRow(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StageRow(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, code, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StageRow &&
          other.id == this.id &&
          other.code == this.code &&
          other.label == this.label);
}

class StagesCompanion extends UpdateCompanion<StageRow> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> label;
  const StagesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.label = const Value.absent(),
  });
  StagesCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String label,
  }) : code = Value(code),
       label = Value(label);
  static Insertable<StageRow> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (label != null) 'label': label,
    });
  }

  StagesCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? label,
  }) {
    return StagesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      label: label ?? this.label,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StagesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, ActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }
}

class ActivityRow extends DataClass implements Insertable<ActivityRow> {
  final int id;
  final String label;
  const ActivityRow({required this.id, required this.label});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(id: Value(id), label: Value(label));
  }

  factory ActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityRow(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
    };
  }

  ActivityRow copyWith({int? id, String? label}) =>
      ActivityRow(id: id ?? this.id, label: label ?? this.label);
  ActivityRow copyWithCompanion(ActivitiesCompanion data) {
    return ActivityRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityRow(')
          ..write('id: $id, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityRow &&
          other.id == this.id &&
          other.label == this.label);
}

class ActivitiesCompanion extends UpdateCompanion<ActivityRow> {
  final Value<int> id;
  final Value<String> label;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    this.id = const Value.absent(),
    required String label,
  }) : label = Value(label);
  static Insertable<ActivityRow> custom({
    Expression<int>? id,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
    });
  }

  ActivitiesCompanion copyWith({Value<int>? id, Value<String>? label}) {
    return ActivitiesCompanion(id: id ?? this.id, label: label ?? this.label);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, LocationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, label];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class LocationRow extends DataClass implements Insertable<LocationRow> {
  final int id;
  final String label;
  const LocationRow({required this.id, required this.label});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['label'] = Variable<String>(label);
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(id: Value(id), label: Value(label));
  }

  factory LocationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationRow(
      id: serializer.fromJson<int>(json['id']),
      label: serializer.fromJson<String>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'label': serializer.toJson<String>(label),
    };
  }

  LocationRow copyWith({int? id, String? label}) =>
      LocationRow(id: id ?? this.id, label: label ?? this.label);
  LocationRow copyWithCompanion(LocationsCompanion data) {
    return LocationRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationRow(')
          ..write('id: $id, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, label);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationRow &&
          other.id == this.id &&
          other.label == this.label);
}

class LocationsCompanion extends UpdateCompanion<LocationRow> {
  final Value<int> id;
  final Value<String> label;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
  });
  LocationsCompanion.insert({
    this.id = const Value.absent(),
    required String label,
  }) : label = Value(label);
  static Insertable<LocationRow> custom({
    Expression<int>? id,
    Expression<String>? label,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
    });
  }

  LocationsCompanion copyWith({Value<int>? id, Value<String>? label}) {
    return LocationsCompanion(id: id ?? this.id, label: label ?? this.label);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }
}

class $ParentsTable extends Parents with TableInfo<$ParentsTable, ParentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParentsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _babyFirstNameMeta = const VerificationMeta(
    'babyFirstName',
  );
  @override
  late final GeneratedColumn<String> babyFirstName = GeneratedColumn<String>(
    'baby_first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _babyBirthDateMeta = const VerificationMeta(
    'babyBirthDate',
  );
  @override
  late final GeneratedColumn<DateTime> babyBirthDate =
      GeneratedColumn<DateTime>(
        'baby_birth_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _gestationalAgeWeeksMeta =
      const VerificationMeta('gestationalAgeWeeks');
  @override
  late final GeneratedColumn<int> gestationalAgeWeeks = GeneratedColumn<int>(
    'gestational_age_weeks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageIdMeta = const VerificationMeta(
    'stageId',
  );
  @override
  late final GeneratedColumn<int> stageId = GeneratedColumn<int>(
    'stage_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stages (id)',
    ),
  );
  static const VerificationMeta _coparentIdMeta = const VerificationMeta(
    'coparentId',
  );
  @override
  late final GeneratedColumn<int> coparentId = GeneratedColumn<int>(
    'coparent_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NULL REFERENCES parents(id)',
  );
  static const VerificationMeta _sharingConsentMeta = const VerificationMeta(
    'sharingConsent',
  );
  @override
  late final GeneratedColumn<bool> sharingConsent = GeneratedColumn<bool>(
    'sharing_consent',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sharing_consent" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    firstName,
    babyFirstName,
    babyBirthDate,
    gestationalAgeWeeks,
    stageId,
    coparentId,
    sharingConsent,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'parents';
  @override
  VerificationContext validateIntegrity(
    Insertable<ParentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('baby_first_name')) {
      context.handle(
        _babyFirstNameMeta,
        babyFirstName.isAcceptableOrUnknown(
          data['baby_first_name']!,
          _babyFirstNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_babyFirstNameMeta);
    }
    if (data.containsKey('baby_birth_date')) {
      context.handle(
        _babyBirthDateMeta,
        babyBirthDate.isAcceptableOrUnknown(
          data['baby_birth_date']!,
          _babyBirthDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_babyBirthDateMeta);
    }
    if (data.containsKey('gestational_age_weeks')) {
      context.handle(
        _gestationalAgeWeeksMeta,
        gestationalAgeWeeks.isAcceptableOrUnknown(
          data['gestational_age_weeks']!,
          _gestationalAgeWeeksMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gestationalAgeWeeksMeta);
    }
    if (data.containsKey('stage_id')) {
      context.handle(
        _stageIdMeta,
        stageId.isAcceptableOrUnknown(data['stage_id']!, _stageIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stageIdMeta);
    }
    if (data.containsKey('coparent_id')) {
      context.handle(
        _coparentIdMeta,
        coparentId.isAcceptableOrUnknown(data['coparent_id']!, _coparentIdMeta),
      );
    }
    if (data.containsKey('sharing_consent')) {
      context.handle(
        _sharingConsentMeta,
        sharingConsent.isAcceptableOrUnknown(
          data['sharing_consent']!,
          _sharingConsentMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ParentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      babyFirstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}baby_first_name'],
      )!,
      babyBirthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}baby_birth_date'],
      )!,
      gestationalAgeWeeks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}gestational_age_weeks'],
      )!,
      stageId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stage_id'],
      )!,
      coparentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}coparent_id'],
      ),
      sharingConsent: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sharing_consent'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ParentsTable createAlias(String alias) {
    return $ParentsTable(attachedDatabase, alias);
  }
}

class ParentRow extends DataClass implements Insertable<ParentRow> {
  final int id;
  final String firstName;
  final String babyFirstName;
  final DateTime babyBirthDate;
  final int gestationalAgeWeeks;
  final int stageId;
  final int? coparentId;
  final bool sharingConsent;
  final DateTime createdAt;
  const ParentRow({
    required this.id,
    required this.firstName,
    required this.babyFirstName,
    required this.babyBirthDate,
    required this.gestationalAgeWeeks,
    required this.stageId,
    this.coparentId,
    required this.sharingConsent,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['first_name'] = Variable<String>(firstName);
    map['baby_first_name'] = Variable<String>(babyFirstName);
    map['baby_birth_date'] = Variable<DateTime>(babyBirthDate);
    map['gestational_age_weeks'] = Variable<int>(gestationalAgeWeeks);
    map['stage_id'] = Variable<int>(stageId);
    if (!nullToAbsent || coparentId != null) {
      map['coparent_id'] = Variable<int>(coparentId);
    }
    map['sharing_consent'] = Variable<bool>(sharingConsent);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ParentsCompanion toCompanion(bool nullToAbsent) {
    return ParentsCompanion(
      id: Value(id),
      firstName: Value(firstName),
      babyFirstName: Value(babyFirstName),
      babyBirthDate: Value(babyBirthDate),
      gestationalAgeWeeks: Value(gestationalAgeWeeks),
      stageId: Value(stageId),
      coparentId: coparentId == null && nullToAbsent
          ? const Value.absent()
          : Value(coparentId),
      sharingConsent: Value(sharingConsent),
      createdAt: Value(createdAt),
    );
  }

  factory ParentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParentRow(
      id: serializer.fromJson<int>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      babyFirstName: serializer.fromJson<String>(json['babyFirstName']),
      babyBirthDate: serializer.fromJson<DateTime>(json['babyBirthDate']),
      gestationalAgeWeeks: serializer.fromJson<int>(
        json['gestationalAgeWeeks'],
      ),
      stageId: serializer.fromJson<int>(json['stageId']),
      coparentId: serializer.fromJson<int?>(json['coparentId']),
      sharingConsent: serializer.fromJson<bool>(json['sharingConsent']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'firstName': serializer.toJson<String>(firstName),
      'babyFirstName': serializer.toJson<String>(babyFirstName),
      'babyBirthDate': serializer.toJson<DateTime>(babyBirthDate),
      'gestationalAgeWeeks': serializer.toJson<int>(gestationalAgeWeeks),
      'stageId': serializer.toJson<int>(stageId),
      'coparentId': serializer.toJson<int?>(coparentId),
      'sharingConsent': serializer.toJson<bool>(sharingConsent),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ParentRow copyWith({
    int? id,
    String? firstName,
    String? babyFirstName,
    DateTime? babyBirthDate,
    int? gestationalAgeWeeks,
    int? stageId,
    Value<int?> coparentId = const Value.absent(),
    bool? sharingConsent,
    DateTime? createdAt,
  }) => ParentRow(
    id: id ?? this.id,
    firstName: firstName ?? this.firstName,
    babyFirstName: babyFirstName ?? this.babyFirstName,
    babyBirthDate: babyBirthDate ?? this.babyBirthDate,
    gestationalAgeWeeks: gestationalAgeWeeks ?? this.gestationalAgeWeeks,
    stageId: stageId ?? this.stageId,
    coparentId: coparentId.present ? coparentId.value : this.coparentId,
    sharingConsent: sharingConsent ?? this.sharingConsent,
    createdAt: createdAt ?? this.createdAt,
  );
  ParentRow copyWithCompanion(ParentsCompanion data) {
    return ParentRow(
      id: data.id.present ? data.id.value : this.id,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      babyFirstName: data.babyFirstName.present
          ? data.babyFirstName.value
          : this.babyFirstName,
      babyBirthDate: data.babyBirthDate.present
          ? data.babyBirthDate.value
          : this.babyBirthDate,
      gestationalAgeWeeks: data.gestationalAgeWeeks.present
          ? data.gestationalAgeWeeks.value
          : this.gestationalAgeWeeks,
      stageId: data.stageId.present ? data.stageId.value : this.stageId,
      coparentId: data.coparentId.present
          ? data.coparentId.value
          : this.coparentId,
      sharingConsent: data.sharingConsent.present
          ? data.sharingConsent.value
          : this.sharingConsent,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ParentRow(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('babyFirstName: $babyFirstName, ')
          ..write('babyBirthDate: $babyBirthDate, ')
          ..write('gestationalAgeWeeks: $gestationalAgeWeeks, ')
          ..write('stageId: $stageId, ')
          ..write('coparentId: $coparentId, ')
          ..write('sharingConsent: $sharingConsent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    babyFirstName,
    babyBirthDate,
    gestationalAgeWeeks,
    stageId,
    coparentId,
    sharingConsent,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParentRow &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.babyFirstName == this.babyFirstName &&
          other.babyBirthDate == this.babyBirthDate &&
          other.gestationalAgeWeeks == this.gestationalAgeWeeks &&
          other.stageId == this.stageId &&
          other.coparentId == this.coparentId &&
          other.sharingConsent == this.sharingConsent &&
          other.createdAt == this.createdAt);
}

class ParentsCompanion extends UpdateCompanion<ParentRow> {
  final Value<int> id;
  final Value<String> firstName;
  final Value<String> babyFirstName;
  final Value<DateTime> babyBirthDate;
  final Value<int> gestationalAgeWeeks;
  final Value<int> stageId;
  final Value<int?> coparentId;
  final Value<bool> sharingConsent;
  final Value<DateTime> createdAt;
  const ParentsCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.babyFirstName = const Value.absent(),
    this.babyBirthDate = const Value.absent(),
    this.gestationalAgeWeeks = const Value.absent(),
    this.stageId = const Value.absent(),
    this.coparentId = const Value.absent(),
    this.sharingConsent = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ParentsCompanion.insert({
    this.id = const Value.absent(),
    required String firstName,
    required String babyFirstName,
    required DateTime babyBirthDate,
    required int gestationalAgeWeeks,
    required int stageId,
    this.coparentId = const Value.absent(),
    this.sharingConsent = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : firstName = Value(firstName),
       babyFirstName = Value(babyFirstName),
       babyBirthDate = Value(babyBirthDate),
       gestationalAgeWeeks = Value(gestationalAgeWeeks),
       stageId = Value(stageId);
  static Insertable<ParentRow> custom({
    Expression<int>? id,
    Expression<String>? firstName,
    Expression<String>? babyFirstName,
    Expression<DateTime>? babyBirthDate,
    Expression<int>? gestationalAgeWeeks,
    Expression<int>? stageId,
    Expression<int>? coparentId,
    Expression<bool>? sharingConsent,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (babyFirstName != null) 'baby_first_name': babyFirstName,
      if (babyBirthDate != null) 'baby_birth_date': babyBirthDate,
      if (gestationalAgeWeeks != null)
        'gestational_age_weeks': gestationalAgeWeeks,
      if (stageId != null) 'stage_id': stageId,
      if (coparentId != null) 'coparent_id': coparentId,
      if (sharingConsent != null) 'sharing_consent': sharingConsent,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ParentsCompanion copyWith({
    Value<int>? id,
    Value<String>? firstName,
    Value<String>? babyFirstName,
    Value<DateTime>? babyBirthDate,
    Value<int>? gestationalAgeWeeks,
    Value<int>? stageId,
    Value<int?>? coparentId,
    Value<bool>? sharingConsent,
    Value<DateTime>? createdAt,
  }) {
    return ParentsCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      babyFirstName: babyFirstName ?? this.babyFirstName,
      babyBirthDate: babyBirthDate ?? this.babyBirthDate,
      gestationalAgeWeeks: gestationalAgeWeeks ?? this.gestationalAgeWeeks,
      stageId: stageId ?? this.stageId,
      coparentId: coparentId ?? this.coparentId,
      sharingConsent: sharingConsent ?? this.sharingConsent,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (babyFirstName.present) {
      map['baby_first_name'] = Variable<String>(babyFirstName.value);
    }
    if (babyBirthDate.present) {
      map['baby_birth_date'] = Variable<DateTime>(babyBirthDate.value);
    }
    if (gestationalAgeWeeks.present) {
      map['gestational_age_weeks'] = Variable<int>(gestationalAgeWeeks.value);
    }
    if (stageId.present) {
      map['stage_id'] = Variable<int>(stageId.value);
    }
    if (coparentId.present) {
      map['coparent_id'] = Variable<int>(coparentId.value);
    }
    if (sharingConsent.present) {
      map['sharing_consent'] = Variable<bool>(sharingConsent.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParentsCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('babyFirstName: $babyFirstName, ')
          ..write('babyBirthDate: $babyBirthDate, ')
          ..write('gestationalAgeWeeks: $gestationalAgeWeeks, ')
          ..write('stageId: $stageId, ')
          ..write('coparentId: $coparentId, ')
          ..write('sharingConsent: $sharingConsent, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $EntriesTable extends Entries with TableInfo<$EntriesTable, EntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
    'parent_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES parents (id)',
    ),
  );
  static const VerificationMeta _emotionIdMeta = const VerificationMeta(
    'emotionId',
  );
  @override
  late final GeneratedColumn<int> emotionId = GeneratedColumn<int>(
    'emotion_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES emotions (id)',
    ),
  );
  static const VerificationMeta _intensityMeta = const VerificationMeta(
    'intensity',
  );
  @override
  late final GeneratedColumn<int> intensity = GeneratedColumn<int>(
    'intensity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL CHECK (intensity BETWEEN 1 AND 5)',
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<int> activityId = GeneratedColumn<int>(
    'activity_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id)',
    ),
  );
  static const VerificationMeta _locationIdMeta = const VerificationMeta(
    'locationId',
  );
  @override
  late final GeneratedColumn<int> locationId = GeneratedColumn<int>(
    'location_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES locations (id)',
    ),
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    parentId,
    emotionId,
    intensity,
    activityId,
    locationId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<EntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_parentIdMeta);
    }
    if (data.containsKey('emotion_id')) {
      context.handle(
        _emotionIdMeta,
        emotionId.isAcceptableOrUnknown(data['emotion_id']!, _emotionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_emotionIdMeta);
    }
    if (data.containsKey('intensity')) {
      context.handle(
        _intensityMeta,
        intensity.isAcceptableOrUnknown(data['intensity']!, _intensityMeta),
      );
    } else if (isInserting) {
      context.missing(_intensityMeta);
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    }
    if (data.containsKey('location_id')) {
      context.handle(
        _locationIdMeta,
        locationId.isAcceptableOrUnknown(data['location_id']!, _locationIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}parent_id'],
      )!,
      emotionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}emotion_id'],
      )!,
      intensity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}intensity'],
      )!,
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_id'],
      ),
      locationId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}location_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EntriesTable createAlias(String alias) {
    return $EntriesTable(attachedDatabase, alias);
  }
}

class EntryRow extends DataClass implements Insertable<EntryRow> {
  final int id;
  final int parentId;
  final int emotionId;
  final int intensity;
  final int? activityId;
  final int? locationId;
  final DateTime createdAt;
  const EntryRow({
    required this.id,
    required this.parentId,
    required this.emotionId,
    required this.intensity,
    this.activityId,
    this.locationId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['parent_id'] = Variable<int>(parentId);
    map['emotion_id'] = Variable<int>(emotionId);
    map['intensity'] = Variable<int>(intensity);
    if (!nullToAbsent || activityId != null) {
      map['activity_id'] = Variable<int>(activityId);
    }
    if (!nullToAbsent || locationId != null) {
      map['location_id'] = Variable<int>(locationId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EntriesCompanion toCompanion(bool nullToAbsent) {
    return EntriesCompanion(
      id: Value(id),
      parentId: Value(parentId),
      emotionId: Value(emotionId),
      intensity: Value(intensity),
      activityId: activityId == null && nullToAbsent
          ? const Value.absent()
          : Value(activityId),
      locationId: locationId == null && nullToAbsent
          ? const Value.absent()
          : Value(locationId),
      createdAt: Value(createdAt),
    );
  }

  factory EntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EntryRow(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int>(json['parentId']),
      emotionId: serializer.fromJson<int>(json['emotionId']),
      intensity: serializer.fromJson<int>(json['intensity']),
      activityId: serializer.fromJson<int?>(json['activityId']),
      locationId: serializer.fromJson<int?>(json['locationId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int>(parentId),
      'emotionId': serializer.toJson<int>(emotionId),
      'intensity': serializer.toJson<int>(intensity),
      'activityId': serializer.toJson<int?>(activityId),
      'locationId': serializer.toJson<int?>(locationId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EntryRow copyWith({
    int? id,
    int? parentId,
    int? emotionId,
    int? intensity,
    Value<int?> activityId = const Value.absent(),
    Value<int?> locationId = const Value.absent(),
    DateTime? createdAt,
  }) => EntryRow(
    id: id ?? this.id,
    parentId: parentId ?? this.parentId,
    emotionId: emotionId ?? this.emotionId,
    intensity: intensity ?? this.intensity,
    activityId: activityId.present ? activityId.value : this.activityId,
    locationId: locationId.present ? locationId.value : this.locationId,
    createdAt: createdAt ?? this.createdAt,
  );
  EntryRow copyWithCompanion(EntriesCompanion data) {
    return EntryRow(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      emotionId: data.emotionId.present ? data.emotionId.value : this.emotionId,
      intensity: data.intensity.present ? data.intensity.value : this.intensity,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      locationId: data.locationId.present
          ? data.locationId.value
          : this.locationId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EntryRow(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('emotionId: $emotionId, ')
          ..write('intensity: $intensity, ')
          ..write('activityId: $activityId, ')
          ..write('locationId: $locationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    parentId,
    emotionId,
    intensity,
    activityId,
    locationId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EntryRow &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.emotionId == this.emotionId &&
          other.intensity == this.intensity &&
          other.activityId == this.activityId &&
          other.locationId == this.locationId &&
          other.createdAt == this.createdAt);
}

class EntriesCompanion extends UpdateCompanion<EntryRow> {
  final Value<int> id;
  final Value<int> parentId;
  final Value<int> emotionId;
  final Value<int> intensity;
  final Value<int?> activityId;
  final Value<int?> locationId;
  final Value<DateTime> createdAt;
  const EntriesCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.emotionId = const Value.absent(),
    this.intensity = const Value.absent(),
    this.activityId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  EntriesCompanion.insert({
    this.id = const Value.absent(),
    required int parentId,
    required int emotionId,
    required int intensity,
    this.activityId = const Value.absent(),
    this.locationId = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : parentId = Value(parentId),
       emotionId = Value(emotionId),
       intensity = Value(intensity);
  static Insertable<EntryRow> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<int>? emotionId,
    Expression<int>? intensity,
    Expression<int>? activityId,
    Expression<int>? locationId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (emotionId != null) 'emotion_id': emotionId,
      if (intensity != null) 'intensity': intensity,
      if (activityId != null) 'activity_id': activityId,
      if (locationId != null) 'location_id': locationId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  EntriesCompanion copyWith({
    Value<int>? id,
    Value<int>? parentId,
    Value<int>? emotionId,
    Value<int>? intensity,
    Value<int?>? activityId,
    Value<int?>? locationId,
    Value<DateTime>? createdAt,
  }) {
    return EntriesCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      emotionId: emotionId ?? this.emotionId,
      intensity: intensity ?? this.intensity,
      activityId: activityId ?? this.activityId,
      locationId: locationId ?? this.locationId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (emotionId.present) {
      map['emotion_id'] = Variable<int>(emotionId.value);
    }
    if (intensity.present) {
      map['intensity'] = Variable<int>(intensity.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<int>(activityId.value);
    }
    if (locationId.present) {
      map['location_id'] = Variable<int>(locationId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntriesCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('emotionId: $emotionId, ')
          ..write('intensity: $intensity, ')
          ..write('activityId: $activityId, ')
          ..write('locationId: $locationId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuadrantsTable quadrants = $QuadrantsTable(this);
  late final $EmotionsTable emotions = $EmotionsTable(this);
  late final $StagesTable stages = $StagesTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $ParentsTable parents = $ParentsTable(this);
  late final $EntriesTable entries = $EntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    quadrants,
    emotions,
    stages,
    activities,
    locations,
    parents,
    entries,
  ];
}

typedef $$QuadrantsTableCreateCompanionBuilder =
    QuadrantsCompanion Function({Value<int> id, required String label});
typedef $$QuadrantsTableUpdateCompanionBuilder =
    QuadrantsCompanion Function({Value<int> id, Value<String> label});

final class $$QuadrantsTableReferences
    extends BaseReferences<_$AppDatabase, $QuadrantsTable, QuadrantRow> {
  $$QuadrantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EmotionsTable, List<EmotionRow>>
  _emotionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.emotions,
    aliasName: $_aliasNameGenerator(db.quadrants.id, db.emotions.quadrantId),
  );

  $$EmotionsTableProcessedTableManager get emotionsRefs {
    final manager = $$EmotionsTableTableManager(
      $_db,
      $_db.emotions,
    ).filter((f) => f.quadrantId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_emotionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$QuadrantsTableFilterComposer
    extends Composer<_$AppDatabase, $QuadrantsTable> {
  $$QuadrantsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> emotionsRefs(
    Expression<bool> Function($$EmotionsTableFilterComposer f) f,
  ) {
    final $$EmotionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emotions,
      getReferencedColumn: (t) => t.quadrantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmotionsTableFilterComposer(
            $db: $db,
            $table: $db.emotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuadrantsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuadrantsTable> {
  $$QuadrantsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuadrantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuadrantsTable> {
  $$QuadrantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  Expression<T> emotionsRefs<T extends Object>(
    Expression<T> Function($$EmotionsTableAnnotationComposer a) f,
  ) {
    final $$EmotionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.emotions,
      getReferencedColumn: (t) => t.quadrantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmotionsTableAnnotationComposer(
            $db: $db,
            $table: $db.emotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$QuadrantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuadrantsTable,
          QuadrantRow,
          $$QuadrantsTableFilterComposer,
          $$QuadrantsTableOrderingComposer,
          $$QuadrantsTableAnnotationComposer,
          $$QuadrantsTableCreateCompanionBuilder,
          $$QuadrantsTableUpdateCompanionBuilder,
          (QuadrantRow, $$QuadrantsTableReferences),
          QuadrantRow,
          PrefetchHooks Function({bool emotionsRefs})
        > {
  $$QuadrantsTableTableManager(_$AppDatabase db, $QuadrantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuadrantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuadrantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuadrantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
              }) => QuadrantsCompanion(id: id, label: label),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String label}) =>
                  QuadrantsCompanion.insert(id: id, label: label),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$QuadrantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({emotionsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (emotionsRefs) db.emotions],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (emotionsRefs)
                    await $_getPrefetchedData<
                      QuadrantRow,
                      $QuadrantsTable,
                      EmotionRow
                    >(
                      currentTable: table,
                      referencedTable: $$QuadrantsTableReferences
                          ._emotionsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$QuadrantsTableReferences(
                            db,
                            table,
                            p0,
                          ).emotionsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.quadrantId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$QuadrantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuadrantsTable,
      QuadrantRow,
      $$QuadrantsTableFilterComposer,
      $$QuadrantsTableOrderingComposer,
      $$QuadrantsTableAnnotationComposer,
      $$QuadrantsTableCreateCompanionBuilder,
      $$QuadrantsTableUpdateCompanionBuilder,
      (QuadrantRow, $$QuadrantsTableReferences),
      QuadrantRow,
      PrefetchHooks Function({bool emotionsRefs})
    >;
typedef $$EmotionsTableCreateCompanionBuilder =
    EmotionsCompanion Function({
      Value<int> id,
      required String name,
      required int quadrantId,
    });
typedef $$EmotionsTableUpdateCompanionBuilder =
    EmotionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> quadrantId,
    });

final class $$EmotionsTableReferences
    extends BaseReferences<_$AppDatabase, $EmotionsTable, EmotionRow> {
  $$EmotionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $QuadrantsTable _quadrantIdTable(_$AppDatabase db) =>
      db.quadrants.createAlias(
        $_aliasNameGenerator(db.emotions.quadrantId, db.quadrants.id),
      );

  $$QuadrantsTableProcessedTableManager get quadrantId {
    final $_column = $_itemColumn<int>('quadrant_id')!;

    final manager = $$QuadrantsTableTableManager(
      $_db,
      $_db.quadrants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_quadrantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EntriesTable, List<EntryRow>> _entriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.entries,
    aliasName: $_aliasNameGenerator(db.emotions.id, db.entries.emotionId),
  );

  $$EntriesTableProcessedTableManager get entriesRefs {
    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.emotionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_entriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmotionsTableFilterComposer
    extends Composer<_$AppDatabase, $EmotionsTable> {
  $$EmotionsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  $$QuadrantsTableFilterComposer get quadrantId {
    final $$QuadrantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quadrantId,
      referencedTable: $db.quadrants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuadrantsTableFilterComposer(
            $db: $db,
            $table: $db.quadrants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> entriesRefs(
    Expression<bool> Function($$EntriesTableFilterComposer f) f,
  ) {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.emotionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmotionsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmotionsTable> {
  $$EmotionsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  $$QuadrantsTableOrderingComposer get quadrantId {
    final $$QuadrantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quadrantId,
      referencedTable: $db.quadrants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuadrantsTableOrderingComposer(
            $db: $db,
            $table: $db.quadrants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EmotionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmotionsTable> {
  $$EmotionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$QuadrantsTableAnnotationComposer get quadrantId {
    final $$QuadrantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.quadrantId,
      referencedTable: $db.quadrants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$QuadrantsTableAnnotationComposer(
            $db: $db,
            $table: $db.quadrants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> entriesRefs<T extends Object>(
    Expression<T> Function($$EntriesTableAnnotationComposer a) f,
  ) {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.emotionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmotionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmotionsTable,
          EmotionRow,
          $$EmotionsTableFilterComposer,
          $$EmotionsTableOrderingComposer,
          $$EmotionsTableAnnotationComposer,
          $$EmotionsTableCreateCompanionBuilder,
          $$EmotionsTableUpdateCompanionBuilder,
          (EmotionRow, $$EmotionsTableReferences),
          EmotionRow,
          PrefetchHooks Function({bool quadrantId, bool entriesRefs})
        > {
  $$EmotionsTableTableManager(_$AppDatabase db, $EmotionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmotionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmotionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmotionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> quadrantId = const Value.absent(),
              }) =>
                  EmotionsCompanion(id: id, name: name, quadrantId: quadrantId),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int quadrantId,
              }) => EmotionsCompanion.insert(
                id: id,
                name: name,
                quadrantId: quadrantId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmotionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({quadrantId = false, entriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entriesRefs) db.entries],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (quadrantId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.quadrantId,
                                referencedTable: $$EmotionsTableReferences
                                    ._quadrantIdTable(db),
                                referencedColumn: $$EmotionsTableReferences
                                    ._quadrantIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entriesRefs)
                    await $_getPrefetchedData<
                      EmotionRow,
                      $EmotionsTable,
                      EntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$EmotionsTableReferences
                          ._entriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EmotionsTableReferences(db, table, p0).entriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.emotionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EmotionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmotionsTable,
      EmotionRow,
      $$EmotionsTableFilterComposer,
      $$EmotionsTableOrderingComposer,
      $$EmotionsTableAnnotationComposer,
      $$EmotionsTableCreateCompanionBuilder,
      $$EmotionsTableUpdateCompanionBuilder,
      (EmotionRow, $$EmotionsTableReferences),
      EmotionRow,
      PrefetchHooks Function({bool quadrantId, bool entriesRefs})
    >;
typedef $$StagesTableCreateCompanionBuilder =
    StagesCompanion Function({
      Value<int> id,
      required String code,
      required String label,
    });
typedef $$StagesTableUpdateCompanionBuilder =
    StagesCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> label,
    });

final class $$StagesTableReferences
    extends BaseReferences<_$AppDatabase, $StagesTable, StageRow> {
  $$StagesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ParentsTable, List<ParentRow>> _parentsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.parents,
    aliasName: $_aliasNameGenerator(db.stages.id, db.parents.stageId),
  );

  $$ParentsTableProcessedTableManager get parentsRefs {
    final manager = $$ParentsTableTableManager(
      $_db,
      $_db.parents,
    ).filter((f) => f.stageId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_parentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StagesTableFilterComposer
    extends Composer<_$AppDatabase, $StagesTable> {
  $$StagesTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> parentsRefs(
    Expression<bool> Function($$ParentsTableFilterComposer f) f,
  ) {
    final $$ParentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parents,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParentsTableFilterComposer(
            $db: $db,
            $table: $db.parents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StagesTableOrderingComposer
    extends Composer<_$AppDatabase, $StagesTable> {
  $$StagesTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StagesTable> {
  $$StagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  Expression<T> parentsRefs<T extends Object>(
    Expression<T> Function($$ParentsTableAnnotationComposer a) f,
  ) {
    final $$ParentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.parents,
      getReferencedColumn: (t) => t.stageId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParentsTableAnnotationComposer(
            $db: $db,
            $table: $db.parents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StagesTable,
          StageRow,
          $$StagesTableFilterComposer,
          $$StagesTableOrderingComposer,
          $$StagesTableAnnotationComposer,
          $$StagesTableCreateCompanionBuilder,
          $$StagesTableUpdateCompanionBuilder,
          (StageRow, $$StagesTableReferences),
          StageRow,
          PrefetchHooks Function({bool parentsRefs})
        > {
  $$StagesTableTableManager(_$AppDatabase db, $StagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> label = const Value.absent(),
              }) => StagesCompanion(id: id, code: code, label: label),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String label,
              }) => StagesCompanion.insert(id: id, code: code, label: label),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$StagesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({parentsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (parentsRefs) db.parents],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (parentsRefs)
                    await $_getPrefetchedData<
                      StageRow,
                      $StagesTable,
                      ParentRow
                    >(
                      currentTable: table,
                      referencedTable: $$StagesTableReferences
                          ._parentsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$StagesTableReferences(db, table, p0).parentsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.stageId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StagesTable,
      StageRow,
      $$StagesTableFilterComposer,
      $$StagesTableOrderingComposer,
      $$StagesTableAnnotationComposer,
      $$StagesTableCreateCompanionBuilder,
      $$StagesTableUpdateCompanionBuilder,
      (StageRow, $$StagesTableReferences),
      StageRow,
      PrefetchHooks Function({bool parentsRefs})
    >;
typedef $$ActivitiesTableCreateCompanionBuilder =
    ActivitiesCompanion Function({Value<int> id, required String label});
typedef $$ActivitiesTableUpdateCompanionBuilder =
    ActivitiesCompanion Function({Value<int> id, Value<String> label});

final class $$ActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $ActivitiesTable, ActivityRow> {
  $$ActivitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntriesTable, List<EntryRow>> _entriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.entries,
    aliasName: $_aliasNameGenerator(db.activities.id, db.entries.activityId),
  );

  $$EntriesTableProcessedTableManager get entriesRefs {
    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_entriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> entriesRefs(
    Expression<bool> Function($$EntriesTableFilterComposer f) f,
  ) {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  Expression<T> entriesRefs<T extends Object>(
    Expression<T> Function($$EntriesTableAnnotationComposer a) f,
  ) {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          ActivityRow,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (ActivityRow, $$ActivitiesTableReferences),
          ActivityRow,
          PrefetchHooks Function({bool entriesRefs})
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
              }) => ActivitiesCompanion(id: id, label: label),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String label}) =>
                  ActivitiesCompanion.insert(id: id, label: label),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entriesRefs) db.entries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entriesRefs)
                    await $_getPrefetchedData<
                      ActivityRow,
                      $ActivitiesTable,
                      EntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$ActivitiesTableReferences
                          ._entriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ActivitiesTableReferences(
                            db,
                            table,
                            p0,
                          ).entriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.activityId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      ActivityRow,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (ActivityRow, $$ActivitiesTableReferences),
      ActivityRow,
      PrefetchHooks Function({bool entriesRefs})
    >;
typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({Value<int> id, required String label});
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({Value<int> id, Value<String> label});

final class $$LocationsTableReferences
    extends BaseReferences<_$AppDatabase, $LocationsTable, LocationRow> {
  $$LocationsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$EntriesTable, List<EntryRow>> _entriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.entries,
    aliasName: $_aliasNameGenerator(db.locations.id, db.entries.locationId),
  );

  $$EntriesTableProcessedTableManager get entriesRefs {
    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.locationId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_entriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LocationsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
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

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> entriesRefs(
    Expression<bool> Function($$EntriesTableFilterComposer f) f,
  ) {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
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

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  Expression<T> entriesRefs<T extends Object>(
    Expression<T> Function($$EntriesTableAnnotationComposer a) f,
  ) {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.locationId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationsTable,
          LocationRow,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (LocationRow, $$LocationsTableReferences),
          LocationRow,
          PrefetchHooks Function({bool entriesRefs})
        > {
  $$LocationsTableTableManager(_$AppDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> label = const Value.absent(),
              }) => LocationsCompanion(id: id, label: label),
          createCompanionCallback:
              ({Value<int> id = const Value.absent(), required String label}) =>
                  LocationsCompanion.insert(id: id, label: label),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$LocationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({entriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entriesRefs) db.entries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entriesRefs)
                    await $_getPrefetchedData<
                      LocationRow,
                      $LocationsTable,
                      EntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$LocationsTableReferences
                          ._entriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LocationsTableReferences(db, table, p0).entriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.locationId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationsTable,
      LocationRow,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (LocationRow, $$LocationsTableReferences),
      LocationRow,
      PrefetchHooks Function({bool entriesRefs})
    >;
typedef $$ParentsTableCreateCompanionBuilder =
    ParentsCompanion Function({
      Value<int> id,
      required String firstName,
      required String babyFirstName,
      required DateTime babyBirthDate,
      required int gestationalAgeWeeks,
      required int stageId,
      Value<int?> coparentId,
      Value<bool> sharingConsent,
      Value<DateTime> createdAt,
    });
typedef $$ParentsTableUpdateCompanionBuilder =
    ParentsCompanion Function({
      Value<int> id,
      Value<String> firstName,
      Value<String> babyFirstName,
      Value<DateTime> babyBirthDate,
      Value<int> gestationalAgeWeeks,
      Value<int> stageId,
      Value<int?> coparentId,
      Value<bool> sharingConsent,
      Value<DateTime> createdAt,
    });

final class $$ParentsTableReferences
    extends BaseReferences<_$AppDatabase, $ParentsTable, ParentRow> {
  $$ParentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StagesTable _stageIdTable(_$AppDatabase db) => db.stages.createAlias(
    $_aliasNameGenerator(db.parents.stageId, db.stages.id),
  );

  $$StagesTableProcessedTableManager get stageId {
    final $_column = $_itemColumn<int>('stage_id')!;

    final manager = $$StagesTableTableManager(
      $_db,
      $_db.stages,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stageIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EntriesTable, List<EntryRow>> _entriesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.entries,
    aliasName: $_aliasNameGenerator(db.parents.id, db.entries.parentId),
  );

  $$EntriesTableProcessedTableManager get entriesRefs {
    final manager = $$EntriesTableTableManager(
      $_db,
      $_db.entries,
    ).filter((f) => f.parentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_entriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ParentsTableFilterComposer
    extends Composer<_$AppDatabase, $ParentsTable> {
  $$ParentsTableFilterComposer({
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

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get babyFirstName => $composableBuilder(
    column: $table.babyFirstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get babyBirthDate => $composableBuilder(
    column: $table.babyBirthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get gestationalAgeWeeks => $composableBuilder(
    column: $table.gestationalAgeWeeks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coparentId => $composableBuilder(
    column: $table.coparentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sharingConsent => $composableBuilder(
    column: $table.sharingConsent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$StagesTableFilterComposer get stageId {
    final $$StagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.stages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagesTableFilterComposer(
            $db: $db,
            $table: $db.stages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> entriesRefs(
    Expression<bool> Function($$EntriesTableFilterComposer f) f,
  ) {
    final $$EntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.parentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableFilterComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ParentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ParentsTable> {
  $$ParentsTableOrderingComposer({
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

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get babyFirstName => $composableBuilder(
    column: $table.babyFirstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get babyBirthDate => $composableBuilder(
    column: $table.babyBirthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get gestationalAgeWeeks => $composableBuilder(
    column: $table.gestationalAgeWeeks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coparentId => $composableBuilder(
    column: $table.coparentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sharingConsent => $composableBuilder(
    column: $table.sharingConsent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$StagesTableOrderingComposer get stageId {
    final $$StagesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.stages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagesTableOrderingComposer(
            $db: $db,
            $table: $db.stages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ParentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ParentsTable> {
  $$ParentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get babyFirstName => $composableBuilder(
    column: $table.babyFirstName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get babyBirthDate => $composableBuilder(
    column: $table.babyBirthDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get gestationalAgeWeeks => $composableBuilder(
    column: $table.gestationalAgeWeeks,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coparentId => $composableBuilder(
    column: $table.coparentId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sharingConsent => $composableBuilder(
    column: $table.sharingConsent,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$StagesTableAnnotationComposer get stageId {
    final $$StagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stageId,
      referencedTable: $db.stages,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StagesTableAnnotationComposer(
            $db: $db,
            $table: $db.stages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> entriesRefs<T extends Object>(
    Expression<T> Function($$EntriesTableAnnotationComposer a) f,
  ) {
    final $$EntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.entries,
      getReferencedColumn: (t) => t.parentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.entries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ParentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ParentsTable,
          ParentRow,
          $$ParentsTableFilterComposer,
          $$ParentsTableOrderingComposer,
          $$ParentsTableAnnotationComposer,
          $$ParentsTableCreateCompanionBuilder,
          $$ParentsTableUpdateCompanionBuilder,
          (ParentRow, $$ParentsTableReferences),
          ParentRow,
          PrefetchHooks Function({bool stageId, bool entriesRefs})
        > {
  $$ParentsTableTableManager(_$AppDatabase db, $ParentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ParentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ParentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ParentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> babyFirstName = const Value.absent(),
                Value<DateTime> babyBirthDate = const Value.absent(),
                Value<int> gestationalAgeWeeks = const Value.absent(),
                Value<int> stageId = const Value.absent(),
                Value<int?> coparentId = const Value.absent(),
                Value<bool> sharingConsent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ParentsCompanion(
                id: id,
                firstName: firstName,
                babyFirstName: babyFirstName,
                babyBirthDate: babyBirthDate,
                gestationalAgeWeeks: gestationalAgeWeeks,
                stageId: stageId,
                coparentId: coparentId,
                sharingConsent: sharingConsent,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String firstName,
                required String babyFirstName,
                required DateTime babyBirthDate,
                required int gestationalAgeWeeks,
                required int stageId,
                Value<int?> coparentId = const Value.absent(),
                Value<bool> sharingConsent = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ParentsCompanion.insert(
                id: id,
                firstName: firstName,
                babyFirstName: babyFirstName,
                babyBirthDate: babyBirthDate,
                gestationalAgeWeeks: gestationalAgeWeeks,
                stageId: stageId,
                coparentId: coparentId,
                sharingConsent: sharingConsent,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ParentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({stageId = false, entriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (entriesRefs) db.entries],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (stageId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.stageId,
                                referencedTable: $$ParentsTableReferences
                                    ._stageIdTable(db),
                                referencedColumn: $$ParentsTableReferences
                                    ._stageIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (entriesRefs)
                    await $_getPrefetchedData<
                      ParentRow,
                      $ParentsTable,
                      EntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$ParentsTableReferences
                          ._entriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ParentsTableReferences(db, table, p0).entriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.parentId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ParentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ParentsTable,
      ParentRow,
      $$ParentsTableFilterComposer,
      $$ParentsTableOrderingComposer,
      $$ParentsTableAnnotationComposer,
      $$ParentsTableCreateCompanionBuilder,
      $$ParentsTableUpdateCompanionBuilder,
      (ParentRow, $$ParentsTableReferences),
      ParentRow,
      PrefetchHooks Function({bool stageId, bool entriesRefs})
    >;
typedef $$EntriesTableCreateCompanionBuilder =
    EntriesCompanion Function({
      Value<int> id,
      required int parentId,
      required int emotionId,
      required int intensity,
      Value<int?> activityId,
      Value<int?> locationId,
      Value<DateTime> createdAt,
    });
typedef $$EntriesTableUpdateCompanionBuilder =
    EntriesCompanion Function({
      Value<int> id,
      Value<int> parentId,
      Value<int> emotionId,
      Value<int> intensity,
      Value<int?> activityId,
      Value<int?> locationId,
      Value<DateTime> createdAt,
    });

final class $$EntriesTableReferences
    extends BaseReferences<_$AppDatabase, $EntriesTable, EntryRow> {
  $$EntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ParentsTable _parentIdTable(_$AppDatabase db) => db.parents
      .createAlias($_aliasNameGenerator(db.entries.parentId, db.parents.id));

  $$ParentsTableProcessedTableManager get parentId {
    final $_column = $_itemColumn<int>('parent_id')!;

    final manager = $$ParentsTableTableManager(
      $_db,
      $_db.parents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmotionsTable _emotionIdTable(_$AppDatabase db) => db.emotions
      .createAlias($_aliasNameGenerator(db.entries.emotionId, db.emotions.id));

  $$EmotionsTableProcessedTableManager get emotionId {
    final $_column = $_itemColumn<int>('emotion_id')!;

    final manager = $$EmotionsTableTableManager(
      $_db,
      $_db.emotions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_emotionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias(
        $_aliasNameGenerator(db.entries.activityId, db.activities.id),
      );

  $$ActivitiesTableProcessedTableManager? get activityId {
    final $_column = $_itemColumn<int>('activity_id');
    if ($_column == null) return null;
    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LocationsTable _locationIdTable(_$AppDatabase db) =>
      db.locations.createAlias(
        $_aliasNameGenerator(db.entries.locationId, db.locations.id),
      );

  $$LocationsTableProcessedTableManager? get locationId {
    final $_column = $_itemColumn<int>('location_id');
    if ($_column == null) return null;
    final manager = $$LocationsTableTableManager(
      $_db,
      $_db.locations,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_locationIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EntriesTableFilterComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableFilterComposer({
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

  ColumnFilters<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ParentsTableFilterComposer get parentId {
    final $$ParentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.parents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParentsTableFilterComposer(
            $db: $db,
            $table: $db.parents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmotionsTableFilterComposer get emotionId {
    final $$EmotionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emotionId,
      referencedTable: $db.emotions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmotionsTableFilterComposer(
            $db: $db,
            $table: $db.emotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableFilterComposer get locationId {
    final $$LocationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableFilterComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableOrderingComposer({
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

  ColumnOrderings<int> get intensity => $composableBuilder(
    column: $table.intensity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ParentsTableOrderingComposer get parentId {
    final $$ParentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.parents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParentsTableOrderingComposer(
            $db: $db,
            $table: $db.parents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmotionsTableOrderingComposer get emotionId {
    final $$EmotionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emotionId,
      referencedTable: $db.emotions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmotionsTableOrderingComposer(
            $db: $db,
            $table: $db.emotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableOrderingComposer get locationId {
    final $$LocationsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableOrderingComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EntriesTable> {
  $$EntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get intensity =>
      $composableBuilder(column: $table.intensity, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ParentsTableAnnotationComposer get parentId {
    final $$ParentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.parents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ParentsTableAnnotationComposer(
            $db: $db,
            $table: $db.parents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmotionsTableAnnotationComposer get emotionId {
    final $$EmotionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.emotionId,
      referencedTable: $db.emotions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmotionsTableAnnotationComposer(
            $db: $db,
            $table: $db.emotions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LocationsTableAnnotationComposer get locationId {
    final $$LocationsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.locationId,
      referencedTable: $db.locations,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LocationsTableAnnotationComposer(
            $db: $db,
            $table: $db.locations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EntriesTable,
          EntryRow,
          $$EntriesTableFilterComposer,
          $$EntriesTableOrderingComposer,
          $$EntriesTableAnnotationComposer,
          $$EntriesTableCreateCompanionBuilder,
          $$EntriesTableUpdateCompanionBuilder,
          (EntryRow, $$EntriesTableReferences),
          EntryRow,
          PrefetchHooks Function({
            bool parentId,
            bool emotionId,
            bool activityId,
            bool locationId,
          })
        > {
  $$EntriesTableTableManager(_$AppDatabase db, $EntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> parentId = const Value.absent(),
                Value<int> emotionId = const Value.absent(),
                Value<int> intensity = const Value.absent(),
                Value<int?> activityId = const Value.absent(),
                Value<int?> locationId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EntriesCompanion(
                id: id,
                parentId: parentId,
                emotionId: emotionId,
                intensity: intensity,
                activityId: activityId,
                locationId: locationId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int parentId,
                required int emotionId,
                required int intensity,
                Value<int?> activityId = const Value.absent(),
                Value<int?> locationId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => EntriesCompanion.insert(
                id: id,
                parentId: parentId,
                emotionId: emotionId,
                intensity: intensity,
                activityId: activityId,
                locationId: locationId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                emotionId = false,
                activityId = false,
                locationId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.parentId,
                                    referencedTable: $$EntriesTableReferences
                                        ._parentIdTable(db),
                                    referencedColumn: $$EntriesTableReferences
                                        ._parentIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (emotionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.emotionId,
                                    referencedTable: $$EntriesTableReferences
                                        ._emotionIdTable(db),
                                    referencedColumn: $$EntriesTableReferences
                                        ._emotionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (activityId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.activityId,
                                    referencedTable: $$EntriesTableReferences
                                        ._activityIdTable(db),
                                    referencedColumn: $$EntriesTableReferences
                                        ._activityIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (locationId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.locationId,
                                    referencedTable: $$EntriesTableReferences
                                        ._locationIdTable(db),
                                    referencedColumn: $$EntriesTableReferences
                                        ._locationIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$EntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EntriesTable,
      EntryRow,
      $$EntriesTableFilterComposer,
      $$EntriesTableOrderingComposer,
      $$EntriesTableAnnotationComposer,
      $$EntriesTableCreateCompanionBuilder,
      $$EntriesTableUpdateCompanionBuilder,
      (EntryRow, $$EntriesTableReferences),
      EntryRow,
      PrefetchHooks Function({
        bool parentId,
        bool emotionId,
        bool activityId,
        bool locationId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuadrantsTableTableManager get quadrants =>
      $$QuadrantsTableTableManager(_db, _db.quadrants);
  $$EmotionsTableTableManager get emotions =>
      $$EmotionsTableTableManager(_db, _db.emotions);
  $$StagesTableTableManager get stages =>
      $$StagesTableTableManager(_db, _db.stages);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$ParentsTableTableManager get parents =>
      $$ParentsTableTableManager(_db, _db.parents);
  $$EntriesTableTableManager get entries =>
      $$EntriesTableTableManager(_db, _db.entries);
}
