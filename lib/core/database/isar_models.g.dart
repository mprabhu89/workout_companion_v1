// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_models.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarExerciseRecordCollection on Isar {
  IsarCollection<IsarExerciseRecord> get isarExerciseRecords =>
      this.collection();
}

const IsarExerciseRecordSchema = CollectionSchema(
  name: r'IsarExerciseRecord',
  id: -8192706539405338074,
  properties: {
    r'description': PropertySchema(
      id: 0,
      name: r'description',
      type: IsarType.string,
    ),
    r'difficultyName': PropertySchema(
      id: 1,
      name: r'difficultyName',
      type: IsarType.string,
    ),
    r'equipmentName': PropertySchema(
      id: 2,
      name: r'equipmentName',
      type: IsarType.string,
    ),
    r'id': PropertySchema(id: 3, name: r'id', type: IsarType.string),
    r'instructions': PropertySchema(
      id: 4,
      name: r'instructions',
      type: IsarType.string,
    ),
    r'isArchived': PropertySchema(
      id: 5,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'isCustom': PropertySchema(id: 6, name: r'isCustom', type: IsarType.bool),
    r'muscleGroupName': PropertySchema(
      id: 7,
      name: r'muscleGroupName',
      type: IsarType.string,
    ),
    r'name': PropertySchema(id: 8, name: r'name', type: IsarType.string),
  },

  estimateSize: _isarExerciseRecordEstimateSize,
  serialize: _isarExerciseRecordSerialize,
  deserialize: _isarExerciseRecordDeserialize,
  deserializeProp: _isarExerciseRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _isarExerciseRecordGetId,
  getLinks: _isarExerciseRecordGetLinks,
  attach: _isarExerciseRecordAttach,
  version: '3.3.2',
);

int _isarExerciseRecordEstimateSize(
  IsarExerciseRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.difficultyName.length * 3;
  bytesCount += 3 + object.equipmentName.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.instructions.length * 3;
  bytesCount += 3 + object.muscleGroupName.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _isarExerciseRecordSerialize(
  IsarExerciseRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.description);
  writer.writeString(offsets[1], object.difficultyName);
  writer.writeString(offsets[2], object.equipmentName);
  writer.writeString(offsets[3], object.id);
  writer.writeString(offsets[4], object.instructions);
  writer.writeBool(offsets[5], object.isArchived);
  writer.writeBool(offsets[6], object.isCustom);
  writer.writeString(offsets[7], object.muscleGroupName);
  writer.writeString(offsets[8], object.name);
}

IsarExerciseRecord _isarExerciseRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarExerciseRecord();
  object.description = reader.readString(offsets[0]);
  object.difficultyName = reader.readString(offsets[1]);
  object.equipmentName = reader.readString(offsets[2]);
  object.id = reader.readString(offsets[3]);
  object.instructions = reader.readString(offsets[4]);
  object.isArchived = reader.readBool(offsets[5]);
  object.isCustom = reader.readBool(offsets[6]);
  object.isarId = id;
  object.muscleGroupName = reader.readString(offsets[7]);
  object.name = reader.readString(offsets[8]);
  return object;
}

P _isarExerciseRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarExerciseRecordGetId(IsarExerciseRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _isarExerciseRecordGetLinks(
  IsarExerciseRecord object,
) {
  return [];
}

void _isarExerciseRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarExerciseRecord object,
) {
  object.isarId = id;
}

extension IsarExerciseRecordByIndex on IsarCollection<IsarExerciseRecord> {
  Future<IsarExerciseRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  IsarExerciseRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<IsarExerciseRecord?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<IsarExerciseRecord?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(IsarExerciseRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(IsarExerciseRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<IsarExerciseRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(
    List<IsarExerciseRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension IsarExerciseRecordQueryWhereSort
    on QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QWhere> {
  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterWhere>
  anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarExerciseRecordQueryWhere
    on QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QWhereClause> {
  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterWhereClause>
  isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterWhereClause>
  isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterWhereClause>
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterWhereClause>
  isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterWhereClause>
  isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerIsarId,
          includeLower: includeLower,
          upper: upperIsarId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterWhereClause>
  idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'id', value: [id]),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterWhereClause>
  idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension IsarExerciseRecordQueryFilter
    on QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QFilterCondition> {
  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'difficultyName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'difficultyName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'difficultyName', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  difficultyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'difficultyName', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'equipmentName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'equipmentName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'equipmentName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'equipmentName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'equipmentName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'equipmentName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'equipmentName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'equipmentName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'equipmentName', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  equipmentNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'equipmentName', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'id',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'instructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'instructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'instructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'instructions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'instructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'instructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'instructions',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'instructions',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'instructions', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  instructionsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'instructions', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isArchived', value: value),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  isCustomEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCustom', value: value),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  isarIdGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  isarIdLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isarId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'muscleGroupName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'muscleGroupName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'muscleGroupName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'muscleGroupName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'muscleGroupName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'muscleGroupName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'muscleGroupName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'muscleGroupName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'muscleGroupName', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  muscleGroupNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'muscleGroupName', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }
}

extension IsarExerciseRecordQueryObject
    on QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QFilterCondition> {}

extension IsarExerciseRecordQueryLinks
    on QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QFilterCondition> {}

extension IsarExerciseRecordQuerySortBy
    on QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QSortBy> {
  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByDifficultyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyName', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByDifficultyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyName', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByEquipmentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipmentName', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByEquipmentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipmentName', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByInstructions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructions', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByInstructionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructions', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByMuscleGroupName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroupName', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByMuscleGroupNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroupName', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsarExerciseRecordQuerySortThenBy
    on QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QSortThenBy> {
  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByDifficultyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyName', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByDifficultyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyName', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByEquipmentName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipmentName', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByEquipmentNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'equipmentName', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByInstructions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructions', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByInstructionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'instructions', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByIsCustomDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustom', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByMuscleGroupName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroupName', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByMuscleGroupNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleGroupName', Sort.desc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsarExerciseRecordQueryWhereDistinct
    on QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct> {
  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct>
  distinctByDifficultyName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'difficultyName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct>
  distinctByEquipmentName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'equipmentName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct> distinctById({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct>
  distinctByInstructions({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'instructions', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct>
  distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct>
  distinctByIsCustom() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCustom');
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct>
  distinctByMuscleGroupName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'muscleGroupName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension IsarExerciseRecordQueryProperty
    on QueryBuilder<IsarExerciseRecord, IsarExerciseRecord, QQueryProperty> {
  QueryBuilder<IsarExerciseRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<IsarExerciseRecord, String, QQueryOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<IsarExerciseRecord, String, QQueryOperations>
  difficultyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficultyName');
    });
  }

  QueryBuilder<IsarExerciseRecord, String, QQueryOperations>
  equipmentNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'equipmentName');
    });
  }

  QueryBuilder<IsarExerciseRecord, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarExerciseRecord, String, QQueryOperations>
  instructionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'instructions');
    });
  }

  QueryBuilder<IsarExerciseRecord, bool, QQueryOperations>
  isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<IsarExerciseRecord, bool, QQueryOperations> isCustomProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCustom');
    });
  }

  QueryBuilder<IsarExerciseRecord, String, QQueryOperations>
  muscleGroupNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleGroupName');
    });
  }

  QueryBuilder<IsarExerciseRecord, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarWorkoutPlanRecordCollection on Isar {
  IsarCollection<IsarWorkoutPlanRecord> get isarWorkoutPlanRecords =>
      this.collection();
}

