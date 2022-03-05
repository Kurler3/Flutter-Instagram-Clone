import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_flutter/models/user.dart' as model;
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/utils/global_variables.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of user
  Stream<User?> get userStream => _auth.authStateChanges();

  // Get user details
  Future<model.User> getUserDetails() async {
    // Provided by firebase
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    // Transform the snapshot data to model.User class.
    return model.User.fromSnapshot(snapshot);
  }

  // Sign up user func
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List? avatar,
  }) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          bio.isNotEmpty &&
          username.isNotEmpty) {
        // Sign Up
        UserCredential creds = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String? avatarUrl;
        if (avatar != null) {
          // Store avatar in storage
          avatarUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', avatar, false, null);
        }

        model.User user = model.User(
          username: username.toLowerCase(),
          uid: creds.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: avatarUrl ?? defaultProfilePicUrl,
        );

        // Store in db username, bio, avatar
        await _firestore
            .collection('users')
            .doc(creds.user!.uid)
            .set(user.toJson());

        res = 'Success';
      }
    } on FirebaseAuthException catch (err) {
      res = err.code;
    } catch (e) {
      debugPrint(e.toString());
      res = e.toString();
    }

    return res;
  }

  // Sign in
  Future<String> signIn(String email, String password) async {
    String res = 'Some error accurred';
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = 'Success';
      } else {
        res = 'Please enter all the fields';
      }
    } on FirebaseAuthException catch (err) {
      debugPrint(err.code);
      res = err.code;
    } catch (e) {
      debugPrint(e.toString());
      res = e.toString();
    }

    return res;
  }

  // Sign out

  Future<String> signOut() async {
    String res = 'Some error occurred';
    try {
      await _auth.signOut();

      res = 'Success';
    } on FirebaseAuthException catch (err) {
      debugPrint(err.code);
      res = err.code;
    } catch (e) {
      debugPrint(e.toString());
      res = e.toString();
    }
    return res;
  }
}
