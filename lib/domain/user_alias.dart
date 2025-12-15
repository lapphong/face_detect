import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

class UserAlias {
  final String id;
  final String date;
  final Uint8List file;

  UserAlias({
    String? id,
    required this.date,
    required this.file,
  }) : id = id ?? const Uuid().v4();

  factory UserAlias.fromJson(Map<String, dynamic> map) {
    return UserAlias(
      id: map['id'] as String?,
      date: map['date'] as String,
      file: map['file'] as Uint8List,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'file': file,
    };
  }
}
