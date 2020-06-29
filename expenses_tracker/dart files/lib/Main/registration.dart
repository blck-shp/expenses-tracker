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

  @override
  void dispose(){
    super.dispose();
  }

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
    return GestureDetector(
      onTap: (){
        FocusScopeNode focus = FocusScope.of(context);

        if(!focus.hasPrimaryFocus){
          focus.unfocus();
        }
      },
      child: Scaffold(
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
                            color: Color(0xff009688),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextInputDecoration(controller: _controller1, name: 'Name', obscureText: false,),
                      ),
                      Expanded(
                        child: TextInputDecoration(controller: _controller2, name: 'Email', obscureText: false,),
                      ),
                      Expanded(
                        child: TextInputDecoration(controller: _controller3, name: 'Password', obscureText: true,),
                      ),
                      Expanded(
                        child: TextInputDecoration(controller: _controller4, name: 'Confirm Password', obscureText: true,),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: Container(),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 15.0 , bottom: 15.0),
                        child: MaterialButton(
                          color: Color(0xffffffff),
                          minWidth: displayWidth(context) * .75,
                          onPressed: () async{
                            String hash = 'hehehe';
                            bool validEmail = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_controller2.text);

                            if(_controller1.text == '' || _controller2.text == '' || _controller3.text == '' || _controller4.text == ''){
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ErrorMessage(header: "Error" , text: "Please complete the form before proceeding."), 
                                  );
                                });         
                            }else if(_controller3.text != _controller4.text){
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (context) => ErrorMessage(header: "Error" , text: "Passwords don't match. Please try again."),
                                );
                              });          
                            }else if(validEmail != true){
                              showDialog(
                                context: context,
                                builder: (context) => ErrorMessage(header: "Error" , text: "Invalid email address. Please try again."),
                              );
                            }else{
                              final hashValue = await createAccount(_controller1.text , _controller2.text , _controller3.text , hash);
                              if(hashValue != null){
                                setState(() {
                                  showDialog(
                                    context: context,
                                    builder: (context){
                                      Future.delayed(Duration(seconds: 3), (){
                                        Navigator.pushAndRemoveUntil(
                                          context, 
                                          MaterialPageRoute(builder: (context) => Dashboard(hash: hashValue,)), 
                                          (Route<dynamic> route) => false);
                                      });
                                      return ShowMessage(title: "Success" , content: "Successfullly registered! Processing account. Please wait for a moment.");
                                    }
                                  );
                                });
                              }
                            }
                          },
                          child: Text("SIGN UP",
                            style: TextStyle(fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
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
            ],
          ),
        ),
      ),
    );
  }
}