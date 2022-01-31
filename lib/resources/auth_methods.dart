import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up user func
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    // required Uint8List avatar,
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

        // Store in db username, bio, avatar
        await _firestore.collection('users').doc(creds.user!.uid).set({
          'username': username,
          'uid': creds.user!.uid,
          'email': email,
          'bio': bio,
          // Will be a list of uids of other users
          'followers': [],
          'following': [],
        });

        res = 'Success';
      }
    } catch (e) {
      debugPrint(e.toString());
      res = e.toString();
    }

    return res;
  }
}
