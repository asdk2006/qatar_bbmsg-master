import 'package:bm_social_qatar/backend/AppGet.dart';
import 'package:bm_social_qatar/features/insta_profile/ui/pages/insta_profile.dart';
import 'package:bm_social_qatar/features/insta_profile/ui/pages/other_user_profile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bm_social_qatar/backend/firebase_helper.dart';

class FollowersUsers extends StatelessWidget {
  String title;
  AppGet appGet = Get.find();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Followers'),
      ),
      body: Obx(() {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView.builder(
              itemCount: appGet.myFollowers.length,
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
                              imageUrl: appGet.myFollowers[index]['imageUrl']),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text(appGet.myFollowers[index]['userName']),
                          subtitle: Text(appGet.myFollowers[index]['email']),
                          trailing: CupertinoButton(
                              child: Text('view profile'),
                              onPressed: () {
                                getProfileStatictics(
                                    appGet.myFollowers[index]['userId']);
                                getMyPosts();
                                getUserFromFirestore(
                                    userId: appGet.myFollowers[index]
                                        ['userId']);

                                Get.to(OhterInstaProfile());

                                // followUser(appGet.userId,
                                //     appGet.myFollowers[index]['userId']);

                                // unFollowUser(appGet.userId,
                                //     appGet.myFollows[index]['userId']);
                                // appGet.myFollows.removeWhere((e) =>
                                //     e['userId'] ==
                                //     appGet.myFollows[index]['userId']);
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
