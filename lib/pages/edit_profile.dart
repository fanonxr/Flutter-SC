import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:sc_media_flutter/models/user.dart';
import 'package:sc_media_flutter/pages/home.dart';
import 'package:sc_media_flutter/pages/timeline.dart';
import 'package:sc_media_flutter/widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displaynameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool isLoading = false;
  User user;
  bool _displayNameValid = true;
  bool _bioValid = true;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    // get the user doc from firebase
    DocumentSnapshot doc = await userRef.document(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displaynameController.text = user.displayName;
    bioController.text = user.bio;

    setState(() {
      isLoading = false;
    });
  }

  // method to build the display name field
  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Display Name",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displaynameController,
          decoration: InputDecoration(
              hintText: "Update Display Name",
              errorText: _displayNameValid ? null : "Display name too short"),
        )
      ],
    );
  }

  // method to build the bio field
  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            "Bio",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
              hintText: "Update Bio",
              errorText: _bioValid ? null : "Bio Description too long"),
        )
      ],
    );
  }

  // method to update the profile data
  updateProfileData() {
    setState(() {
      // if the display name is empty or if its less than 3 chars
      displaynameController.text.length < 3 ||
              displaynameController.text.isEmpty
          ? _displayNameValid = false
          : _displayNameValid = true;

      // checking if bio has enough characters
      bioController.text.trim().length > 100
          ? _bioValid = false
          : _bioValid = true;
    });

    // update firebase with the accepted data from the user
    if (_displayNameValid && _bioValid) {
      userRef.document(widget.currentUserId).updateData({
        "displayName": displaynameController.text,
        "bio": bioController.text,
      });

      SnackBar snackbar = SnackBar(
        content: Text("Profile updated"),
      );
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  // logging out of the app and going back to home page
  logout() async {
    await googleSignIn.signOut();
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: (Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            )),
          )
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage:
                              CachedNetworkImageProvider(user.photoUrl),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Column(
                          children: <Widget>[
                            buildDisplayNameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: () => updateProfileData(),
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FlatButton.icon(
                            onPressed: () => logout(),
                            icon: Icon(
                              Icons.cancel,
                              color: Colors.red,
                            ),
                            label: Text(
                              "logout",
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.0),
                            )),
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
