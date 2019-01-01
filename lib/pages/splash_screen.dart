import 'package:flutter/material.dart';
import 'package:flutter_login/auth.dart';
import 'dart:async';
import 'root_page.dart';


class SplashScreen extends StatefulWidget {

  SplashScreen({this.auth});
  final BaseAuth auth;
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  Animation logoanimation,textanimation;
  AnimationController animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2)
    );
    logoanimation = Tween(begin: 25.0,end: 100.0).animate(
      CurvedAnimation(
          parent: animationController,
          curve: Curves.bounceOut
      )
    );
    textanimation = Tween(begin: 0.0,end: 27.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Curves.bounceInOut
        )
    );
    logoanimation.addListener(()=> this.setState((){}));
    textanimation.addListener(()=> this.setState((){}));
    animationController.forward();
    Timer(
        Duration(seconds: 4),
            ()=>Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context)=>RootPage(auth: widget.auth,)
        ))
    );
  }
  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.red),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlutterLogo(
                        size: logoanimation.value,
                        curve: Curves.bounceOut,
                      ),
                      Padding(padding: EdgeInsets.only(top: 20.0)),
                      Text(
                        "LOGIN APP",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Pacifico",
                            fontSize: textanimation.value
                        ),
                      )
                    ],
                  )
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.yellowAccent),),
                    Padding(padding: EdgeInsets.only(top: 20.0)),
                    Text(
                      "              Loading....\n Thanks for your paitence",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 13.0
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}