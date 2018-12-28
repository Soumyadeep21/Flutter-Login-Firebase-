import 'package:flutter/material.dart';
import 'package:flutter_login/auth.dart';
import 'login_page.dart';
import 'home_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});
  final BaseAuth auth;
  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus{
  //NotDetermined,
  SignedIn,
  NotSignedIn
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NotSignedIn;
  String _userId="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.currentUser().then((user){
      setState(() {
        if(user!=null){
          _userId = user?.uid;
        }
        authStatus = user?.uid ==null ? AuthStatus.NotSignedIn:AuthStatus.SignedIn;
      });
    });
  }
  void _signedIn(){
    setState(() {
      authStatus = AuthStatus.SignedIn;
      widget.auth.currentUser().then((user){
        _userId = user.uid.toString();
      });
    });
  }
  void _signedOut(){
    setState(() {
      authStatus = AuthStatus.NotSignedIn;
      _userId = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(authStatus){
      case AuthStatus.NotSignedIn:
        return LoginPage(auth: widget.auth,onSignedIn: _signedIn,);
        break;
      case AuthStatus.SignedIn:
        return HomePage(auth: widget.auth,onSignedOut: _signedOut,);
        break;
      /*case AuthStatus.NotDetermined:
        return Scaffold(body: Center(child: Text("Hello World"),),);
        break;*/
    }
  }
}