const IsarWorkoutPlanRecordSchema = CollectionSchema(
  name: r'IsarWorkoutPlanRecord',
  id: -1157997486701606071,
  properties: {
    r'categoryName': PropertySchema(
      id: 0,
      name: r'categoryName',
      type: IsarType.string,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'difficultyName': PropertySchema(
      id: 2,
      name: r'difficultyName',
      type: IsarType.string,
    ),
    r'estimatedDurationInMinutes': PropertySchema(
      id: 3,
      name: r'estimatedDurationInMinutes',
      type: IsarType.long,
    ),
    r'id': PropertySchema(id: 4, name: r'id', type: IsarType.string),
    r'isArchived': PropertySchema(
      id: 5,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(id: 6, name: r'name', type: IsarType.string),
  },

  estimateSize: _isarWorkoutPlanRecordEstimateSize,
  serialize: _isarWorkoutPlanRecordSerialize,
  deserialize: _isarWorkoutPlanRecordDeserialize,
  deserializeProp: _isarWorkoutPlanRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _isarWorkoutPlanRecordGetId,
  getLinks: _isarWorkoutPlanRecordGetLinks,
  attach: _isarWorkoutPlanRecordAttach,
  version: '3.3.2',
);

int _isarWorkoutPlanRecordEstimateSize(
  IsarWorkoutPlanRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryName.length * 3;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.difficultyName.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _isarWorkoutPlanRecordSerialize(
  IsarWorkoutPlanRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categoryName);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.difficultyName);
  writer.writeLong(offsets[3], object.estimatedDurationInMinutes);
  writer.writeString(offsets[4], object.id);
  writer.writeBool(offsets[5], object.isArchived);
  writer.writeString(offsets[6], object.name);
}

IsarWorkoutPlanRecord _isarWorkoutPlanRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarWorkoutPlanRecord();
  object.categoryName = reader.readString(offsets[0]);
  object.description = reader.readString(offsets[1]);
  object.difficultyName = reader.readString(offsets[2]);
  object.estimatedDurationInMinutes = reader.readLong(offsets[3]);
  object.id = reader.readString(offsets[4]);
  object.isArchived = reader.readBool(offsets[5]);
  object.isarId = id;
  object.name = reader.readString(offsets[6]);
  return object;
}

P _isarWorkoutPlanRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarWorkoutPlanRecordGetId(IsarWorkoutPlanRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _isarWorkoutPlanRecordGetLinks(
  IsarWorkoutPlanRecord object,
) {
  return [];
}

void _isarWorkoutPlanRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarWorkoutPlanRecord object,
) {
  object.isarId = id;
}

