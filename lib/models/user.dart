import 'package:cloud_firestore/cloud_firestore.dart';

class MUser {
  final String? id;
  final String uid;
  final String displayName;
  final String? profession;
  final String? quotes;
  final String? avatarUrl;

  MUser({
    this.id,
    required this.uid,
    required this.displayName,
    this.profession,
    this.quotes,
    this.avatarUrl,
  });

  factory MUser.fromDocument(QueryDocumentSnapshot data) {
    return MUser(
      id: data.id,
      uid: data.get("uid"),
      displayName: data.get("display_name"),
      profession: data.get("profession"),
      quotes: data.get("quotes"),
      avatarUrl: data.get("avatar_url"),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "display_name": displayName,
      "profession": profession,
      "quotes": quotes,
      "avatar_url": avatarUrl
    };
  }
}
