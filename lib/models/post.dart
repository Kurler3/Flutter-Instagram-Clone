import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final String datePublished;
  final String postUrl;
  final String profImage;
  final List likes;

  const Post({
    required this.datePublished,
    required this.description,
    required this.uid,
    required this.postUrl,
    required this.username,
    required this.postId,
    required this.profImage,
    required this.likes,
  });

  // Converts this class into an object, which is useful when
  // storing it in firebase (takes in a json object, not a class)
  Map<String, dynamic> toJson() => {
        "description": description,
        "uid": uid,
        "postUrl": postUrl,
        "username": username,
        "postId": postId,
        "profImage": profImage,
        "likes": likes,
        "datePublished": datePublished,
      };

  // From snapshot to a User instance
  static Post fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotData = (snapshot.data() as Map<String, dynamic>);

    return Post(
      description: snapshotData['description'],
      uid: snapshotData['uid'],
      postUrl: snapshotData['postUrl'],
      username: snapshotData['username'],
      postId: snapshotData['postId'],
      profImage: snapshotData['profImage'],
      likes: snapshotData['likes'],
      datePublished: snapshotData['datePublished'],
    );
  }
}
