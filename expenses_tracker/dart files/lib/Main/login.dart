// import 'package:expenses_tracker/Extras/extras.dart';
import 'package:expenses_tracker/Extras/sizes.dart';
import 'package:expenses_tracker/Main/dashboard.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget{
  @override
  _Login createState() => _Login();
}

class _Login extends State<Login>{

  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  Account account;

  Future<Account> _futureAccount;

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xffd8fcff),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: (_futureAccount == null)
        ? Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios , color: Color(0xff006c55)),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),
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
              child: Container(
                padding: EdgeInsets.only(left: 50.0 , right: 50.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "WALLET",
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff90b4aa),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _controller1,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff555555),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff246c55),
                              width: 2.0,
                            ),                            
                          ),
                          focusColor: Color(0xff246c55),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff246c55),
                            ),                            
                          ),
                          labelText: "Email",
                          labelStyle: TextStyle(
                            color: Color(0xff555555),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _controller2,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff555555),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff246c55),
                              width: 2.0,
                            ),                            
                          ),
                          focusColor: Color(0xff246c55),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff246c55),
                            ),                            
                          ),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Color(0xff555555),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0 , bottom: 10.0),
                      child: MaterialButton(
                        color: Color(0xffffffff),
                        minWidth: displayWidth(context) * .75,
                        onPressed: (){
                          setState(() {
                            _futureAccount = createAccount(_controller1.text , _controller2.text);
                          });
                        },
                        child: Text("Login", 
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                      ),
                      // child: ButtonFilled(width: .75 , height: 0, fontSize: 20.0, text: "LOGIN" , backgroundColor: Color(0xffffffff), fontWeight: FontWeight.bold, nextPage: Dashboard()),
                    ),
                  ),
                  Expanded(
                    child: Container(
                    ),
                  ),
                ],
              ),
            ),
          ],
        ) 
        : FutureBuilder<Account>(
          future: _futureAccount,
          builder: (context , snapshot){
            if(snapshot.hasData){
              if(snapshot.data.message == 'Successfully signed in!'){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Dashboard(hash: snapshot.data.token)));
              }
            }else if(snapshot.hasError){
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => Login()));
              return Center(
                child: Text('${snapshot.error}'),
                
              );
              
              
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}



Future<Account> createAccount(String email , String password) async{
  final http.Response response = await http.post('http://expenses.koda.ws/api/v1/sign_in',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    },
    body: jsonEncode(<String , String>{
      'email': email,
      'password': password
    }),
  );

  print('The email is $email');
  print('The password is $password');

  print('The status code is ${response.statusCode}');

  if(response.statusCode == 200){
    return Account.fromJson(json.decode(response.body));
  }else{
    
    throw Exception('Failed to login');
  }
}

class Account{
  String message;
  String token;

  Account({this.message , this.token});

  factory Account.fromJson(Map<String, dynamic> json){
    return Account(
      message: json['message'],
      token: json['token']
    );
  }
}