extension IsarWorkoutPlanRecordByIndex
    on IsarCollection<IsarWorkoutPlanRecord> {
  Future<IsarWorkoutPlanRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  IsarWorkoutPlanRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<IsarWorkoutPlanRecord?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<IsarWorkoutPlanRecord?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(IsarWorkoutPlanRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(IsarWorkoutPlanRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<IsarWorkoutPlanRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(
    List<IsarWorkoutPlanRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension IsarWorkoutPlanRecordQueryWhereSort
    on QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QWhere> {
  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterWhere>
  anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarWorkoutPlanRecordQueryWhere
    on
        QueryBuilder<
          IsarWorkoutPlanRecord,
          IsarWorkoutPlanRecord,
          QWhereClause
        > {
  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterWhereClause>
  isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterWhereClause>
  isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterWhereClause>
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterWhereClause>
  isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterWhereClause>
  isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerIsarId,
          includeLower: includeLower,
          upper: upperIsarId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterWhereClause>
  idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'id', value: [id]),
      );
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterWhereClause>
  idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension IsarWorkoutPlanRecordQueryFilter
    on
        QueryBuilder<
          IsarWorkoutPlanRecord,
          IsarWorkoutPlanRecord,
          QFilterCondition
        > {
  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'categoryName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'categoryName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'categoryName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'categoryName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  categoryNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'categoryName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'difficultyName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'difficultyName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'difficultyName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'difficultyName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  difficultyNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'difficultyName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  estimatedDurationInMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'estimatedDurationInMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  estimatedDurationInMinutesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'estimatedDurationInMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  estimatedDurationInMinutesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'estimatedDurationInMinutes',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  estimatedDurationInMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'estimatedDurationInMinutes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'id',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isArchived', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  isarIdGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  isarIdLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isarId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutPlanRecord,
    IsarWorkoutPlanRecord,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }
}

extension IsarWorkoutPlanRecordQueryObject
    on
        QueryBuilder<
          IsarWorkoutPlanRecord,
          IsarWorkoutPlanRecord,
          QFilterCondition
        > {}

extension IsarWorkoutPlanRecordQueryLinks
    on
        QueryBuilder<
          IsarWorkoutPlanRecord,
          IsarWorkoutPlanRecord,
          QFilterCondition
        > {}

extension IsarWorkoutPlanRecordQuerySortBy
    on QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QSortBy> {
  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByDifficultyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyName', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByDifficultyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyName', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByEstimatedDurationInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedDurationInMinutes', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByEstimatedDurationInMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedDurationInMinutes', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsarWorkoutPlanRecordQuerySortThenBy
    on QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QSortThenBy> {
  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByCategoryName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByCategoryNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryName', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByDifficultyName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyName', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByDifficultyNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'difficultyName', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByEstimatedDurationInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedDurationInMinutes', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByEstimatedDurationInMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'estimatedDurationInMinutes', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsarWorkoutPlanRecordQueryWhereDistinct
    on QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QDistinct> {
  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QDistinct>
  distinctByCategoryName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QDistinct>
  distinctByDifficultyName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'difficultyName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QDistinct>
  distinctByEstimatedDurationInMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'estimatedDurationInMinutes');
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QDistinct>
  distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QDistinct>
  distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, IsarWorkoutPlanRecord, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension IsarWorkoutPlanRecordQueryProperty
    on
        QueryBuilder<
          IsarWorkoutPlanRecord,
          IsarWorkoutPlanRecord,
          QQueryProperty
        > {
  QueryBuilder<IsarWorkoutPlanRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, String, QQueryOperations>
  categoryNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryName');
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, String, QQueryOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, String, QQueryOperations>
  difficultyNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'difficultyName');
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, int, QQueryOperations>
  estimatedDurationInMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'estimatedDurationInMinutes');
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, bool, QQueryOperations>
  isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<IsarWorkoutPlanRecord, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarWorkoutDayRecordCollection on Isar {
  IsarCollection<IsarWorkoutDayRecord> get isarWorkoutDayRecords =>
      this.collection();
}

const IsarWorkoutDayRecordSchema = CollectionSchema(
  name: r'IsarWorkoutDayRecord',
  id: 1082807866787477039,
  properties: {
    r'dayNumber': PropertySchema(
      id: 0,
      name: r'dayNumber',
      type: IsarType.long,
    ),
    r'description': PropertySchema(
      id: 1,
      name: r'description',
      type: IsarType.string,
    ),
    r'id': PropertySchema(id: 2, name: r'id', type: IsarType.string),
    r'isArchived': PropertySchema(
      id: 3,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'isRestDay': PropertySchema(
      id: 4,
      name: r'isRestDay',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(id: 5, name: r'name', type: IsarType.string),
    r'workoutPlanId': PropertySchema(
      id: 6,
      name: r'workoutPlanId',
      type: IsarType.string,
    ),
  },

  estimateSize: _isarWorkoutDayRecordEstimateSize,
  serialize: _isarWorkoutDayRecordSerialize,
  deserialize: _isarWorkoutDayRecordDeserialize,
  deserializeProp: _isarWorkoutDayRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'workoutPlanId': IndexSchema(
      id: -7046368611050782311,
      name: r'workoutPlanId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workoutPlanId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _isarWorkoutDayRecordGetId,
  getLinks: _isarWorkoutDayRecordGetLinks,
  attach: _isarWorkoutDayRecordAttach,
  version: '3.3.2',
);

int _isarWorkoutDayRecordEstimateSize(
  IsarWorkoutDayRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.description.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.workoutPlanId.length * 3;
  return bytesCount;
}

void _isarWorkoutDayRecordSerialize(
  IsarWorkoutDayRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.dayNumber);
  writer.writeString(offsets[1], object.description);
  writer.writeString(offsets[2], object.id);
  writer.writeBool(offsets[3], object.isArchived);
  writer.writeBool(offsets[4], object.isRestDay);
  writer.writeString(offsets[5], object.name);
  writer.writeString(offsets[6], object.workoutPlanId);
}

IsarWorkoutDayRecord _isarWorkoutDayRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarWorkoutDayRecord();
  object.dayNumber = reader.readLong(offsets[0]);
  object.description = reader.readString(offsets[1]);
  object.id = reader.readString(offsets[2]);
  object.isArchived = reader.readBool(offsets[3]);
  object.isRestDay = reader.readBool(offsets[4]);
  object.isarId = id;
  object.name = reader.readString(offsets[5]);
  object.workoutPlanId = reader.readString(offsets[6]);
  return object;
}

P _isarWorkoutDayRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarWorkoutDayRecordGetId(IsarWorkoutDayRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _isarWorkoutDayRecordGetLinks(
  IsarWorkoutDayRecord object,
) {
  return [];
}

void _isarWorkoutDayRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarWorkoutDayRecord object,
) {
  object.isarId = id;
}

extension IsarWorkoutDayRecordByIndex on IsarCollection<IsarWorkoutDayRecord> {
  Future<IsarWorkoutDayRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  IsarWorkoutDayRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<IsarWorkoutDayRecord?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<IsarWorkoutDayRecord?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(IsarWorkoutDayRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(IsarWorkoutDayRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<IsarWorkoutDayRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(
    List<IsarWorkoutDayRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension IsarWorkoutDayRecordQueryWhereSort
    on QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QWhere> {
  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhere>
  anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarWorkoutDayRecordQueryWhere
    on QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QWhereClause> {
  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhereClause>
  isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhereClause>
  isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhereClause>
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhereClause>
  isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhereClause>
  isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerIsarId,
          includeLower: includeLower,
          upper: upperIsarId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhereClause>
  idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'id', value: [id]),
      );
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhereClause>
  idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhereClause>
  workoutPlanIdEqualTo(String workoutPlanId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'workoutPlanId',
          value: [workoutPlanId],
        ),
      );
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterWhereClause>
  workoutPlanIdNotEqualTo(String workoutPlanId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutPlanId',
                lower: [],
                upper: [workoutPlanId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutPlanId',
                lower: [workoutPlanId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutPlanId',
                lower: [workoutPlanId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutPlanId',
                lower: [],
                upper: [workoutPlanId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension IsarWorkoutDayRecordQueryFilter
    on
        QueryBuilder<
          IsarWorkoutDayRecord,
          IsarWorkoutDayRecord,
          QFilterCondition
        > {
  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  dayNumberEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dayNumber', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  dayNumberGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'dayNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  dayNumberLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'dayNumber',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  dayNumberBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'dayNumber',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'description',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'description',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'description',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'description', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'id',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isArchived', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  isRestDayEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isRestDay', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  isarIdGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  isarIdLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isarId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workoutPlanId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'workoutPlanId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workoutPlanId', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutDayRecord,
    IsarWorkoutDayRecord,
    QAfterFilterCondition
  >
  workoutPlanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'workoutPlanId', value: ''),
      );
    });
  }
}

extension IsarWorkoutDayRecordQueryObject
    on
        QueryBuilder<
          IsarWorkoutDayRecord,
          IsarWorkoutDayRecord,
          QFilterCondition
        > {}

extension IsarWorkoutDayRecordQueryLinks
    on
        QueryBuilder<
          IsarWorkoutDayRecord,
          IsarWorkoutDayRecord,
          QFilterCondition
        > {}

extension IsarWorkoutDayRecordQuerySortBy
    on QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QSortBy> {
  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByIsRestDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRestDay', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByIsRestDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRestDay', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByWorkoutPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanId', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  sortByWorkoutPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanId', Sort.desc);
    });
  }
}

extension IsarWorkoutDayRecordQuerySortThenBy
    on QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QSortThenBy> {
  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByDayNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dayNumber', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByIsRestDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRestDay', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByIsRestDayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRestDay', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByWorkoutPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanId', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QAfterSortBy>
  thenByWorkoutPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanId', Sort.desc);
    });
  }
}

extension IsarWorkoutDayRecordQueryWhereDistinct
    on QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QDistinct> {
  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QDistinct>
  distinctByDayNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dayNumber');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QDistinct>
  distinctByDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QDistinct>
  distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QDistinct>
  distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QDistinct>
  distinctByIsRestDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRestDay');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, IsarWorkoutDayRecord, QDistinct>
  distinctByWorkoutPlanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'workoutPlanId',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension IsarWorkoutDayRecordQueryProperty
    on
        QueryBuilder<
          IsarWorkoutDayRecord,
          IsarWorkoutDayRecord,
          QQueryProperty
        > {
  QueryBuilder<IsarWorkoutDayRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, int, QQueryOperations>
  dayNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dayNumber');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, String, QQueryOperations>
  descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, bool, QQueryOperations>
  isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, bool, QQueryOperations>
  isRestDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRestDay');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IsarWorkoutDayRecord, String, QQueryOperations>
  workoutPlanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutPlanId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarWorkoutGroupRecordCollection on Isar {
  IsarCollection<IsarWorkoutGroupRecord> get isarWorkoutGroupRecords =>
      this.collection();
}

const IsarWorkoutGroupRecordSchema = CollectionSchema(
  name: r'IsarWorkoutGroupRecord',
  id: 3058754439547211014,
  properties: {
    r'displayOrder': PropertySchema(
      id: 0,
      name: r'displayOrder',
      type: IsarType.long,
    ),
    r'id': PropertySchema(id: 1, name: r'id', type: IsarType.string),
    r'isArchived': PropertySchema(
      id: 2,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(id: 3, name: r'name', type: IsarType.string),
    r'workoutDayId': PropertySchema(
      id: 4,
      name: r'workoutDayId',
      type: IsarType.string,
    ),
  },

  estimateSize: _isarWorkoutGroupRecordEstimateSize,
  serialize: _isarWorkoutGroupRecordSerialize,
  deserialize: _isarWorkoutGroupRecordDeserialize,
  deserializeProp: _isarWorkoutGroupRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'workoutDayId': IndexSchema(
      id: -1637358403312548662,
      name: r'workoutDayId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workoutDayId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _isarWorkoutGroupRecordGetId,
  getLinks: _isarWorkoutGroupRecordGetLinks,
  attach: _isarWorkoutGroupRecordAttach,
  version: '3.3.2',
);

int _isarWorkoutGroupRecordEstimateSize(
  IsarWorkoutGroupRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.name.length * 3;
  bytesCount += 3 + object.workoutDayId.length * 3;
  return bytesCount;
}

void _isarWorkoutGroupRecordSerialize(
  IsarWorkoutGroupRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.displayOrder);
  writer.writeString(offsets[1], object.id);
  writer.writeBool(offsets[2], object.isArchived);
  writer.writeString(offsets[3], object.name);
  writer.writeString(offsets[4], object.workoutDayId);
}

IsarWorkoutGroupRecord _isarWorkoutGroupRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarWorkoutGroupRecord();
  object.displayOrder = reader.readLong(offsets[0]);
  object.id = reader.readString(offsets[1]);
  object.isArchived = reader.readBool(offsets[2]);
  object.isarId = id;
  object.name = reader.readString(offsets[3]);
  object.workoutDayId = reader.readString(offsets[4]);
  return object;
}

P _isarWorkoutGroupRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarWorkoutGroupRecordGetId(IsarWorkoutGroupRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _isarWorkoutGroupRecordGetLinks(
  IsarWorkoutGroupRecord object,
) {
  return [];
}

void _isarWorkoutGroupRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarWorkoutGroupRecord object,
) {
  object.isarId = id;
}

extension IsarWorkoutGroupRecordByIndex
    on IsarCollection<IsarWorkoutGroupRecord> {
  Future<IsarWorkoutGroupRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  IsarWorkoutGroupRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<IsarWorkoutGroupRecord?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<IsarWorkoutGroupRecord?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(IsarWorkoutGroupRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(IsarWorkoutGroupRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<IsarWorkoutGroupRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(
    List<IsarWorkoutGroupRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension IsarWorkoutGroupRecordQueryWhereSort
    on QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QWhere> {
  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterWhere>
  anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarWorkoutGroupRecordQueryWhere
    on
        QueryBuilder<
          IsarWorkoutGroupRecord,
          IsarWorkoutGroupRecord,
          QWhereClause
        > {
  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterWhereClause
  >
  isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterWhereClause
  >
  isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterWhereClause
  >
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterWhereClause
  >
  isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterWhereClause
  >
  isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerIsarId,
          includeLower: includeLower,
          upper: upperIsarId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterWhereClause
  >
  idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'id', value: [id]),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterWhereClause
  >
  idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterWhereClause
  >
  workoutDayIdEqualTo(String workoutDayId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'workoutDayId',
          value: [workoutDayId],
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterWhereClause
  >
  workoutDayIdNotEqualTo(String workoutDayId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutDayId',
                lower: [],
                upper: [workoutDayId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutDayId',
                lower: [workoutDayId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutDayId',
                lower: [workoutDayId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutDayId',
                lower: [],
                upper: [workoutDayId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension IsarWorkoutGroupRecordQueryFilter
    on
        QueryBuilder<
          IsarWorkoutGroupRecord,
          IsarWorkoutGroupRecord,
          QFilterCondition
        > {
  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  displayOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayOrder', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  displayOrderGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  displayOrderLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  displayOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayOrder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'id',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isArchived', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  isarIdGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  isarIdLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isarId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workoutDayId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'workoutDayId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workoutDayId', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutGroupRecord,
    IsarWorkoutGroupRecord,
    QAfterFilterCondition
  >
  workoutDayIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'workoutDayId', value: ''),
      );
    });
  }
}

extension IsarWorkoutGroupRecordQueryObject
    on
        QueryBuilder<
          IsarWorkoutGroupRecord,
          IsarWorkoutGroupRecord,
          QFilterCondition
        > {}

extension IsarWorkoutGroupRecordQueryLinks
    on
        QueryBuilder<
          IsarWorkoutGroupRecord,
          IsarWorkoutGroupRecord,
          QFilterCondition
        > {}

extension IsarWorkoutGroupRecordQuerySortBy
    on QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QSortBy> {
  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortByDisplayOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrder', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortByDisplayOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrder', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortByWorkoutDayId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayId', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  sortByWorkoutDayIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayId', Sort.desc);
    });
  }
}

extension IsarWorkoutGroupRecordQuerySortThenBy
    on
        QueryBuilder<
          IsarWorkoutGroupRecord,
          IsarWorkoutGroupRecord,
          QSortThenBy
        > {
  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByDisplayOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrder', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByDisplayOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrder', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByWorkoutDayId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayId', Sort.asc);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QAfterSortBy>
  thenByWorkoutDayIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayId', Sort.desc);
    });
  }
}

extension IsarWorkoutGroupRecordQueryWhereDistinct
    on QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QDistinct> {
  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QDistinct>
  distinctByDisplayOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayOrder');
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QDistinct>
  distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QDistinct>
  distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QDistinct>
  distinctByName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, IsarWorkoutGroupRecord, QDistinct>
  distinctByWorkoutDayId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutDayId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarWorkoutGroupRecordQueryProperty
    on
        QueryBuilder<
          IsarWorkoutGroupRecord,
          IsarWorkoutGroupRecord,
          QQueryProperty
        > {
  QueryBuilder<IsarWorkoutGroupRecord, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, int, QQueryOperations>
  displayOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayOrder');
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, bool, QQueryOperations>
  isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, String, QQueryOperations>
  nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IsarWorkoutGroupRecord, String, QQueryOperations>
  workoutDayIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutDayId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarWorkoutExerciseRecordCollection on Isar {
  IsarCollection<IsarWorkoutExerciseRecord> get isarWorkoutExerciseRecords =>
      this.collection();
}

const IsarWorkoutExerciseRecordSchema = CollectionSchema(
  name: r'IsarWorkoutExerciseRecord',
  id: 902142545895533076,
  properties: {
    r'customTempo': PropertySchema(
      id: 0,
      name: r'customTempo',
      type: IsarType.string,
    ),
    r'displayOrder': PropertySchema(
      id: 1,
      name: r'displayOrder',
      type: IsarType.long,
    ),
    r'durationInSeconds': PropertySchema(
      id: 2,
      name: r'durationInSeconds',
      type: IsarType.long,
    ),
    r'exerciseId': PropertySchema(
      id: 3,
      name: r'exerciseId',
      type: IsarType.string,
    ),
    r'id': PropertySchema(id: 4, name: r'id', type: IsarType.string),
    r'isArchived': PropertySchema(
      id: 5,
      name: r'isArchived',
      type: IsarType.bool,
    ),
    r'notes': PropertySchema(id: 6, name: r'notes', type: IsarType.string),
    r'repetitions': PropertySchema(
      id: 7,
      name: r'repetitions',
      type: IsarType.long,
    ),
    r'restInSeconds': PropertySchema(
      id: 8,
      name: r'restInSeconds',
      type: IsarType.long,
    ),
    r'rpe': PropertySchema(id: 9, name: r'rpe', type: IsarType.long),
    r'sequenceDefinition': PropertySchema(
      id: 10,
      name: r'sequenceDefinition',
      type: IsarType.object,

      target: r'IsarWorkoutSequenceDefinitionRecord',
    ),
    r'sessionRepetitions': PropertySchema(
      id: 11,
      name: r'sessionRepetitions',
      type: IsarType.long,
    ),
    r'sets': PropertySchema(id: 12, name: r'sets', type: IsarType.long),
    r'targetTypeName': PropertySchema(
      id: 13,
      name: r'targetTypeName',
      type: IsarType.string,
    ),
    r'tempoTypeName': PropertySchema(
      id: 14,
      name: r'tempoTypeName',
      type: IsarType.string,
    ),
    r'weight': PropertySchema(id: 15, name: r'weight', type: IsarType.double),
    r'weightUnitName': PropertySchema(
      id: 16,
      name: r'weightUnitName',
      type: IsarType.string,
    ),
    r'workoutGroupId': PropertySchema(
      id: 17,
      name: r'workoutGroupId',
      type: IsarType.string,
    ),
  },

  estimateSize: _isarWorkoutExerciseRecordEstimateSize,
  serialize: _isarWorkoutExerciseRecordSerialize,
  deserialize: _isarWorkoutExerciseRecordDeserialize,
  deserializeProp: _isarWorkoutExerciseRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
    r'workoutGroupId': IndexSchema(
      id: 7726520331874482434,
      name: r'workoutGroupId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'workoutGroupId',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {
    r'IsarWorkoutSequenceDefinitionRecord':
        IsarWorkoutSequenceDefinitionRecordSchema,
    r'IsarWorkoutSequenceStepRecord': IsarWorkoutSequenceStepRecordSchema,
  },

  getId: _isarWorkoutExerciseRecordGetId,
  getLinks: _isarWorkoutExerciseRecordGetLinks,
  attach: _isarWorkoutExerciseRecordAttach,
  version: '3.3.2',
);

int _isarWorkoutExerciseRecordEstimateSize(
  IsarWorkoutExerciseRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.customTempo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.exerciseId.length * 3;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.notes.length * 3;
  {
    final value = object.sequenceDefinition;
    if (value != null) {
      bytesCount +=
          3 +
          IsarWorkoutSequenceDefinitionRecordSchema.estimateSize(
            value,
            allOffsets[IsarWorkoutSequenceDefinitionRecord]!,
            allOffsets,
          );
    }
  }
  bytesCount += 3 + object.targetTypeName.length * 3;
  bytesCount += 3 + object.tempoTypeName.length * 3;
  bytesCount += 3 + object.weightUnitName.length * 3;
  bytesCount += 3 + object.workoutGroupId.length * 3;
  return bytesCount;
}

void _isarWorkoutExerciseRecordSerialize(
  IsarWorkoutExerciseRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.customTempo);
  writer.writeLong(offsets[1], object.displayOrder);
  writer.writeLong(offsets[2], object.durationInSeconds);
  writer.writeString(offsets[3], object.exerciseId);
  writer.writeString(offsets[4], object.id);
  writer.writeBool(offsets[5], object.isArchived);
  writer.writeString(offsets[6], object.notes);
  writer.writeLong(offsets[7], object.repetitions);
  writer.writeLong(offsets[8], object.restInSeconds);
  writer.writeLong(offsets[9], object.rpe);
  writer.writeObject<IsarWorkoutSequenceDefinitionRecord>(
    offsets[10],
    allOffsets,
    IsarWorkoutSequenceDefinitionRecordSchema.serialize,
    object.sequenceDefinition,
  );
  writer.writeLong(offsets[11], object.sessionRepetitions);
  writer.writeLong(offsets[12], object.sets);
  writer.writeString(offsets[13], object.targetTypeName);
  writer.writeString(offsets[14], object.tempoTypeName);
  writer.writeDouble(offsets[15], object.weight);
  writer.writeString(offsets[16], object.weightUnitName);
  writer.writeString(offsets[17], object.workoutGroupId);
}

IsarWorkoutExerciseRecord _isarWorkoutExerciseRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarWorkoutExerciseRecord();
  object.customTempo = reader.readStringOrNull(offsets[0]);
  object.displayOrder = reader.readLong(offsets[1]);
  object.durationInSeconds = reader.readLongOrNull(offsets[2]);
  object.exerciseId = reader.readString(offsets[3]);
  object.id = reader.readString(offsets[4]);
  object.isArchived = reader.readBool(offsets[5]);
  object.isarId = id;
  object.notes = reader.readString(offsets[6]);
  object.repetitions = reader.readLongOrNull(offsets[7]);
  object.restInSeconds = reader.readLongOrNull(offsets[8]);
  object.rpe = reader.readLongOrNull(offsets[9]);
  object.sequenceDefinition = reader
      .readObjectOrNull<IsarWorkoutSequenceDefinitionRecord>(
        offsets[10],
        IsarWorkoutSequenceDefinitionRecordSchema.deserialize,
        allOffsets,
      );
  object.sessionRepetitions = reader.readLong(offsets[11]);
  object.sets = reader.readLongOrNull(offsets[12]);
  object.targetTypeName = reader.readString(offsets[13]);
  object.tempoTypeName = reader.readString(offsets[14]);
  object.weight = reader.readDoubleOrNull(offsets[15]);
  object.weightUnitName = reader.readString(offsets[16]);
  object.workoutGroupId = reader.readString(offsets[17]);
  return object;
}

P _isarWorkoutExerciseRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readObjectOrNull<IsarWorkoutSequenceDefinitionRecord>(
            offset,
            IsarWorkoutSequenceDefinitionRecordSchema.deserialize,
            allOffsets,
          ))
          as P;
    case 11:
      return (reader.readLong(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readDoubleOrNull(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarWorkoutExerciseRecordGetId(IsarWorkoutExerciseRecord object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _isarWorkoutExerciseRecordGetLinks(
  IsarWorkoutExerciseRecord object,
) {
  return [];
}

void _isarWorkoutExerciseRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarWorkoutExerciseRecord object,
) {
  object.isarId = id;
}

extension IsarWorkoutExerciseRecordByIndex
    on IsarCollection<IsarWorkoutExerciseRecord> {
  Future<IsarWorkoutExerciseRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  IsarWorkoutExerciseRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<IsarWorkoutExerciseRecord?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<IsarWorkoutExerciseRecord?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(IsarWorkoutExerciseRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(IsarWorkoutExerciseRecord object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<IsarWorkoutExerciseRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(
    List<IsarWorkoutExerciseRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension IsarWorkoutExerciseRecordQueryWhereSort
    on
        QueryBuilder<
          IsarWorkoutExerciseRecord,
          IsarWorkoutExerciseRecord,
          QWhere
        > {
  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhere
  >
  anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarWorkoutExerciseRecordQueryWhere
    on
        QueryBuilder<
          IsarWorkoutExerciseRecord,
          IsarWorkoutExerciseRecord,
          QWhereClause
        > {
  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhereClause
  >
  isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhereClause
  >
  isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhereClause
  >
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhereClause
  >
  isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhereClause
  >
  isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerIsarId,
          includeLower: includeLower,
          upper: upperIsarId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhereClause
  >
  idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'id', value: [id]),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhereClause
  >
  idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhereClause
  >
  workoutGroupIdEqualTo(String workoutGroupId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'workoutGroupId',
          value: [workoutGroupId],
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterWhereClause
  >
  workoutGroupIdNotEqualTo(String workoutGroupId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutGroupId',
                lower: [],
                upper: [workoutGroupId],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutGroupId',
                lower: [workoutGroupId],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutGroupId',
                lower: [workoutGroupId],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'workoutGroupId',
                lower: [],
                upper: [workoutGroupId],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension IsarWorkoutExerciseRecordQueryFilter
    on
        QueryBuilder<
          IsarWorkoutExerciseRecord,
          IsarWorkoutExerciseRecord,
          QFilterCondition
        > {
  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'customTempo'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'customTempo'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'customTempo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'customTempo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'customTempo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'customTempo',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'customTempo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'customTempo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'customTempo',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'customTempo',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'customTempo', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  customTempoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'customTempo', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  displayOrderEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'displayOrder', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  displayOrderGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'displayOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  displayOrderLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'displayOrder',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  displayOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'displayOrder',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  durationInSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'durationInSeconds'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  durationInSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'durationInSeconds'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  durationInSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationInSeconds', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  durationInSecondsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  durationInSecondsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  durationInSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationInSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'exerciseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'exerciseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'exerciseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'exerciseId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'exerciseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'exerciseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'exerciseId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'exerciseId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'exerciseId', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  exerciseIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'exerciseId', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'id',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  isArchivedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isArchived', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  isarIdGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  isarIdLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isarId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  repetitionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'repetitions'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  repetitionsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'repetitions'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  repetitionsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'repetitions', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  repetitionsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'repetitions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  repetitionsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'repetitions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  repetitionsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'repetitions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  restInSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'restInSeconds'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  restInSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'restInSeconds'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  restInSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'restInSeconds', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  restInSecondsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'restInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  restInSecondsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'restInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  restInSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'restInSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  rpeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'rpe'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  rpeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'rpe'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  rpeEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'rpe', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  rpeGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'rpe',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  rpeLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'rpe',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  rpeBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'rpe',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  sequenceDefinitionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sequenceDefinition'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  sequenceDefinitionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sequenceDefinition'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  sessionRepetitionsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sessionRepetitions', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  sessionRepetitionsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sessionRepetitions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  sessionRepetitionsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sessionRepetitions',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  sessionRepetitionsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sessionRepetitions',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  setsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'sets'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  setsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'sets'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  setsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'sets', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  setsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'sets',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  setsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'sets',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  setsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'sets',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'targetTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'targetTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'targetTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'targetTypeName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'targetTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'targetTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'targetTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'targetTypeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'targetTypeName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  targetTypeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'targetTypeName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'tempoTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'tempoTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'tempoTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'tempoTypeName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'tempoTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'tempoTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'tempoTypeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'tempoTypeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'tempoTypeName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  tempoTypeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'tempoTypeName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'weight'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'weight'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightEqualTo(double? value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weight',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weight',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weight',
          value: value,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weight',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,

          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'weightUnitName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'weightUnitName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'weightUnitName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'weightUnitName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'weightUnitName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'weightUnitName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'weightUnitName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'weightUnitName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'weightUnitName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  weightUnitNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'weightUnitName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'workoutGroupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workoutGroupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workoutGroupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workoutGroupId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'workoutGroupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'workoutGroupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'workoutGroupId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'workoutGroupId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workoutGroupId', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  workoutGroupIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'workoutGroupId', value: ''),
      );
    });
  }
}

extension IsarWorkoutExerciseRecordQueryObject
    on
        QueryBuilder<
          IsarWorkoutExerciseRecord,
          IsarWorkoutExerciseRecord,
          QFilterCondition
        > {
  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterFilterCondition
  >
  sequenceDefinition(FilterQuery<IsarWorkoutSequenceDefinitionRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'sequenceDefinition');
    });
  }
}

extension IsarWorkoutExerciseRecordQueryLinks
    on
        QueryBuilder<
          IsarWorkoutExerciseRecord,
          IsarWorkoutExerciseRecord,
          QFilterCondition
        > {}

extension IsarWorkoutExerciseRecordQuerySortBy
    on
        QueryBuilder<
          IsarWorkoutExerciseRecord,
          IsarWorkoutExerciseRecord,
          QSortBy
        > {
  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByCustomTempo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTempo', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByCustomTempoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTempo', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByDisplayOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrder', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByDisplayOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrder', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByDurationInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByExerciseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByRestInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restInSeconds', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByRestInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restInSeconds', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByRpe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpe', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByRpeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpe', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortBySessionRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionRepetitions', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortBySessionRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionRepetitions', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortBySets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sets', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortBySetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sets', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByTargetTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTypeName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByTargetTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTypeName', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByTempoTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempoTypeName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByTempoTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempoTypeName', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByWeightUnitName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnitName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByWeightUnitNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnitName', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByWorkoutGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutGroupId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  sortByWorkoutGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutGroupId', Sort.desc);
    });
  }
}

