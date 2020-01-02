/*
 * online.dart
 * ----------------
 * Sends and recieves data from online web services
 * 
 */

import 'package:http/http.dart';

class Online {

  // Get JSON data from a URL provided and return as String
  static Future<String> getJsonData(String url) async {
    print("Started getting news...");

    // open request and get
    var response = await get(url);

    print("Got JSON NEWS");

    // test for healthy request
    if (response.statusCode == 200) return response.body;

    // return empty for no data / error
    return "";
  }





}
