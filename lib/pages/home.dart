import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sc_media_flutter/pages/activity_feed.dart';
import 'package:sc_media_flutter/pages/profile.dart';
import 'package:sc_media_flutter/pages/search.dart';
import 'package:sc_media_flutter/pages/timeline.dart';
import 'package:sc_media_flutter/pages/upload.dart';

// bringing in google sign in
final GoogleSignIn googleSignIn = GoogleSignIn();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // to see if its a auth screen or not
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;

  @override
  initState() {
    super.initState();
    pageController = PageController();

    // when this widget is created, automatically sign in
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (error) {
      print('Error signing in ' + error.toString());
    });
    // reauthicate user when app is opened again
    googleSignIn.signInSilently(suppressErrors: false).then((account) {
      handleSignIn(account);
    }).catchError((err) {
      print('Error Signing in: $err');
    });
  }

  // handle signing in
  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      print('User Signed In: $account');
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  // dispose of the page
  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // method to sign into the google
  login() {
    googleSignIn.signIn();
  }

  // handling logging out
  logout() {
    googleSignIn.signOut();
  }

  // when the state of the page is changed
  onPagedChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  // method to select the page
  onPageSelect(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(),
          ActivityFeed(),
          Upload(),
          Search(),
          Profile()
        ],
        controller: pageController,
        onPageChanged: onPagedChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onPageSelect,
        activeColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_camera),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).accentColor
              ]),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Flutter Share',
              style: TextStyle(
                  fontSize: 90.0, color: Colors.white, fontFamily: "Signatra"),
            ),
            GestureDetector(
              onTap: login(),
              child: Container(
                width: 260.0,
                height: 60.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            'assets/images/google_signin_button.png'),
                        fit: BoxFit.cover)),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
