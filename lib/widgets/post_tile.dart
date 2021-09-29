import 'package:flutter/material.dart';
import 'package:media/widgets/post.dart';
import 'costom_image.dart';
 class PostTile extends StatefulWidget {
 late final Post post;

   PostTile({Key? key,required this.post}) : super(key: key);

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: (){},
        child: mm(  widget.post.mediaUrl),
      ),
    );
  }
}
