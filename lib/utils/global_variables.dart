import 'package:flutter/material.dart';
import 'package:instagram_flutter/screens/add_post_screen.dart';
import 'package:instagram_flutter/screens/feed_screen.dart';
import 'package:instagram_flutter/screens/profile_screen.dart';
import 'package:instagram_flutter/screens/search_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  // Home
  FeedScreen(),
  // Search
  SearchScreen(),
  // Add
  AddPostScreen(),
  // Favorites
  Text('Favorites'),
  // Profile
  ProfileScreen(),
];

const defaultProfilePicUrl =
    'https://t4.ftcdn.net/jpg/00/64/67/63/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg';

// Post dialog options shown when user clicks in 3 dots icon button on the feed page

// const POST_3_ICONS_OPTIONS = [
//   {
//     'value': 'Edit',
//     'color': primaryColor,
//     'backgroundColor': Colors.green,
//   },
//   {
//     'value': 'Delete',
//     'color': primaryColor,
//     'backgroundColor': Colors.red,
//   },
//   {
//     'value': 'Close',
//     'color': primaryColor,
//     'backgroundColor': Colors.black,
//   },
// ];
