import 'dart:io';

import 'package:bm_social_qatar/backend/AppGet.dart';
import 'package:bm_social_qatar/backend/firebase_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserImageWithPlusIcon extends StatelessWidget {
  String imageUrl;
  UserImageWithPlusIcon(this.imageUrl);
  AppGet appGet = Get.find();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: <Widget>[
          Container(
            height: 100.0,
            width: 100.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(appGet.userMap['imageUrl']),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: GestureDetector(
              onTap: () async {
                PickedFile pickedFile =
                    await ImagePicker().getImage(source: ImageSource.gallery);

                File file = File(pickedFile.path);
                updateImage(file, appGet.userId);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Container(
                  height: 24.0,
                  width: 24.0,
                  margin: EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
