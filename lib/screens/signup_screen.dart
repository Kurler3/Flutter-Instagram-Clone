import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_methods.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenScreenState createState() => _SignUpScreenScreenState();
}

class _SignUpScreenScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();

    // Dispose of the text editing controllers
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    // Pick the image
    Uint8List? imagePicked = await pickImage(ImageSource.gallery);

    if (imagePicked != null) {
      setState(() {
        _image = imagePicked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          // double.infinity makes it as big as the parent
          // MediaQuery makes it as big as the entire phone screen
          width: double.infinity,
          child: Column(
            // Center everything horizontally
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Makes it so that everything sticks to bottom of Column
              Flexible(
                flex: 2,
                child: Container(),
              ),
              // SVG image
              // Use flutter_svg package to display it from 'assets'
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              GestureDetector(
                onTap: selectImage,
                child: Stack(
                  children: [
                    // If user picked an image, then show it instead of the default one
                    _image != null
                        ? CircleAvatar(
                            radius: 64.0,
                            // MemoryImage takes a Uint8List as the image
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor: Colors.transparent,
                          )
                        : const CircleAvatar(
                            radius: 64.0,
                            backgroundImage: NetworkImage(
                                'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg'),
                            backgroundColor: Colors.transparent,
                          ),
                    Positioned(
                      left: 80,
                      bottom: -15,
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.add_a_photo),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // Text Field Input for username
              TextFieldInput(
                textEditingController: _usernameController,
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24.0,
              ),
              // Text Field for email
              TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              // Text Field for password
              TextFieldInput(
                textEditingController: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPassword: true,
              ),
              const SizedBox(
                height: 20,
              ),
              // Text Field Input for bio
              TextFieldInput(
                textEditingController: _bioController,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 20,
              ),
              // Login button
              InkWell(
                onTap: () async {
                  AuthMethods().signUpUser(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                    username: _usernameController.text.trim(),
                    bio: _bioController.text.trim(),
                    // avatar: ,
                  );
                },
                child: Container(
                  child: const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              // Transition to Sign Up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Already have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint('sign up');
                    },
                    child: Container(
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 12.0),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