extension IsarWorkoutExerciseRecordQuerySortThenBy
    on
        QueryBuilder<
          IsarWorkoutExerciseRecord,
          IsarWorkoutExerciseRecord,
          QSortThenBy
        > {
  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByCustomTempo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTempo', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByCustomTempoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customTempo', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByDisplayOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrder', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByDisplayOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayOrder', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByDurationInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByExerciseId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByExerciseIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseId', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByIsArchivedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isArchived', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repetitions', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByRestInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restInSeconds', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByRestInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'restInSeconds', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByRpe() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpe', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByRpeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rpe', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenBySessionRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionRepetitions', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenBySessionRepetitionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sessionRepetitions', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenBySets() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sets', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenBySetsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sets', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByTargetTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTypeName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByTargetTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTypeName', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByTempoTypeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempoTypeName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByTempoTypeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tempoTypeName', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByWeightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weight', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByWeightUnitName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnitName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByWeightUnitNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weightUnitName', Sort.desc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByWorkoutGroupId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutGroupId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutExerciseRecord,
    QAfterSortBy
  >
  thenByWorkoutGroupIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutGroupId', Sort.desc);
    });
  }
}

extension IsarWorkoutExerciseRecordQueryWhereDistinct
    on
        QueryBuilder<
          IsarWorkoutExerciseRecord,
          IsarWorkoutExerciseRecord,
          QDistinct
        > {
  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByCustomTempo({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customTempo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByDisplayOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayOrder');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInSeconds');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByExerciseId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByIsArchived() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isArchived');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repetitions');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByRestInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'restInSeconds');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByRpe() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rpe');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctBySessionRepetitions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sessionRepetitions');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctBySets() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sets');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByTargetTypeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'targetTypeName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByTempoTypeName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'tempoTypeName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByWeight() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weight');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByWeightUnitName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'weightUnitName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, IsarWorkoutExerciseRecord, QDistinct>
  distinctByWorkoutGroupId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'workoutGroupId',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension IsarWorkoutExerciseRecordQueryProperty
    on
        QueryBuilder<
          IsarWorkoutExerciseRecord,
          IsarWorkoutExerciseRecord,
          QQueryProperty
        > {
  QueryBuilder<IsarWorkoutExerciseRecord, int, QQueryOperations>
  isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, String?, QQueryOperations>
  customTempoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customTempo');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, int, QQueryOperations>
  displayOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayOrder');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, int?, QQueryOperations>
  durationInSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInSeconds');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, String, QQueryOperations>
  exerciseIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseId');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, String, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, bool, QQueryOperations>
  isArchivedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isArchived');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, String, QQueryOperations>
  notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, int?, QQueryOperations>
  repetitionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repetitions');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, int?, QQueryOperations>
  restInSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'restInSeconds');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, int?, QQueryOperations>
  rpeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rpe');
    });
  }

  QueryBuilder<
    IsarWorkoutExerciseRecord,
    IsarWorkoutSequenceDefinitionRecord?,
    QQueryOperations
  >
  sequenceDefinitionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sequenceDefinition');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, int, QQueryOperations>
  sessionRepetitionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sessionRepetitions');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, int?, QQueryOperations>
  setsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sets');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, String, QQueryOperations>
  targetTypeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetTypeName');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, String, QQueryOperations>
  tempoTypeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tempoTypeName');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, double?, QQueryOperations>
  weightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weight');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, String, QQueryOperations>
  weightUnitNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weightUnitName');
    });
  }

  QueryBuilder<IsarWorkoutExerciseRecord, String, QQueryOperations>
  workoutGroupIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutGroupId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarCompletedWorkoutSessionRecordCollection on Isar {
  IsarCollection<IsarCompletedWorkoutSessionRecord>
  get isarCompletedWorkoutSessionRecords => this.collection();
}

