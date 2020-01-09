import 'package:flutter/material.dart';
import 'package:newsdesign/pages/Home_Page.dart';
import 'package:newsdesign/pages/news_detail_page.dart';
import 'package:newsdesign/pages/story_view.dart';
import 'package:newsdesign/pages/view_image_page.dart';

class Constants {
  // ROUTES MAP
  static Map<String, WidgetBuilder> routes = {
    homePageRoute: (context) => MyHomePage(),
    newsDetailRoute: (context) => NewsDetail(),
    viewImageRoute: (context) => ViewImage(),
    storyViewRoute: (context) => StoryView(),
  };

  // ROUTE NAMES
  static const initialRoute = '/';
  static const homePageRoute = '/home_page';
  static const newsDetailRoute = '/news_detail_page';
  static const viewImageRoute = '/view_image_page';
  static const storyViewRoute = '/story_view_page';

  // URLs
  static const newsURL =
      "http://www.elnashra.com/app/v2.0/json/newsfeed.json";
  static const sliderURL = "http://www.elnashra.com/app/v2.0/json/slider.json";

  // MEASUREMENTS
  static const headerImageHeight = 290.0;
  static const carouselHeight = 220.0;
  static const imageAspectRatio = 3/4.0;
  static const storiesContainerHeight = 180.0;
  static const storyWidth = 120.0;
  static const storyHeight = 180.0;
  static Widget space = SizedBox(height: 50.0);

  static double getScreenWidth(BuildContext context) {return MediaQuery.of(context).size.width;}  
  static double getScreenHeight(BuildContext context) {return MediaQuery.of(context).size.height;}

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


  // OTHER
  static const newsOffset = 8;
  static const adsPlacementIndex = 4;


}
