import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

// LOGIN

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
  String email;
  String password;
  String message;

  Account({this.email , this.password , this.message});

  factory Account.fromJson(Map<String, dynamic> json){
    return Account(
      email: json['email'],
      password: json['password'],
      message: json['message'],
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

  Account account;

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
                    hintText: 'Email: '
                  ),
                ),
                TextField(
                  controller: _controller2,
                  decoration: InputDecoration(
                    hintText: 'Password: '
                  ),
                ),
                RaisedButton(
                  child: Text("Login"),
                  onPressed: (){
                    setState(() {
                      _futureAccount = createAccount(_controller1.text , _controller2.text);
                    });
                  },
                ),
              ],
            )
            : FutureBuilder<Account>(
              future: _futureAccount,
              builder: (context , snapshot){
                if(snapshot.hasData){
                  return Text('${snapshot.data.message}');
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

// =======================================================


// Future<http.Response> createAccount(String email , String password) async{
//   final http.Response response = await http.post('http://expenses.koda.ws/api/v1/sign_in',
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Accept': 'application/json',
//     },
//     body: jsonEncode(<String , String>{
//       'email': email,
//       'password': password
//     }),
//   );

//   print('The email is $email');
//   print('The password is $password');

//   print('The status code is ${response.statusCode}');

  

//   if(response.statusCode == 200){
//     var str =  json.decode(response.body);
//     var message = str['message'];
//     // print('The message is $message');
//     return message;
//     // return Account.fromJson(json.decode(response.body));
//   }else{
//     throw Exception('Failed to login');
//   }
// }

// // class Account{
// //   String email;
// //   String password;
// //   String message;

// //   Account({this.email , this.password , this.message});

// //   factory Account.fromJson(Map<String, dynamic> json){
// //     return Account(
// //       email: json['email'],
// //       password: json['password'],
// //       message: json['message'],
// //     );
// //   }
// // }

// void main() => runApp(Post());

// class Post extends StatefulWidget{
//   @override
//   _Post createState() => _Post();
// }

// class _Post extends State<Post>{
//   final TextEditingController _controller1 = TextEditingController();
//   final TextEditingController _controller2 = TextEditingController();

//   // Account account;

//   // Future<Account> _futureAccount;
//   Future<http.Response> _futureAccount;
//   // var message;

//   @override

//   Widget build(BuildContext context){
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Post"),
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8.0),
//           child: (_futureAccount == null)
//             ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 TextField(
//                   controller: _controller1,
//                   decoration: InputDecoration(
//                     hintText: 'Email: '
//                   ),
//                 ),
//                 TextField(
//                   controller: _controller2,
//                   decoration: InputDecoration(
//                     hintText: 'Password: '
//                   ),
//                 ),
//                 RaisedButton(
//                   child: Text("Login"),
//                   onPressed: (){
//                     setState(() {
//                       _futureAccount = createAccount(_controller1.text , _controller2.text);
//                       // message = _futureAccount;
//                       // print('The message is ${message as String}');
//                     });
//                   },
//                 ),
//               ],
//             )
//             // : 
//             : FutureBuilder<http.Response>(
//               future: _futureAccount,
//               builder: (context , snapshot){
//                 if(snapshot.hasData){
//                   // return Text('$message');
//                   // return Text('${snapshot.data.reasonPhrase}');
//                   // var message = _futureAccount;
//                   // String _message = message.toString();
//                   return Text('${snapshot.data.request.toString()}');
//                 }else if(snapshot.hasError){
//                   return Text('${snapshot.error}');
//                 }
//                 return CircularProgressIndicator();
//               },
//             ),
//         ),
//       ),
//     );
//   }
// }