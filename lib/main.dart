import 'package:flutter/material.dart';
import 'package:sc_media_flutter/pages/home.dart';

void main() {
//  Firestore.instance.settings(timestampsInSnapshotsEnabled: true).then(
//      (value) => print("Timestamps enabled in snapshots\n"),
//      onError: (err) => print("Error enabling timestamps in snapshots\n"));
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
