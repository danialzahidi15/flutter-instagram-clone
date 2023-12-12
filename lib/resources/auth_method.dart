import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_danthocode_instagram_clone/models/user_model.dart';
import 'package:flutter_danthocode_instagram_clone/resources/storage_method.dart';

class AuthMethod {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();

    return UserModel.fromSnap(snapshot);
  }

  signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some error occured';
    try {
      if (username.isNotEmpty || email.isNotEmpty || password.isNotEmpty || bio.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

        String photoUrl = await StorageMethod().uploadImageToStorage('profilePics', file, false);

        UserModel userModel = UserModel(
          email: email,
          uid: credential.user!.uid,
          username: username,
          bio: bio,
          followers: [],
          followings: [],
          photoUrl: photoUrl,
        );

        await _firestore.collection('users').doc(credential.user!.uid).set(userModel.toJson());
        res = 'Success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        res = 'The email is badly formatted';
      } else if (e.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      }
    } catch (e) {
      return res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'Success';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {}
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
