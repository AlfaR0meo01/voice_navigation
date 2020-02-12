import 'package:flutter/material.dart';
import 'views/vista_main.dart';
//import 'package:speech_recognition/speech_recognition.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //debugPaintSizeEnabled = true;
    return MaterialApp(
      home: Voice(),
    );
  }
}
