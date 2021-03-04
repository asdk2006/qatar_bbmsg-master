import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:bm_social_qatar/backend/AppGet.dart';
import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:bm_social_qatar/features/sign_in/ui/pages/login_page_test.dart';
import 'package:bm_social_qatar/main.dart';
import 'package:bm_social_qatar/services/shared_prefrences_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'features/insta_profile/ui/pages/followers_listciew.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AppGet appGet = Get.put(AppGet());
  Future<String> getUserFromSp() async {
    String userId = getUser();
    appGet.userId = userId;
    return userId;
  }

  getUserDetails(String userId) {
    getUserFromFirestore(userId: userId);
  }

  getFollowers(String userID) {
    getFollowdUsers(userID);
  }

  getAllVariables() async {
    await getUserFromSp();
    if (appGet.userId != null) {
      print('shady');
      getUserDetails(appGet.userId);
      getFollowers(appGet.userId);
      getAllUsers();
      getProfileStatictics(appGet.userId);
      suggestFriends(appGet.userId);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllVariables();
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () async {
      print(appGet.userId);
      if (appGet.userId != null) {
        Get.off(HomePage1());
      } else {
        Get.off(LoginScreen());
      }
    });
    return Scaffold(
      backgroundColor: Color(0xfff3f3f3),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 100.h, horizontal: 100.w),
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/logo.png"),
        )),
      ),
    );
  }
}
