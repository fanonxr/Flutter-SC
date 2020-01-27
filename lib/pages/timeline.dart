import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sc_media_flutter/widgets/header.dart';
import 'package:sc_media_flutter/widgets/progress.dart';

// getting the users collections from firebase
final userRef = Firestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  List<dynamic> users = []; // list to gold user objects from firebase

  // method to create a user in firebase
  createUser() {
    userRef
        .document('hajhfskgjnkjs')
        .setData({"username": "jeff", "postsCount": 0, "isAdmin": false});
  }

  // method to update a user in firebase
  updateUser() async {
    final doc = await userRef.document('hajhfskgjnkjs').get();
    if (doc.exists) {
      doc.reference
          .updateData({"username": "jake", "postsCount": 0, "isAdmin": false});
    }
  }

  // method to delete user from firebase
  deleteUser() async {
    final doc = await userRef.document('hajhfskgjnkjs').get();
    if (doc.exists) {
      doc.reference.delete();
    }
  }

  // method to get all the users from firebase
  getUsers() async {
    final QuerySnapshot snapshot = await userRef.getDocuments();
    setState(() {
      users = snapshot.documents;
    });
  }

  // method to get the user by the ID
  getUserById() async {
    final String id = "";
    final DocumentSnapshot doc = await userRef.document(id).get();
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context, isAppTitle: true),
        body: StreamBuilder<QuerySnapshot>(
          stream: userRef.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return circularProgress();
            }
            final List<Text> children = snapshot.data.documents
                .map((doc) => Text(doc['username']))
                .toList();
            return Container(
              child: ListView(
                children: children,
              ),
            );
          },
        ));
  }

  @override
  void initState() {
    super.initState();
  }
}
