import 'package:cloud_firestore/cloud_firestore.dart';

class IUser {
  String? uid, email, name, phone, provider;
  bool? isProfileComplete, isActive;
  Timestamp? createdAt, updatedAt;
  int? steps, timeTaken;

  IUser({
    this.uid,
    this.email,
    this.name,
    this.phone,
    this.provider,
    this.isProfileComplete,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.steps,
    this.timeTaken,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'provider': provider,
      'isProfileComplete': isProfileComplete,
      'isActive': isActive,
      'steps': steps,
      'timeTaken': timeTaken,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  factory IUser.fromJson(Map<String, dynamic> json) => IUser(
        uid: json["uid"],
        email: json["email"],
        name: json["name"],
        phone: json["phone"],
        provider: json["provider"],
        isProfileComplete: json["isProfileComplete"],
        isActive: json["isActive"],
        steps: json["steps"],
        timeTaken: json["timeTaken"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );
}
