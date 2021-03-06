import 'package:flutter/material.dart';
import 'package:expenses_tracker/Extras/extras.dart';
import 'Extras/sizes.dart';
import 'Main/registration.dart';
import 'Main/login.dart';

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
  void dispose(){
    super.dispose();
  }

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
                                color: Color(0xff009688),
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
                      margin: EdgeInsets.only(top: 15.0 , bottom: 15.0),
                      child: MaterialButton(
                        color: Color(0xffffffff),
                        minWidth: displayWidth(context) * .75,
                        onPressed: (){
                          // Route route = MaterialPageRoute(builder: (context) => Registration());
                          // Navigator.push(context , route);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => Registration()));
                        },
                        child: Text("SIGN UP", 
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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