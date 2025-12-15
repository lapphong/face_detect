class User {
  final bool match;
  final double confidence;
  final String name;

  User({
    this.match = false,
    this.confidence = 0.0,
    this.name = '',
  });

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      match: map['match'] as bool,
      confidence: map['confidence'] as double,
      name: map['name'] as String,
    );
  }
}

extension UserExt on User {
  bool get isMatch => match && confidence > 45.0 && name.isNotEmpty;
}
