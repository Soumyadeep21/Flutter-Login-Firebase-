import 'package:flutter/material.dart';
import 'package:flutter_login/auth.dart';
import 'root_page.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({this.auth});
  final BaseAuth auth;
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
      await widget.auth.sendEmailVerification()
          .then((user) async{
        widget.auth.signOut();
        Fluttertoast.showToast(
            msg: "Verification Email Sent!Verify to Login",
            gravity: ToastGravity.BOTTOM,
            toastLength: Toast.LENGTH_LONG
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context)=> RootPage(auth: widget.auth)),
                (Route<dynamic> route) => false
        );
      });
    }
    catch(e){
      print("Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "images/registration.jpg",
            fit: BoxFit.cover,
            color: Colors.black87,
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
                      color: Colors.cyanAccent[400]
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
                              hintText: "Enter Your Name",
                              labelText: "Name",
                              labelStyle: TextStyle(color: Colors.yellowAccent),
                              hintStyle: TextStyle(color: Colors.blueAccent.withOpacity(.45)),
                              icon: Icon(Icons.person,color: Colors.red,),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
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
                              hintText: "Enter Your Email",
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.yellowAccent),
                              hintStyle: TextStyle(color: Colors.blueAccent.withOpacity(.45)),
                              icon: Icon(Icons.mail,color: Colors.red,),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
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
                              hintText: "Enter Password",
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.yellowAccent),
                              hintStyle: TextStyle(color: Colors.blueAccent.withOpacity(.45)),
                              icon: Icon(Icons.lock,color: Colors.red,),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
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
                      color: Colors.deepPurple[400].withOpacity(.6),
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: FlatButton(
                    onPressed: _submit,
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontFamily: "Karla",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                    splashColor: Colors.blue[800],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 30.0)),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (BuildContext context)=> RootPage(auth: widget.auth)),
                            (Route<dynamic> route) => false
                    );
                  },
                  child: Text(
                    "Already Registered? Log In",
                    style: TextStyle(
                        color: Colors.deepOrange,
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
