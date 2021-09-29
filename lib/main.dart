 import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:media/pages/home.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'social network',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        // ignore: deprecated_member_use
        accentColor: Colors.green[400]
      ),
      home:  const Home(),

    );
  }
}
