import 'package:bm_social_qatar/backend/AppGet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bm_social_qatar/backend/firebase_helper.dart';

class FollowingUsers extends StatelessWidget {
  String title;
  AppGet appGet = Get.find();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Followed'),
      ),
      body: Obx(() {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              itemCount: appGet.myFollows.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Container(
                          width: 70.0,
                          height: 70.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: appGet.myFollows[index]['imageUrl']),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(appGet.myFollows[index]['userName']),
                          subtitle: Text(appGet.myFollows[index]['email']),
                          trailing: CupertinoButton(
                              child: Text('Following'),
                              onPressed: () {
                                unFollowUser(appGet.userId,
                                    appGet.myFollows[index]['userId']);
                                getProfileStatictics(appGet.userId);
                                appGet.myFollows.removeWhere((e) =>
                                    e['userId'] ==
                                    appGet.myFollows[index]['userId']);
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ));
      }),
    );
  }
}
