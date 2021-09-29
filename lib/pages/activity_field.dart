import 'package:flutter/material.dart';
import 'package:media/widgets/header.dart';

class ActivityField extends StatefulWidget {
  const ActivityField({Key? key}) : super(key: key);

  @override
  _ActivityFieldState createState() => _ActivityFieldState();
}

class _ActivityFieldState extends State<ActivityField> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: header(context,titleText: 'ActiviityField'),
    // ignore: avoid_unnecessary_containers
    body: Container(
      child: const Center(child: Text('ActiviityField')),)
    );
  }
}
