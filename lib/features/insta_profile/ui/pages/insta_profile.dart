import 'package:bm_social_qatar/backend/AppGet.dart';
import 'package:bm_social_qatar/features/insta_profile/ui/pages/follow_users_listview.dart';
import 'package:bm_social_qatar/features/insta_profile/ui/pages/followers_listciew.dart';
import 'package:bm_social_qatar/features/insta_profile/ui/widgets/user_image_with_plus_icon.dart';
import 'package:bm_social_qatar/utils/ui_image_data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class InstaProfile extends StatefulWidget {
  @override
  _InstaProfileState createState() => _InstaProfileState();
}

class _InstaProfileState extends State<InstaProfile>
    with SingleTickerProviderStateMixin {
  AppGet appGet = Get.find();
  TabController _tabController;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {},
        child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
              return <Widget>[
                // User information section
                SliverToBoxAdapter(child: userInfo()),

                // Tap bar
                SliverPersistentHeader(
                  delegate: CustomSliverDelegate(_tabController),
                  pinned: true,
                  floating: true,
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: <Widget>[
                postGridView(),
                taggedGridView(),
              ],
            )),
      ),
    );
  }

  // App bar
  Widget appBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.grey[50],
      title: Row(
        children: <Widget>[
          Text(
            'koirala_pankaj_000',
            style: TextStyle(),
          ),
          SizedBox(width: 4.0),
          Icon(
            Icons.keyboard_arrow_down,
            size: 18.0,
          ),
        ],
      ),
      actions: <Widget>[
        Icon(Icons.menu),
        SizedBox(width: 16.0),
      ],
    );
  }

  // User information
  Widget userInfo() {
    return Obx(() {
      return Container(
        //margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          border: Border(
            bottom: BorderSide(
              color: Colors.black26,
              width: 0.5,
            ),
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  UserImageWithPlusIcon(appGet.userMap['imageUrl']),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text('Posts'),
                            appGet.myStatictics['myPosts'] != null
                                ? Text(
                                    appGet.myStatictics['myPosts'].toString())
                                : Center(
                                    child: CircularProgressIndicator(
                                    backgroundColor: Colors.blue,
                                  ))
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(FollowersUsers());
                          },
                          child: Column(
                            children: [
                              Text('Followers'),
                              appGet.myStatictics['myPosts'] != null
                                  ? Text(appGet.myStatictics['myFollowers']
                                      .toString())
                                  : Center(
                                      child: CircularProgressIndicator(
                                      backgroundColor: Colors.blue,
                                    ))
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(FollowingUsers());
                          },
                          child: Column(
                            children: [
                              Text('Following'),
                              appGet.myStatictics['myPosts'] != null
                                  ? Text(appGet.myStatictics['myFollows']
                                      .toString())
                                  : Center(
                                      child: CircularProgressIndicator(
                                      backgroundColor: Colors.blue,
                                    ))
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                appGet.userMap['userName'],
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                appGet.userMap['bio'],
                style: TextStyle(),
              ),
              // Edit profile button
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 24.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black26,
                    width: 0.5,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // For padding
              SizedBox(height: 16.0),
            ],
          ),
        ),
      );
    });
  }

  // Tab 1 page (Frist TabView)
  Widget postGridView() {
    return Obx(() {
      return GridView.builder(
        itemCount: appGet.myImages.length,
        padding: EdgeInsets.only(top: 4.0),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 3.0,
          crossAxisSpacing: 3.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  appGet.myImages[index],
                ),
              ),
            ),
          );
        },
      );
    });
  }

  // Tab 2 page (Second TabView)
  Widget taggedGridView() {
    return GridView.builder(
      itemCount: 4,
      padding: EdgeInsets.only(top: 4.0),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 3.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                UIImageData.man4,
              ),
            ),
          ),
        );
      },
    );
  }
}

// Tab bar
class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  TabController _tabController;
  CustomSliverDelegate(this._tabController);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.black,
        tabs: <Widget>[
          Icon(Icons.grid_on),
          Icon(Icons.contacts),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
