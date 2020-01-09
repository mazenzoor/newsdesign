import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsdesign/globals.dart';
import 'package:newsdesign/model/news.dart';
import 'package:newsdesign/constants.dart';
import 'package:newsdesign/services/online.dart';
import 'package:newsdesign/services/parser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

List newsData = [];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // init state
  @override
  void initState() {
    super.initState();
    // Start getting news data in the background
    getNewsData();
  }

  // Register global key for nav drawer
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  // Nav drawer state
  bool drawerOpen = false;

  // Handles page refresh
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  // Method to retrieve news items
  Future<void> getNewsData() async {
    // Ask online class to get JSON string from URL
    String json = await Online.getJsonData(Constants.newsURL);

    // Parse if not empty
    if (json.isNotEmpty) {
      // Empty newsData array for a fresh list
      newsData = [];

      try {
        // Parse json to list of News
        newsData = Parser.jsonToNews(json);

        // Update the Global news list
        Globals.newsList = newsData;
        Globals.storyList = newsData.sublist(0, 8);

        // Update the UI
        setState(() {});
      } catch (e) {
        print(e);
      }
    } else {
      // Try loading News from local files
      //
    }
  }

  // Triggered when user pulls to refresh
  void _onRefresh() async {
    // monitor network fetch
    await getNewsData();

    // Refresh completed
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with red background
      appBar: _buildAppBar(context),

      // Register key for navigation drawer
      key: _drawerKey,

      // Menu Drawer
      endDrawer: _buildNavigationDrawer(context),

      body: SafeArea(
        bottom: false,
        // ScrollView
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: ClassicHeader(),
          footer: _buildLoadMoreFooter(context),
          controller: _refreshController,
          onRefresh: _onRefresh,

          // Whole Page ScrollView
          child: SingleChildScrollView(
            // App wrap with background color
            child: Container(
              // Main background color
              color: Constants.elNashraBackground,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Top Header (menu, logo, search)
                  _buildTopHeader(context),

                  // Stories
                  _buildNewsStories(context),

                  // Height
                  SizedBox(height: 15),

                  // Latest News Title
                  _buildLatestNewsTitle(context),

                  // Latest News List
                  _buildNewsListView(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* BUILD METHODS */

  Widget _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(0),
      child: AppBar(
        backgroundColor: Constants.elNashraRed,
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 10.0),
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
        ));
  }

  Widget _buildNavigationDrawer(BuildContext context) {
    return Drawer(
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
    );
  }

  Widget _buildNewsStories(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 12.0, 0, 6.0),
      height: Constants.storiesContainerHeight,
      child: ListView.builder(
        itemCount: Constants.newsOffset,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        reverse: true,
        itemBuilder: (context, index) {
          News currentNews = newsData[index];
          return Story(currentNews, index);
        },
      ),
    );
  }

  Widget _buildLatestNewsTitle(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
      child: Row(
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
          SizedBox(width: 10),
          Icon(Icons.lightbulb_outline)
        ],
      ),
    );
  }

  Widget _buildNewsListView(BuildContext context) {
    // If news list is still empty show loading
    if (newsData.length == 0) {
      return Container(
        child: Text("Loading News"),
      );
    }

    // Ads list for UI testing
    List ads = ["Space for Ad 1", "Space for Ad 2", "Space for Ads 3"];

    // Track ads list index
    int adsIndex = 0;

    // Place ad between news list items on some index
    shouldBuildAd(int index) {
      // test if correct position for ad and there is still ads
      if (index != 0 &&
          index % Constants.adsPlacementIndex == 0 &&
          adsIndex < ads.length) {
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
      padding: EdgeInsets.symmetric(horizontal: Constants.horizontalPadding),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: newsData.length,
      itemBuilder: (context, index) {
        News temporary = newsData[index];

        // Return a News row
        return Column(
          children: <Widget>[
            Container(
              child: shouldBuildAd(index),
            ),
            GestureDetector(
              onTap: () {
                // Open News Detail Page
                Navigator.pushNamed(context, Constants.newsDetailRoute,
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
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            //
                            // News Item Date
                            Text(
                              Parser.dateDiffString(
                                  temporary.createDate, temporary.createDateAR),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
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
                          height: 90,
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

  Widget _buildLoadMoreFooter(BuildContext context) {
    return CustomFooter(
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
    );
  }
} /* end state */

/* Own state management for Story */
class Story extends StatefulWidget {
  final News currentNews;
  final int index;
  const Story(this.currentNews, this.index);

  @override
  _StoryState createState() => _StoryState();
}

class _StoryState extends State<Story> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Init animation controller for stories
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.08,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    return Transform.scale(
      scale: _scale,
      child: Container(
        width: Constants.storyWidth,
        height: Constants.storyHeight,
        margin: EdgeInsets.fromLTRB(0, 0, 12.0, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          // Story image and title with gesture detection
          child: GestureDetector(
              onTapUp: (_) {
                _controller.reverse();

                print(_scale);
              },
              onTapDown: (_) {
                _controller.forward();
                print(_scale);
              },
              onTapCancel: () {
                _controller.reverse();
              },
              // Navigate to Story View on tap
              onTap: () {
                Navigator.pushNamed(context, Constants.storyViewRoute,
                    arguments: widget.index);
              },
              child: Stack(
                children: <Widget>[
                  Container(
                    // Image of Story
                    child: FadeInImage.assetNetwork(
                      height: Constants.storyHeight,
                      placeholder: Constants.placeholder,
                      image: widget.currentNews.pictureURL,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    left: 0.0,
                    top: 0.0,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(0, 0, 0, 0),
                              Color.fromARGB(220, 0, 0, 0)
                            ]),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          //
                          // Main Header Title
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 18.0),
                            child: Text(
                              widget.currentNews.title,
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.cairo(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
