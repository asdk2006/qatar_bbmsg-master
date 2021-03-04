import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:bm_social_qatar/customIcons/custom_icons.dart';
import 'package:bm_social_qatar/features/insta_favourite/ui/pages/insta_favourite.dart';
import 'package:bm_social_qatar/features/insta_gallery/ui/pages/instapost.dart';
import 'package:bm_social_qatar/features/insta_profile/ui/pages/insta_profile.dart';
import 'package:bm_social_qatar/features/insta_search/ui/pages/insta_search.dart';
import 'package:bm_social_qatar/features/splash_screen.dart';
import 'package:bm_social_qatar/feed.dart';
import 'package:bm_social_qatar/services/connectvity_service.dart';
import 'package:bm_social_qatar/services/shared_prefrences_helper.dart';
import 'package:bm_social_qatar/splach.dart';
import 'package:bm_social_qatar/values/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'backend/firebase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await translator.init(
  //   localeDefault: LocalizationDefaultType.device,
  //   languagesList: <String>['ar', 'en'],
  //   assetsDirectory: 'assets/langs/',
  // );

  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  binding.renderView.automaticSystemUiAdjustment = false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // navigation bar color

      statusBarColor: Colors.transparent,
      systemNavigationBarColor: AppColors.primaryColor,
      systemNavigationBarIconBrightness: Brightness.light

      // status bar color
      ));

  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(201, 6, 40, .1),
  100: Color.fromRGBO(201, 6, 40, .2),
  200: Color.fromRGBO(201, 6, 40, .3),
  300: Color.fromRGBO(201, 6, 40, .4),
  400: Color.fromRGBO(201, 6, 40, .5),
  500: Color.fromRGBO(201, 6, 40, .6),
  600: Color.fromRGBO(201, 6, 40, .7),
  700: Color.fromRGBO(201, 6, 40, .8),
  800: Color.fromRGBO(201, 6, 40, .9),
  900: Color.fromRGBO(201, 6, 40, 1),
};

var _myTheme = new ThemeData(
    primarySwatch: MaterialColor(0xFFC10627, color),
    primaryColor: MaterialColor(0xff88A53B, color),
    buttonColor: MaterialColor(0xff88A53B, color),
    brightness: Brightness.light,
    accentColor: Colors.white,
    fontFamily: "DIN NEXT ARABIC REGULAR",
    textTheme: TextTheme(headline1: TextStyle(fontSize: 17)));

//////////////////////////////////////////////////////////////////////
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> inslaizfirbase() async {
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
  }

  ConnectivityService connectivityService;
  @override
  void initState() {
    super.initState();
    connectivityService = ConnectivityService();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: _myTheme,
      // localizationsDelegates: translator.delegates,
      // locale: translator.locale,
      // supportedLocales: translator.locals(),
      home: MaterialApp(
        theme: _myTheme,
        title: 'Ecards',
        home: BrokerPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class BrokerPage extends StatefulWidget {
  @override
  _BrokerPageState createState() => _BrokerPageState();
}

class _BrokerPageState extends State<BrokerPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(392.72727272727275, 850.9090909090909),
        allowFontScaling: true);
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return ErrorScreen();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return SplashScreen();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return LoadingScreen();
      },
    );

    // EditMarketProfilePage();
  }
}

//////////////////////////////////////////////////////////////////////////////
class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('error'),
    ));
  }
}

//////////////////////////////////////////////////////////////////////////////
class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}

/////////////////////////////////////////////////////////////////////////////
class HomePage1 extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  var _pages = [
    Feed(), // insta_activities.dart inside widgets folder
    InstaSearch(),
    // InstaGallery(),
    Instapost(),
    InstaFavourite(),
    InstaProfile(),
  ];

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFEEEEEE),
        brightness: Brightness.light,
        centerTitle: true,
        title: Text(
          "BBMSG",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              signOut();
            },
            icon: Icon(
              FontAwesome.sign_out,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: _pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) async {
          setState(() {
            currentIndex = i;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        items: [
          BottomNavigationBarItem(
              icon: Icon(currentIndex == 0
                  ? CustomIcons.home_filled
                  : CustomIcons.home_lineal),
              title: Container() // I have used custom icon here
              ),
          // Second item
          BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 1
                    ? CustomIcons.search_fill
                    : CustomIcons.search_lineal,
              ),
              title: Container()),
          // Third item
          BottomNavigationBarItem(
              icon: Icon(CustomIcons.add), title: Container()),
          // Fourth item
          BottomNavigationBarItem(
              icon: Icon(currentIndex == 3
                  ? CustomIcons.like_fill
                  : CustomIcons.like_lineal),
              title: Container()),
          // Fifth item
          BottomNavigationBarItem(
              icon: Icon(
                currentIndex == 4
                    ? CustomIcons.people_fill
                    : CustomIcons.profile_lineal,
              ),
              title: Container()),
        ],
      ),
    );
  }
}
