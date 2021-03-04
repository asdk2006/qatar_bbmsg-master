import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:bm_social_qatar/main.dart';
import 'package:bm_social_qatar/utils/getimagedata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Instapost extends StatefulWidget {
  Instapost({Key key}) : super(key: key);

  @override
  _InstapostState createState() => _InstapostState();
}

class _InstapostState extends State<Instapost> {
  Widget buildGridView() {
    return StaggeredGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      staggeredTiles: [
        StaggeredTile.count(2, 2),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
        StaggeredTile.count(1, 1),
      ],
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 200,
          height: 200,
        );
      }),
    );
  }

  int imagcount = 0;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      setState(() {
        imagcount = resultList.length;
        print('imagecount=' + imagcount.toString());
      });
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Color txtclr = Colors.black;
  Color cc = Colors.white;
  bool acolr = false;
  TextEditingController postcontrollerp = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 0),
          child: Center(
              child: Text(
            'new post',
            style: TextStyle(color: Colors.black, fontSize: 20),
          )),
        ),
        Padding(
            padding: EdgeInsets.only(top: 0, left: 10, right: 10),
            child: Center(
                child: Container(
              decoration: BoxDecoration(
                color: cc,
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextFormField(
                style: TextStyle(color: txtclr),
                cursorColor: Colors.black,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                controller: postcontrollerp,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: 'What do think',
                  hintStyle: TextStyle(color: txtclr),
                ),
              ),
            ))),
        Padding(
          padding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    acolr = !acolr;
                  });
                },
                child: Container(
                  child: acolr
                      ? Image.asset(
                          'assets/images/acolor.png',
                          width: 48,
                        )
                      : Icon(
                          Icons.arrow_forward_ios,
                          size: 48,
                        ),
                ),
              ),
              Opacity(
                opacity: acolr ? 0 : 1,
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cc = Colors.white;

                            txtclr = Colors.black;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setHeight(35),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(70),
                                border:
                                    Border.all(color: Colors.red, width: 1.5)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cc = Colors.black;

                            txtclr = Colors.white;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setHeight(35),
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(70),
                                border: Border.all(
                                    color: Colors.yellow, width: 1.5)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cc = Colors.red[300];

                            txtclr = Colors.white;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setHeight(35),
                            decoration: BoxDecoration(
                                color: Colors.red[300],
                                borderRadius: BorderRadius.circular(70),
                                border: Border.all(
                                    color: Colors.yellow, width: 1.5)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cc = Colors.blue[300];

                            txtclr = Colors.white;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setHeight(35),
                            decoration: BoxDecoration(
                                color: Colors.blue[300],
                                borderRadius: BorderRadius.circular(70),
                                border: Border.all(
                                    color: Colors.yellow, width: 1.5)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            cc = Colors.deepOrange;

                            txtclr = Colors.white;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(70),
                          child: Container(
                            width: ScreenUtil().setWidth(30),
                            height: ScreenUtil().setHeight(35),
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(70),
                                border: Border.all(
                                    color: Colors.yellow, width: 1.5)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          child: Container(
            padding: EdgeInsets.only(
              left: 15,
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 2),
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      addNewPost(
                          content: postcontrollerp.text, assetImages: images);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => HomePage1()),
                          (Route<dynamic> route) => false);
                    },
                    child: Container(
                        width: ScreenUtil().setWidth(120),
                        height: ScreenUtil().setHeight(35),
                        decoration: BoxDecoration(
                            color: Colors.red[400],
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text('Post',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                        ))),
                Container(
                  child: Row(
                    children: [
                      IconButton(
                          icon: Icon(Feather.camera, color: Colors.blue[500]),
                          onPressed: () {
                            getimagdata(context);
                          }),
                      IconButton(
                          icon: Icon(
                            Feather.image,
                            color: Colors.green[300],
                          ),
                          onPressed: () {
                            loadAssets();
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          // padding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),

          child: buildGridView(),
        ),
      ],
    );
  }
}
