// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDocumentCollection on Isar {
  IsarCollection<Document> get documents => this.collection();
}

const DocumentSchema = CollectionSchema(
  name: r'Document',
  id: -6041136144672943509,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'loaiVanBan': PropertySchema(
      id: 1,
      name: r'loaiVanBan',
      type: IsarType.string,
    ),
    r'ngayBanHanh': PropertySchema(
      id: 2,
      name: r'ngayBanHanh',
      type: IsarType.dateTime,
    ),
    r'noiDung': PropertySchema(
      id: 3,
      name: r'noiDung',
      type: IsarType.string,
    ),
    r'soHieu': PropertySchema(
      id: 4,
      name: r'soHieu',
      type: IsarType.string,
    ),
    r'tenVanBan': PropertySchema(
      id: 5,
      name: r'tenVanBan',
      type: IsarType.string,
    )
  },
  estimateSize: _documentEstimateSize,
  serialize: _documentSerialize,
  deserialize: _documentDeserialize,
  deserializeProp: _documentDeserializeProp,
  idName: r'id',
  indexes: {
    r'soHieu': IndexSchema(
      id: 4271274017006171667,
      name: r'soHieu',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'soHieu',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'tenVanBan': IndexSchema(
      id: -2933781547802953105,
      name: r'tenVanBan',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'tenVanBan',
          type: IndexType.value,
          caseSensitive: true,
        )
      ],
    ),
    r'loaiVanBan': IndexSchema(
      id: -5653490408397230628,
      name: r'loaiVanBan',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'loaiVanBan',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'ngayBanHanh': IndexSchema(
      id: -8467237532423833344,
      name: r'ngayBanHanh',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'ngayBanHanh',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _documentGetId,
  getLinks: _documentGetLinks,
  attach: _documentAttach,
  version: '3.1.0+1',
);

int _documentEstimateSize(
  Document object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.loaiVanBan.length * 3;
  bytesCount += 3 + object.noiDung.length * 3;
  bytesCount += 3 + object.soHieu.length * 3;
  bytesCount += 3 + object.tenVanBan.length * 3;
  return bytesCount;
}

void _documentSerialize(
  Document object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.loaiVanBan);
  writer.writeDateTime(offsets[2], object.ngayBanHanh);
  writer.writeString(offsets[3], object.noiDung);
  writer.writeString(offsets[4], object.soHieu);
  writer.writeString(offsets[5], object.tenVanBan);
}

Document _documentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Document();
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  object.loaiVanBan = reader.readString(offsets[1]);
  object.ngayBanHanh = reader.readDateTime(offsets[2]);
  object.noiDung = reader.readString(offsets[3]);
  object.soHieu = reader.readString(offsets[4]);
  object.tenVanBan = reader.readString(offsets[5]);
  return object;
}

P _documentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _documentGetId(Document object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _documentGetLinks(Document object) {
  return [];
}

void _documentAttach(IsarCollection<dynamic> col, Id id, Document object) {
  object.id = id;
}

extension DocumentQueryWhereSort on QueryBuilder<Document, Document, QWhere> {
  QueryBuilder<Document, Document, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Document, Document, QAfterWhere> anyTenVanBan() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'tenVanBan'),
      );
    });
  }

  QueryBuilder<Document, Document, QAfterWhere> anyNgayBanHanh() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'ngayBanHanh'),
      );
    });
  }
}

