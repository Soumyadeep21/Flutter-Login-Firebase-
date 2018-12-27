import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth firebaseAuth;
  FirebaseUser firebaseUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firebaseAuth = FirebaseAuth.instance;
    firebaseAuth.currentUser().then((user){
      print("user uid ${user.uid}");
      print("email : ${user.email}");
      firebaseUser = user;
    });
  }
  void signOut(){

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MY LOGIN APP"),),
      body: Center(child: RaisedButton(
        child: Text("Sign Out"),
        onPressed: (){
          firebaseAuth.signOut().whenComplete((){
            print("Signed Out");
            Navigator.of(context).pushReplacementNamed("login");
          });
        },
      ),),
    );
  }
}
