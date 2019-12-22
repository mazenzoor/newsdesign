import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:newsdesign/blueprints/News.dart';
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

    // Using local data for header
    _reloadHeader();

    // Simulate loader delay
    await Future.delayed(Duration(milliseconds: 500));

    // Refresh completed
    _refreshController.refreshCompleted();
  }

  /* (start) Code to be re-written */

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

  /* (end) Code to be re-written */

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
        // ScrollView
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          header: MaterialClassicHeader(),
          footer: _buildLoadMoreFooter(context),
          controller: _refreshController,
          onRefresh: _onRefresh,

          // Whole Page ScrollView
          child: SingleChildScrollView(
            // App wrap with background color
            child: Container(
              // Main background color
              color: Constants.elNashraBackground,
              child: Padding(
                // Padding of page
                padding: Constants.elNashraHorizontalPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    // Top Header (menu, logo, search)
                    _buildTopHeader(context),

                    // New Carousel
                    _buildNewsCarousel(context),

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

  Widget _buildNewsCarousel(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16.0)),
      // Main News Header and News Carousel
      child: GestureDetector(
          onHorizontalDragStart: (DragStartDetails start) => _reloadHeader(),
          child: Stack(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                child: FadeInImage.assetNetwork(
                  height: Constants.carouselHeight,
                  placeholder: Constants.placeholder,
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
                    padding: const EdgeInsets.fromLTRB(12.0, 30, 12, 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildLatestNewsTitle(BuildContext context) {
    return Row(
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
    );
  }

  Widget _buildNewsListView(BuildContext context) {
    // Ads list for UI testing
    List ads = ["Space for Ad 1", "Space for Ad 2", "Space for Ads 3"];

    // Track ads list index
    int adsIndex = 0;

    // Place ad between news list items on some index
    shouldBuildAd(int index) {
      // test if correct position for ad and there is still ads
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