const IsarCompletedWorkoutSessionRecordSchema = CollectionSchema(
  name: r'IsarCompletedWorkoutSessionRecord',
  id: -577823640778504987,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'completedExercises': PropertySchema(
      id: 1,
      name: r'completedExercises',
      type: IsarType.long,
    ),
    r'durationInSeconds': PropertySchema(
      id: 2,
      name: r'durationInSeconds',
      type: IsarType.long,
    ),
    r'id': PropertySchema(id: 3, name: r'id', type: IsarType.string),
    r'notes': PropertySchema(id: 4, name: r'notes', type: IsarType.string),
    r'startedAt': PropertySchema(
      id: 5,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'totalExercises': PropertySchema(
      id: 6,
      name: r'totalExercises',
      type: IsarType.long,
    ),
    r'wasCompleted': PropertySchema(
      id: 7,
      name: r'wasCompleted',
      type: IsarType.bool,
    ),
    r'workoutDayId': PropertySchema(
      id: 8,
      name: r'workoutDayId',
      type: IsarType.string,
    ),
    r'workoutDayName': PropertySchema(
      id: 9,
      name: r'workoutDayName',
      type: IsarType.string,
    ),
    r'workoutPlanId': PropertySchema(
      id: 10,
      name: r'workoutPlanId',
      type: IsarType.string,
    ),
    r'workoutPlanName': PropertySchema(
      id: 11,
      name: r'workoutPlanName',
      type: IsarType.string,
    ),
  },

  estimateSize: _isarCompletedWorkoutSessionRecordEstimateSize,
  serialize: _isarCompletedWorkoutSessionRecordSerialize,
  deserialize: _isarCompletedWorkoutSessionRecordDeserialize,
  deserializeProp: _isarCompletedWorkoutSessionRecordDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        ),
      ],
    ),
  },
  links: {},
  embeddedSchemas: {},

  getId: _isarCompletedWorkoutSessionRecordGetId,
  getLinks: _isarCompletedWorkoutSessionRecordGetLinks,
  attach: _isarCompletedWorkoutSessionRecordAttach,
  version: '3.3.2',
);

