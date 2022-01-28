import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_flutter/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
              // Flexible(),
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
              // Text Field for email

              // Text Field for password
              // Login button
              // Transition to Sign Up
            ],
          ),
        ),
      ),
    );
  }
}
