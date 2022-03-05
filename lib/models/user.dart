import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String? photoUrl;
  final String username;
  final String bio;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.username,
    required this.bio,
    required this.followers,
    required this.following,
  });

  // Converts this class into an object, which is useful when
  // storing it in firebase (takes in a json object, not a class)
  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": following,
      };

  // From snapshot to a User instance
  static User fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotData = (snapshot.data() as Map<String, dynamic>);

    return User(
      email: snapshotData['email'],
      uid: snapshotData['uid'],
      photoUrl: snapshotData['photoUrl'],
      username: snapshotData['username'],
      bio: snapshotData['bio'],
      followers: snapshotData['followers'],
      following: snapshotData['following'],
    );
  }

  static User fromMap(Map<String, dynamic> map) => User(
        email: map['email'],
        uid: map['uid'],
        photoUrl: map['photoUrl'],
        username: map['username'],
        bio: map['bio'],
        followers: map['followers'],
        following: map['following'],
      );
}