int _isarCompletedWorkoutSessionRecordEstimateSize(
  IsarCompletedWorkoutSessionRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.id.length * 3;
  bytesCount += 3 + object.notes.length * 3;
  {
    final value = object.workoutDayId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.workoutDayName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.workoutPlanId.length * 3;
  bytesCount += 3 + object.workoutPlanName.length * 3;
  return bytesCount;
}

void _isarCompletedWorkoutSessionRecordSerialize(
  IsarCompletedWorkoutSessionRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeLong(offsets[1], object.completedExercises);
  writer.writeLong(offsets[2], object.durationInSeconds);
  writer.writeString(offsets[3], object.id);
  writer.writeString(offsets[4], object.notes);
  writer.writeDateTime(offsets[5], object.startedAt);
  writer.writeLong(offsets[6], object.totalExercises);
  writer.writeBool(offsets[7], object.wasCompleted);
  writer.writeString(offsets[8], object.workoutDayId);
  writer.writeString(offsets[9], object.workoutDayName);
  writer.writeString(offsets[10], object.workoutPlanId);
  writer.writeString(offsets[11], object.workoutPlanName);
}

IsarCompletedWorkoutSessionRecord _isarCompletedWorkoutSessionRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarCompletedWorkoutSessionRecord();
  object.completedAt = reader.readDateTime(offsets[0]);
  object.completedExercises = reader.readLong(offsets[1]);
  object.durationInSeconds = reader.readLong(offsets[2]);
  object.id = reader.readString(offsets[3]);
  object.isarId = id;
  object.notes = reader.readString(offsets[4]);
  object.startedAt = reader.readDateTime(offsets[5]);
  object.totalExercises = reader.readLong(offsets[6]);
  object.wasCompleted = reader.readBool(offsets[7]);
  object.workoutDayId = reader.readStringOrNull(offsets[8]);
  object.workoutDayName = reader.readStringOrNull(offsets[9]);
  object.workoutPlanId = reader.readString(offsets[10]);
  object.workoutPlanName = reader.readString(offsets[11]);
  return object;
}

P _isarCompletedWorkoutSessionRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarCompletedWorkoutSessionRecordGetId(
  IsarCompletedWorkoutSessionRecord object,
) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _isarCompletedWorkoutSessionRecordGetLinks(
  IsarCompletedWorkoutSessionRecord object,
) {
  return [];
}

void _isarCompletedWorkoutSessionRecordAttach(
  IsarCollection<dynamic> col,
  Id id,
  IsarCompletedWorkoutSessionRecord object,
) {
  object.isarId = id;
}

extension IsarCompletedWorkoutSessionRecordByIndex
    on IsarCollection<IsarCompletedWorkoutSessionRecord> {
  Future<IsarCompletedWorkoutSessionRecord?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  IsarCompletedWorkoutSessionRecord? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<IsarCompletedWorkoutSessionRecord?>> getAllById(
    List<String> idValues,
  ) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<IsarCompletedWorkoutSessionRecord?> getAllByIdSync(
    List<String> idValues,
  ) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(IsarCompletedWorkoutSessionRecord object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(
    IsarCompletedWorkoutSessionRecord object, {
    bool saveLinks = true,
  }) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<IsarCompletedWorkoutSessionRecord> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(
    List<IsarCompletedWorkoutSessionRecord> objects, {
    bool saveLinks = true,
  }) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension IsarCompletedWorkoutSessionRecordQueryWhereSort
    on
        QueryBuilder<
          IsarCompletedWorkoutSessionRecord,
          IsarCompletedWorkoutSessionRecord,
          QWhere
        > {
  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterWhere
  >
  anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarCompletedWorkoutSessionRecordQueryWhere
    on
        QueryBuilder<
          IsarCompletedWorkoutSessionRecord,
          IsarCompletedWorkoutSessionRecord,
          QWhereClause
        > {
  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterWhereClause
  >
  isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(lower: isarId, upper: isarId),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterWhereClause
  >
  isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterWhereClause
  >
  isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterWhereClause
  >
  isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterWhereClause
  >
  isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerIsarId,
          includeLower: includeLower,
          upper: upperIsarId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterWhereClause
  >
  idEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(indexName: r'id', value: [id]),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterWhereClause
  >
  idNotEqualTo(String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [id],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'id',
                lower: [],
                upper: [id],
                includeUpper: false,
              ),
            );
      }
    });
  }
}

extension IsarCompletedWorkoutSessionRecordQueryFilter
    on
        QueryBuilder<
          IsarCompletedWorkoutSessionRecord,
          IsarCompletedWorkoutSessionRecord,
          QFilterCondition
        > {
  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  completedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedAt', value: value),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  completedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  completedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  completedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  completedExercisesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedExercises', value: value),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  completedExercisesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedExercises',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  completedExercisesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedExercises',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  completedExercisesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedExercises',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  durationInSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationInSeconds', value: value),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  durationInSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  durationInSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  durationInSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationInSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idLessThan(String value, {bool include = false, bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'id',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'id',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'id', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isarId', value: value),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  isarIdGreaterThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  isarIdLessThan(Id value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'isarId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'isarId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'notes',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'notes',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'notes',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'notes', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  startedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'startedAt', value: value),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  startedAtGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  startedAtLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'startedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  startedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'startedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  totalExercisesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'totalExercises', value: value),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  totalExercisesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'totalExercises',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  totalExercisesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'totalExercises',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  totalExercisesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'totalExercises',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  wasCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'wasCompleted', value: value),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'workoutDayId'),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'workoutDayId'),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workoutDayId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'workoutDayId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'workoutDayId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workoutDayId', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'workoutDayId', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'workoutDayName'),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'workoutDayName'),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'workoutDayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workoutDayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workoutDayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workoutDayName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'workoutDayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'workoutDayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'workoutDayName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'workoutDayName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workoutDayName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutDayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'workoutDayName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workoutPlanId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'workoutPlanId',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'workoutPlanId',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workoutPlanId', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'workoutPlanId', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'workoutPlanName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'workoutPlanName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'workoutPlanName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'workoutPlanName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'workoutPlanName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'workoutPlanName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'workoutPlanName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'workoutPlanName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'workoutPlanName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterFilterCondition
  >
  workoutPlanNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'workoutPlanName', value: ''),
      );
    });
  }
}

extension IsarCompletedWorkoutSessionRecordQueryObject
    on
        QueryBuilder<
          IsarCompletedWorkoutSessionRecord,
          IsarCompletedWorkoutSessionRecord,
          QFilterCondition
        > {}

extension IsarCompletedWorkoutSessionRecordQueryLinks
    on
        QueryBuilder<
          IsarCompletedWorkoutSessionRecord,
          IsarCompletedWorkoutSessionRecord,
          QFilterCondition
        > {}

extension IsarCompletedWorkoutSessionRecordQuerySortBy
    on
        QueryBuilder<
          IsarCompletedWorkoutSessionRecord,
          IsarCompletedWorkoutSessionRecord,
          QSortBy
        > {
  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByCompletedExercises() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedExercises', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByCompletedExercisesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedExercises', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByDurationInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByTotalExercises() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExercises', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByTotalExercisesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExercises', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWasCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasCompleted', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWasCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasCompleted', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWorkoutDayId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWorkoutDayIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayId', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWorkoutDayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWorkoutDayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayName', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWorkoutPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWorkoutPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanId', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWorkoutPlanName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  sortByWorkoutPlanNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanName', Sort.desc);
    });
  }
}

extension IsarCompletedWorkoutSessionRecordQuerySortThenBy
    on
        QueryBuilder<
          IsarCompletedWorkoutSessionRecord,
          IsarCompletedWorkoutSessionRecord,
          QSortThenBy
        > {
  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByCompletedExercises() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedExercises', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByCompletedExercisesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedExercises', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByDurationInSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationInSeconds', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByTotalExercises() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExercises', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByTotalExercisesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalExercises', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWasCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasCompleted', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWasCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wasCompleted', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWorkoutDayId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWorkoutDayIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayId', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWorkoutDayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWorkoutDayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutDayName', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWorkoutPlanId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanId', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWorkoutPlanIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanId', Sort.desc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWorkoutPlanName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanName', Sort.asc);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QAfterSortBy
  >
  thenByWorkoutPlanNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'workoutPlanName', Sort.desc);
    });
  }
}

extension IsarCompletedWorkoutSessionRecordQueryWhereDistinct
    on
        QueryBuilder<
          IsarCompletedWorkoutSessionRecord,
          IsarCompletedWorkoutSessionRecord,
          QDistinct
        > {
  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByCompletedExercises() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedExercises');
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByDurationInSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationInSeconds');
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByTotalExercises() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalExercises');
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByWasCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wasCompleted');
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByWorkoutDayId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'workoutDayId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByWorkoutDayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'workoutDayName',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByWorkoutPlanId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'workoutPlanId',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<
    IsarCompletedWorkoutSessionRecord,
    IsarCompletedWorkoutSessionRecord,
    QDistinct
  >
  distinctByWorkoutPlanName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'workoutPlanName',
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension IsarCompletedWorkoutSessionRecordQueryProperty
    on
        QueryBuilder<
          IsarCompletedWorkoutSessionRecord,
          IsarCompletedWorkoutSessionRecord,
          QQueryProperty
        > {
  QueryBuilder<IsarCompletedWorkoutSessionRecord, int, QQueryOperations>
  isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, DateTime, QQueryOperations>
  completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, int, QQueryOperations>
  completedExercisesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedExercises');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, int, QQueryOperations>
  durationInSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationInSeconds');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, String, QQueryOperations>
  idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, String, QQueryOperations>
  notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, DateTime, QQueryOperations>
  startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, int, QQueryOperations>
  totalExercisesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalExercises');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, bool, QQueryOperations>
  wasCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wasCompleted');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, String?, QQueryOperations>
  workoutDayIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutDayId');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, String?, QQueryOperations>
  workoutDayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutDayName');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, String, QQueryOperations>
  workoutPlanIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutPlanId');
    });
  }

  QueryBuilder<IsarCompletedWorkoutSessionRecord, String, QQueryOperations>
  workoutPlanNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'workoutPlanName');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarWorkoutSequenceStepRecordSchema = Schema(
  name: r'IsarWorkoutSequenceStepRecord',
  id: -691908455432964880,
  properties: {
    r'count': PropertySchema(id: 0, name: r'count', type: IsarType.long),
    r'countDirectionName': PropertySchema(
      id: 1,
      name: r'countDirectionName',
      type: IsarType.string,
    ),
    r'durationInSeconds': PropertySchema(
      id: 2,
      name: r'durationInSeconds',
      type: IsarType.long,
    ),
    r'repetitionCount': PropertySchema(
      id: 3,
      name: r'repetitionCount',
      type: IsarType.long,
    ),
    r'text': PropertySchema(id: 4, name: r'text', type: IsarType.string),
    r'typeName': PropertySchema(
      id: 5,
      name: r'typeName',
      type: IsarType.string,
    ),
  },

  estimateSize: _isarWorkoutSequenceStepRecordEstimateSize,
  serialize: _isarWorkoutSequenceStepRecordSerialize,
  deserialize: _isarWorkoutSequenceStepRecordDeserialize,
  deserializeProp: _isarWorkoutSequenceStepRecordDeserializeProp,
);

