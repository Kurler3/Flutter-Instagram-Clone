import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/post_screen.dart';

class StaggeredPosts extends StatefulWidget {
  const StaggeredPosts({Key? key}) : super(key: key);

  @override
  State<StaggeredPosts> createState() => _StaggeredPostsState();
}

class _StaggeredPostsState extends State<StaggeredPosts> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirestoreMethods().postsStream,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // ERROR
              return const Center(
                child: Text('Error fetching posts :('),
              );
            } else if (snapshot.hasData) {
              // has data
              return snapshot.data!.docs.isNotEmpty
                  ? StaggeredGrid.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 2,
                      crossAxisSpacing: 2,
                      axisDirection: AxisDirection.up,
                      children: snapshot.data!.docs.map((doc) {
                        Post post = Post.fromSnapshot(doc);

                        int index = snapshot.data!.docs.indexOf(doc);

                        return StaggeredGridTile.count(
                          key: Key('search-screen-post-item-${post.postId}'),
                          crossAxisCellCount: (index * 4) % 2 == 0 ? 1 : 2,
                          mainAxisCellCount: (index * 3) % 2 == 0 ? 1 : 2,
                          // child: GestureDetector(
                          //   onTap: () {
                          //     // Go to specific post screen
                          //     Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             PostScreen(post: post)));
                          //   },
                          //   child: Image.network(
                          //     post.postUrl,
                          //     fit: BoxFit.cover,
                          //   ),
                          // ),
                          child: Image.network(
                            post.postUrl,
                            fit: BoxFit.fill,
                          ),
                        );
                      }).toList(),
                    )
                  : const Center(
                      child: Text('No posts :('),
                    );
            } else {
              //  NO DATA
              return const Center(
                child: Text('No posts yet :('),
              );
            }
          } else {
            // LOADING
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
