// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String name;
  final String comment;
  final String uid;
  final String commentId;
  final String profilePic;
  final DateTime datePublished;
  final likes;
  CommentModel({
    required this.name,
    required this.comment,
    required this.uid,
    required this.commentId,
    required this.profilePic,
    required this.datePublished,
    required this.likes,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'comment': comment,
        'uid': uid,
        'commentId': commentId,
        'profilePic': profilePic,
        'datePublished': datePublished,
        'likes': likes,
      };

  static CommentModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return CommentModel(
      name: snapshot['name'],
      comment: snapshot['comment'],
      uid: snapshot['uid'],
      commentId: snapshot['commentId'],
      profilePic: snapshot['profilePic'],
      datePublished: snapshot['datePublished'],
      likes: snapshot['likes'],
    );
  }
}
