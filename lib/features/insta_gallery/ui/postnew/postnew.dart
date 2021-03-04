import 'dart:io';

import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:bm_social_qatar/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Postnew extends StatefulWidget {
  final String image;
  Postnew(this.image, {Key key}) : super(key: key);

  @override
  _PostnewState createState() => _PostnewState();
}

class _PostnewState extends State<Postnew> {
  TextEditingController postcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: Size(375, 812), allowFontScaling: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        iconTheme: new IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'New Post',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            GestureDetector(
              onTap: () {
                // navigator.pop();
                addNewPostonimage(
                    content: postcontroller.text, images: File(widget.image));
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => HomePage1()),
                    (Route<dynamic> route) => false);
              },
              child: Text(
                'share',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
            )
          ],
        ),
      ),
      body: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.file(
              File(widget.image),
              height: ScreenUtil().setHeight(50),
              width: ScreenUtil().setWidth(40),
            ),
            Container(
                height: ScreenUtil().setHeight(50),
                width: ScreenUtil().setWidth(300),
                child: TextField(
                  controller: postcontroller,
                ))
          ],
        ),
      ),
    );
  }
}
