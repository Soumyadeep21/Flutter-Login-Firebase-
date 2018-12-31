import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'registration_page.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.auth,this.onSignedIn});
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{
  AnimationController animationController;
  Animation logoanimation;
  String _email,_password,_emailpassword;
  FocusNode focusNode;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final formKey1 = GlobalKey<FormState>();
  void initState(){
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    logoanimation = CurvedAnimation(
        parent: animationController,
        curve: Curves.easeOut
    );
    logoanimation.addListener(()=>this.setState((){}));
    animationController.forward();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    super.dispose();

  }
  void _submit(){
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      print("Email: $_email Password: $_password");
      _login();
    }
  }
  void _login() async{
    try{
      String uid = await widget.auth.signIn(_email,_password);
      print("Signed in : $uid");
      await widget.auth.isEmailVerified().then((isVerified) async{
        if (isVerified){
          print("Verified");
          widget.onSignedIn();}
        else {
          final snackBar = SnackBar(
            content: Text("Email Not Verified!"),
            duration: Duration(seconds: 1),
            action: SnackBarAction(
                label: "Send Again",
                onPressed: () async {
                  await widget.auth.sendEmailVerification();
                }
            ),
          );
          scaffoldKey.currentState.showSnackBar(snackBar);
          await Future.delayed(Duration(milliseconds: 1001));
          await widget.auth.signOut();
        }
      });
    }
    catch(e){
      final snackBar = SnackBar(content: Text("Error in Signing in!"));
      scaffoldKey.currentState.showSnackBar(snackBar);
      print("Error: $e");
    }
  }

  void _passwordReset() async{
    final form = formKey1.currentState;
    if(form.validate()){
      form.save();
      try {
        await widget.auth.resetPassword(_emailpassword);
        Navigator.of(context).pop();
        final snackBar = SnackBar(content: Text("Password Reset Email Sent"));
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
      catch(e){
        Fluttertoast.showToast(
            msg: "Invalid Input!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
        );
      }
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
            "images/login.jpg",
            fit: BoxFit.cover,
            color: Colors.black87,
            colorBlendMode: BlendMode.darken,
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0,right: 20.0),
            child: ListView(
              children: <Widget>[
                Container(
                  height: 25.0,
                ),
                Image.asset(
                  "images/loginlogo.png",
                  height: logoanimation.value * 150,
                  width: logoanimation.value * 150,
                ),
                Padding(padding: EdgeInsets.only(top: 60.0)),
                Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Enter Email",
                              labelText: "Email",
                              labelStyle: TextStyle(color: Colors.yellowAccent),
                              hintStyle: TextStyle(color: Colors.blueAccent.withOpacity(.45)),
                              icon: Icon(Icons.mail,color: Colors.red,),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                            ),
                          style: TextStyle(color: Colors.blue),
                          validator: (val)=> !val.contains('@')?"Invalid Email":null,
                          onSaved: (val)=> _email=val,
                          onFieldSubmitted: (val)=> FocusScope.of(context).requestFocus(focusNode),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 30.0)),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Enter Password",
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.yellowAccent),
                              hintStyle: TextStyle(color: Colors.blueAccent.withOpacity(.45)),
                              icon: Icon(Icons.lock,color: Colors.red,),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                          ),
                          obscureText: true,
                          style: TextStyle(color: Colors.blue),
                          validator: (val)=> val.length<6?"Password too short":null,
                          onSaved: (val)=> _password=val,
                          focusNode: focusNode,
                        ),
                      ],
                    ),
                ),
                Padding(padding: EdgeInsets.only(top:60.0)),
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
                      "LOGIN",
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
                Padding(padding: EdgeInsets.only(top: 20.0)),
                FlatButton(
                  onPressed: () {
                   Navigator.of(context).push(PageNavigate(auth: widget.auth));
                  },
                  child: Text(
                    "New User? Sign Up!",
                    style: TextStyle(
                        color: Colors.orangeAccent,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontFamily: "Karla",
                        fontSize: 24.0
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 20.0)),
                FlatButton(
                    onPressed: (){
                      showDialog(
                          context: context,
                          builder: (BuildContext context){
                            return AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                              title: Text("Reset Password"),
                              content: Form(
                                key: formKey1,
                                child: TextFormField(
                                  onSaved: (val)=>_emailpassword = val,
                                  validator: (val)=> !val.contains('@')?"Invalid Email":null,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: Colors.blue),
                                  decoration: InputDecoration(
                                    hintText: "Enter Email",
                                    labelText: "Email",
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                                  ),
                                  autofocus: true,
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: ()=>Navigator.of(context).pop(),
                                    child: Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.black),
                                    )
                                ),
                                RaisedButton(
                                  onPressed: (){
                                    _passwordReset();
                                  },
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  color: Colors.deepOrange,
                                )
                              ],
                            );
                          }
                      );
                    },
                    child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontFamily: "Karla",
                            fontSize: 20.0
                        ),
                    )
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PageNavigate extends CupertinoPageRoute{
  final BaseAuth auth;
  PageNavigate({this.auth})
  :super(builder: (BuildContext context) => RegistrationPage(auth: auth,));
}