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
    // Temporary map to use in for loop
    Map<String, dynamic> newsRow;

    // decode json object
    List listData = jsonDecode(json);

    // Get the map of general news at index 0
    Map<String, dynamic> mapData = listData[0];

    // Get the News array
    listData = mapData['news'];

    // Get image base url
    String baseURL = mapData['baseURL'];

    // temporary newslist
    List newsList = [];

    // loop to extract data to News objects
    for (int i = 0; i < listData.length; i++) {
      // Retrieve each record of news
      newsRow = listData[i];

      // add to list
      newsList.add(News(
          title: newsRow['title'].toString().trim(),
          pictureURL: baseURL + newsRow['picture'],
          content: newsRow['body'],
          author: newsRow['author'],
          category: newsRow['category_name'],
          createDate: newsRow['create_date'],
          createDateAR: newsRow['create_date_ar'],
          videoURL: newsRow['video']));
    }

    return newsList;
  }

  static String dateDiffString(String currentDate, String dateAR) {
    DateTime dob = DateTime.parse(currentDate);
    int dur = DateTime.now().difference(dob).inDays;

    try {
      switch (dur) {
        case 0:
          List datetime = currentDate.split(" ");
          String time = datetime[1].toString().substring(0, 5);
          return time;
          break;

        default:
          return dateAR;
      }
    } catch (e) {
      return '';
    }
  }
}
