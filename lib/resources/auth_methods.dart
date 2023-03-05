import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart' as model;
import 'storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snap);
  }

  //! Sign up
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

        model.User user = model.User(
          uid: cred.user!.uid,
          username: username,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          avatarUrl: avatarUrl,
        );

        //! Add user to database
        await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());

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

  //! Log in
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      } else {
        res = 'Please fill the all fields';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'unknown') {
        res = 'Please, fill the all fields';
      } else if (err.code == 'invalid-email') {
        res = 'The email address is badly formatted';
      } else if (err.code == 'user-not-found') {
        res = 'User not found';
      } else if (err.code == 'wrong-password') {
        res = 'The password is invalid';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
