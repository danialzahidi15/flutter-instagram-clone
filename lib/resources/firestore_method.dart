import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_danthocode_instagram_clone/models/comment_model.dart';
import 'package:flutter_danthocode_instagram_clone/models/post_model.dart';
import 'package:flutter_danthocode_instagram_clone/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profileImage,
  ) async {
    String res = 'Some error occured';
    try {
      String photoUrl = await StorageMethod().uploadImageToStorage('posts', file, true);
      String postId = const Uuid().v1();

      PostModel post = PostModel(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profileImage: profileImage,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> updateLikePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(
    String name,
    String textComment,
    String uid,
    String postId,
    String photoUrl,
  ) async {
    String res = 'Some error occured';
    try {
      String commentId = const Uuid().v1();

      CommentModel comment = CommentModel(
        name: name,
        comment: textComment,
        uid: uid,
        commentId: commentId,
        profilePic: photoUrl,
        datePublished: DateTime.now(),
        likes: [],
      );
      if (textComment.isNotEmpty) {
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).set(
              comment.toJson(),
            );
      }

      res = 'Success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> deletePost(String postId) async {
    String res = 'Some error occured';
    try {
      await _firestore.collection('posts').doc(postId).delete();

      res = 'Successfully deleted';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<String> followUser(String uid, String followId) async {
    String res = 'Some error occured';
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        //
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
