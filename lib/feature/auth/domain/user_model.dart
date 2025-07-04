// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
class UserInsertResult {
  final bool success;
  final UserModel? user;

  UserInsertResult({required this.success, this.user});
}
class UserModel {
  final int? id;
  final String email;
  final String password;
  UserModel({
      this.id,
    required this.email,
    required this.password,
  });
  
// copy the same date into another object
  UserModel copyWith({
    int? id,
    String? email,
    String? password,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
 //convert model into json
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'password': password,
    };
  }
 //convert json into model
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ??0,
      email: map['email'] ?? '',
      password: map['password'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'UserModel(id: $id, email: $email, password: $password)';

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.email == email &&
      other.password == password;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ password.hashCode;
}
