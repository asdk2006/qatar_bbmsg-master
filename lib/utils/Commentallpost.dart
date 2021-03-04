import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Commentallpost extends StatefulWidget {
  final String postid;

  Commentallpost(this.postid, {Key key}) : super(key: key);

  @override
  _CommentallpostState createState() => _CommentallpostState();
}

class _CommentallpostState extends State<Commentallpost> {
  TextEditingController postcommentcontroloer = new TextEditingController();
  bool liks = false;
  List<Map> likes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: new IconThemeData(color: Colors.black),
          title: Text(
            'Comments',
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: getAllPostComments(widget.postid),
                      builder: (context, snapshot) {
                        QuerySnapshot querySnapshot = snapshot.data;

                        return snapshot.hasData
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: querySnapshot.size,
                                itemBuilder: (ctx, i) {
                                  likes =
                                      List.from(querySnapshot.docs[i]['likes']);
                                  // var sList = List<String>. (likes);
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: 300,
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(70),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: Image(
                                                      image: NetworkImage(
                                                          "https://s3.amazonaws.com/uifaces/faces/twitter/oskarlevinson/128.jpg"),
                                                      width: ScreenUtil()
                                                          .setWidth(30),
                                                      height: ScreenUtil()
                                                          .setHeight(30),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Text(querySnapshot.docs[i]
                                                      ['comment']
                                                  .toString()),
                                            ],
                                          )),
                                      IconButton(
                                          icon: getLike(
                                            querySnapshot.docs[i]
                                                .data()['likes'],
                                          )
                                              ? Icon(
                                                  FontAwesome.heart,
                                                  color: Colors.red,
                                                  size: 14,
                                                )
                                              : Icon(
                                                  FontAwesome.heart_o,
                                                  size: 14,
                                                ),
                                          onPressed: () {
                                            addLikeToComment(
                                                    querySnapshot.docs[i]
                                                        ['postId'],
                                                    querySnapshot.docs[i].id,
                                                    likes)
                                                .then((value) {
                                              setState(() {});
                                            });
                                          })
                                    ],
                                  );
                                })
                            : CircularProgressIndicator();
                      }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Container(
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
                        addCommentToPost(
                            widget.postid, postcommentcontroloer.text);
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
              ),
            )
          ],
        ));
  }
}
