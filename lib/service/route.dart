import 'package:flutter/material.dart';
import 'package:hai_tegal/screen.dart';
import 'package:hai_tegal/screen/boarding_screen.dart';
import 'package:hai_tegal/screen/home/category_screen.dart';
import 'package:hai_tegal/screen/home/detail_category_screen.dart';
import 'package:hai_tegal/screen/home/post/detail_post_screen.dart';
import 'package:hai_tegal/screen/home/tags_screen.dart';
import 'package:hai_tegal/screen/login_screen.dart';
import 'package:hai_tegal/screen/menu/account_screen.dart';
import 'package:hai_tegal/screen/menu/home_screen.dart';
import 'package:hai_tegal/screen/menu/notifikasi_screen.dart';
import 'package:hai_tegal/screen/menu/saved_screen.dart';
import 'package:hai_tegal/screen/register_screen.dart';
import 'package:hai_tegal/screen/splash_screen.dart';

class MyRoute {
  Route onRoute(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
            builder: (BuildContext context) => const SplashScreens());
      case "/boarding":
        return MaterialPageRoute(
            builder: (BuildContext context) => BoardingScreen());
      case "/login":
        return MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen());
      case "/home":
        return MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen());
      case "/notifikasi":
        return MaterialPageRoute(
            builder: (BuildContext context) => const NotifikasiScreen());
      case "/saved":
        return MaterialPageRoute(
            builder: (BuildContext context) => SavedScreen());
      case "/account":
        return MaterialPageRoute(
            builder: (BuildContext context) => const AccountScreen());
      case "/register":
        return MaterialPageRoute(
            builder: (BuildContext context) => RegisterScreen());
      case "/category":
        return MaterialPageRoute(
            builder: (BuildContext context) => CategoryScreen());
      case "/detail-category":
        return MaterialPageRoute(
            builder: (BuildContext context) => DetailCategoryScreen());
      case "/detail-post":
        // return MaterialPageRoute(
        //     builder: (BuildContext context) => DetailPostScreen());
        return MaterialPageRoute(
            builder: (BuildContext context) => CategoryScreen());
      case "/tags":
        return MaterialPageRoute(
            builder: (BuildContext context) => TagsScreen());
      default:
        return MaterialPageRoute(
            builder: (BuildContext context) => const ScreenPage());
    }
  }
}