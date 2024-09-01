import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firestore/rank.dart';
import '../../models/firestore/user.dart';
import '../../utils/safe_promise.dart';

class FireStoreService {
  // user collection reference
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  // rank collection reference
  final CollectionReference _rankCollectionReference =
      FirebaseFirestore.instance.collection('rank');

  final Timestamp getCurrentTimestamp = Timestamp.fromDate(DateTime.now());

  Future<IUser> fetchUserIfExistsOrSet(String uid, IUser iUser) async {
    /* Here we check the document with user uid is exist or not
    *  If found the return the document data
    *  else we will create document with user id and then add data in it
    */

    // document reference
    final DocumentReference documentReference =
        _usersCollectionReference.doc(uid);

    // fetch the document from firebase
    final result = await promiseHandler(documentReference.get());

    // document fetch error handle
    if (result.hasError) {
      return Future.error(result.error);
    }

    // storing in document snapshot
    DocumentSnapshot snapshot = result.response;

    // checking if document is null or not
    if (snapshot.exists) {
      // get data from snapshot and return user object
      final data = snapshot.data();
      return IUser.fromJson(data as Map<String, dynamic>);
    }

    // if user not found the create new user
    final result1 = await promiseHandler(
        _usersCollectionReference.doc(uid).set(iUser.toJson()));

    // if error occurs while creating user
    if (result1.hasError) {
      return Future.error(result1.error);
    }

    // return new user created
    return iUser;
  }

  Future<IUser> fetchUser(String uid) async {
    await Future.delayed(const Duration(seconds: 2));

    // document reference
    final DocumentReference documentReference =
        _usersCollectionReference.doc(uid);

    // fetch the document from firebase
    final result = await promiseHandler(documentReference.get());

    // document fetch error handle
    if (result.hasError) {
      return Future.error(result.error);
    }

    // storing in document snapshot
    DocumentSnapshot snapshot = result.response;

    // checking if document is null or not
    if (!snapshot.exists) {
      // if snapshot is empty then return error
      return Future.error("User with uid:'$uid' not exists");
    }

    // get data from snapshot and return user object
    final data = snapshot.data();
    return IUser.fromJson(data as Map<String, dynamic>);
  }

  Future<IUser> createUser(String uid, IUser iUser) async {
    // create user
    final result1 = await promiseHandler(
        _usersCollectionReference.doc(uid).set(iUser.toJson()));

    // if error occurs while creating user
    if (result1.hasError) {
      return Future.error(result1.error);
    }

    // return new user created
    return iUser;
  }

  Future<IUser> updateUser(
      {required String uid,
      required String phone,
      required String name,
      required IUser oldUser}) async {
    // update user
    final result1 =
        await promiseHandler(_usersCollectionReference.doc(uid).update({
      "phone": phone,
      "name": name,
      "isProfileComplete": true,
      "updatedAt": getCurrentTimestamp
    }));

    // if error occurs while updating user
    if (result1.hasError) {
      return Future.error(result1.error);
    }

    oldUser.phone = phone;
    oldUser.name = name;
    oldUser.isProfileComplete = true;
    oldUser.updatedAt = getCurrentTimestamp;
    // return updated user
    return oldUser;
  }

  Future<IUser> updateScore(
      {required String uid,
      required int steps,
      required int timeTaken,
      required IUser oldUser}) async {
    // update user
    final result1 = await promiseHandler(_usersCollectionReference
        .doc(uid)
        .update({
      "steps": steps,
      "timeTaken": timeTaken,
      "updatedAt": getCurrentTimestamp
    }));
    // if error occurs while updating user
    if (result1.hasError) {
      return Future.error(result1.error);
    }
    // update global rank document by user uid as doc id and rank as model

    // create rank
    final result2 = await promiseHandler(_rankCollectionReference.doc(uid).set(
        IRank(
                uid: oldUser.uid,
                name: oldUser.name,
                createdAt: getCurrentTimestamp,
                updatedAt: getCurrentTimestamp,
                steps: steps,
                timeTaken: timeTaken)
            .toJson()));

    // if error occurs while creating user
    if (result2.hasError) {
      return Future.error(result1.error);
    }

    oldUser.timeTaken = timeTaken;
    oldUser.steps = steps;
    oldUser.updatedAt = getCurrentTimestamp;
    // return updated user
    return oldUser;
  }

  Future<List<IRank>> fetchRanks() async {
    try {
      QuerySnapshot snapshot = await _rankCollectionReference
          .orderBy("steps", descending: true)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) => IRank.fromFirestore(doc)).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<dynamic>> fetchCrossApps() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('cross_platform').get();

      return snapshot.docs.toList();
    } catch (error) {
      rethrow;
    }
  }
}
