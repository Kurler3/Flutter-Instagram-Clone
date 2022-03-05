import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/comment.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  // INPUT CONTROLLER
  final TextEditingController _inputController = TextEditingController();

  bool _isLoading = false;

  // ADD COMMENT FUNCTION
  createComment(User user) async {
    // STORE INPUT TEXT
    String inputText = _inputController.text;

    // CLEAR INPUT CONTROLLER
    _inputController.clear();

    // SET LOADING TO TRUE
    setState(() {
      _isLoading = true;
    });

    debugPrint('createComment content: $inputText');

    String result =
        await FirestoreMethods().createComment(widget.postId, inputText, user);

    // SET LOADING TO FALSE
    setState(() {
      _isLoading = false;
    });

    // CHECK IF RESULT == 'Sucess'

    if (result != 'Success') {
      showSnackBar(result, context);
    }
  }

  @override
  void dispose() {
    super.dispose();

    // DISPOSE OF TEXTEDITINGCONTROLLER
    _inputController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get user from Provider
    final User user = Provider.of<UserProvider>(context).getUser!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text("Comments"),
      ),
      // FETCH THE COMMENTS USING THE POST ID
      body: StreamBuilder(
        stream: FirestoreMethods().getComments(widget.postId),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>?> snapshot) {
          // debugPrint(snapshot.toString());
          // IF DONE OR ACTION
          if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            // IF THERE WAS AN ERROR
            if (snapshot.hasError) {
              return const Center(child: Text('error'));
            }
            // IF HAS DATA
            else if (snapshot.hasData) {
              return snapshot.data!.docs.isNotEmpty
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        Comment comment =
                            Comment.fromMap(snapshot.data!.docs[index].data());

                        return CommentCard(
                          key: Key("comment-card-${comment.commentId}-$index"),
                          comment: comment,
                        );
                      })
                  : const Center(
                      child: Text('No comments :('),
                    );
            }
            // IF RETRIEVED EMPTY
            else {
              return const Center(
                child: Text('No comments :('),
              );
            }
          }
          // LOADING
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // PROGRESS INDICATOR WHEN COMMENTING
            _isLoading ? const LinearProgressIndicator() : Container(),
            // INPUT AREA
            Container(
              decoration: const BoxDecoration(
                color: mobileSearchColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              // kToolbarHeight is the height of the toolbar in the AppBar widget.
              height: kToolbarHeight,
              width: double.infinity,
              // viewInsets.bottom listens to the keyboard popping up, for example, so it moves the input up.
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              padding: const EdgeInsets.only(left: 16, right: 8),
              // CHILD IS ROW TO SHOW AVATAR AND INPUT
              child: Row(
                children: [
                  // PROFILE PIC
                  CircleAvatar(
                    backgroundImage:
                        NetworkImage(user.photoUrl ?? defaultProfilePicUrl),
                    radius: 18,
                  ),
                  // INPUT FIELD
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _inputController,
                        decoration: InputDecoration(
                          hintText: 'Comment as ${user.username}',
                          hintStyle: const TextStyle(fontSize: 15),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  // POST BUTTON
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[300])),
                    onPressed: () => createComment(user),
                    child: const Text('Post'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
