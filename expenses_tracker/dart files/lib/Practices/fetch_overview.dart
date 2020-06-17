import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
void main() => runApp(AccountFetch());

// OVERVIEW

class Charts{
  final double income;
  final double expenses;

  Charts({this.income , this.expenses});
}

// Charts charts = new Charts();

class AccountFetch extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<Overview>(
          future: getRecord(),
          builder: (context , snapshot){
            // print('The value is ${snapshot.data.expenses}');
            if(snapshot.hasData){
              // return Center(child: Text('${snapshot.data.income}'),);
              return Center(
                child: Container(
                  height: 200.0,
                  width: 200.0,
                  color: Colors.grey,
                  
                ),
              );
            }else if(snapshot.hasError){
              return Center(child: Text("Error"));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

Future<Overview> getRecord() async{
  final response = await http.get(
    'http://expenses.koda.ws/api/v1/records/overview',
    headers: {
      HttpHeaders.authorizationHeader: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNX0.DOueXZ9-xQcdSz294L21oe4ZLOkOty9Au_FxniFMD64',
    },
  );

  print('The status is ${response.statusCode}');
  return postFromJson(response.body);
}

Overview postFromJson(String str){
  print('The string is $str');
  final jsonData = json.decode(str);
  print('The jsonData is $jsonData');
  var value = Overview.fromJson(jsonData);
  print('The value is $value');
  return value;
}

class Overview{
  final double income;
  final double expenses;

  Overview({this.income , this.expenses});

  factory Overview.fromJson(Map<String , dynamic> parsedJson){
    return Overview(
      income: parsedJson['income'],
      expenses: parsedJson['expenses'],
    );
  }
}
