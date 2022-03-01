import 'dart:convert';

class User {
  int id;
  String username;
  String password;
  User({
    required this.id,
    required this.username,
    required this.password,
  });

  User copyWith({
    int? id,
    String? username,
    String? password,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      username: map['username'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() => 'User(id: $id, username: $username, password: $password)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is User &&
      other.id == id &&
      other.username == username &&
      other.password == password;
  }

  @override
  int get hashCode => id.hashCode ^ username.hashCode ^ password.hashCode;
}
