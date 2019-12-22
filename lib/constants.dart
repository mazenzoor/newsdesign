import 'package:flutter/material.dart';
import 'package:newsdesign/screens/Home_Page.dart';
import 'package:newsdesign/screens/news_detail_page.dart';

class Constants {
  // ROUTES MAP
  static Map<String, WidgetBuilder> routes = {
    homePageRoute: (context) => MyHomePage(),
    newsDetailRoute: (context) => NewsDetail(),
  };

  // ROUTE NAMES
  static const homePageRoute = '/Home_Page';
  static const newsDetailRoute = '/NewsDetail_Page';
  static const initialRoute = '/';

  // URLs
  static const newsURL =
      "https://raw.githubusercontent.com/mzpro10/FilesIDon-tNeed/master/news.json";

  // MEASUREMENTS
  static const headerImageHeight = 250.0;
  static const carouselHeight = 220.0;

  // PADDING & MARGINS
  static const horizontalPadding = 14.0;
  static const verticalPadding = 12.0;
  static const elNashraHorizontalPadding =
      EdgeInsets.symmetric(horizontal: horizontalPadding);
  static const elNashraPadding = EdgeInsets.symmetric(
      horizontal: horizontalPadding, vertical: verticalPadding);

  // COLORS
  static const elNashraRed = Color.fromARGB(255, 174, 0, 4);
  static final elNashraBackground = Colors.grey[100];
  static const elNashraMaterialRed =
      MaterialColor(0xFF880E4F, {500: Color.fromRGBO(174, 0, 4, 1)});

  // IMAGES
  static const placeholder = 'assets/placeholder.jpg';
}
