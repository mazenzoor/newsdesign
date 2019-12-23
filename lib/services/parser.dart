/*
 * parser.dart
 * ----------------
 * Parses all types of data/strings to Objects(blueprints)
 * 
 */

import 'dart:convert';
import 'package:newsdesign/blueprints/news.dart';

class Parser {

  // Method to parse JSON string to News objects list
  static List jsonToNews(String json) {

    // decode json object
    List data = jsonDecode(json);

    // temporary newslist
    List newsList = [];

    // loop to extract data to News objects
    for (int i = 0; i < data.length; i++) {

      // add to list
      newsList.add(
        News(
          title: data[i]['title'],
          pictureURL: data[i]['image'],
          content: data[i]['content'])
          );

    }

    return newsList; 
  }
} 
