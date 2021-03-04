import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Postgrid extends StatefulWidget {
  final List img;
  Postgrid(this.img, {Key key}) : super(key: key);

  @override
  _PostgridState createState() => _PostgridState();
}

class _PostgridState extends State<Postgrid> {
  @override
  Widget build(BuildContext context) {
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
        children: List.generate(widget.img.length, (index) {
          String img = widget.img[index];
          return Image.network(
            img,
            width: MediaQuery.of(context).size.width,
          );
        }));
  }
}
