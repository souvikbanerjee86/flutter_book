import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

Future<void> createUser(String displayName, BuildContext context) async {
  final firebaseCollection = FirebaseFirestore.instance.collection("users");
  final Auth = FirebaseAuth.instance;
  String uId = Auth.currentUser!.uid;

  Map<String, dynamic> user = {
    "display_name": displayName,
    "uid": uId,
    "avatar_url": null,
    "profession": null,
    "quotes": "Be Good"
  };
  firebaseCollection.add(user);
}
