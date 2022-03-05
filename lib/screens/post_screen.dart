import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/post.dart';
import 'package:instagram_flutter/utils/colors.dart';

class PostScreen extends StatefulWidget {
  final Post post;

  const PostScreen({Key? key, required this.post}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: mobileBackgroundColor,
      ),
      body: Center(
        child: Text(widget.post.description),
      ),
    );
  }
}
