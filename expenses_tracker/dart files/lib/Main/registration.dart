import 'package:flutter/material.dart';
import 'package:expenses_tracker/Extras/extras.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

Future<Account> createAccount(String name , String email,  String password, String hash) async{
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

  Account({this.message});

  factory Account.fromJson(Map<String, dynamic> json){
    return Account(
      message: json['message'],
    );
  }
}


String generateMd5(String input){
  return md5.convert(utf8.encode(input)).toString();
}

class Registration extends StatefulWidget{
  @override
  _Registration createState() => _Registration();
}

class _Registration extends State<Registration>{

  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();

  Future<Account> _futureAccount;
  List numbers = [];

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
                      // child: ButtonFilled(width: .75 , height: 0, fontSize: 20.0, text: "SIGN UP" , backgroundColor: Color(0xffffffff), fontWeight: FontWeight.bold, nextPage: Registration(), check: false),
                      child: RaisedButton(
                        onPressed: (){
                          setState(() {
                              if(_controller3.text == _controller4.text){

                                    bool flag = false;
                                    int number;
                                    Random value = new Random();
                                    number = value.nextInt(1000000);

                                    for(var i = 0; i < numbers.length; i++){
                                      if(numbers[i] == number){
                                        flag = true;
                                      }
                                    }

                                    if(flag == false){
                                      print('The number is $number');

                                      numbers.add(number);

                                      var hash = generateMd5(number.toString());

                                      for(var i = 0; i < numbers.length; i++){
                                        print('The array of number is ${numbers[i]}');
                                      }

                                      _futureAccount = createAccount(_controller1.text , _controller2.text , _controller3.text , hash);
                                    }

                              }else{
                                showDialog(
                                  context: context,
                                  builder: (_) => ErrorMessage(header: "Error" , text: "Passwords don't match. Please try again."),                        
                                );
                              }
                          });
                        },
                        child: Text("Login"),
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
        )
        : FutureBuilder<Account>(
              future: _futureAccount,
              builder: (context , snapshot){
                if(snapshot.hasData){
                  return Center(child: Text('${snapshot.data.message}'));
                }else if(snapshot.hasError){
                  return Center(child: Text('${snapshot.error}'));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
      ),
    );
  }
}