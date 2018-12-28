import 'package:flutter/material.dart';
import 'package:flutter_login/auth.dart';

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
  String _email,_password;
  FocusNode focusNode;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
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
      widget.onSignedIn();
    }
    catch(e){
      final snackBar = SnackBar(content: Text("Error: $e"));
      scaffoldKey.currentState.showSnackBar(snackBar);
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
            "images/login.jpg",
            fit: BoxFit.cover,
            color: Colors.black45,
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
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.blueAccent),
                              icon: Icon(Icons.mail,color: Colors.red,)
                            ),
                          style: TextStyle(color: Colors.blue),
                          validator: (val)=> !val.contains('@')?"Invalid Email":null,
                          onSaved: (val)=> _email=val,
                          onFieldSubmitted: (val)=> FocusScope.of(context).requestFocus(focusNode),
                        ),
                        new Padding(padding: EdgeInsets.only(top: 30.0)),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "Password",
                              hintStyle: TextStyle(color: Colors.blueAccent),
                              icon: Icon(Icons.lock,color: Colors.red,)
                          ),
                          obscureText: true,
                          style: TextStyle(color: Colors.blue),
                          validator: (val)=> val.length<6?"Password too short:null":null,
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
                      color: Colors.pink[700],
                      borderRadius: BorderRadius.circular(30.0)
                  ),
                  child: FlatButton(
                    onPressed: _submit,
                    child: Text(
                      "LOGIN",
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
                    //Navigator.of(context).pushNamed("registration");
                    Navigator.of(context).pushReplacementNamed("registration");
                  },
                  child: Text(
                    "New User? Sign Up",
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
      ),
    );
  }
}