 import 'package:flutter/material.dart';
import 'package:media/widgets/header.dart';



class TimeLine extends StatefulWidget {
  const TimeLine({Key? key}) : super(key: key);

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {


  @override
void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: header(context, titleText: 'TimeLine'),
        body:Container(),
    );
  }

}


