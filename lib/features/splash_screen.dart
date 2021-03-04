import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BMSSplachScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
