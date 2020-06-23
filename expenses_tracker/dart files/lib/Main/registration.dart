import 'package:expenses_tracker/Extras/sizes.dart';
import 'package:flutter/material.dart';
import 'package:expenses_tracker/Extras/extras.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dashboard.dart';

class Registration extends StatefulWidget{
  @override
  _Registration createState() => _Registration();
}

class _Registration extends State<Registration>{

  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();

  List numbers = [];

  Future<String> createAccount(String name , String email,  String password, String hash) async{
  final http.Response response = await http.post('http://expenses.koda.ws/api/v1/sign_up',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $hash',
    },
    body: jsonEncode(<String , String>{
      'name': name,
      'email': email,
      'password': password
    }),
  );

  String value;

  dynamic fromJsonMessage(Map<String, dynamic> json){
    String hashValue = json['token'];

    if(hashValue != null){
      setState(() {
        showDialog(
          context: context,
          builder: (context){
            Future.delayed(Duration(seconds: 3), (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => Dashboard(hash: hashValue,)));
            });
            return ShowMessage(title: "Success" , content: "Successfullly registered! Processing account.");
          }
        );
      });
    }

    return hashValue;
  }

  if(response.statusCode == 200){
    value = fromJsonMessage(json.decode(response.body));
  }else if(response.statusCode == 400){
    showDialog(
      context: context,
      builder: (_) => ErrorMessage(header: "Error" , text: "Email address has already been taken. Please try again."),                        
    );     
  }else{
    throw Exception('Failed to register');
  }
  return value;
}

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Color(0xffd8fcff),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
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
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Color(0xff555555),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _controller2,
                        keyboardType: TextInputType.emailAddress,
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
                        controller: _controller3,
                        obscureText: true,
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
                      child: TextFormField(
                        controller: _controller4,
                        obscureText: true,
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
                          labelText: "Confirm Password",
                          labelStyle: TextStyle(
                            color: Color(0xff555555),
                          ),
                        ),
                      ),
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
                        onPressed: () async{
                          setState(() {
                            String hash = 'Heheheh';
                            createAccount(_controller1.text , _controller2.text , _controller3.text , hash);
                          });
                        },
                        child: Text("Register",
                          style: TextStyle(fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
        ),
      ),
    );
  }
}