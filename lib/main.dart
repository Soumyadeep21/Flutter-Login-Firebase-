import 'package:flutter/material.dart';
import 'package:flutter_login/pages/home_page.dart';
import 'package:flutter_login/pages/login_page.dart';
import 'package:flutter_login/pages/registration_page.dart';
import 'package:flutter_login/auth.dart';
import 'package:flutter_login/pages/root_page.dart';
import 'auth.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  final BaseAuth auth = Auth();
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String,WidgetBuilder>{
        "login" : (BuildContext context) => new LoginPage(auth: widget.auth,),
        "registration" : (BuildContext context) => new RegistrationPage(auth: widget.auth,),
        "home" : (BuildContext context) => new HomePage(auth: widget.auth,),
      },
      //initialRoute: "login",
      home: RootPage(auth: widget.auth,),
    );
  }
}


