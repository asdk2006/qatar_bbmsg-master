import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Addcommentwidget extends StatefulWidget {
  final String postid;
  Addcommentwidget(this.postid, {Key key}) : super(key: key);

  @override
  _AddcommentwidgetState createState() => _AddcommentwidgetState();
}

class _AddcommentwidgetState extends State<Addcommentwidget> {
  TextEditingController postcommentcontroloer = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              border: Border.all(
                width: 3,
                color: Color(0xFF8e44ad),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(
                0,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image(
                  image: NetworkImage(
                      "https://s3.amazonaws.com/uifaces/faces/twitter/oskarlevinson/128.jpg"),
                  width: ScreenUtil().setWidth(30),
                  height: ScreenUtil().setHeight(30),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(280),
            child: TextField(
              controller: postcommentcontroloer,
              decoration: InputDecoration(
                  border: InputBorder.none, hintText: 'add comment'),
            ),
          ),
          GestureDetector(
            onTap: () {
              print('dfsdfsdsfs');
              addCommentToPost(widget.postid, postcommentcontroloer.text);
            },
            child: Container(
              child: Center(
                child: Text(
                  'post',
                  style: TextStyle(color: Colors.blue[700]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
