import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsdesign/Pages/NewsDetail_Page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart';

import 'Items/News.dart';

void main() => runApp(MyApp());

String jsonURL =
    "https://raw.githubusercontent.com/mzpro10/FilesIDon-tNeed/master/news.json";

List newsData = [];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {'/NewsDetail_Page': (context) => NewsDetail()},
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'The News App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  Future<void> getNewsData() async {
    var response = await get(jsonURL);

    if (response.statusCode == 200) {
      newsData = [];
      try {
        List data = jsonDecode(response.body);

        print(data);

        for (int i = 0; i < data.length; i++) {
          newsData.add(News(
              title: data[i]['title'],
              pictureURL: data[i]['image'],
              content: data[i]['content']));
        }

        setState(() {});
      } catch (e) {
        // final snackbar = SnackBar(content: Text('An Error Occured'),);
        // Scaffold.of(context).showSnackBar(snackbar);
        print(e);
      }
    }
  }

  //Future<void>

  @override
  void initState() {
    super.initState();
    getNewsData();
  }

  void _onRefresh() async {
    // monitor network fetch
    await getNewsData();
    _reloadHeader();
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  int _currentIndex = 0;

  List banner = [
    'https://static.adweek.com/adweek.com-prod/wp-content/uploads/2019/10/data-brands-politics-hero-2019.png',
    'https://static01.nyt.com/images/2019/12/18/us/politics/18dc-impeach-trump1/18dc-impeach-trump1-videoLarge-v2.jpg'
  ];

  List bannerTitles = [
    "اتحاد جمعيات العائلات البيروتية: تكليف دياب خرق فاضح للميثاقية الوطنية",
    "مقتل 6 أشخاص وإصابة 5 آخرين في حادث تصادم قطار بسيارة شمال مصر"
  ];

  void _reloadHeader() async {
    setState(() {
      _currentIndex = _currentIndex == 1 ? 0 : _currentIndex + 1;
    });
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  bool drawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 210, 0, 4),
          )),
      key: _drawerKey,
      //
      // Menu Drawer
      endDrawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                if (_drawerKey.currentState.isEndDrawerOpen) {
                  _drawerKey.currentState.openEndDrawer();
                }
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        //
        // ScrollView
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: MaterialClassicHeader(),
          footer: CustomFooter(
            builder: (BuildContext context, LoadStatus mode) {
              Widget body;
              if (mode == LoadStatus.idle) {
                body = Text("Go On Pull Up");
              } else if (mode == LoadStatus.loading) {
                body = CupertinoActivityIndicator();
              } else if (mode == LoadStatus.failed) {
                body = Text("Load Failed!Click retry!");
              } else if (mode == LoadStatus.canLoading) {
                body = Text("release to load more");
              } else {
                body = Text("No more Data");
              }
              return Container(
                height: 50.0,
                child: Center(child: body),
              );
            },
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          //
          // Whole Page ScrollView
          child: SingleChildScrollView(
            child: Container(
              color: Colors.grey[200],
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 12.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 10.0),
                      //
                      // AppBar
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.search,
                              color: Colors.black54,
                            ),
                          ),

                          //
                          // LOGO + Nav Icons
                          Image(
                            image: AssetImage('assets/logo.png'),
                            width: 120,
                          ),

                          IconButton(
                            color: Color.fromARGB(255, 174, 0, 4),
                            icon: Icon(Icons.menu),
                            onPressed: () {
                              if (!drawerOpen) {
                                _drawerKey.currentState.openEndDrawer();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                        //
                        // Main News Header
                        child: GestureDetector(
                          onHorizontalDragStart: (DragStartDetails start) =>
                              _reloadHeader(),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: FadeInImage.assetNetwork(
                                  height: 220,
                                  placeholder: 'assets/placeholder.jpg',
                                  image: banner[_currentIndex],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 0.0,
                                right: 0.0,
                                left: 0.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color.fromARGB(0, 0, 0, 0),
                                          Color.fromARGB(200, 0, 0, 0)
                                        ]),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        12.0, 30, 12, 12),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        //
                                        // Main Header Title
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            bannerTitles[_currentIndex],
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        //
                                        // Main Header Subtitle
                                        Visibility(
                                          visible: false,
                                          child: Text(
                                            "في يناير أتى الوزير الخارجية لإنجلترا في حل لكل المسائل التصويت وما يمكن أن ينتج عن مشاكل الشارع ",
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.cairo(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    //
                    // Latest News Title
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "آخر الاخبار",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.cairo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              textStyle: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.lightbulb_outline)
                      ],
                    ),

                    //
                    // Latest News List (Built in another method)
                    _homeNewsListView(context),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _homeNewsListView(BuildContext context) {
  List ads = ["Space for Ad 1", "Space for Ad 2", "Space for Ads 3"];

  int adsIndex = 0;

  shouldBuildAd(int index) {
    if (index != 0 && index % 3 == 0 && adsIndex < ads.length) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            height: 130,
            color: Colors.grey[300],
            child: Center(child: Text(ads[adsIndex++])),
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: newsData.length,
    itemBuilder: (context, index) {
      News temporary = newsData[index];

      return Column(
        children: <Widget>[
          Container(
            child: shouldBuildAd(index),
          ),
          GestureDetector(
            onTap: () {
              //
              // Open News Detail Page
              //

              Navigator.pushNamed(context, '/NewsDetail_Page',
                  arguments: newsData[index]);
            },
            child: Container(
              margin: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8.0, 0.0, 12.0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //
                          // News Item Title
                          Text(
                            temporary.title,
                            textAlign: TextAlign.justify,
                            textDirection: TextDirection.rtl,
                            style: GoogleFonts.cairo(
                              textStyle: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          //
                          // News Item Date
                          Text(
                            "Jan 1",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              textStyle: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //
                  // News Item Image
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeholder.jpg',
                        image: temporary.pictureURL,
                        width: 120,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}
