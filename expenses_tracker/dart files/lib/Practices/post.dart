import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


      // 'Content-Type': 'application/x-www-form-urlencoded',
      // 'Accept': 'application/json; charset=UTF-8',
      // 'Content-Type': 'application/x-www-form-urlencoded',

      // 'name': account.name,
      // 'email': account.email,
      // 'password': account.password,


Future<Account> createAccount(Account account) async{
  final http.Response response = await http.post('http://expenses.koda.ws/api/v1/sign_up',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      
    },
    body: jsonEncode(<String , String>{
      'name': account.name,
      'email': account.email,
      'password': account.password
      // 'name': "Name",
      // 'email': "Email",
      // 'password': "Password",
    }),
  );

  print('The name is ${account.name}');
  print('The email is ${account.email}');
  print('The password is ${account.password}');

  print('The status code is ${response.statusCode}');

  if(response.statusCode == 201){
    return Account.fromJson(json.decode(response.body));
  }else{
    throw Exception('Failed to create account');
  }
}

class Account{
  String name;
  String email;
  String password;

  Account({this.name , this.email , this.password});

  factory Account.fromJson(Map<String, dynamic> json){
    return Account(
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
}


void main() => runApp(Post());

class Post extends StatefulWidget{
  @override
  _Post createState() => _Post();
}

class _Post extends State<Post>{
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  // Account account;

  Future<Account> _futureAccount;

  @override

  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Post"),
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (_futureAccount == null)
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _controller1,
                  decoration: InputDecoration(
                    hintText: 'Name: '
                  ),
                ),
                TextField(
                  controller: _controller2,
                  decoration: InputDecoration(
                    hintText: 'Email: '
                  ),
                ),
                TextField(
                  controller: _controller3,
                  decoration: InputDecoration(
                    hintText: 'Password: '
                  ),
                ),
                TextField(
                  controller: _controller4,
                  decoration: InputDecoration(
                    hintText: 'Confirm password: '
                  ),
                ),
                RaisedButton(
                  child: Text("Create Data"),
                  onPressed: (){
                    
                    Account account = new Account(name: _controller1.text , email: _controller2.text , password: _controller3.text);

                    setState(() {
                      _futureAccount = createAccount(account);
                    });
                  },
                ),
              ],
            )
            : FutureBuilder<Account>(
              future: _futureAccount,
              builder: (context , snapshot){
                if(snapshot.hasData){
                  return Text(snapshot.data.name);
                }else if(snapshot.hasError){
                  return Text('${snapshot.error}');
                }
                return CircularProgressIndicator();
              },
            ),
        ),
      ),
    );
  }
}