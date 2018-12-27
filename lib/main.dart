import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login/pages/home_page.dart';
import 'package:flutter_login/pages/login_page.dart';
import 'package:flutter_login/pages/registration_page.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  FirebaseUser firebaseUser;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth.currentUser().then((user){
      firebaseUser = user;
      //print(user.email);
    }).catchError((e){print(e);});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String,WidgetBuilder>{
        "login" : (BuildContext context) => new LoginPage(),
        "registration" : (BuildContext context) => new RegistrationPage(),
        "home" : (BuildContext context) => new HomePage(),
      },
      //initialRoute: "login",
      home: (firebaseUser!=null)?HomePage():LoginPage(),
    );
  }
}


