import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsdesign/blueprints/news.dart';
import 'package:newsdesign/constants.dart';
import 'package:flutter_html/flutter_html.dart';

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
        child: CustomScrollView(
          slivers: <Widget>[
            _buildSliverAppBar(context, news),
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  _buildNewsInfo(context, news),
                  _buildTitle(context, news),
                  _buildNewsAuthor(context, news),
                  _divider(),
                  _builderNewsBody(context, news),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

SliverAppBar _buildSliverAppBar(BuildContext context, News newsItem) {
  return SliverAppBar(
    backgroundColor: Colors.white,
    pinned: true,
    elevation: 3,
    title: Image.asset(
      'assets/logo.png',
      height: 20,
    ),
    centerTitle: true,
    iconTheme: IconThemeData(color: Constants.elNashraRed),
    expandedHeight: Constants.headerImageHeight,
    flexibleSpace: FlexibleSpaceBar(
      background: _buildSliverBackground(newsItem.pictureURL, newsItem.videoURL),
    ),
  );
}

Widget _buildTitle(BuildContext context, News newsItem) {
  return Container(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.horizontalPadding, vertical: 0.0),
      child: Text(newsItem.title,
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.justify,
          style: GoogleFonts.almarai(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          )),
    ),
  );
}

Widget _buildNewsInfo(BuildContext context, News newsItem) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding,
        vertical: Constants.verticalPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(3.0),
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 0),
              color: Colors.orange,
              child: Text(
                newsItem.category,
                style: GoogleFonts.almarai(
                    fontSize: 13.0, textStyle: TextStyle(color: Colors.white)),
              )),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              newsItem.createDateAR,
              style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.0,
                  textStyle: TextStyle(color: Colors.grey[400])),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.access_time,
              color: Colors.grey[400],
              size: 13.0,
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildNewsAuthor(BuildContext context, News newsItem) {
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding, vertical: 2.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: newsItem.author == '' ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.share,
              size: 14.0,
              color: Colors.grey[400],
            ),
            SizedBox(width: 8),
            Text(
              "share",
              style: GoogleFonts.almarai(
                  fontSize: 15.0,
                  textStyle: TextStyle(color: Colors.grey[400])),
            )
          ],
        ),
        Visibility(
          visible: newsItem.author == '' ? false : true,
          child: Row(
            children: <Widget>[
              Text(
                newsItem.author,
                style: GoogleFonts.almarai(
                  fontSize: 14.0,
                  textStyle: TextStyle(color: Colors.grey[500]),
                ),
              ),
              SizedBox(width: 8.0),
              Icon(Icons.account_circle, size: 15.0, color: Colors.grey[500]),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _buildSliverBackground(String imageURL, String videoURL) {
  if(videoURL == null || videoURL.isEmpty) {
    return Image(
        image: NetworkImage(imageURL),
        fit: BoxFit.cover,
      );
  } else {
    return Text("IMPLEMENT VIDEO");
  }
}

Widget _builderNewsBody(BuildContext context, News newsItem) {
  String html = newsItem.content;

  return Container(
    child: Directionality(
      textDirection: TextDirection.rtl,
      child: Html(
        padding: EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
        data: html,
        onLinkTap: (url) {
          // Append el nashra domain to the url
          url = "http://elnashra.com" + url;
          print("Your link: $url");
        },
        defaultTextStyle: GoogleFonts.almarai(
          textStyle: TextStyle(
            color: Colors.grey[800],
            height: 1.5,
            fontSize: 17.0,
          ),
        ),
        customTextAlign: (_) {
          return TextAlign.justify;
        },
        linkStyle: TextStyle(
          color: Constants.elNashraRed,
        ),
      ),
    ),
  );
}

Widget _divider() {
  return Container(
    margin: EdgeInsets.symmetric(
        horizontal: Constants.horizontalPadding, vertical: 8.0),
    height: 1.0,
    color: Colors.grey[200],
  );
}
