import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream of Posts
  Stream<QuerySnapshot<Map<String, dynamic>>?> get postsStream =>
      _firestore.collection('posts').orderBy("datePublished").snapshots();

  // Upload a post
  Future<String> uploadPost({
    required String? description,
    required Uint8List file,
    required String uid,
    required String username,
    required String profImage,
  }) async {
    String result = 'Some error occurred';

    try {
      // Create unique id for post
      String postId = const Uuid().v4();

      // Upload in Storage, then get the download URL
      String photoUrl = await StorageMethods()
          .uploadImageToStorage('posts', file, true, postId);

      // Then store it in the firestore
      Post post = Post(
        description: description ?? '',
        datePublished: DateTime.now().toString(),
        // The user that posted uid.
        uid: uid,
        username: username,
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
        // Create unique id for post, using uuid.
        postId: postId,
      );

      // Finally upload to firestore, with the doc name as the postId, for easy access later on.
      _firestore.collection('posts').doc(postId).set(post.toJson());

      // Set the result String to success.
      result = 'Success';
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      result = e.toString();
    } catch (e) {
      debugPrint(e.toString());
      result = e.toString();
    }

    return result;
  }

  // Like post function
  Future<void> likePost(String postId, String userUid, List likes) async {
    try {
      var docToUpdate = _firestore.collection('posts').doc(postId);

      var newLikesList = [];

      // Check whether user was already in the likes list
      if (likes.contains(userUid)) {
        newLikesList = likes.where((id) => id != userUid).toList();
      } else {
        newLikesList = [...likes, userUid];
      }

      // If so then remove his uid from the likes list

      // Else add his uid to the likes list

      // Update the post using the postId.
      await docToUpdate.update({
        "likes": newLikesList,
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // GET ALL COMMENTS WITH POSTID
  Stream<QuerySnapshot<Map<String, dynamic>>?> getComments(postId) async* {
    try {
      yield* _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .snapshots();
    } catch (e) {
      debugPrint(e.toString());
      yield null;
    }
  }

  // CREATE COMMENT
  Future<String> createComment(String postId, String content, User user) async {
    String result = 'Some error occurred';
    try {
      if (content.isNotEmpty) {
        // CREATE RANDOM ID FOR COMMENT
        String commentId = const Uuid().v4();

        // Create Comment object
        Comment comment = Comment(
          userId: user.uid,
          postId: postId,
          profilePic: user.photoUrl ?? defaultProfilePicUrl,
          username: user.username,
          commentId: commentId,
          content: content,
          likes: [],
        );

        // COMMENTS IS A SUB-COLLECTION OF POSTS
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(comment.toJson());

        result = 'Success';
      } else {
        result = "Can't post a empty comment :(";
      }
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      result = e.toString();
    } catch (e) {
      debugPrint(e.toString());
      result = e.toString();
    }

    return result;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> searchUsers(String input) async =>
      await _firestore
          .collection('users')
          .where('username', arrayContains: input)
          .get();
}
