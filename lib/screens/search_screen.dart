import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/resources/firestore_methods.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/widgets/staggered_posts.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _isShowUsers = false;

  bool _isInputEmpty = true;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.search),
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              _isShowUsers = true;
            });
          },
          onChanged: (value) => setState(() {
            _isInputEmpty = value.isEmpty;
            _isShowUsers = value.isNotEmpty;
          }),
        ),
        actions: [
          !_isInputEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _isShowUsers = false;
                      _isInputEmpty = true;
                    });
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: const Icon(
                      Icons.clear,
                      color: mobileSearchColor,
                      size: 15,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      body: _isShowUsers
          ? FutureBuilder(
              future: FirestoreMethods().searchUsers(_searchController.text),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // Error
                    return const Center(
                      child: Text('Error'),
                    );
                  } else if (snapshot.hasData) {
                    //  Has data (but still check for length > 0)
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          User userSearched =
                              User.fromMap(snapshot.data!.docs[index].data());

                          return ListTile(
                            key: Key(
                                'search-screen-list-item-${userSearched.uid}}'),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  userSearched.photoUrl ??
                                      defaultProfilePicUrl),
                            ),
                            title: Text(userSearched.username),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                    user: userSearched,
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  } else {
                    //  No data
                    return const Center(
                      child: Text('no data'),
                    );
                  }
                } else {
                  // loading
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          : const StaggeredPosts(),
    );
  }
}
