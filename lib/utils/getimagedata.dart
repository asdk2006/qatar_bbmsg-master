import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

File _pickedImage;
String base64Image;
final ImagePicker picker = ImagePicker();

getimagdata(BuildContext context) async {
  final imageSource = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Select the image source"),
            actions: <Widget>[
              MaterialButton(
                child: Text("Camera"),
                onPressed: () => Navigator.pop(context, ImageSource.camera),
              ),
              // MaterialButton(
              //   child: Text("Gallery"),
              //   onPressed: () => Navigator.pop(context, ImageSource.gallery),
              // )
            ],
          ));

  if (imageSource != null) {
    var imgfil = await picker.getImage(
        source: imageSource, maxHeight: 100, maxWidth: 100, imageQuality: 100);
    print('images is full');

    if (imgfil != null) {
      _pickedImage = File(imgfil.path);
      // img = _pickedImage;

    }
  } else {}

  return _pickedImage;
}
