import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_instagram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //! Sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? file,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty && file != null) {
        //! Register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String avatarUrl = await StorageMethods().uploadImageToStorage('avatars', file, false);
        //! Add user to database
        await _firestore.collection('users').doc(cred.user!.uid).set({
          'uid': cred.user!.uid,
          'username': username,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'avatarUrl': avatarUrl,
        });
        res = 'success';
      } else {
        res = 'Please fill the all fields';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'unknown') {
        res = 'Please, fill the all fields';
      } else if (err.code == 'invalid-email') {
        res = 'The email address is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 characters';
      } else if (err.code == 'email-already-in-use') {
        res = 'This email is already in use';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
