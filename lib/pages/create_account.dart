import 'package:flutter/material.dart';
import 'package:sc_media_flutter/widgets/header.dart';

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  // getting the username when the submit button is tapped
  String username;

  // method to handle the submission of the form
  submit() {
    _formKey.currentState.save();
    Navigator.pop(context, username);
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      appBar: header(context, titleText: "Sign Up"),
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: Center(
                    child: Text(
                      "Create a User Name",
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        onSaved: (value) => username = value,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "UserName",
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: "Must be at least 3 characters"),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submit,
                  child: Container(
                    height: 50.0,
                    width: 350.0,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(7.0)),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
