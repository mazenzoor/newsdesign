import 'package:flutter/material.dart';
import 'package:newsdesign/constants.dart';
import 'package:newsdesign/globals.dart';

class StoryView extends StatefulWidget {
  @override
  _StoryViewState createState() => _StoryViewState();
}

class _StoryViewState extends State<StoryView> {
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    currentIndex = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Container(
        
        child: FadeInImage.assetNetwork(
          height: Constants.storyHeight,
          placeholder: Constants.placeholder,
          image: Globals.storyList[currentIndex].pictureURL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
