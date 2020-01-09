import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:newsdesign/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(SplashScreen());
}

void _setErrorHandler(BuildContext context) {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    bool inDebug = false;
    // assert(() {
    //   inDebug = true;
    //   return true;
    // }());
    // In debug mode, use the normal error widget which shows
    // the error message:
    if (inDebug) return ErrorWidget(details.exception);
    // In release builds, show a yellow-on-blue message instead:
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            height: 20,
            alignment: Alignment.center,
            child: Text(
              'An error has occured, Please restart the app.',
              style: TextStyle(color: Colors.black),
              textDirection: TextDirection.ltr,
            ),
          ),
        ),
      ),
    );
  };
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _setErrorHandler(context);
    return MaterialApp(
      initialRoute: Constants.initialRoute,
      routes: Constants.routes,
      title: 'News App Demo',
      theme: ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        primaryColor: Colors.red,
        accentColor: Colors.red[800],
      ),
      home: MySplashScreen(),
    );
  }
}

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  // FCM
  final Firestore _db = Firestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging();
  StreamSubscription iosSubscription;

  @override
  void initState() {
    super.initState();

    // Get Notification Permission if IOS

    if (Platform.isIOS) {
      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
        // Save the token OR subscribe to a topic here
        _fcm.subscribeToTopic('Breaking News');
      });

      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _loadHomePage();
  }

  _loadHomePage() async {
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacementNamed(Constants.homePageRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 210, 0, 4),
          )),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Image.asset('assets/logo.png')],
          ),
        ),
      ),
    );
  }
}
