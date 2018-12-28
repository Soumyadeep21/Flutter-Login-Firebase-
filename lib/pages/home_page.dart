import 'package:flutter/material.dart';
import 'package:flutter_login/auth.dart';
class HomePage extends StatefulWidget {
  HomePage({this.auth,this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name="Android",_email="";
  void onSignOut() async{
    try {
      await widget.auth.signOut();
      print("Signed Out");
      widget.onSignedOut();
    }
    catch(e){
      print("Error: $e");
    }
  }

  @override
  void initState(){
    super.initState();
    widget.auth.currentUser().then((user){
      setState(() {
        if(user!=null)
          _email = user.email.toString();
        else
          _email="Loading...";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("MY LOGIN APP"),),
      body: Center(child: RaisedButton(
        child: Text("Sign Out"),
        onPressed: onSignOut
        )
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text(_name),
                accountEmail: Text(_email),
                currentAccountPicture: CircleAvatar(
                  child: Text(_name[0],style: TextStyle(color: Colors.yellowAccent),),
                  backgroundColor: Colors.red,
                ),
            )
          ],
        ),
      ),
    );
  }
}
