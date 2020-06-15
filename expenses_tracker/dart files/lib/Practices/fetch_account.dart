import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
void main() => runApp(AccountFetch());

class AccountFetch extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<Account>(
          future: getAccount(),
          builder: (context , snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Text("Error");
              }
              return Center(child: Text('${snapshot.data.email}'),);
            }else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

Future<Account> getAccount() async{
  final response = await http.get('http://expenses.koda.ws/api/v1/sign_in');
  return postFromJson(response.body);
}

Account postFromJson(String str){
  final jsonData = json.decode(str);
  var value = Account.fromJson(jsonData);
  return value;
}

class Account{
  final String email;
  final String password;

  Account({this.email , this.password});

  factory Account.fromJson(Map<String , String> parsedJson){
    return Account(
      email: parsedJson['email'],
      password: parsedJson['password'],
    );
  }
}
