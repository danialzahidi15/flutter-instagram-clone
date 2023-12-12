import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class UserModel {
  final String email;
  final String uid;
  final String photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List followings;
  UserModel({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.followings,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'email': email,
      'uid': uid,
      'photoUrl' : photoUrl,
      'username': username,
      'bio': bio,
      'followers': followers,
      'followings': followings,
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      email: snapshot['email'] ?? '',
      uid: snapshot['uid'] ?? '',
      photoUrl: snapshot['photoUrl'] ?? '',
      username: snapshot['username'] ?? '',
      bio: snapshot['bio'] ?? '',
      followers: snapshot['followers'] ?? [],
      followings: snapshot['followings'] ?? [],
    );
  }
}
