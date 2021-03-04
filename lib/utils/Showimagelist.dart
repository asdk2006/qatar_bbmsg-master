import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Showimagelist extends StatefulWidget {
  final List img;
  Showimagelist(this.img, {Key key}) : super(key: key);

  @override
  _ShowimagelistState createState() => _ShowimagelistState();
}

class _ShowimagelistState extends State<Showimagelist> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: ScreenUtil().setWidth(350),
      child: Stack(
        children: [
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.img.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                width: ScreenUtil().setWidth(375),
                decoration: new BoxDecoration(
                    image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(widget.img[index].toString()))),
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, right: 5),
            child: Align(
              alignment: Alignment(1, -1),
              child: Text(
                widget.img.length.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
