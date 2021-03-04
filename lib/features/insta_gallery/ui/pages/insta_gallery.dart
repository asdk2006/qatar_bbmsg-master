import 'dart:io';

import 'dart:convert';

import 'package:bm_social_qatar/features/insta_gallery/ui/pages/multiselectgrid.dart';
import 'package:bm_social_qatar/features/insta_gallery/ui/postnew/postnew.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:storage_path/storage_path.dart';

import 'file.dart';

class InstaGallery extends StatefulWidget {
  @override
  _InstaGalleryState createState() => _InstaGalleryState();
}

class _InstaGalleryState extends State<InstaGallery> {
  var _selection = MultiChildSelection.empty;
  List<FileModel> files = [];
  FileModel selectedModel;
  String image;
  @override
  void initState() {
    super.initState();
    getImagesPath();
  }

  getImagesPath() async {
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files != null && files.length > 0)
      setState(() {
        selectedModel = files[0];
        image = files[0].files[0];
      });
  }

  List<DropdownMenuItem<FileModel>> getItems() {
    return files == null
        ? null
        : files
                ?.map((e) => DropdownMenuItem(
                      child: Text(
                        e.folder,
                        style: TextStyle(color: Colors.black),
                      ),
                      value: e,
                    ))
                ?.toList() ??
            [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(Icons.clear),
                    SizedBox(width: 10),
                    DropdownButtonHideUnderline(
                        child: DropdownButton<FileModel>(
                      items: getItems(),
                      onChanged: (FileModel d) {
                        assert(d.files.length > 0);
                        image = d.files[0];
                        setState(() {
                          selectedModel = d;
                        });
                      },
                      value: selectedModel,
                    ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      print('ddreee:' + image);
                      Get.to(Postnew(image));
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                )
              ],
            ),
            Divider(),
            Container(
                height: MediaQuery.of(context).size.height * 0.45,
                child: image != null
                    ? Image.file(File(image),
                        height: MediaQuery.of(context).size.height * 0.45,
                        width: MediaQuery.of(context).size.width)
                    : Container()),
            Divider(),
            selectedModel == null && selectedModel.files.length < 1
                ? Container()
                : Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    child: MultiSelectGridView(
                        onSelectionChanged: (selection) => setState(() {
                              _selection = selection;
                              print('fsfs' + selection.total.toString());
                            }),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemBuilder:
                            (BuildContext context, int index, bool selected) {
                          var file = selectedModel.files[index];
                          return GestureDetector(
                            child: Image.file(
                              File(file),
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              setState(() {
                                print('fff');
                                image = file;
                                print('fff:' + image);
                              });
                            },
                          );
                        },
                        itemCount: selectedModel.files.length),
                  )
          ],
        ),
      ),
    );
  }
}
