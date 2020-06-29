import 'package:expenses_tracker/Extras/extras.dart';
import 'package:expenses_tracker/Extras/sizes.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dashboard.dart';

class Login extends StatefulWidget{

  @override
  _Login createState() => _Login();
}

class _Login extends State<Login>{

  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose(){
    super.dispose();
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
                        flex: 2,
                        child: Form(
                        key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: TextInputDecoration(controller: _controller1, name: 'Email', obscureText: false,),
                              ),
                              Expanded(
                                child: TextInputDecoration(controller: _controller2, name: 'Password', obscureText: true),
                              ),
                            ],
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
                        margin: EdgeInsets.only(top: 15.0 , bottom: 15.0),
                        child: MaterialButton(
                          color: Color(0xffffffff),
                          minWidth: displayWidth(context) * .75,
                          onPressed: () async {
                            if(_controller1.text == '' || _controller2.text == ''){
                              setState(() {
                                showDialog(
                                  context: context,
                                  builder: (_) => ErrorMessage(header: "Error" , text: "Please complete the credentials before signing in."),   
                                );
                              });
                            }else{
                              final token = await loginAccount(_controller1.text , _controller2.text);
                              if(token != null){
                                Navigator.pushAndRemoveUntil(context, 
                                  MaterialPageRoute(builder: (context) => Dashboard(hash: token,)), 
                                  (Route<dynamic> route) => false);
                              }
                            }
                            return Center(child: CircularProgressIndicator());
                          },
                          child: Text("LOGIN", 
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Nunito'
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
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

  Future<String> loginAccount(String email, String password) async{
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

    String parseLoginAccount(Map<String , dynamic> parsedJson){
      String token = parsedJson['token'];
      return token;
    }

    if(response.statusCode == 200){
      String token = parseLoginAccount(json.decode(response.body));
      return token;
    }else{
      setState(() {
        showDialog(
          context: context,
          builder: (_) => ErrorMessage(header: "Error" , text: "Incorrect email or password. Please try again."),   
        );
      });
      throw Exception('Failed to login');
    }
  }
}