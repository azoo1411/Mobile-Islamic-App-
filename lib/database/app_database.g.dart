// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SurahsTable extends Surahs with TableInfo<$SurahsTable, Surah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SurahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _nameArabicMeta =
      const VerificationMeta('nameArabic');
  @override
  late final GeneratedColumn<String> nameArabic = GeneratedColumn<String>(
      'name_arabic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameTransliterationMeta =
      const VerificationMeta('nameTransliteration');
  @override
  late final GeneratedColumn<String> nameTransliteration =
      GeneratedColumn<String>('name_transliteration', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _ayahCountMeta =
      const VerificationMeta('ayahCount');
  @override
  late final GeneratedColumn<int> ayahCount = GeneratedColumn<int>(
      'ayah_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _revelationTypeMeta =
      const VerificationMeta('revelationType');
  @override
  late final GeneratedColumn<String> revelationType = GeneratedColumn<String>(
      'revelation_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chronologicalOrderMeta =
      const VerificationMeta('chronologicalOrder');
  @override
  late final GeneratedColumn<int> chronologicalOrder = GeneratedColumn<int>(
      'chronological_order', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        number,
        nameArabic,
        nameTransliteration,
        ayahCount,
        revelationType,
        chronologicalOrder
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'surahs';
  @override
  VerificationContext validateIntegrity(Insertable<Surah> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    }
    if (data.containsKey('name_arabic')) {
      context.handle(
          _nameArabicMeta,
          nameArabic.isAcceptableOrUnknown(
              data['name_arabic']!, _nameArabicMeta));
    } else if (isInserting) {
      context.missing(_nameArabicMeta);
    }
    if (data.containsKey('name_transliteration')) {
      context.handle(
          _nameTransliterationMeta,
          nameTransliteration.isAcceptableOrUnknown(
              data['name_transliteration']!, _nameTransliterationMeta));
    } else if (isInserting) {
      context.missing(_nameTransliterationMeta);
    }
    if (data.containsKey('ayah_count')) {
      context.handle(_ayahCountMeta,
          ayahCount.isAcceptableOrUnknown(data['ayah_count']!, _ayahCountMeta));
    } else if (isInserting) {
      context.missing(_ayahCountMeta);
    }
    if (data.containsKey('revelation_type')) {
      context.handle(
          _revelationTypeMeta,
          revelationType.isAcceptableOrUnknown(
              data['revelation_type']!, _revelationTypeMeta));
    } else if (isInserting) {
      context.missing(_revelationTypeMeta);
    }
    if (data.containsKey('chronological_order')) {
      context.handle(
          _chronologicalOrderMeta,
          chronologicalOrder.isAcceptableOrUnknown(
              data['chronological_order']!, _chronologicalOrderMeta));
    } else if (isInserting) {
      context.missing(_chronologicalOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {number};
  @override
  Surah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Surah(
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      nameArabic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name_arabic'])!,
      nameTransliteration: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}name_transliteration'])!,
      ayahCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ayah_count'])!,
      revelationType: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}revelation_type'])!,
      chronologicalOrder: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}chronological_order'])!,
    );
  }

  @override
  $SurahsTable createAlias(String alias) {
    return $SurahsTable(attachedDatabase, alias);
  }
}

class Surah extends DataClass implements Insertable<Surah> {
  final int number;
  final String nameArabic;
  final String nameTransliteration;
  final int ayahCount;
  final String revelationType;
  final int chronologicalOrder;
  const Surah(
      {required this.number,
      required this.nameArabic,
      required this.nameTransliteration,
      required this.ayahCount,
      required this.revelationType,
      required this.chronologicalOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['number'] = Variable<int>(number);
    map['name_arabic'] = Variable<String>(nameArabic);
    map['name_transliteration'] = Variable<String>(nameTransliteration);
    map['ayah_count'] = Variable<int>(ayahCount);
    map['revelation_type'] = Variable<String>(revelationType);
    map['chronological_order'] = Variable<int>(chronologicalOrder);
    return map;
  }

  SurahsCompanion toCompanion(bool nullToAbsent) {
    return SurahsCompanion(
      number: Value(number),
      nameArabic: Value(nameArabic),
      nameTransliteration: Value(nameTransliteration),
      ayahCount: Value(ayahCount),
      revelationType: Value(revelationType),
      chronologicalOrder: Value(chronologicalOrder),
    );
  }

  factory Surah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Surah(
      number: serializer.fromJson<int>(json['number']),
      nameArabic: serializer.fromJson<String>(json['nameArabic']),
      nameTransliteration:
          serializer.fromJson<String>(json['nameTransliteration']),
      ayahCount: serializer.fromJson<int>(json['ayahCount']),
      revelationType: serializer.fromJson<String>(json['revelationType']),
      chronologicalOrder: serializer.fromJson<int>(json['chronologicalOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'number': serializer.toJson<int>(number),
      'nameArabic': serializer.toJson<String>(nameArabic),
      'nameTransliteration': serializer.toJson<String>(nameTransliteration),
      'ayahCount': serializer.toJson<int>(ayahCount),
      'revelationType': serializer.toJson<String>(revelationType),
      'chronologicalOrder': serializer.toJson<int>(chronologicalOrder),
    };
  }

  Surah copyWith(
          {int? number,
          String? nameArabic,
          String? nameTransliteration,
          int? ayahCount,
          String? revelationType,
          int? chronologicalOrder}) =>
      Surah(
        number: number ?? this.number,
        nameArabic: nameArabic ?? this.nameArabic,
        nameTransliteration: nameTransliteration ?? this.nameTransliteration,
        ayahCount: ayahCount ?? this.ayahCount,
        revelationType: revelationType ?? this.revelationType,
        chronologicalOrder: chronologicalOrder ?? this.chronologicalOrder,
      );
  Surah copyWithCompanion(SurahsCompanion data) {
    return Surah(
      number: data.number.present ? data.number.value : this.number,
      nameArabic:
          data.nameArabic.present ? data.nameArabic.value : this.nameArabic,
      nameTransliteration: data.nameTransliteration.present
          ? data.nameTransliteration.value
          : this.nameTransliteration,
      ayahCount: data.ayahCount.present ? data.ayahCount.value : this.ayahCount,
      revelationType: data.revelationType.present
          ? data.revelationType.value
          : this.revelationType,
      chronologicalOrder: data.chronologicalOrder.present
          ? data.chronologicalOrder.value
          : this.chronologicalOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Surah(')
          ..write('number: $number, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameTransliteration: $nameTransliteration, ')
          ..write('ayahCount: $ayahCount, ')
          ..write('revelationType: $revelationType, ')
          ..write('chronologicalOrder: $chronologicalOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(number, nameArabic, nameTransliteration,
      ayahCount, revelationType, chronologicalOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Surah &&
          other.number == this.number &&
          other.nameArabic == this.nameArabic &&
          other.nameTransliteration == this.nameTransliteration &&
          other.ayahCount == this.ayahCount &&
          other.revelationType == this.revelationType &&
          other.chronologicalOrder == this.chronologicalOrder);
}

class SurahsCompanion extends UpdateCompanion<Surah> {
  final Value<int> number;
  final Value<String> nameArabic;
  final Value<String> nameTransliteration;
  final Value<int> ayahCount;
  final Value<String> revelationType;
  final Value<int> chronologicalOrder;
  const SurahsCompanion({
    this.number = const Value.absent(),
    this.nameArabic = const Value.absent(),
    this.nameTransliteration = const Value.absent(),
    this.ayahCount = const Value.absent(),
    this.revelationType = const Value.absent(),
    this.chronologicalOrder = const Value.absent(),
  });
  SurahsCompanion.insert({
    this.number = const Value.absent(),
    required String nameArabic,
    required String nameTransliteration,
    required int ayahCount,
    required String revelationType,
    required int chronologicalOrder,
  })  : nameArabic = Value(nameArabic),
        nameTransliteration = Value(nameTransliteration),
        ayahCount = Value(ayahCount),
        revelationType = Value(revelationType),
        chronologicalOrder = Value(chronologicalOrder);
  static Insertable<Surah> custom({
    Expression<int>? number,
    Expression<String>? nameArabic,
    Expression<String>? nameTransliteration,
    Expression<int>? ayahCount,
    Expression<String>? revelationType,
    Expression<int>? chronologicalOrder,
  }) {
    return RawValuesInsertable({
      if (number != null) 'number': number,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (nameTransliteration != null)
        'name_transliteration': nameTransliteration,
      if (ayahCount != null) 'ayah_count': ayahCount,
      if (revelationType != null) 'revelation_type': revelationType,
      if (chronologicalOrder != null) 'chronological_order': chronologicalOrder,
    });
  }

  SurahsCompanion copyWith(
      {Value<int>? number,
      Value<String>? nameArabic,
      Value<String>? nameTransliteration,
      Value<int>? ayahCount,
      Value<String>? revelationType,
      Value<int>? chronologicalOrder}) {
    return SurahsCompanion(
      number: number ?? this.number,
      nameArabic: nameArabic ?? this.nameArabic,
      nameTransliteration: nameTransliteration ?? this.nameTransliteration,
      ayahCount: ayahCount ?? this.ayahCount,
      revelationType: revelationType ?? this.revelationType,
      chronologicalOrder: chronologicalOrder ?? this.chronologicalOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (nameArabic.present) {
      map['name_arabic'] = Variable<String>(nameArabic.value);
    }
    if (nameTransliteration.present) {
      map['name_transliteration'] = Variable<String>(nameTransliteration.value);
    }
    if (ayahCount.present) {
      map['ayah_count'] = Variable<int>(ayahCount.value);
    }
    if (revelationType.present) {
      map['revelation_type'] = Variable<String>(revelationType.value);
    }
    if (chronologicalOrder.present) {
      map['chronological_order'] = Variable<int>(chronologicalOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SurahsCompanion(')
          ..write('number: $number, ')
          ..write('nameArabic: $nameArabic, ')
          ..write('nameTransliteration: $nameTransliteration, ')
          ..write('ayahCount: $ayahCount, ')
          ..write('revelationType: $revelationType, ')
          ..write('chronologicalOrder: $chronologicalOrder')
          ..write(')'))
        .toString();
  }
}

class $AyahsTable extends Ayahs with TableInfo<$AyahsTable, Ayah> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AyahsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _surahNumberMeta =
      const VerificationMeta('surahNumber');
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
      'surah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ayahNumberMeta =
      const VerificationMeta('ayahNumber');
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
      'ayah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textArabicMeta =
      const VerificationMeta('textArabic');
  @override
  late final GeneratedColumn<String> textArabic = GeneratedColumn<String>(
      'text_arabic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _textUthmaniMeta =
      const VerificationMeta('textUthmani');
  @override
  late final GeneratedColumn<String> textUthmani = GeneratedColumn<String>(
      'text_uthmani', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _pageNumberMeta =
      const VerificationMeta('pageNumber');
  @override
  late final GeneratedColumn<int> pageNumber = GeneratedColumn<int>(
      'page_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _juzNumberMeta =
      const VerificationMeta('juzNumber');
  @override
  late final GeneratedColumn<int> juzNumber = GeneratedColumn<int>(
      'juz_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hizbNumberMeta =
      const VerificationMeta('hizbNumber');
  @override
  late final GeneratedColumn<int> hizbNumber = GeneratedColumn<int>(
      'hizb_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        surahNumber,
        ayahNumber,
        textArabic,
        textUthmani,
        pageNumber,
        juzNumber,
        hizbNumber
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ayahs';
  @override
  VerificationContext validateIntegrity(Insertable<Ayah> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
          _surahNumberMeta,
          surahNumber.isAcceptableOrUnknown(
              data['surah_number']!, _surahNumberMeta));
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
          _ayahNumberMeta,
          ayahNumber.isAcceptableOrUnknown(
              data['ayah_number']!, _ayahNumberMeta));
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('text_arabic')) {
      context.handle(
          _textArabicMeta,
          textArabic.isAcceptableOrUnknown(
              data['text_arabic']!, _textArabicMeta));
    } else if (isInserting) {
      context.missing(_textArabicMeta);
    }
    if (data.containsKey('text_uthmani')) {
      context.handle(
          _textUthmaniMeta,
          textUthmani.isAcceptableOrUnknown(
              data['text_uthmani']!, _textUthmaniMeta));
    } else if (isInserting) {
      context.missing(_textUthmaniMeta);
    }
    if (data.containsKey('page_number')) {
      context.handle(
          _pageNumberMeta,
          pageNumber.isAcceptableOrUnknown(
              data['page_number']!, _pageNumberMeta));
    } else if (isInserting) {
      context.missing(_pageNumberMeta);
    }
    if (data.containsKey('juz_number')) {
      context.handle(_juzNumberMeta,
          juzNumber.isAcceptableOrUnknown(data['juz_number']!, _juzNumberMeta));
    } else if (isInserting) {
      context.missing(_juzNumberMeta);
    }
    if (data.containsKey('hizb_number')) {
      context.handle(
          _hizbNumberMeta,
          hizbNumber.isAcceptableOrUnknown(
              data['hizb_number']!, _hizbNumberMeta));
    } else if (isInserting) {
      context.missing(_hizbNumberMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ayah map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ayah(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      surahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_number'])!,
      ayahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ayah_number'])!,
      textArabic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_arabic'])!,
      textUthmani: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_uthmani'])!,
      pageNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}page_number'])!,
      juzNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}juz_number'])!,
      hizbNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hizb_number'])!,
    );
  }

  @override
  $AyahsTable createAlias(String alias) {
    return $AyahsTable(attachedDatabase, alias);
  }
}

class Ayah extends DataClass implements Insertable<Ayah> {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String textArabic;
  final String textUthmani;
  final int pageNumber;
  final int juzNumber;
  final int hizbNumber;
  const Ayah(
      {required this.id,
      required this.surahNumber,
      required this.ayahNumber,
      required this.textArabic,
      required this.textUthmani,
      required this.pageNumber,
      required this.juzNumber,
      required this.hizbNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['text_arabic'] = Variable<String>(textArabic);
    map['text_uthmani'] = Variable<String>(textUthmani);
    map['page_number'] = Variable<int>(pageNumber);
    map['juz_number'] = Variable<int>(juzNumber);
    map['hizb_number'] = Variable<int>(hizbNumber);
    return map;
  }

  AyahsCompanion toCompanion(bool nullToAbsent) {
    return AyahsCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      textArabic: Value(textArabic),
      textUthmani: Value(textUthmani),
      pageNumber: Value(pageNumber),
      juzNumber: Value(juzNumber),
      hizbNumber: Value(hizbNumber),
    );
  }

  factory Ayah.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ayah(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      textArabic: serializer.fromJson<String>(json['textArabic']),
      textUthmani: serializer.fromJson<String>(json['textUthmani']),
      pageNumber: serializer.fromJson<int>(json['pageNumber']),
      juzNumber: serializer.fromJson<int>(json['juzNumber']),
      hizbNumber: serializer.fromJson<int>(json['hizbNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'textArabic': serializer.toJson<String>(textArabic),
      'textUthmani': serializer.toJson<String>(textUthmani),
      'pageNumber': serializer.toJson<int>(pageNumber),
      'juzNumber': serializer.toJson<int>(juzNumber),
      'hizbNumber': serializer.toJson<int>(hizbNumber),
    };
  }

  Ayah copyWith(
          {int? id,
          int? surahNumber,
          int? ayahNumber,
          String? textArabic,
          String? textUthmani,
          int? pageNumber,
          int? juzNumber,
          int? hizbNumber}) =>
      Ayah(
        id: id ?? this.id,
        surahNumber: surahNumber ?? this.surahNumber,
        ayahNumber: ayahNumber ?? this.ayahNumber,
        textArabic: textArabic ?? this.textArabic,
        textUthmani: textUthmani ?? this.textUthmani,
        pageNumber: pageNumber ?? this.pageNumber,
        juzNumber: juzNumber ?? this.juzNumber,
        hizbNumber: hizbNumber ?? this.hizbNumber,
      );
  Ayah copyWithCompanion(AyahsCompanion data) {
    return Ayah(
      id: data.id.present ? data.id.value : this.id,
      surahNumber:
          data.surahNumber.present ? data.surahNumber.value : this.surahNumber,
      ayahNumber:
          data.ayahNumber.present ? data.ayahNumber.value : this.ayahNumber,
      textArabic:
          data.textArabic.present ? data.textArabic.value : this.textArabic,
      textUthmani:
          data.textUthmani.present ? data.textUthmani.value : this.textUthmani,
      pageNumber:
          data.pageNumber.present ? data.pageNumber.value : this.pageNumber,
      juzNumber: data.juzNumber.present ? data.juzNumber.value : this.juzNumber,
      hizbNumber:
          data.hizbNumber.present ? data.hizbNumber.value : this.hizbNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ayah(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('textArabic: $textArabic, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('hizbNumber: $hizbNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, surahNumber, ayahNumber, textArabic,
      textUthmani, pageNumber, juzNumber, hizbNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ayah &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.textArabic == this.textArabic &&
          other.textUthmani == this.textUthmani &&
          other.pageNumber == this.pageNumber &&
          other.juzNumber == this.juzNumber &&
          other.hizbNumber == this.hizbNumber);
}

class AyahsCompanion extends UpdateCompanion<Ayah> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String> textArabic;
  final Value<String> textUthmani;
  final Value<int> pageNumber;
  final Value<int> juzNumber;
  final Value<int> hizbNumber;
  const AyahsCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.textArabic = const Value.absent(),
    this.textUthmani = const Value.absent(),
    this.pageNumber = const Value.absent(),
    this.juzNumber = const Value.absent(),
    this.hizbNumber = const Value.absent(),
  });
  AyahsCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int ayahNumber,
    required String textArabic,
    required String textUthmani,
    required int pageNumber,
    required int juzNumber,
    required int hizbNumber,
  })  : surahNumber = Value(surahNumber),
        ayahNumber = Value(ayahNumber),
        textArabic = Value(textArabic),
        textUthmani = Value(textUthmani),
        pageNumber = Value(pageNumber),
        juzNumber = Value(juzNumber),
        hizbNumber = Value(hizbNumber);
  static Insertable<Ayah> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? textArabic,
    Expression<String>? textUthmani,
    Expression<int>? pageNumber,
    Expression<int>? juzNumber,
    Expression<int>? hizbNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (textArabic != null) 'text_arabic': textArabic,
      if (textUthmani != null) 'text_uthmani': textUthmani,
      if (pageNumber != null) 'page_number': pageNumber,
      if (juzNumber != null) 'juz_number': juzNumber,
      if (hizbNumber != null) 'hizb_number': hizbNumber,
    });
  }

  AyahsCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahNumber,
      Value<int>? ayahNumber,
      Value<String>? textArabic,
      Value<String>? textUthmani,
      Value<int>? pageNumber,
      Value<int>? juzNumber,
      Value<int>? hizbNumber}) {
    return AyahsCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      textArabic: textArabic ?? this.textArabic,
      textUthmani: textUthmani ?? this.textUthmani,
      pageNumber: pageNumber ?? this.pageNumber,
      juzNumber: juzNumber ?? this.juzNumber,
      hizbNumber: hizbNumber ?? this.hizbNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (textArabic.present) {
      map['text_arabic'] = Variable<String>(textArabic.value);
    }
    if (textUthmani.present) {
      map['text_uthmani'] = Variable<String>(textUthmani.value);
    }
    if (pageNumber.present) {
      map['page_number'] = Variable<int>(pageNumber.value);
    }
    if (juzNumber.present) {
      map['juz_number'] = Variable<int>(juzNumber.value);
    }
    if (hizbNumber.present) {
      map['hizb_number'] = Variable<int>(hizbNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AyahsCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('textArabic: $textArabic, ')
          ..write('textUthmani: $textUthmani, ')
          ..write('pageNumber: $pageNumber, ')
          ..write('juzNumber: $juzNumber, ')
          ..write('hizbNumber: $hizbNumber')
          ..write(')'))
        .toString();
  }
}

class $TafseersTable extends Tafseers with TableInfo<$TafseersTable, Tafseer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TafseersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _surahNumberMeta =
      const VerificationMeta('surahNumber');
  @override
  late final GeneratedColumn<int> surahNumber = GeneratedColumn<int>(
      'surah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _ayahNumberMeta =
      const VerificationMeta('ayahNumber');
  @override
  late final GeneratedColumn<int> ayahNumber = GeneratedColumn<int>(
      'ayah_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _textArabicMeta =
      const VerificationMeta('textArabic');
  @override
  late final GeneratedColumn<String> textArabic = GeneratedColumn<String>(
      'text_arabic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, surahNumber, ayahNumber, source, textArabic];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tafseers';
  @override
  VerificationContext validateIntegrity(Insertable<Tafseer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('surah_number')) {
      context.handle(
          _surahNumberMeta,
          surahNumber.isAcceptableOrUnknown(
              data['surah_number']!, _surahNumberMeta));
    } else if (isInserting) {
      context.missing(_surahNumberMeta);
    }
    if (data.containsKey('ayah_number')) {
      context.handle(
          _ayahNumberMeta,
          ayahNumber.isAcceptableOrUnknown(
              data['ayah_number']!, _ayahNumberMeta));
    } else if (isInserting) {
      context.missing(_ayahNumberMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('text_arabic')) {
      context.handle(
          _textArabicMeta,
          textArabic.isAcceptableOrUnknown(
              data['text_arabic']!, _textArabicMeta));
    } else if (isInserting) {
      context.missing(_textArabicMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tafseer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tafseer(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      surahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}surah_number'])!,
      ayahNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ayah_number'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      textArabic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_arabic'])!,
    );
  }

  @override
  $TafseersTable createAlias(String alias) {
    return $TafseersTable(attachedDatabase, alias);
  }
}

class Tafseer extends DataClass implements Insertable<Tafseer> {
  final int id;
  final int surahNumber;
  final int ayahNumber;
  final String source;
  final String textArabic;
  const Tafseer(
      {required this.id,
      required this.surahNumber,
      required this.ayahNumber,
      required this.source,
      required this.textArabic});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['surah_number'] = Variable<int>(surahNumber);
    map['ayah_number'] = Variable<int>(ayahNumber);
    map['source'] = Variable<String>(source);
    map['text_arabic'] = Variable<String>(textArabic);
    return map;
  }

  TafseersCompanion toCompanion(bool nullToAbsent) {
    return TafseersCompanion(
      id: Value(id),
      surahNumber: Value(surahNumber),
      ayahNumber: Value(ayahNumber),
      source: Value(source),
      textArabic: Value(textArabic),
    );
  }

  factory Tafseer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tafseer(
      id: serializer.fromJson<int>(json['id']),
      surahNumber: serializer.fromJson<int>(json['surahNumber']),
      ayahNumber: serializer.fromJson<int>(json['ayahNumber']),
      source: serializer.fromJson<String>(json['source']),
      textArabic: serializer.fromJson<String>(json['textArabic']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'surahNumber': serializer.toJson<int>(surahNumber),
      'ayahNumber': serializer.toJson<int>(ayahNumber),
      'source': serializer.toJson<String>(source),
      'textArabic': serializer.toJson<String>(textArabic),
    };
  }

  Tafseer copyWith(
          {int? id,
          int? surahNumber,
          int? ayahNumber,
          String? source,
          String? textArabic}) =>
      Tafseer(
        id: id ?? this.id,
        surahNumber: surahNumber ?? this.surahNumber,
        ayahNumber: ayahNumber ?? this.ayahNumber,
        source: source ?? this.source,
        textArabic: textArabic ?? this.textArabic,
      );
  Tafseer copyWithCompanion(TafseersCompanion data) {
    return Tafseer(
      id: data.id.present ? data.id.value : this.id,
      surahNumber:
          data.surahNumber.present ? data.surahNumber.value : this.surahNumber,
      ayahNumber:
          data.ayahNumber.present ? data.ayahNumber.value : this.ayahNumber,
      source: data.source.present ? data.source.value : this.source,
      textArabic:
          data.textArabic.present ? data.textArabic.value : this.textArabic,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tafseer(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('source: $source, ')
          ..write('textArabic: $textArabic')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, surahNumber, ayahNumber, source, textArabic);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tafseer &&
          other.id == this.id &&
          other.surahNumber == this.surahNumber &&
          other.ayahNumber == this.ayahNumber &&
          other.source == this.source &&
          other.textArabic == this.textArabic);
}

class TafseersCompanion extends UpdateCompanion<Tafseer> {
  final Value<int> id;
  final Value<int> surahNumber;
  final Value<int> ayahNumber;
  final Value<String> source;
  final Value<String> textArabic;
  const TafseersCompanion({
    this.id = const Value.absent(),
    this.surahNumber = const Value.absent(),
    this.ayahNumber = const Value.absent(),
    this.source = const Value.absent(),
    this.textArabic = const Value.absent(),
  });
  TafseersCompanion.insert({
    this.id = const Value.absent(),
    required int surahNumber,
    required int ayahNumber,
    required String source,
    required String textArabic,
  })  : surahNumber = Value(surahNumber),
        ayahNumber = Value(ayahNumber),
        source = Value(source),
        textArabic = Value(textArabic);
  static Insertable<Tafseer> custom({
    Expression<int>? id,
    Expression<int>? surahNumber,
    Expression<int>? ayahNumber,
    Expression<String>? source,
    Expression<String>? textArabic,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (surahNumber != null) 'surah_number': surahNumber,
      if (ayahNumber != null) 'ayah_number': ayahNumber,
      if (source != null) 'source': source,
      if (textArabic != null) 'text_arabic': textArabic,
    });
  }

  TafseersCompanion copyWith(
      {Value<int>? id,
      Value<int>? surahNumber,
      Value<int>? ayahNumber,
      Value<String>? source,
      Value<String>? textArabic}) {
    return TafseersCompanion(
      id: id ?? this.id,
      surahNumber: surahNumber ?? this.surahNumber,
      ayahNumber: ayahNumber ?? this.ayahNumber,
      source: source ?? this.source,
      textArabic: textArabic ?? this.textArabic,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (surahNumber.present) {
      map['surah_number'] = Variable<int>(surahNumber.value);
    }
    if (ayahNumber.present) {
      map['ayah_number'] = Variable<int>(ayahNumber.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (textArabic.present) {
      map['text_arabic'] = Variable<String>(textArabic.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TafseersCompanion(')
          ..write('id: $id, ')
          ..write('surahNumber: $surahNumber, ')
          ..write('ayahNumber: $ayahNumber, ')
          ..write('source: $source, ')
          ..write('textArabic: $textArabic')
          ..write(')'))
        .toString();
  }
}

class $HadithsTable extends Hadiths with TableInfo<$HadithsTable, Hadith> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HadithsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterIdMeta =
      const VerificationMeta('chapterId');
  @override
  late final GeneratedColumn<int> chapterId = GeneratedColumn<int>(
      'chapter_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _hadithNumberMeta =
      const VerificationMeta('hadithNumber');
  @override
  late final GeneratedColumn<int> hadithNumber = GeneratedColumn<int>(
      'hadith_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _textArabicMeta =
      const VerificationMeta('textArabic');
  @override
  late final GeneratedColumn<String> textArabic = GeneratedColumn<String>(
      'text_arabic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _narratorMeta =
      const VerificationMeta('narrator');
  @override
  late final GeneratedColumn<String> narrator = GeneratedColumn<String>(
      'narrator', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
      'grade', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _referenceNumberMeta =
      const VerificationMeta('referenceNumber');
  @override
  late final GeneratedColumn<int> referenceNumber = GeneratedColumn<int>(
      'reference_number', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        bookId,
        chapterId,
        hadithNumber,
        textArabic,
        narrator,
        grade,
        referenceNumber
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hadiths';
  @override
  VerificationContext validateIntegrity(Insertable<Hadith> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_id')) {
      context.handle(_chapterIdMeta,
          chapterId.isAcceptableOrUnknown(data['chapter_id']!, _chapterIdMeta));
    } else if (isInserting) {
      context.missing(_chapterIdMeta);
    }
    if (data.containsKey('hadith_number')) {
      context.handle(
          _hadithNumberMeta,
          hadithNumber.isAcceptableOrUnknown(
              data['hadith_number']!, _hadithNumberMeta));
    } else if (isInserting) {
      context.missing(_hadithNumberMeta);
    }
    if (data.containsKey('text_arabic')) {
      context.handle(
          _textArabicMeta,
          textArabic.isAcceptableOrUnknown(
              data['text_arabic']!, _textArabicMeta));
    } else if (isInserting) {
      context.missing(_textArabicMeta);
    }
    if (data.containsKey('narrator')) {
      context.handle(_narratorMeta,
          narrator.isAcceptableOrUnknown(data['narrator']!, _narratorMeta));
    } else if (isInserting) {
      context.missing(_narratorMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
          _gradeMeta, grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta));
    }
    if (data.containsKey('reference_number')) {
      context.handle(
          _referenceNumberMeta,
          referenceNumber.isAcceptableOrUnknown(
              data['reference_number']!, _referenceNumberMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hadith map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hadith(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      chapterId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_id'])!,
      hadithNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hadith_number'])!,
      textArabic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text_arabic'])!,
      narrator: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}narrator'])!,
      grade: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}grade']),
      referenceNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}reference_number']),
    );
  }

  @override
  $HadithsTable createAlias(String alias) {
    return $HadithsTable(attachedDatabase, alias);
  }
}

class Hadith extends DataClass implements Insertable<Hadith> {
  final int id;
  final String bookId;
  final int chapterId;
  final int hadithNumber;
  final String textArabic;
  final String narrator;
  final String? grade;
  final int? referenceNumber;
  const Hadith(
      {required this.id,
      required this.bookId,
      required this.chapterId,
      required this.hadithNumber,
      required this.textArabic,
      required this.narrator,
      this.grade,
      this.referenceNumber});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<String>(bookId);
    map['chapter_id'] = Variable<int>(chapterId);
    map['hadith_number'] = Variable<int>(hadithNumber);
    map['text_arabic'] = Variable<String>(textArabic);
    map['narrator'] = Variable<String>(narrator);
    if (!nullToAbsent || grade != null) {
      map['grade'] = Variable<String>(grade);
    }
    if (!nullToAbsent || referenceNumber != null) {
      map['reference_number'] = Variable<int>(referenceNumber);
    }
    return map;
  }

  HadithsCompanion toCompanion(bool nullToAbsent) {
    return HadithsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterId: Value(chapterId),
      hadithNumber: Value(hadithNumber),
      textArabic: Value(textArabic),
      narrator: Value(narrator),
      grade:
          grade == null && nullToAbsent ? const Value.absent() : Value(grade),
      referenceNumber: referenceNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(referenceNumber),
    );
  }

  factory Hadith.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hadith(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterId: serializer.fromJson<int>(json['chapterId']),
      hadithNumber: serializer.fromJson<int>(json['hadithNumber']),
      textArabic: serializer.fromJson<String>(json['textArabic']),
      narrator: serializer.fromJson<String>(json['narrator']),
      grade: serializer.fromJson<String?>(json['grade']),
      referenceNumber: serializer.fromJson<int?>(json['referenceNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<String>(bookId),
      'chapterId': serializer.toJson<int>(chapterId),
      'hadithNumber': serializer.toJson<int>(hadithNumber),
      'textArabic': serializer.toJson<String>(textArabic),
      'narrator': serializer.toJson<String>(narrator),
      'grade': serializer.toJson<String?>(grade),
      'referenceNumber': serializer.toJson<int?>(referenceNumber),
    };
  }

  Hadith copyWith(
          {int? id,
          String? bookId,
          int? chapterId,
          int? hadithNumber,
          String? textArabic,
          String? narrator,
          Value<String?> grade = const Value.absent(),
          Value<int?> referenceNumber = const Value.absent()}) =>
      Hadith(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        chapterId: chapterId ?? this.chapterId,
        hadithNumber: hadithNumber ?? this.hadithNumber,
        textArabic: textArabic ?? this.textArabic,
        narrator: narrator ?? this.narrator,
        grade: grade.present ? grade.value : this.grade,
        referenceNumber: referenceNumber.present
            ? referenceNumber.value
            : this.referenceNumber,
      );
  Hadith copyWithCompanion(HadithsCompanion data) {
    return Hadith(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterId: data.chapterId.present ? data.chapterId.value : this.chapterId,
      hadithNumber: data.hadithNumber.present
          ? data.hadithNumber.value
          : this.hadithNumber,
      textArabic:
          data.textArabic.present ? data.textArabic.value : this.textArabic,
      narrator: data.narrator.present ? data.narrator.value : this.narrator,
      grade: data.grade.present ? data.grade.value : this.grade,
      referenceNumber: data.referenceNumber.present
          ? data.referenceNumber.value
          : this.referenceNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hadith(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('hadithNumber: $hadithNumber, ')
          ..write('textArabic: $textArabic, ')
          ..write('narrator: $narrator, ')
          ..write('grade: $grade, ')
          ..write('referenceNumber: $referenceNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, chapterId, hadithNumber,
      textArabic, narrator, grade, referenceNumber);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hadith &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterId == this.chapterId &&
          other.hadithNumber == this.hadithNumber &&
          other.textArabic == this.textArabic &&
          other.narrator == this.narrator &&
          other.grade == this.grade &&
          other.referenceNumber == this.referenceNumber);
}

class HadithsCompanion extends UpdateCompanion<Hadith> {
  final Value<int> id;
  final Value<String> bookId;
  final Value<int> chapterId;
  final Value<int> hadithNumber;
  final Value<String> textArabic;
  final Value<String> narrator;
  final Value<String?> grade;
  final Value<int?> referenceNumber;
  const HadithsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterId = const Value.absent(),
    this.hadithNumber = const Value.absent(),
    this.textArabic = const Value.absent(),
    this.narrator = const Value.absent(),
    this.grade = const Value.absent(),
    this.referenceNumber = const Value.absent(),
  });
  HadithsCompanion.insert({
    this.id = const Value.absent(),
    required String bookId,
    required int chapterId,
    required int hadithNumber,
    required String textArabic,
    required String narrator,
    this.grade = const Value.absent(),
    this.referenceNumber = const Value.absent(),
  })  : bookId = Value(bookId),
        chapterId = Value(chapterId),
        hadithNumber = Value(hadithNumber),
        textArabic = Value(textArabic),
        narrator = Value(narrator);
  static Insertable<Hadith> custom({
    Expression<int>? id,
    Expression<String>? bookId,
    Expression<int>? chapterId,
    Expression<int>? hadithNumber,
    Expression<String>? textArabic,
    Expression<String>? narrator,
    Expression<String>? grade,
    Expression<int>? referenceNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapterId != null) 'chapter_id': chapterId,
      if (hadithNumber != null) 'hadith_number': hadithNumber,
      if (textArabic != null) 'text_arabic': textArabic,
      if (narrator != null) 'narrator': narrator,
      if (grade != null) 'grade': grade,
      if (referenceNumber != null) 'reference_number': referenceNumber,
    });
  }

  HadithsCompanion copyWith(
      {Value<int>? id,
      Value<String>? bookId,
      Value<int>? chapterId,
      Value<int>? hadithNumber,
      Value<String>? textArabic,
      Value<String>? narrator,
      Value<String?>? grade,
      Value<int?>? referenceNumber}) {
    return HadithsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterId: chapterId ?? this.chapterId,
      hadithNumber: hadithNumber ?? this.hadithNumber,
      textArabic: textArabic ?? this.textArabic,
      narrator: narrator ?? this.narrator,
      grade: grade ?? this.grade,
      referenceNumber: referenceNumber ?? this.referenceNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterId.present) {
      map['chapter_id'] = Variable<int>(chapterId.value);
    }
    if (hadithNumber.present) {
      map['hadith_number'] = Variable<int>(hadithNumber.value);
    }
    if (textArabic.present) {
      map['text_arabic'] = Variable<String>(textArabic.value);
    }
    if (narrator.present) {
      map['narrator'] = Variable<String>(narrator.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (referenceNumber.present) {
      map['reference_number'] = Variable<int>(referenceNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HadithsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterId: $chapterId, ')
          ..write('hadithNumber: $hadithNumber, ')
          ..write('textArabic: $textArabic, ')
          ..write('narrator: $narrator, ')
          ..write('grade: $grade, ')
          ..write('referenceNumber: $referenceNumber')
          ..write(')'))
        .toString();
  }
}

class $HadithChaptersTable extends HadithChapters
    with TableInfo<$HadithChaptersTable, HadithChapter> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HadithChaptersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<String> bookId = GeneratedColumn<String>(
      'book_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterNumberMeta =
      const VerificationMeta('chapterNumber');
  @override
  late final GeneratedColumn<int> chapterNumber = GeneratedColumn<int>(
      'chapter_number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleArabicMeta =
      const VerificationMeta('titleArabic');
  @override
  late final GeneratedColumn<String> titleArabic = GeneratedColumn<String>(
      'title_arabic', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _hadithCountMeta =
      const VerificationMeta('hadithCount');
  @override
  late final GeneratedColumn<int> hadithCount = GeneratedColumn<int>(
      'hadith_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookId, chapterNumber, titleArabic, hadithCount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hadith_chapters';
  @override
  VerificationContext validateIntegrity(Insertable<HadithChapter> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('chapter_number')) {
      context.handle(
          _chapterNumberMeta,
          chapterNumber.isAcceptableOrUnknown(
              data['chapter_number']!, _chapterNumberMeta));
    } else if (isInserting) {
      context.missing(_chapterNumberMeta);
    }
    if (data.containsKey('title_arabic')) {
      context.handle(
          _titleArabicMeta,
          titleArabic.isAcceptableOrUnknown(
              data['title_arabic']!, _titleArabicMeta));
    } else if (isInserting) {
      context.missing(_titleArabicMeta);
    }
    if (data.containsKey('hadith_count')) {
      context.handle(
          _hadithCountMeta,
          hadithCount.isAcceptableOrUnknown(
              data['hadith_count']!, _hadithCountMeta));
    } else if (isInserting) {
      context.missing(_hadithCountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  HadithChapter map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HadithChapter(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_id'])!,
      chapterNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter_number'])!,
      titleArabic: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title_arabic'])!,
      hadithCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}hadith_count'])!,
    );
  }

  @override
  $HadithChaptersTable createAlias(String alias) {
    return $HadithChaptersTable(attachedDatabase, alias);
  }
}

class HadithChapter extends DataClass implements Insertable<HadithChapter> {
  final int id;
  final String bookId;
  final int chapterNumber;
  final String titleArabic;
  final int hadithCount;
  const HadithChapter(
      {required this.id,
      required this.bookId,
      required this.chapterNumber,
      required this.titleArabic,
      required this.hadithCount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<String>(bookId);
    map['chapter_number'] = Variable<int>(chapterNumber);
    map['title_arabic'] = Variable<String>(titleArabic);
    map['hadith_count'] = Variable<int>(hadithCount);
    return map;
  }

  HadithChaptersCompanion toCompanion(bool nullToAbsent) {
    return HadithChaptersCompanion(
      id: Value(id),
      bookId: Value(bookId),
      chapterNumber: Value(chapterNumber),
      titleArabic: Value(titleArabic),
      hadithCount: Value(hadithCount),
    );
  }

  factory HadithChapter.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HadithChapter(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<String>(json['bookId']),
      chapterNumber: serializer.fromJson<int>(json['chapterNumber']),
      titleArabic: serializer.fromJson<String>(json['titleArabic']),
      hadithCount: serializer.fromJson<int>(json['hadithCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<String>(bookId),
      'chapterNumber': serializer.toJson<int>(chapterNumber),
      'titleArabic': serializer.toJson<String>(titleArabic),
      'hadithCount': serializer.toJson<int>(hadithCount),
    };
  }

  HadithChapter copyWith(
          {int? id,
          String? bookId,
          int? chapterNumber,
          String? titleArabic,
          int? hadithCount}) =>
      HadithChapter(
        id: id ?? this.id,
        bookId: bookId ?? this.bookId,
        chapterNumber: chapterNumber ?? this.chapterNumber,
        titleArabic: titleArabic ?? this.titleArabic,
        hadithCount: hadithCount ?? this.hadithCount,
      );
  HadithChapter copyWithCompanion(HadithChaptersCompanion data) {
    return HadithChapter(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      chapterNumber: data.chapterNumber.present
          ? data.chapterNumber.value
          : this.chapterNumber,
      titleArabic:
          data.titleArabic.present ? data.titleArabic.value : this.titleArabic,
      hadithCount:
          data.hadithCount.present ? data.hadithCount.value : this.hadithCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HadithChapter(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('titleArabic: $titleArabic, ')
          ..write('hadithCount: $hadithCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, chapterNumber, titleArabic, hadithCount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HadithChapter &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.chapterNumber == this.chapterNumber &&
          other.titleArabic == this.titleArabic &&
          other.hadithCount == this.hadithCount);
}

class HadithChaptersCompanion extends UpdateCompanion<HadithChapter> {
  final Value<int> id;
  final Value<String> bookId;
  final Value<int> chapterNumber;
  final Value<String> titleArabic;
  final Value<int> hadithCount;
  const HadithChaptersCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.titleArabic = const Value.absent(),
    this.hadithCount = const Value.absent(),
  });
  HadithChaptersCompanion.insert({
    this.id = const Value.absent(),
    required String bookId,
    required int chapterNumber,
    required String titleArabic,
    required int hadithCount,
  })  : bookId = Value(bookId),
        chapterNumber = Value(chapterNumber),
        titleArabic = Value(titleArabic),
        hadithCount = Value(hadithCount);
  static Insertable<HadithChapter> custom({
    Expression<int>? id,
    Expression<String>? bookId,
    Expression<int>? chapterNumber,
    Expression<String>? titleArabic,
    Expression<int>? hadithCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (chapterNumber != null) 'chapter_number': chapterNumber,
      if (titleArabic != null) 'title_arabic': titleArabic,
      if (hadithCount != null) 'hadith_count': hadithCount,
    });
  }

  HadithChaptersCompanion copyWith(
      {Value<int>? id,
      Value<String>? bookId,
      Value<int>? chapterNumber,
      Value<String>? titleArabic,
      Value<int>? hadithCount}) {
    return HadithChaptersCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      titleArabic: titleArabic ?? this.titleArabic,
      hadithCount: hadithCount ?? this.hadithCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<String>(bookId.value);
    }
    if (chapterNumber.present) {
      map['chapter_number'] = Variable<int>(chapterNumber.value);
    }
    if (titleArabic.present) {
      map['title_arabic'] = Variable<String>(titleArabic.value);
    }
    if (hadithCount.present) {
      map['hadith_count'] = Variable<int>(hadithCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HadithChaptersCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('titleArabic: $titleArabic, ')
          ..write('hadithCount: $hadithCount')
          ..write(')'))
        .toString();
  }
}

class $PoemsTable extends Poems with TableInfo<$PoemsTable, Poem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PoemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryIdMeta =
      const VerificationMeta('categoryId');
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
      'category_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _poetMeta = const VerificationMeta('poet');
  @override
  late final GeneratedColumn<String> poet = GeneratedColumn<String>(
      'poet', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _eraMeta = const VerificationMeta('era');
  @override
  late final GeneratedColumn<String> era = GeneratedColumn<String>(
      'era', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _poemTextMeta =
      const VerificationMeta('poemText');
  @override
  late final GeneratedColumn<String> poemText = GeneratedColumn<String>(
      'poem_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, categoryId, title, poet, era, poemText, tags];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'poems';
  @override
  VerificationContext validateIntegrity(Insertable<Poem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
          _categoryIdMeta,
          categoryId.isAcceptableOrUnknown(
              data['category_id']!, _categoryIdMeta));
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poet')) {
      context.handle(
          _poetMeta, poet.isAcceptableOrUnknown(data['poet']!, _poetMeta));
    } else if (isInserting) {
      context.missing(_poetMeta);
    }
    if (data.containsKey('era')) {
      context.handle(
          _eraMeta, era.isAcceptableOrUnknown(data['era']!, _eraMeta));
    }
    if (data.containsKey('poem_text')) {
      context.handle(_poemTextMeta,
          poemText.isAcceptableOrUnknown(data['poem_text']!, _poemTextMeta));
    } else if (isInserting) {
      context.missing(_poemTextMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Poem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Poem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      categoryId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      poet: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poet'])!,
      era: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}era']),
      poemText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}poem_text'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags']),
    );
  }

  @override
  $PoemsTable createAlias(String alias) {
    return $PoemsTable(attachedDatabase, alias);
  }
}

class Poem extends DataClass implements Insertable<Poem> {
  final int id;
  final String categoryId;
  final String title;
  final String poet;
  final String? era;
  final String poemText;
  final String? tags;
  const Poem(
      {required this.id,
      required this.categoryId,
      required this.title,
      required this.poet,
      this.era,
      required this.poemText,
      this.tags});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['title'] = Variable<String>(title);
    map['poet'] = Variable<String>(poet);
    if (!nullToAbsent || era != null) {
      map['era'] = Variable<String>(era);
    }
    map['poem_text'] = Variable<String>(poemText);
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    return map;
  }

  PoemsCompanion toCompanion(bool nullToAbsent) {
    return PoemsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      title: Value(title),
      poet: Value(poet),
      era: era == null && nullToAbsent ? const Value.absent() : Value(era),
      poemText: Value(poemText),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
    );
  }

  factory Poem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Poem(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      title: serializer.fromJson<String>(json['title']),
      poet: serializer.fromJson<String>(json['poet']),
      era: serializer.fromJson<String?>(json['era']),
      poemText: serializer.fromJson<String>(json['poemText']),
      tags: serializer.fromJson<String?>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'title': serializer.toJson<String>(title),
      'poet': serializer.toJson<String>(poet),
      'era': serializer.toJson<String?>(era),
      'poemText': serializer.toJson<String>(poemText),
      'tags': serializer.toJson<String?>(tags),
    };
  }

  Poem copyWith(
          {int? id,
          String? categoryId,
          String? title,
          String? poet,
          Value<String?> era = const Value.absent(),
          String? poemText,
          Value<String?> tags = const Value.absent()}) =>
      Poem(
        id: id ?? this.id,
        categoryId: categoryId ?? this.categoryId,
        title: title ?? this.title,
        poet: poet ?? this.poet,
        era: era.present ? era.value : this.era,
        poemText: poemText ?? this.poemText,
        tags: tags.present ? tags.value : this.tags,
      );
  Poem copyWithCompanion(PoemsCompanion data) {
    return Poem(
      id: data.id.present ? data.id.value : this.id,
      categoryId:
          data.categoryId.present ? data.categoryId.value : this.categoryId,
      title: data.title.present ? data.title.value : this.title,
      poet: data.poet.present ? data.poet.value : this.poet,
      era: data.era.present ? data.era.value : this.era,
      poemText: data.poemText.present ? data.poemText.value : this.poemText,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Poem(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('poet: $poet, ')
          ..write('era: $era, ')
          ..write('poemText: $poemText, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, categoryId, title, poet, era, poemText, tags);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Poem &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.title == this.title &&
          other.poet == this.poet &&
          other.era == this.era &&
          other.poemText == this.poemText &&
          other.tags == this.tags);
}

class PoemsCompanion extends UpdateCompanion<Poem> {
  final Value<int> id;
  final Value<String> categoryId;
  final Value<String> title;
  final Value<String> poet;
  final Value<String?> era;
  final Value<String> poemText;
  final Value<String?> tags;
  const PoemsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.title = const Value.absent(),
    this.poet = const Value.absent(),
    this.era = const Value.absent(),
    this.poemText = const Value.absent(),
    this.tags = const Value.absent(),
  });
  PoemsCompanion.insert({
    this.id = const Value.absent(),
    required String categoryId,
    required String title,
    required String poet,
    this.era = const Value.absent(),
    required String poemText,
    this.tags = const Value.absent(),
  })  : categoryId = Value(categoryId),
        title = Value(title),
        poet = Value(poet),
        poemText = Value(poemText);
  static Insertable<Poem> custom({
    Expression<int>? id,
    Expression<String>? categoryId,
    Expression<String>? title,
    Expression<String>? poet,
    Expression<String>? era,
    Expression<String>? poemText,
    Expression<String>? tags,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (title != null) 'title': title,
      if (poet != null) 'poet': poet,
      if (era != null) 'era': era,
      if (poemText != null) 'poem_text': poemText,
      if (tags != null) 'tags': tags,
    });
  }

  PoemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? categoryId,
      Value<String>? title,
      Value<String>? poet,
      Value<String?>? era,
      Value<String>? poemText,
      Value<String?>? tags}) {
    return PoemsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      poet: poet ?? this.poet,
      era: era ?? this.era,
      poemText: poemText ?? this.poemText,
      tags: tags ?? this.tags,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (poet.present) {
      map['poet'] = Variable<String>(poet.value);
    }
    if (era.present) {
      map['era'] = Variable<String>(era.value);
    }
    if (poemText.present) {
      map['poem_text'] = Variable<String>(poemText.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PoemsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('title: $title, ')
          ..write('poet: $poet, ')
          ..write('era: $era, ')
          ..write('poemText: $poemText, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, Bookmark> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bookmarkTypeMeta =
      const VerificationMeta('bookmarkType');
  @override
  late final GeneratedColumn<String> bookmarkType = GeneratedColumn<String>(
      'bookmark_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
      'reference_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _savedAtMeta =
      const VerificationMeta('savedAt');
  @override
  late final GeneratedColumn<DateTime> savedAt = GeneratedColumn<DateTime>(
      'saved_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, bookmarkType, referenceId, note, savedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(Insertable<Bookmark> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bookmark_type')) {
      context.handle(
          _bookmarkTypeMeta,
          bookmarkType.isAcceptableOrUnknown(
              data['bookmark_type']!, _bookmarkTypeMeta));
    } else if (isInserting) {
      context.missing(_bookmarkTypeMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    } else if (isInserting) {
      context.missing(_referenceIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    if (data.containsKey('saved_at')) {
      context.handle(_savedAtMeta,
          savedAt.isAcceptableOrUnknown(data['saved_at']!, _savedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Bookmark map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Bookmark(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookmarkType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}bookmark_type'])!,
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_id'])!,
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
      savedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}saved_at'])!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class Bookmark extends DataClass implements Insertable<Bookmark> {
  final int id;
  final String bookmarkType;
  final String referenceId;
  final String? note;
  final DateTime savedAt;
  const Bookmark(
      {required this.id,
      required this.bookmarkType,
      required this.referenceId,
      this.note,
      required this.savedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bookmark_type'] = Variable<String>(bookmarkType);
    map['reference_id'] = Variable<String>(referenceId);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['saved_at'] = Variable<DateTime>(savedAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      bookmarkType: Value(bookmarkType),
      referenceId: Value(referenceId),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      savedAt: Value(savedAt),
    );
  }

  factory Bookmark.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Bookmark(
      id: serializer.fromJson<int>(json['id']),
      bookmarkType: serializer.fromJson<String>(json['bookmarkType']),
      referenceId: serializer.fromJson<String>(json['referenceId']),
      note: serializer.fromJson<String?>(json['note']),
      savedAt: serializer.fromJson<DateTime>(json['savedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookmarkType': serializer.toJson<String>(bookmarkType),
      'referenceId': serializer.toJson<String>(referenceId),
      'note': serializer.toJson<String?>(note),
      'savedAt': serializer.toJson<DateTime>(savedAt),
    };
  }

  Bookmark copyWith(
          {int? id,
          String? bookmarkType,
          String? referenceId,
          Value<String?> note = const Value.absent(),
          DateTime? savedAt}) =>
      Bookmark(
        id: id ?? this.id,
        bookmarkType: bookmarkType ?? this.bookmarkType,
        referenceId: referenceId ?? this.referenceId,
        note: note.present ? note.value : this.note,
        savedAt: savedAt ?? this.savedAt,
      );
  Bookmark copyWithCompanion(BookmarksCompanion data) {
    return Bookmark(
      id: data.id.present ? data.id.value : this.id,
      bookmarkType: data.bookmarkType.present
          ? data.bookmarkType.value
          : this.bookmarkType,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      note: data.note.present ? data.note.value : this.note,
      savedAt: data.savedAt.present ? data.savedAt.value : this.savedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Bookmark(')
          ..write('id: $id, ')
          ..write('bookmarkType: $bookmarkType, ')
          ..write('referenceId: $referenceId, ')
          ..write('note: $note, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookmarkType, referenceId, note, savedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Bookmark &&
          other.id == this.id &&
          other.bookmarkType == this.bookmarkType &&
          other.referenceId == this.referenceId &&
          other.note == this.note &&
          other.savedAt == this.savedAt);
}

class BookmarksCompanion extends UpdateCompanion<Bookmark> {
  final Value<int> id;
  final Value<String> bookmarkType;
  final Value<String> referenceId;
  final Value<String?> note;
  final Value<DateTime> savedAt;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.bookmarkType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.note = const Value.absent(),
    this.savedAt = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    required String bookmarkType,
    required String referenceId,
    this.note = const Value.absent(),
    this.savedAt = const Value.absent(),
  })  : bookmarkType = Value(bookmarkType),
        referenceId = Value(referenceId);
  static Insertable<Bookmark> custom({
    Expression<int>? id,
    Expression<String>? bookmarkType,
    Expression<String>? referenceId,
    Expression<String>? note,
    Expression<DateTime>? savedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookmarkType != null) 'bookmark_type': bookmarkType,
      if (referenceId != null) 'reference_id': referenceId,
      if (note != null) 'note': note,
      if (savedAt != null) 'saved_at': savedAt,
    });
  }

  BookmarksCompanion copyWith(
      {Value<int>? id,
      Value<String>? bookmarkType,
      Value<String>? referenceId,
      Value<String?>? note,
      Value<DateTime>? savedAt}) {
    return BookmarksCompanion(
      id: id ?? this.id,
      bookmarkType: bookmarkType ?? this.bookmarkType,
      referenceId: referenceId ?? this.referenceId,
      note: note ?? this.note,
      savedAt: savedAt ?? this.savedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookmarkType.present) {
      map['bookmark_type'] = Variable<String>(bookmarkType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (savedAt.present) {
      map['saved_at'] = Variable<DateTime>(savedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('bookmarkType: $bookmarkType, ')
          ..write('referenceId: $referenceId, ')
          ..write('note: $note, ')
          ..write('savedAt: $savedAt')
          ..write(')'))
        .toString();
  }
}

class $LastReadTable extends LastRead
    with TableInfo<$LastReadTable, LastReadData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LastReadTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentTypeMeta =
      const VerificationMeta('contentType');
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
      'content_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _referenceIdMeta =
      const VerificationMeta('referenceId');
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
      'reference_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastReadMeta =
      const VerificationMeta('lastRead');
  @override
  late final GeneratedColumn<DateTime> lastRead = GeneratedColumn<DateTime>(
      'last_read', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [contentType, referenceId, lastRead];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'last_read';
  @override
  VerificationContext validateIntegrity(Insertable<LastReadData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_type')) {
      context.handle(
          _contentTypeMeta,
          contentType.isAcceptableOrUnknown(
              data['content_type']!, _contentTypeMeta));
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
          _referenceIdMeta,
          referenceId.isAcceptableOrUnknown(
              data['reference_id']!, _referenceIdMeta));
    } else if (isInserting) {
      context.missing(_referenceIdMeta);
    }
    if (data.containsKey('last_read')) {
      context.handle(_lastReadMeta,
          lastRead.isAcceptableOrUnknown(data['last_read']!, _lastReadMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentType, referenceId};
  @override
  LastReadData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LastReadData(
      contentType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content_type'])!,
      referenceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reference_id'])!,
      lastRead: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_read'])!,
    );
  }

  @override
  $LastReadTable createAlias(String alias) {
    return $LastReadTable(attachedDatabase, alias);
  }
}

class LastReadData extends DataClass implements Insertable<LastReadData> {
  final String contentType;
  final String referenceId;
  final DateTime lastRead;
  const LastReadData(
      {required this.contentType,
      required this.referenceId,
      required this.lastRead});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_type'] = Variable<String>(contentType);
    map['reference_id'] = Variable<String>(referenceId);
    map['last_read'] = Variable<DateTime>(lastRead);
    return map;
  }

  LastReadCompanion toCompanion(bool nullToAbsent) {
    return LastReadCompanion(
      contentType: Value(contentType),
      referenceId: Value(referenceId),
      lastRead: Value(lastRead),
    );
  }

  factory LastReadData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LastReadData(
      contentType: serializer.fromJson<String>(json['contentType']),
      referenceId: serializer.fromJson<String>(json['referenceId']),
      lastRead: serializer.fromJson<DateTime>(json['lastRead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentType': serializer.toJson<String>(contentType),
      'referenceId': serializer.toJson<String>(referenceId),
      'lastRead': serializer.toJson<DateTime>(lastRead),
    };
  }

  LastReadData copyWith(
          {String? contentType, String? referenceId, DateTime? lastRead}) =>
      LastReadData(
        contentType: contentType ?? this.contentType,
        referenceId: referenceId ?? this.referenceId,
        lastRead: lastRead ?? this.lastRead,
      );
  LastReadData copyWithCompanion(LastReadCompanion data) {
    return LastReadData(
      contentType:
          data.contentType.present ? data.contentType.value : this.contentType,
      referenceId:
          data.referenceId.present ? data.referenceId.value : this.referenceId,
      lastRead: data.lastRead.present ? data.lastRead.value : this.lastRead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LastReadData(')
          ..write('contentType: $contentType, ')
          ..write('referenceId: $referenceId, ')
          ..write('lastRead: $lastRead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(contentType, referenceId, lastRead);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LastReadData &&
          other.contentType == this.contentType &&
          other.referenceId == this.referenceId &&
          other.lastRead == this.lastRead);
}

class LastReadCompanion extends UpdateCompanion<LastReadData> {
  final Value<String> contentType;
  final Value<String> referenceId;
  final Value<DateTime> lastRead;
  final Value<int> rowid;
  const LastReadCompanion({
    this.contentType = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.lastRead = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LastReadCompanion.insert({
    required String contentType,
    required String referenceId,
    this.lastRead = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : contentType = Value(contentType),
        referenceId = Value(referenceId);
  static Insertable<LastReadData> custom({
    Expression<String>? contentType,
    Expression<String>? referenceId,
    Expression<DateTime>? lastRead,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentType != null) 'content_type': contentType,
      if (referenceId != null) 'reference_id': referenceId,
      if (lastRead != null) 'last_read': lastRead,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LastReadCompanion copyWith(
      {Value<String>? contentType,
      Value<String>? referenceId,
      Value<DateTime>? lastRead,
      Value<int>? rowid}) {
    return LastReadCompanion(
      contentType: contentType ?? this.contentType,
      referenceId: referenceId ?? this.referenceId,
      lastRead: lastRead ?? this.lastRead,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (lastRead.present) {
      map['last_read'] = Variable<DateTime>(lastRead.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LastReadCompanion(')
          ..write('contentType: $contentType, ')
          ..write('referenceId: $referenceId, ')
          ..write('lastRead: $lastRead, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SurahsTable surahs = $SurahsTable(this);
  late final $AyahsTable ayahs = $AyahsTable(this);
  late final $TafseersTable tafseers = $TafseersTable(this);
  late final $HadithsTable hadiths = $HadithsTable(this);
  late final $HadithChaptersTable hadithChapters = $HadithChaptersTable(this);
  late final $PoemsTable poems = $PoemsTable(this);
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $LastReadTable lastRead = $LastReadTable(this);
  late final QuranDao quranDao = QuranDao(this as AppDatabase);
  late final HadithDao hadithDao = HadithDao(this as AppDatabase);
  late final PoetryDao poetryDao = PoetryDao(this as AppDatabase);
  late final BookmarksDao bookmarksDao = BookmarksDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        surahs,
        ayahs,
        tafseers,
        hadiths,
        hadithChapters,
        poems,
        bookmarks,
        lastRead
      ];
}

typedef $$SurahsTableCreateCompanionBuilder = SurahsCompanion Function({
  Value<int> number,
  required String nameArabic,
  required String nameTransliteration,
  required int ayahCount,
  required String revelationType,
  required int chronologicalOrder,
});
typedef $$SurahsTableUpdateCompanionBuilder = SurahsCompanion Function({
  Value<int> number,
  Value<String> nameArabic,
  Value<String> nameTransliteration,
  Value<int> ayahCount,
  Value<String> revelationType,
  Value<int> chronologicalOrder,
});

class $$SurahsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SurahsTable,
    Surah,
    $$SurahsTableFilterComposer,
    $$SurahsTableOrderingComposer,
    $$SurahsTableCreateCompanionBuilder,
    $$SurahsTableUpdateCompanionBuilder> {
  $$SurahsTableTableManager(_$AppDatabase db, $SurahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SurahsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SurahsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> number = const Value.absent(),
            Value<String> nameArabic = const Value.absent(),
            Value<String> nameTransliteration = const Value.absent(),
            Value<int> ayahCount = const Value.absent(),
            Value<String> revelationType = const Value.absent(),
            Value<int> chronologicalOrder = const Value.absent(),
          }) =>
              SurahsCompanion(
            number: number,
            nameArabic: nameArabic,
            nameTransliteration: nameTransliteration,
            ayahCount: ayahCount,
            revelationType: revelationType,
            chronologicalOrder: chronologicalOrder,
          ),
          createCompanionCallback: ({
            Value<int> number = const Value.absent(),
            required String nameArabic,
            required String nameTransliteration,
            required int ayahCount,
            required String revelationType,
            required int chronologicalOrder,
          }) =>
              SurahsCompanion.insert(
            number: number,
            nameArabic: nameArabic,
            nameTransliteration: nameTransliteration,
            ayahCount: ayahCount,
            revelationType: revelationType,
            chronologicalOrder: chronologicalOrder,
          ),
        ));
}

class $$SurahsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableFilterComposer(super.$state);
  ColumnFilters<int> get number => $state.composableBuilder(
      column: $state.table.number,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nameArabic => $state.composableBuilder(
      column: $state.table.nameArabic,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get nameTransliteration => $state.composableBuilder(
      column: $state.table.nameTransliteration,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get ayahCount => $state.composableBuilder(
      column: $state.table.ayahCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get revelationType => $state.composableBuilder(
      column: $state.table.revelationType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get chronologicalOrder => $state.composableBuilder(
      column: $state.table.chronologicalOrder,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SurahsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SurahsTable> {
  $$SurahsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get number => $state.composableBuilder(
      column: $state.table.number,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nameArabic => $state.composableBuilder(
      column: $state.table.nameArabic,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get nameTransliteration => $state.composableBuilder(
      column: $state.table.nameTransliteration,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get ayahCount => $state.composableBuilder(
      column: $state.table.ayahCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get revelationType => $state.composableBuilder(
      column: $state.table.revelationType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get chronologicalOrder => $state.composableBuilder(
      column: $state.table.chronologicalOrder,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AyahsTableCreateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  required int surahNumber,
  required int ayahNumber,
  required String textArabic,
  required String textUthmani,
  required int pageNumber,
  required int juzNumber,
  required int hizbNumber,
});
typedef $$AyahsTableUpdateCompanionBuilder = AyahsCompanion Function({
  Value<int> id,
  Value<int> surahNumber,
  Value<int> ayahNumber,
  Value<String> textArabic,
  Value<String> textUthmani,
  Value<int> pageNumber,
  Value<int> juzNumber,
  Value<int> hizbNumber,
});

class $$AyahsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AyahsTable,
    Ayah,
    $$AyahsTableFilterComposer,
    $$AyahsTableOrderingComposer,
    $$AyahsTableCreateCompanionBuilder,
    $$AyahsTableUpdateCompanionBuilder> {
  $$AyahsTableTableManager(_$AppDatabase db, $AyahsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AyahsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AyahsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahNumber = const Value.absent(),
            Value<int> ayahNumber = const Value.absent(),
            Value<String> textArabic = const Value.absent(),
            Value<String> textUthmani = const Value.absent(),
            Value<int> pageNumber = const Value.absent(),
            Value<int> juzNumber = const Value.absent(),
            Value<int> hizbNumber = const Value.absent(),
          }) =>
              AyahsCompanion(
            id: id,
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            textArabic: textArabic,
            textUthmani: textUthmani,
            pageNumber: pageNumber,
            juzNumber: juzNumber,
            hizbNumber: hizbNumber,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahNumber,
            required int ayahNumber,
            required String textArabic,
            required String textUthmani,
            required int pageNumber,
            required int juzNumber,
            required int hizbNumber,
          }) =>
              AyahsCompanion.insert(
            id: id,
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            textArabic: textArabic,
            textUthmani: textUthmani,
            pageNumber: pageNumber,
            juzNumber: juzNumber,
            hizbNumber: hizbNumber,
          ),
        ));
}

class $$AyahsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get surahNumber => $state.composableBuilder(
      column: $state.table.surahNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get ayahNumber => $state.composableBuilder(
      column: $state.table.ayahNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get textArabic => $state.composableBuilder(
      column: $state.table.textArabic,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get textUthmani => $state.composableBuilder(
      column: $state.table.textUthmani,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get pageNumber => $state.composableBuilder(
      column: $state.table.pageNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get juzNumber => $state.composableBuilder(
      column: $state.table.juzNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get hizbNumber => $state.composableBuilder(
      column: $state.table.hizbNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AyahsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AyahsTable> {
  $$AyahsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get surahNumber => $state.composableBuilder(
      column: $state.table.surahNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get ayahNumber => $state.composableBuilder(
      column: $state.table.ayahNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get textArabic => $state.composableBuilder(
      column: $state.table.textArabic,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get textUthmani => $state.composableBuilder(
      column: $state.table.textUthmani,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get pageNumber => $state.composableBuilder(
      column: $state.table.pageNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get juzNumber => $state.composableBuilder(
      column: $state.table.juzNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get hizbNumber => $state.composableBuilder(
      column: $state.table.hizbNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$TafseersTableCreateCompanionBuilder = TafseersCompanion Function({
  Value<int> id,
  required int surahNumber,
  required int ayahNumber,
  required String source,
  required String textArabic,
});
typedef $$TafseersTableUpdateCompanionBuilder = TafseersCompanion Function({
  Value<int> id,
  Value<int> surahNumber,
  Value<int> ayahNumber,
  Value<String> source,
  Value<String> textArabic,
});

class $$TafseersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $TafseersTable,
    Tafseer,
    $$TafseersTableFilterComposer,
    $$TafseersTableOrderingComposer,
    $$TafseersTableCreateCompanionBuilder,
    $$TafseersTableUpdateCompanionBuilder> {
  $$TafseersTableTableManager(_$AppDatabase db, $TafseersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$TafseersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$TafseersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> surahNumber = const Value.absent(),
            Value<int> ayahNumber = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> textArabic = const Value.absent(),
          }) =>
              TafseersCompanion(
            id: id,
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            source: source,
            textArabic: textArabic,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int surahNumber,
            required int ayahNumber,
            required String source,
            required String textArabic,
          }) =>
              TafseersCompanion.insert(
            id: id,
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            source: source,
            textArabic: textArabic,
          ),
        ));
}

class $$TafseersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $TafseersTable> {
  $$TafseersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get surahNumber => $state.composableBuilder(
      column: $state.table.surahNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get ayahNumber => $state.composableBuilder(
      column: $state.table.ayahNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get textArabic => $state.composableBuilder(
      column: $state.table.textArabic,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$TafseersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $TafseersTable> {
  $$TafseersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get surahNumber => $state.composableBuilder(
      column: $state.table.surahNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get ayahNumber => $state.composableBuilder(
      column: $state.table.ayahNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get textArabic => $state.composableBuilder(
      column: $state.table.textArabic,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$HadithsTableCreateCompanionBuilder = HadithsCompanion Function({
  Value<int> id,
  required String bookId,
  required int chapterId,
  required int hadithNumber,
  required String textArabic,
  required String narrator,
  Value<String?> grade,
  Value<int?> referenceNumber,
});
typedef $$HadithsTableUpdateCompanionBuilder = HadithsCompanion Function({
  Value<int> id,
  Value<String> bookId,
  Value<int> chapterId,
  Value<int> hadithNumber,
  Value<String> textArabic,
  Value<String> narrator,
  Value<String?> grade,
  Value<int?> referenceNumber,
});

class $$HadithsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HadithsTable,
    Hadith,
    $$HadithsTableFilterComposer,
    $$HadithsTableOrderingComposer,
    $$HadithsTableCreateCompanionBuilder,
    $$HadithsTableUpdateCompanionBuilder> {
  $$HadithsTableTableManager(_$AppDatabase db, $HadithsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HadithsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$HadithsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bookId = const Value.absent(),
            Value<int> chapterId = const Value.absent(),
            Value<int> hadithNumber = const Value.absent(),
            Value<String> textArabic = const Value.absent(),
            Value<String> narrator = const Value.absent(),
            Value<String?> grade = const Value.absent(),
            Value<int?> referenceNumber = const Value.absent(),
          }) =>
              HadithsCompanion(
            id: id,
            bookId: bookId,
            chapterId: chapterId,
            hadithNumber: hadithNumber,
            textArabic: textArabic,
            narrator: narrator,
            grade: grade,
            referenceNumber: referenceNumber,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bookId,
            required int chapterId,
            required int hadithNumber,
            required String textArabic,
            required String narrator,
            Value<String?> grade = const Value.absent(),
            Value<int?> referenceNumber = const Value.absent(),
          }) =>
              HadithsCompanion.insert(
            id: id,
            bookId: bookId,
            chapterId: chapterId,
            hadithNumber: hadithNumber,
            textArabic: textArabic,
            narrator: narrator,
            grade: grade,
            referenceNumber: referenceNumber,
          ),
        ));
}

class $$HadithsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HadithsTable> {
  $$HadithsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bookId => $state.composableBuilder(
      column: $state.table.bookId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get chapterId => $state.composableBuilder(
      column: $state.table.chapterId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get hadithNumber => $state.composableBuilder(
      column: $state.table.hadithNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get textArabic => $state.composableBuilder(
      column: $state.table.textArabic,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get narrator => $state.composableBuilder(
      column: $state.table.narrator,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get grade => $state.composableBuilder(
      column: $state.table.grade,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get referenceNumber => $state.composableBuilder(
      column: $state.table.referenceNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$HadithsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HadithsTable> {
  $$HadithsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bookId => $state.composableBuilder(
      column: $state.table.bookId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get chapterId => $state.composableBuilder(
      column: $state.table.chapterId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get hadithNumber => $state.composableBuilder(
      column: $state.table.hadithNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get textArabic => $state.composableBuilder(
      column: $state.table.textArabic,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get narrator => $state.composableBuilder(
      column: $state.table.narrator,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get grade => $state.composableBuilder(
      column: $state.table.grade,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get referenceNumber => $state.composableBuilder(
      column: $state.table.referenceNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$HadithChaptersTableCreateCompanionBuilder = HadithChaptersCompanion
    Function({
  Value<int> id,
  required String bookId,
  required int chapterNumber,
  required String titleArabic,
  required int hadithCount,
});
typedef $$HadithChaptersTableUpdateCompanionBuilder = HadithChaptersCompanion
    Function({
  Value<int> id,
  Value<String> bookId,
  Value<int> chapterNumber,
  Value<String> titleArabic,
  Value<int> hadithCount,
});

class $$HadithChaptersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HadithChaptersTable,
    HadithChapter,
    $$HadithChaptersTableFilterComposer,
    $$HadithChaptersTableOrderingComposer,
    $$HadithChaptersTableCreateCompanionBuilder,
    $$HadithChaptersTableUpdateCompanionBuilder> {
  $$HadithChaptersTableTableManager(
      _$AppDatabase db, $HadithChaptersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$HadithChaptersTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$HadithChaptersTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bookId = const Value.absent(),
            Value<int> chapterNumber = const Value.absent(),
            Value<String> titleArabic = const Value.absent(),
            Value<int> hadithCount = const Value.absent(),
          }) =>
              HadithChaptersCompanion(
            id: id,
            bookId: bookId,
            chapterNumber: chapterNumber,
            titleArabic: titleArabic,
            hadithCount: hadithCount,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bookId,
            required int chapterNumber,
            required String titleArabic,
            required int hadithCount,
          }) =>
              HadithChaptersCompanion.insert(
            id: id,
            bookId: bookId,
            chapterNumber: chapterNumber,
            titleArabic: titleArabic,
            hadithCount: hadithCount,
          ),
        ));
}

class $$HadithChaptersTableFilterComposer
    extends FilterComposer<_$AppDatabase, $HadithChaptersTable> {
  $$HadithChaptersTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bookId => $state.composableBuilder(
      column: $state.table.bookId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get chapterNumber => $state.composableBuilder(
      column: $state.table.chapterNumber,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get titleArabic => $state.composableBuilder(
      column: $state.table.titleArabic,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get hadithCount => $state.composableBuilder(
      column: $state.table.hadithCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$HadithChaptersTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $HadithChaptersTable> {
  $$HadithChaptersTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bookId => $state.composableBuilder(
      column: $state.table.bookId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get chapterNumber => $state.composableBuilder(
      column: $state.table.chapterNumber,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get titleArabic => $state.composableBuilder(
      column: $state.table.titleArabic,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get hadithCount => $state.composableBuilder(
      column: $state.table.hadithCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$PoemsTableCreateCompanionBuilder = PoemsCompanion Function({
  Value<int> id,
  required String categoryId,
  required String title,
  required String poet,
  Value<String?> era,
  required String poemText,
  Value<String?> tags,
});
typedef $$PoemsTableUpdateCompanionBuilder = PoemsCompanion Function({
  Value<int> id,
  Value<String> categoryId,
  Value<String> title,
  Value<String> poet,
  Value<String?> era,
  Value<String> poemText,
  Value<String?> tags,
});

class $$PoemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $PoemsTable,
    Poem,
    $$PoemsTableFilterComposer,
    $$PoemsTableOrderingComposer,
    $$PoemsTableCreateCompanionBuilder,
    $$PoemsTableUpdateCompanionBuilder> {
  $$PoemsTableTableManager(_$AppDatabase db, $PoemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$PoemsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$PoemsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> categoryId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> poet = const Value.absent(),
            Value<String?> era = const Value.absent(),
            Value<String> poemText = const Value.absent(),
            Value<String?> tags = const Value.absent(),
          }) =>
              PoemsCompanion(
            id: id,
            categoryId: categoryId,
            title: title,
            poet: poet,
            era: era,
            poemText: poemText,
            tags: tags,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String categoryId,
            required String title,
            required String poet,
            Value<String?> era = const Value.absent(),
            required String poemText,
            Value<String?> tags = const Value.absent(),
          }) =>
              PoemsCompanion.insert(
            id: id,
            categoryId: categoryId,
            title: title,
            poet: poet,
            era: era,
            poemText: poemText,
            tags: tags,
          ),
        ));
}

class $$PoemsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $PoemsTable> {
  $$PoemsTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get poet => $state.composableBuilder(
      column: $state.table.poet,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get era => $state.composableBuilder(
      column: $state.table.era,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get poemText => $state.composableBuilder(
      column: $state.table.poemText,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get tags => $state.composableBuilder(
      column: $state.table.tags,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$PoemsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $PoemsTable> {
  $$PoemsTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get categoryId => $state.composableBuilder(
      column: $state.table.categoryId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get title => $state.composableBuilder(
      column: $state.table.title,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get poet => $state.composableBuilder(
      column: $state.table.poet,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get era => $state.composableBuilder(
      column: $state.table.era,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get poemText => $state.composableBuilder(
      column: $state.table.poemText,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get tags => $state.composableBuilder(
      column: $state.table.tags,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$BookmarksTableCreateCompanionBuilder = BookmarksCompanion Function({
  Value<int> id,
  required String bookmarkType,
  required String referenceId,
  Value<String?> note,
  Value<DateTime> savedAt,
});
typedef $$BookmarksTableUpdateCompanionBuilder = BookmarksCompanion Function({
  Value<int> id,
  Value<String> bookmarkType,
  Value<String> referenceId,
  Value<String?> note,
  Value<DateTime> savedAt,
});

class $$BookmarksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BookmarksTable,
    Bookmark,
    $$BookmarksTableFilterComposer,
    $$BookmarksTableOrderingComposer,
    $$BookmarksTableCreateCompanionBuilder,
    $$BookmarksTableUpdateCompanionBuilder> {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$BookmarksTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$BookmarksTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> bookmarkType = const Value.absent(),
            Value<String> referenceId = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              BookmarksCompanion(
            id: id,
            bookmarkType: bookmarkType,
            referenceId: referenceId,
            note: note,
            savedAt: savedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String bookmarkType,
            required String referenceId,
            Value<String?> note = const Value.absent(),
            Value<DateTime> savedAt = const Value.absent(),
          }) =>
              BookmarksCompanion.insert(
            id: id,
            bookmarkType: bookmarkType,
            referenceId: referenceId,
            note: note,
            savedAt: savedAt,
          ),
        ));
}

class $$BookmarksTableFilterComposer
    extends FilterComposer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get bookmarkType => $state.composableBuilder(
      column: $state.table.bookmarkType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get referenceId => $state.composableBuilder(
      column: $state.table.referenceId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get savedAt => $state.composableBuilder(
      column: $state.table.savedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$BookmarksTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get bookmarkType => $state.composableBuilder(
      column: $state.table.bookmarkType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get referenceId => $state.composableBuilder(
      column: $state.table.referenceId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get savedAt => $state.composableBuilder(
      column: $state.table.savedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$LastReadTableCreateCompanionBuilder = LastReadCompanion Function({
  required String contentType,
  required String referenceId,
  Value<DateTime> lastRead,
  Value<int> rowid,
});
typedef $$LastReadTableUpdateCompanionBuilder = LastReadCompanion Function({
  Value<String> contentType,
  Value<String> referenceId,
  Value<DateTime> lastRead,
  Value<int> rowid,
});

class $$LastReadTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LastReadTable,
    LastReadData,
    $$LastReadTableFilterComposer,
    $$LastReadTableOrderingComposer,
    $$LastReadTableCreateCompanionBuilder,
    $$LastReadTableUpdateCompanionBuilder> {
  $$LastReadTableTableManager(_$AppDatabase db, $LastReadTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LastReadTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LastReadTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> contentType = const Value.absent(),
            Value<String> referenceId = const Value.absent(),
            Value<DateTime> lastRead = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LastReadCompanion(
            contentType: contentType,
            referenceId: referenceId,
            lastRead: lastRead,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String contentType,
            required String referenceId,
            Value<DateTime> lastRead = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LastReadCompanion.insert(
            contentType: contentType,
            referenceId: referenceId,
            lastRead: lastRead,
            rowid: rowid,
          ),
        ));
}

class $$LastReadTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LastReadTable> {
  $$LastReadTableFilterComposer(super.$state);
  ColumnFilters<String> get contentType => $state.composableBuilder(
      column: $state.table.contentType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get referenceId => $state.composableBuilder(
      column: $state.table.referenceId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastRead => $state.composableBuilder(
      column: $state.table.lastRead,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$LastReadTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LastReadTable> {
  $$LastReadTableOrderingComposer(super.$state);
  ColumnOrderings<String> get contentType => $state.composableBuilder(
      column: $state.table.contentType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get referenceId => $state.composableBuilder(
      column: $state.table.referenceId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastRead => $state.composableBuilder(
      column: $state.table.lastRead,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SurahsTableTableManager get surahs =>
      $$SurahsTableTableManager(_db, _db.surahs);
  $$AyahsTableTableManager get ayahs =>
      $$AyahsTableTableManager(_db, _db.ayahs);
  $$TafseersTableTableManager get tafseers =>
      $$TafseersTableTableManager(_db, _db.tafseers);
  $$HadithsTableTableManager get hadiths =>
      $$HadithsTableTableManager(_db, _db.hadiths);
  $$HadithChaptersTableTableManager get hadithChapters =>
      $$HadithChaptersTableTableManager(_db, _db.hadithChapters);
  $$PoemsTableTableManager get poems =>
      $$PoemsTableTableManager(_db, _db.poems);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$LastReadTableTableManager get lastRead =>
      $$LastReadTableTableManager(_db, _db.lastRead);
}