int _isarWorkoutSequenceStepRecordEstimateSize(
  IsarWorkoutSequenceStepRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.countDirectionName;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.typeName.length * 3;
  return bytesCount;
}

void _isarWorkoutSequenceStepRecordSerialize(
  IsarWorkoutSequenceStepRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.count);
  writer.writeString(offsets[1], object.countDirectionName);
  writer.writeLong(offsets[2], object.durationInSeconds);
  writer.writeLong(offsets[3], object.repetitionCount);
  writer.writeString(offsets[4], object.text);
  writer.writeString(offsets[5], object.typeName);
}

IsarWorkoutSequenceStepRecord _isarWorkoutSequenceStepRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarWorkoutSequenceStepRecord();
  object.count = reader.readLongOrNull(offsets[0]);
  object.countDirectionName = reader.readStringOrNull(offsets[1]);
  object.durationInSeconds = reader.readLongOrNull(offsets[2]);
  object.repetitionCount = reader.readLongOrNull(offsets[3]);
  object.text = reader.readStringOrNull(offsets[4]);
  object.typeName = reader.readString(offsets[5]);
  return object;
}

P _isarWorkoutSequenceStepRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarWorkoutSequenceStepRecordQueryFilter
    on
        QueryBuilder<
          IsarWorkoutSequenceStepRecord,
          IsarWorkoutSequenceStepRecord,
          QFilterCondition
        > {
  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'count'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'count'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'count', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'count',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'count',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'count',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'countDirectionName'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'countDirectionName'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'countDirectionName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'countDirectionName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'countDirectionName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'countDirectionName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'countDirectionName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'countDirectionName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'countDirectionName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'countDirectionName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'countDirectionName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  countDirectionNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'countDirectionName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  durationInSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'durationInSeconds'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  durationInSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'durationInSeconds'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  durationInSecondsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'durationInSeconds', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  durationInSecondsGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'durationInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  durationInSecondsLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'durationInSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  durationInSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'durationInSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  repetitionCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'repetitionCount'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  repetitionCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'repetitionCount'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  repetitionCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'repetitionCount', value: value),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  repetitionCountGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'repetitionCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  repetitionCountLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'repetitionCount',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  repetitionCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'repetitionCount',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'text'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'text'),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textEqualTo(String? value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'text',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'text',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'text',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'text', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'typeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'typeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'typeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'typeName',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'typeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'typeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'typeName',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'typeName',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'typeName', value: ''),
      );
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceStepRecord,
    IsarWorkoutSequenceStepRecord,
    QAfterFilterCondition
  >
  typeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'typeName', value: ''),
      );
    });
  }
}

extension IsarWorkoutSequenceStepRecordQueryObject
    on
        QueryBuilder<
          IsarWorkoutSequenceStepRecord,
          IsarWorkoutSequenceStepRecord,
          QFilterCondition
        > {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarWorkoutSequenceDefinitionRecordSchema = Schema(
  name: r'IsarWorkoutSequenceDefinitionRecord',
  id: 6882018639302341670,
  properties: {
    r'steps': PropertySchema(
      id: 0,
      name: r'steps',
      type: IsarType.objectList,

      target: r'IsarWorkoutSequenceStepRecord',
    ),
  },

  estimateSize: _isarWorkoutSequenceDefinitionRecordEstimateSize,
  serialize: _isarWorkoutSequenceDefinitionRecordSerialize,
  deserialize: _isarWorkoutSequenceDefinitionRecordDeserialize,
  deserializeProp: _isarWorkoutSequenceDefinitionRecordDeserializeProp,
);

int _isarWorkoutSequenceDefinitionRecordEstimateSize(
  IsarWorkoutSequenceDefinitionRecord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.steps.length * 3;
  {
    final offsets = allOffsets[IsarWorkoutSequenceStepRecord]!;
    for (var i = 0; i < object.steps.length; i++) {
      final value = object.steps[i];
      bytesCount += IsarWorkoutSequenceStepRecordSchema.estimateSize(
        value,
        offsets,
        allOffsets,
      );
    }
  }
  return bytesCount;
}

void _isarWorkoutSequenceDefinitionRecordSerialize(
  IsarWorkoutSequenceDefinitionRecord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<IsarWorkoutSequenceStepRecord>(
    offsets[0],
    allOffsets,
    IsarWorkoutSequenceStepRecordSchema.serialize,
    object.steps,
  );
}

IsarWorkoutSequenceDefinitionRecord
_isarWorkoutSequenceDefinitionRecordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarWorkoutSequenceDefinitionRecord();
  object.steps =
      reader.readObjectList<IsarWorkoutSequenceStepRecord>(
        offsets[0],
        IsarWorkoutSequenceStepRecordSchema.deserialize,
        allOffsets,
        IsarWorkoutSequenceStepRecord(),
      ) ??
      [];
  return object;
}

P _isarWorkoutSequenceDefinitionRecordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<IsarWorkoutSequenceStepRecord>(
                offset,
                IsarWorkoutSequenceStepRecordSchema.deserialize,
                allOffsets,
                IsarWorkoutSequenceStepRecord(),
              ) ??
              [])
          as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarWorkoutSequenceDefinitionRecordQueryFilter
    on
        QueryBuilder<
          IsarWorkoutSequenceDefinitionRecord,
          IsarWorkoutSequenceDefinitionRecord,
          QFilterCondition
        > {
  QueryBuilder<
    IsarWorkoutSequenceDefinitionRecord,
    IsarWorkoutSequenceDefinitionRecord,
    QAfterFilterCondition
  >
  stepsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'steps', length, true, length, true);
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceDefinitionRecord,
    IsarWorkoutSequenceDefinitionRecord,
    QAfterFilterCondition
  >
  stepsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'steps', 0, true, 0, true);
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceDefinitionRecord,
    IsarWorkoutSequenceDefinitionRecord,
    QAfterFilterCondition
  >
  stepsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'steps', 0, false, 999999, true);
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceDefinitionRecord,
    IsarWorkoutSequenceDefinitionRecord,
    QAfterFilterCondition
  >
  stepsLengthLessThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'steps', 0, true, length, include);
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceDefinitionRecord,
    IsarWorkoutSequenceDefinitionRecord,
    QAfterFilterCondition
  >
  stepsLengthGreaterThan(int length, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(r'steps', length, include, 999999, true);
    });
  }

  QueryBuilder<
    IsarWorkoutSequenceDefinitionRecord,
    IsarWorkoutSequenceDefinitionRecord,
    QAfterFilterCondition
  >
  stepsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'steps',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension IsarWorkoutSequenceDefinitionRecordQueryObject
    on
        QueryBuilder<
          IsarWorkoutSequenceDefinitionRecord,
          IsarWorkoutSequenceDefinitionRecord,
          QFilterCondition
        > {
  QueryBuilder<
    IsarWorkoutSequenceDefinitionRecord,
    IsarWorkoutSequenceDefinitionRecord,
    QAfterFilterCondition
  >
  stepsElement(FilterQuery<IsarWorkoutSequenceStepRecord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'steps');
    });
  }
}
