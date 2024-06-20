import 'package:cloud_firestore/cloud_firestore.dart';
UserModel? userModel;

class UserModel {
  final String email;
  final String password;
  final String name;
  final String uid;
  final String phoneNumber;
  final List<String> search;
  final DateTime date;
  final bool delete;
  final bool active;
  final int status;
  final DocumentReference? reference;

  UserModel({
    required this.email,
    required this.password,
    required this.name,
    required this.uid,
    required this.search,
    required this.date,
    required this.delete,
    required this.status,
    required this.active,
    required this.phoneNumber,
    this.reference,
  });

  UserModel copyWith({
    String? email,
    String? password,
    String? name,
    String? uid,
    String? phoneNumber,
    List<String>? search,
    DateTime? date,
    bool? delete,
    bool? active,
    int? status,
    DocumentReference? reference,
  }) {
    return UserModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      uid: uid ?? this.uid,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      search: search ?? this.search,
      date: date ?? this.date,
      delete: delete ?? this.delete,
      status: status ?? this.status,
      active: active ?? this.active,
      reference: reference ?? this.reference,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'uid': uid,
      'phoneNumber': phoneNumber,
      'search': search,
      'date': date,
      'delete': delete,
      'status': status,
      'active': active,
      'reference': reference,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      password: map['password'] as String,
      phoneNumber: map['phoneNumber'] as String,
      name: map['name'] as String,
      status: map['status'] as int,
      uid: map['uid'] as String,
      search: List<String>.from(map['search']),
      date: (map['date'] as Timestamp).toDate(),
      delete: map['delete'] == null ? false : map['delete'] as bool,
      active: map['active'] == null ? false : map['active'] as bool,
      reference: map['reference'] as DocumentReference?,
    );
  }
}
