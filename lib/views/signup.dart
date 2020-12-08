import 'package:chat_app/helper/helperfunctions.dart';
import 'package:chat_app/services/auth.dart';
import 'package:chat_app/services/database.dart';
import 'package:chat_app/views/chatRoomScreen.dart';

import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widget.dart';

class Signup extends StatefulWidget {
  final Function toggle;
  Signup(this.toggle);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  AuthMethods authMethods = new AuthMethods();

  DatabaseMethods databaseMethods = new DatabaseMethods();

  TextEditingController userNameTextEditingController =
      new TextEditingController();

  TextEditingController emailTextEditingController =
      new TextEditingController();

  TextEditingController passwordTextEditingController =
      new TextEditingController();

  signMeUp() {
    Map<String, dynamic> userInfoMap = {
      "name": userNameTextEditingController.text,
      "email": emailTextEditingController.text
    };

    HelperFunctions.saveuserNameSharedPreference(
        userNameTextEditingController.text);

    HelperFunctions.saveuserEmailSharedPreference(
        emailTextEditingController.text);

    if (formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
    }
    authMethods
        .signUpWithEmailAndPassword(
            emailTextEditingController.text, passwordTextEditingController.text)
        .then((val) {
      //print("$val"); //will print instance of user

      databaseMethods.uploadUserInfo(userInfoMap);
      HelperFunctions.saveuserLoggedInSharedPreference(true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: appBarMain(context),
      body: isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 40,
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return val.isEmpty || val.length < 2
                                    ? "Please provide Username"
                                    : null;
                              },
                              controller: userNameTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldDecoration("Username"),
                            ),
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)
                                    ? null
                                    : "Enter correct email";
                              },
                              controller: emailTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldDecoration("Email"),
                            ),
                            TextFormField(
                              obscureText: true,
                              validator: (val) {
                                return val.length < 6
                                    ? "Please provide password of 6+char in length"
                                    : null;
                              },
                              controller: passwordTextEditingController,
                              style: simpleTextStyle(),
                              decoration: textFieldDecoration("Password"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          signMeUp();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Colors.yellowAccent,
                                Colors.orangeAccent
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Colors.white, fontSize: 17),
                          ),
                        ),
                      ),
                      
                      SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: mediumTextStyle(),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                "Sign In Now",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
