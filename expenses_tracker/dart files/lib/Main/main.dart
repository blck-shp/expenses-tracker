import 'package:flutter/material.dart';
import 'package:expenses_tracker/Extras/extras.dart';
import 'registration.dart';
import 'login.dart';

void main() => runApp(
  MaterialApp(
    theme: ThemeData(
      fontFamily: 'Nunito',
    ),
    home: Onboarding(),
  ),
);

class Onboarding extends StatefulWidget{

  @override
  _Onboarding createState() => _Onboarding();
}

class _Onboarding extends State<Onboarding>{
  @override

  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xffd8fcff),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Expanded(
                    child: Center(
                      child: Image.asset('assets/images/app_icon.png'),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: Text(
                              "WALLET",
                              style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff90b4aa),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Track your spending",
                                    style: TextStyle(
                                      color: Color(0xff90b4aa),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "\n\n",
                                  ),
                                  TextSpan(
                                    text: "Plan your budget",
                                    style: TextStyle(
                                      color: Color(0xff90b4aa),
                                    ),
                                  ),
                                ]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0 , bottom: 10.0),
                      child: ButtonFilled(width: .75 , height: 0, fontSize: 20.0, text: "SIGN UP" , backgroundColor: Color(0xffffffff), fontWeight: FontWeight.bold, nextPage: Registration(),),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Center(
                            child: TextLink(text: "I already have an account" , fontSize: 14.0, fontColor: Color(0xff90b4aa) , nextPage: Login(),),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}