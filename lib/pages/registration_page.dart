import 'package:flutter/material.dart';
import 'package:flutter_login/auth.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({this.auth});
  final BaseAuth auth;
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();
  String _name,_email,_password;
  FocusNode f1,f2;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    f1 = FocusNode();
    f2 = FocusNode();
  }

  void _submit(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      print("Name: $_name Email: $_email Password: $_password");
      _register();
    }
  }
  void _register() async{
    try {
      String uid = await widget.auth.createUser(_email, _password);
      print("uid: $uid");
      widget.auth.signOut();
      Navigator.of(context).pushReplacementNamed("login");
    }
    catch(e){
      print("Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "images/registration.jpg",
            fit: BoxFit.cover,
            color: Colors.black45,
            colorBlendMode: BlendMode.darken,
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0,right: 20.0),
            child: ListView(
              children: <Widget>[
                Center(
                  child: Text(
                    "User Registration",
                    style: TextStyle(
                      fontSize: 40.0,
                      fontFamily: "Pacifico",
                      color: Colors.yellowAccent
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 90.0)),
                Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Name",
                              hintStyle: TextStyle(color: Colors.blueAccent),
                              icon: Icon(Icons.person,color: Colors.red,)
                          ),
                          style: TextStyle(color: Colors.blue),
                          validator: (val)=> val.length<1?"Invalid Name":null,
                          onSaved: (val)=> _name=val,
                          onFieldSubmitted: (val)=> FocusScope.of(context).requestFocus(f1),
                        ),
                        Padding(padding: EdgeInsets.only(top: 30.0)),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          focusNode: f1,
                          decoration: InputDecoration(
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.blueAccent),
                              icon: Icon(Icons.mail,color: Colors.red,)
                          ),
                          style: TextStyle(color: Colors.blue),
                          validator: (val)=> !val.contains('@')?"Invalid Email":null,
                          onSaved: (val)=> _email=val,
                          onFieldSubmitted: (val)=> FocusScope.of(context).requestFocus(f2),
                        ),
                        Padding(padding: EdgeInsets.only(top: 30.0)),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          focusNode: f2,
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.blueAccent),
                              icon: Icon(Icons.lock,color: Colors.red,)
                          ),
                          style: TextStyle(color: Colors.blue),
                          validator: (val)=> val.length<6?"Pasword too short":null,
                          onSaved: (val)=> _password=val,
                          obscureText: true,
                        ),
                      ],
                    )
                ),
                Padding(padding: EdgeInsets.only(top: 60.0)),
                Container(
                  height: 45.0,
                  width: 200.0,
                  decoration: BoxDecoration(
                      color: Colors.pink[700],
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: FlatButton(
                    onPressed: _submit,
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        color: Colors.yellowAccent,
                        fontSize: 20.0,
                        fontFamily: "Karla",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    splashColor: Colors.blue[800],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("login");
                  },
                  child: Text(
                    "Already Registered? Log In",
                    style: TextStyle(
                        color: Colors.yellow,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: "Karla",
                        fontSize: 24.0
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}
