import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String postId;
  final String profilePic;
  final String username;
  final String commentId;
  final String content;
  final List likes;
  final DateTime datePublished;

  Comment({
    required this.userId,
    required this.postId,
    required this.profilePic,
    required this.username,
    required this.commentId,
    required this.content,
    required this.likes,
    DateTime? dateCreated,
  }) : datePublished = dateCreated ?? DateTime.now();

  // Converts this class into an object, which is useful when
  // storing it in firebase (takes in a json object, not a class)
  Map<String, dynamic> toJson() => {
        "userId": userId,
        "postId": postId,
        "profilePic": profilePic,
        "username": username,
        "commentId": commentId,
        "datePublished": datePublished,
        "content": content,
        "likes": likes,
      };

  // From snapshot to a User instance
  static Comment fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotData = (snapshot.data() as Map<String, dynamic>);

    return Comment(
      username: snapshotData['username'],
      postId: snapshotData['postId'],
      dateCreated: snapshotData['datePublished'],
      userId: snapshotData['userId'],
      commentId: snapshotData['commentId'],
      profilePic: snapshotData['profilePic'],
      content: snapshotData['content'],
      likes: snapshotData['likes'],
    );
  }

  static Comment fromMap(Map<String, dynamic> map) => Comment(
        username: map['username'],
        postId: map['postId'],
        dateCreated: map['dataPublished'],
        userId: map['userId'],
        commentId: map['commentId'],
        profilePic: map['profilePic'],
        content: map['content'],
        likes: map['likes'],
      );
}