extension DocumentQueryWhere on QueryBuilder<Document, Document, QWhereClause> {
  QueryBuilder<Document, Document, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> soHieuEqualTo(
      String soHieu) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'soHieu',
        value: [soHieu],
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> soHieuNotEqualTo(
      String soHieu) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'soHieu',
              lower: [],
              upper: [soHieu],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'soHieu',
              lower: [soHieu],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'soHieu',
              lower: [soHieu],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'soHieu',
              lower: [],
              upper: [soHieu],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> tenVanBanEqualTo(
      String tenVanBan) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tenVanBan',
        value: [tenVanBan],
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> tenVanBanNotEqualTo(
      String tenVanBan) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenVanBan',
              lower: [],
              upper: [tenVanBan],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenVanBan',
              lower: [tenVanBan],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenVanBan',
              lower: [tenVanBan],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'tenVanBan',
              lower: [],
              upper: [tenVanBan],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> tenVanBanGreaterThan(
    String tenVanBan, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tenVanBan',
        lower: [tenVanBan],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> tenVanBanLessThan(
    String tenVanBan, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tenVanBan',
        lower: [],
        upper: [tenVanBan],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> tenVanBanBetween(
    String lowerTenVanBan,
    String upperTenVanBan, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tenVanBan',
        lower: [lowerTenVanBan],
        includeLower: includeLower,
        upper: [upperTenVanBan],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> tenVanBanStartsWith(
      String TenVanBanPrefix) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'tenVanBan',
        lower: [TenVanBanPrefix],
        upper: ['$TenVanBanPrefix\u{FFFFF}'],
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> tenVanBanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'tenVanBan',
        value: [''],
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> tenVanBanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'tenVanBan',
              upper: [''],
            ))
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'tenVanBan',
              lower: [''],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.greaterThan(
              indexName: r'tenVanBan',
              lower: [''],
            ))
            .addWhereClause(IndexWhereClause.lessThan(
              indexName: r'tenVanBan',
              upper: [''],
            ));
      }
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> loaiVanBanEqualTo(
      String loaiVanBan) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'loaiVanBan',
        value: [loaiVanBan],
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> loaiVanBanNotEqualTo(
      String loaiVanBan) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'loaiVanBan',
              lower: [],
              upper: [loaiVanBan],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'loaiVanBan',
              lower: [loaiVanBan],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'loaiVanBan',
              lower: [loaiVanBan],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'loaiVanBan',
              lower: [],
              upper: [loaiVanBan],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> ngayBanHanhEqualTo(
      DateTime ngayBanHanh) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'ngayBanHanh',
        value: [ngayBanHanh],
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> ngayBanHanhNotEqualTo(
      DateTime ngayBanHanh) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ngayBanHanh',
              lower: [],
              upper: [ngayBanHanh],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ngayBanHanh',
              lower: [ngayBanHanh],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ngayBanHanh',
              lower: [ngayBanHanh],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'ngayBanHanh',
              lower: [],
              upper: [ngayBanHanh],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> ngayBanHanhGreaterThan(
    DateTime ngayBanHanh, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ngayBanHanh',
        lower: [ngayBanHanh],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> ngayBanHanhLessThan(
    DateTime ngayBanHanh, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ngayBanHanh',
        lower: [],
        upper: [ngayBanHanh],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterWhereClause> ngayBanHanhBetween(
    DateTime lowerNgayBanHanh,
    DateTime upperNgayBanHanh, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'ngayBanHanh',
        lower: [lowerNgayBanHanh],
        includeLower: includeLower,
        upper: [upperNgayBanHanh],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DocumentQueryFilter
    on QueryBuilder<Document, Document, QFilterCondition> {
  QueryBuilder<Document, Document, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> loaiVanBanEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loaiVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> loaiVanBanGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'loaiVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> loaiVanBanLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'loaiVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> loaiVanBanBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'loaiVanBan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> loaiVanBanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'loaiVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> loaiVanBanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'loaiVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> loaiVanBanContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'loaiVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> loaiVanBanMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'loaiVanBan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> loaiVanBanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'loaiVanBan',
        value: '',
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition>
      loaiVanBanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'loaiVanBan',
        value: '',
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> ngayBanHanhEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ngayBanHanh',
        value: value,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition>
      ngayBanHanhGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ngayBanHanh',
        value: value,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> ngayBanHanhLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ngayBanHanh',
        value: value,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> ngayBanHanhBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ngayBanHanh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noiDung',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noiDung',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noiDung',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noiDung',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noiDung',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noiDung',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noiDung',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noiDung',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noiDung',
        value: '',
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> noiDungIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noiDung',
        value: '',
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'soHieu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'soHieu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'soHieu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'soHieu',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'soHieu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'soHieu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'soHieu',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'soHieu',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'soHieu',
        value: '',
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> soHieuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'soHieu',
        value: '',
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> tenVanBanEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> tenVanBanGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tenVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> tenVanBanLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tenVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> tenVanBanBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tenVanBan',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> tenVanBanStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tenVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> tenVanBanEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tenVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> tenVanBanContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tenVanBan',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> tenVanBanMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tenVanBan',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition> tenVanBanIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tenVanBan',
        value: '',
      ));
    });
  }

  QueryBuilder<Document, Document, QAfterFilterCondition>
      tenVanBanIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tenVanBan',
        value: '',
      ));
    });
  }
}

extension DocumentQueryObject
    on QueryBuilder<Document, Document, QFilterCondition> {}

extension DocumentQueryLinks
    on QueryBuilder<Document, Document, QFilterCondition> {}

extension DocumentQuerySortBy on QueryBuilder<Document, Document, QSortBy> {
  QueryBuilder<Document, Document, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByLoaiVanBan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loaiVanBan', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByLoaiVanBanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loaiVanBan', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByNgayBanHanh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ngayBanHanh', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByNgayBanHanhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ngayBanHanh', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByNoiDung() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noiDung', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByNoiDungDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noiDung', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortBySoHieu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soHieu', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortBySoHieuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soHieu', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByTenVanBan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenVanBan', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> sortByTenVanBanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenVanBan', Sort.desc);
    });
  }
}

extension DocumentQuerySortThenBy
    on QueryBuilder<Document, Document, QSortThenBy> {
  QueryBuilder<Document, Document, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByLoaiVanBan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loaiVanBan', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByLoaiVanBanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'loaiVanBan', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByNgayBanHanh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ngayBanHanh', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByNgayBanHanhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ngayBanHanh', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByNoiDung() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noiDung', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByNoiDungDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'noiDung', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenBySoHieu() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soHieu', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenBySoHieuDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'soHieu', Sort.desc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByTenVanBan() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenVanBan', Sort.asc);
    });
  }

  QueryBuilder<Document, Document, QAfterSortBy> thenByTenVanBanDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tenVanBan', Sort.desc);
    });
  }
}

extension DocumentQueryWhereDistinct
    on QueryBuilder<Document, Document, QDistinct> {
  QueryBuilder<Document, Document, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Document, Document, QDistinct> distinctByLoaiVanBan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'loaiVanBan', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Document, Document, QDistinct> distinctByNgayBanHanh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ngayBanHanh');
    });
  }

  QueryBuilder<Document, Document, QDistinct> distinctByNoiDung(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noiDung', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Document, Document, QDistinct> distinctBySoHieu(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'soHieu', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Document, Document, QDistinct> distinctByTenVanBan(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tenVanBan', caseSensitive: caseSensitive);
    });
  }
}

extension DocumentQueryProperty
    on QueryBuilder<Document, Document, QQueryProperty> {
  QueryBuilder<Document, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Document, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Document, String, QQueryOperations> loaiVanBanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'loaiVanBan');
    });
  }

  QueryBuilder<Document, DateTime, QQueryOperations> ngayBanHanhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ngayBanHanh');
    });
  }

  QueryBuilder<Document, String, QQueryOperations> noiDungProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noiDung');
    });
  }

  QueryBuilder<Document, String, QQueryOperations> soHieuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'soHieu');
    });
  }

  QueryBuilder<Document, String, QQueryOperations> tenVanBanProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tenVanBan');
    });
  }
}
