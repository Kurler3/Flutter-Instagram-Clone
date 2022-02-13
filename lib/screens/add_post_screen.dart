import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/models/user.dart';
import 'package:instagram_flutter/providers/user_provider.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/global_variables.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  // Image picked
  Uint8List? _filePicked;

  // Text editing controller for the post description
  final TextEditingController _descriptionController = TextEditingController();

  // This function launches a dialog that prompts the user which source to use
  // to select the image
  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: [
            // Camera Option
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Take a photo'),
              onPressed: () async {
                // Dismiss the dialog box
                Navigator.of(context).pop();
                // Launch the camera
                Uint8List? file = await pickImage(ImageSource.camera);
                // Update the state so that it also changes the UI
                setState(() {
                  _filePicked = file;
                });
              },
            ),

            // Galery Option
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                // Dismiss the dialog box
                Navigator.of(context).pop();
                // Launch the camera
                Uint8List? file = await pickImage(ImageSource.gallery);
                // Update the state so that it also changes the UI
                setState(() {
                  _filePicked = file;
                });
              },
            ),

            // Cancel Option
            SimpleDialogOption(
              padding: const EdgeInsets.all(20.0),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () async {
                // Dismiss the dialog box
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get user data for displaying the profile avatar
    final User user = Provider.of<UserProvider>(context).getUser!;

    // If no image picked, then return
    return _filePicked == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.upload,
                    size: 40,
                  ),
                  onPressed: () => _selectImage(context),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Create a post!'),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              // clears the selected image and goes back to add screen
              leading: IconButton(
                onPressed: () {
                  // Set the image picked to null
                  setState(() {
                    _filePicked = null;
                  });
                },
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Post to'),
              // Confirm post btn
              actions: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ))
              ],
            ),
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      // Uses user photoUrl if he has one, otherwise
                      // uses the default one from the constants
                      backgroundImage:
                          NetworkImage(user.photoUrl ?? defaultProfilePicUrl),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: 6,
                        decoration: const InputDecoration(
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: InkWell(
                        // Select another image by tapping in this one
                        onTap: () => _selectImage(context),
                        child: AspectRatio(
                          aspectRatio: 487 / 451,
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(_filePicked!),
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
