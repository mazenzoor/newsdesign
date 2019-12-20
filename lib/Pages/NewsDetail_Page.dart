import 'package:flutter/material.dart';
import 'package:newsdesign/Items/News.dart';
import 'package:newsdesign/constant/Constants.dart';

class NewsDetail extends StatefulWidget {
  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  News news;
  @override
  Widget build(BuildContext context) {
    news = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _appBar(context),
              _headerImage(context, news),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _appBar(BuildContext context) {
  return SizedBox(
    height: 20,
  );
}

Widget _headerImage(BuildContext context, News newsItem) {
  return Container(
    margin: EdgeInsets.all(12.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: Constants.HeaderImageHeight,
        child: Image(
          image: NetworkImage(newsItem.pictureURL),
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
