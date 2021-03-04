import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:bm_social_qatar/post.dart';
import 'package:bm_social_qatar/story.dart';
import 'package:bm_social_qatar/utils/Showimagelist.dart';
import 'package:bm_social_qatar/utils/addcommentwidget.dart';
import 'package:bm_social_qatar/utils/commentpost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:bm_social_qatar/utils/postgrid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Map> likes = [];
  bool lik = false;
  List<Story> _stories = [
    Story(
        "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Jazmin"),
    Story(
        "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Sylvester"),
    Story(
        "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Lavina"),
    Story(
        "https://images.pexels.com/photos/1124724/pexels-photo-1124724.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Mckenzie"),
    Story(
        "https://images.pexels.com/photos/1845534/pexels-photo-1845534.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Buster"),
    Story(
        "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Carlie"),
    Story(
        "https://images.pexels.com/photos/762020/pexels-photo-762020.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Edison"),
    Story(
        "https://images.pexels.com/photos/573299/pexels-photo-573299.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Flossie"),
    Story(
        "https://images.pexels.com/photos/756453/pexels-photo-756453.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Lindsey"),
    Story(
        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Freddy"),
    Story(
        "https://images.pexels.com/photos/1832959/pexels-photo-1832959.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
        "Litzy")
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            RaisedButton(onPressed: () {
              print(appGet.userMap);
            }),
            Divider(),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Stories",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    "Watch All",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(
                vertical: 10,
              ),
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: _stories.map((story) {
                  return Column(
                    children: <Widget>[
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
                            2,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child: Image(
                              image: NetworkImage(story.image),
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(story.name),
                    ],
                  );
                }).toList(),
              ),
            ),

            // posts
            Container(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                  stream: getAllPosts(),
                  builder: (context, snapshot) {
                    QuerySnapshot querySnapshot = snapshot.data;

                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: querySnapshot.size,
                            itemBuilder: (ctx, i) {
                              return Container(
                                color: Colors.white,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                child: CachedNetworkImage(
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                  imageUrl: querySnapshot
                                                      .docs[i]
                                                      .data()['userInfo']
                                                          ['imageUrl']
                                                      .toString(),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(querySnapshot.docs[i]
                                                      .data()['userInfo']
                                                  ['userName']),
                                            ],
                                          ),
                                          IconButton(
                                            icon: Icon(SimpleLineIcons.options),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                        height: ScreenUtil().setHeight(190),
                                        child: Showimagelist(
                                            querySnapshot.docs[i]['images'])),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            IconButton(
                                              onPressed: () {
                                                addLikeToPost(
                                                        querySnapshot
                                                            .docs[i].id,
                                                        querySnapshot.docs[i]
                                                            .data()['likes'])
                                                    .then((value) {
                                                  setState(() {
                                                    lik = value;
                                                  });
                                                });
                                              },
                                              icon: getLike(querySnapshot
                                                      .docs[i]
                                                      .data()['likes'])
                                                  ? Icon(
                                                      FontAwesome.heart,
                                                      color: Colors.red,
                                                    )
                                                  : Icon(FontAwesome.heart_o),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(FontAwesome.comment_o),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(FontAwesome.send_o),
                                            ),
                                          ],
                                        ),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(FontAwesome.bookmark_o),
                                        ),
                                      ],
                                    ),

                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      child: RichText(
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Liked By ",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                              text: querySnapshot.docs[i]
                                                  .data()['likes']
                                                  .length
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // caption
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 5,
                                      ),
                                      child: RichText(
                                        softWrap: true,
                                        overflow: TextOverflow.visible,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                            ),
                                            TextSpan(
                                              text:
                                                  " ${querySnapshot.docs[i]['content']}",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // post date
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: 14,
                                      ),
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Febuary 2020",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child:
                                          Commentpost(querySnapshot.docs[i].id),
                                    ),
                                    //querySnapshot.docs[i].id
                                    Padding(
                                      padding: EdgeInsets.only(left: 0),
                                      child: Addcommentwidget(
                                          querySnapshot.docs[i].id),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : CircularProgressIndicator();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
