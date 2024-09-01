import 'package:cloud_firestore/cloud_firestore.dart';

class IRank {
  String? uid, name;
  int? steps, timeTaken;
  Timestamp? createdAt, updatedAt;

  IRank({
    this.uid,
    this.name,
    this.steps,
    this.timeTaken,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'steps': steps,
      'timeTaken': timeTaken,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  factory IRank.fromJson(Map<String, dynamic> json) => IRank(
        uid: json["uid"],
        name: json["name"],
        steps: json["steps"],
        timeTaken: json["timeTaken"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  factory IRank.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return IRank(
      uid: data["uid"],
      name: data["name"],
      steps: data["steps"],
      timeTaken: data["timeTaken"],
      createdAt: data["createdAt"],
      updatedAt: data["updatedAt"],
    );
  }
}
