// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:baby_words_tracker/util/time_utils.dart';

import 'package:collection/collection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:baby_words_tracker/data/models/data_with_id.dart';

class Child {
  final String? id;
  final DateTime birthday;
  final String name;
  final int wordCount;
  final List<String> parentIDs;
  
  Child({
    this.id,
    required this.birthday,
    required this.name,
    required this.wordCount,
    required this.parentIDs,
  });

  Child copyWith({
    String? id,
    DateTime? birthday,
    String? name,
    int? wordCount,
    List<String>? parentIDs,
  }) {
    return Child(
      id: id ?? this.id,
      birthday: birthday ?? this.birthday,
      name: name ?? this.name,
      wordCount: wordCount ?? this.wordCount,
      parentIDs: parentIDs ?? this.parentIDs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'birthday': birthday,
      'name': name,
      'wordCount': wordCount,
      'parentIDs': parentIDs as List<dynamic>,
    };
  }

  factory Child.fromMap(Map<String, dynamic> map) {
    return Child(
      birthday: map['birthday'] != null ? convertToDateTime(map['birthday']) : DateTime.fromMillisecondsSinceEpoch(0),
      name: (map['name'] ?? '') as String,
      wordCount: (map['wordCount'] ?? 0) as int,
      parentIDs: map['parentIDs'] != null ?  List<String>.from(map['parentIDs'] as List<dynamic>) : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory Child.fromJson(String source) => Child.fromMap(json.decode(source) as Map<String, dynamic>);

  factory Child.fromDataWithId(DataWithId source) {
    Map<String, dynamic> data = source.data;
    data['id'] = source.id;
    return Child.fromMap(data); 
  }

  @override
  String toString() {
    return 'Child(id: $id, birthday: $birthday, name: $name, wordCount: $wordCount, parentIDs: $parentIDs)';
  }

  @override
  bool operator ==(covariant Child other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.id == id &&
      other.birthday == birthday &&
      other.name == name &&
      other.wordCount == wordCount &&
      listEquals(other.parentIDs, parentIDs);
  }

  @override
  int get hashCode {
    return (id?.hashCode ?? 0) ^
      birthday.hashCode ^
      name.hashCode ^
      wordCount.hashCode ^
      parentIDs.hashCode;
  }
}
