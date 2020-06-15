import 'dart:async';
import 'package:expenses_tracker/Extras/extras.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';

Future<Account> createAccount(String name , String email,  String password, String hash) async{
  // String token = await Candidate().getToken();
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


// void main() => runApp(Post());
void main(){
  runApp(
    MaterialApp(
      home: Post(),
    ),
  );
}

class Post extends StatefulWidget{
  @override
  _Post createState() => _Post();
}

class _Post extends State<Post>{
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  Account account;

  Future<Account> _futureAccount;

  List numbers = [];

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
                    hintText: 'Confirm Password: '
                  ),
                ),
                RaisedButton(
                  child: Text("Register"),
                  onPressed: (){

                    setState(() {
                      if(_controller3.text == _controller4.text){

                          // setState(() {
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

                          // }); 

                      }else{
                        showDialog(
                          context: context,
                          builder: (_) => ErrorMessage(header: "Error" , text: "Passwords don't match. Please try again."),                        
                        );
                      }
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




// import 'package:flutter/material.dart';
// import 'dart:math';
// import 'dart:convert';
// import 'package:crypto/crypto.dart';

// void main(){
//   runApp(
//     Tokening(),
//   );
// }


// class Tokening extends StatefulWidget{
//   @override
//   _Tokening createState() => _Tokening();
// }

// class _Tokening extends State<Tokening>{
//   List numbers = [];

//   @override
//   Widget build(BuildContext context){
//     return MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: RaisedButton(
            
//             onPressed: (){
              
//               bool flag = false;
//               int number;
//               Random value = new Random();
//               number = value.nextInt(1000000);
              
//               for(var i = 0; i < numbers.length; i++){
//                 if(numbers[i] == number){
//                   flag = true;
//                 }
//               }

//               if(flag == false){
//                 print('The number is $number');

//                 numbers.add(number);

//                 var hash = generateMd5(number.toString());

//                 for(var i = 0; i < numbers.length; i++){
//                   print('The array of number is ${numbers[i]}');
//                 }

//                 setState(() {
//                   print('The hash is $hash');

//                 });
//               }

//             },
//           ),
          
//         ),
//       ),
//     );
//   }
// }


// String generateMd5(String input){
//   return md5.convert(utf8.encode(input)).toString();
// }

// _incrementCounter() async{
//   SharedPreferences prefs = await SharedPreferences.getInstance();

  
//   int counter = (prefs.getInt('counter') ?? 0) + 1;
//   print('Pressed $counter times.');
//   await prefs.setInt('counter' , counter);

//   // Save a value
//   prefs.setString('value_key' , 'hello preferences');

//   // Retrieve value
//   var savedValue = prefs.getString('value_key');
// }


