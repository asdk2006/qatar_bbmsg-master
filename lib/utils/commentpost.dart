import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:bm_social_qatar/utils/Commentallpost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Commentpost extends StatefulWidget {
  final String postid;
  Commentpost(this.postid, {Key key}) : super(key: key);

  @override
  _CommentpostState createState() => _CommentpostState();
}

class _CommentpostState extends State<Commentpost> {
  bool liks = false;
  List likes = [];
  double hilist = 100;
  @override
  Widget build(BuildContext context) {
    return Container(
        height: hilist,
        width: ScreenUtil().setWidth(350),
        // padding:
        //     EdgeInsets.only(left: 20, right: 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Get.to(Commentallpost(widget.postid));
              },
              child: Container(
                child: Text(
                  'View all' + ' ' + 'comments',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  StreamBuilder<QuerySnapshot>(
                      stream: getAllPostComments(widget.postid),
                      builder: (context, snapshot) {
                        QuerySnapshot querySnapshot = snapshot.data;

                        if (querySnapshot.docs.length > 0) {
                          hilist = 100;
                        } else {
                          hilist = 0;
                        }
                        return snapshot.hasData
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: querySnapshot.size,
                                itemBuilder: (ctx, i) {
                                  likes =
                                      List.from(querySnapshot.docs[i]['likes']);
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: 300,
                                          child: Row(
                                            children: [
                                              // Icon(Feather.heart),
                                              Text(
                                                querySnapshot.docs[i]
                                                        .data()['userInfo']
                                                    ['userName'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                  size: 17,
                                                )
                                              : Icon(
                                                  FontAwesome.heart_o,
                                                  size: 16,
                                                ),
                                          onPressed: () {
                                            addLikeToComment(
                                                querySnapshot.docs[i]
                                                    .data()['postId'],
                                                querySnapshot.docs[i].id,
                                                querySnapshot.docs[i]
                                                    .data()['likes']);
                                            setState(() {});
                                          })
                                    ],
                                  );
                                })
                            : CircularProgressIndicator();
                      }),
                ],
              ),
            ),
          ],
        ));
  }
}
