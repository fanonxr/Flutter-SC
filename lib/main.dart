import 'package:flutter/material.dart';
import 'package:sc_media_flutter/pages/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterShare',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.amber, accentColor: Colors.redAccent),
      home: Home(),
    );
  }
}
