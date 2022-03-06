import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/widgets/common_button.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final User? user;

  const ProfileScreen({Key? key, this.user}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    User loggedUser = Provider.of<UserProvider>(context).getUser!;

    User userToDisplay = widget.user != null ? widget.user! : loggedUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(userToDisplay.username),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          // COLUMN BECAUSE BELOW THE PROFILE PIC, THERE'S GOING TO BE THE BIO
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // PROFILE PIC AND STATS
                Row(
                  children: [
                    // PROFILE PIC
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                          userToDisplay.photoUrl ?? defaultProfilePicUrl),
                      radius: 40.0,
                    ),
                    // FOLLOWERS, FOLLOWING, POSTS NUMBER
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // FOLLOWERS
                          buildStatColumn(
                              userToDisplay.followers.length, 'Followers'),
                          // FOLLOWING
                          buildStatColumn(
                              userToDisplay.following.length, 'Following'),
                          // POSTS
                          buildStatColumn(0, 'Posts'),
                        ],
                      ),
                    ),
                  ],
                ),

                // USERNAME
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 10),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.5),
                  child: Text(
                    userToDisplay.username,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                //BIO CONTAINER
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.1),
                  child: Text(
                    userToDisplay.bio,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                ),

                // EDIT AND FOLLOW BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // EDIT BTN
                    // CommonButton(
                    //   padding: const EdgeInsets.only(
                    //     top: 28,
                    //   ),
                    //   onPressFunction: () {},
                    //   backgroundColor: mobileBackgroundColor,
                    //   borderColor: Colors.grey,
                    //   buttonText: 'Edit',
                    //   textColor: primaryColor,
                    //   buttonWidth: MediaQuery.of(context).size.width * 0.2,
                    //   buttonHeight: 30,
                    // ),

                    // If current user is same as the one passed, then show edit btn, otherwise show follow btn

                    // FOLLOW BTN

                    CommonButton(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      onPressFunction: () {},
                      backgroundColor:
                          widget.user != null ? Colors.blue : mobileSearchColor,
                      borderColor: widget.user != null
                          ? Colors.transparent
                          : Colors.grey,
                      buttonText: widget.user != null ? 'Follow' : 'Edit',
                      textColor: primaryColor,
                      buttonWidth: MediaQuery.of(context).size.width * 0.8,
                      buttonHeight: 35.0,
                    )
                  ],
                ),
              ],
            ),
          ),
          // DIVIDING FOR POSTS
          const Divider(),

          // POSTS GRID
          Expanded(child: postsList(userToDisplay)),
        ],
      ),
    );
  }

  // POSTS FUTURE BUILDER
  FutureBuilder postsList(User user) {
    return FutureBuilder(
      future: FirestoreMethods().getPostsFromUser(user.uid),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.connectionState == ConnectionState.active ||
            snap.connectionState == ConnectionState.done) {
          if (snap.hasError) {
            return const Center(
              child: Text('some error occured :('),
            );
          } else if (snap.hasData) {
            return snap.data?.docs.isNotEmpty
                ? const Center(
                    child: Text('has posts :)'),
                  )
                : const Center(
                    child: Text('No Posts :('),
                  );
          } else {
            return const Center(
              child: Text('No Posts'),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  // FOLLOWERS LABEL + COUNT WIDGET
  Column buildStatColumn(int number, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // COUNT
        Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        // LABEL
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
