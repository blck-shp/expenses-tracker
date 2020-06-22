import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main(){
  runApp(
    MaterialApp(
      home: UpdateRecord(),
    ),
  );
}

class UpdateRecord extends StatefulWidget{
  @override
  _UpdateRecord createState() => _UpdateRecord();
}

class _UpdateRecord extends State<UpdateRecord>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue,
      body: FutureBuilder<String>(
        future: updateRecord(),
        builder: (context , snapshot){
          if(snapshot.hasData){
            return Center(child: Text('${snapshot.data}'));
          }else if(snapshot.hasError){
            return Center(child: Text('Error'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// double amount, String notes, String date, String time, int recordType, int categoryId

Future<String> updateRecord() async{
  final http.Response response = await http.patch('http://expenses.koda.ws/api/v1/records/200',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0NH0._wrHD2srsj-6uDQofWsCnnee7mFzh9N8LO5e4EhiOmI',
    },
    body: jsonEncode(<String, dynamic>{
      'record': {
        'amount': 200.00,
        'notes': 'Newly updated notes',
        'record_type': 0,
        'date': '2020-06-22T00:00:00.000Z',
        'category_id': 2
      },
    }),
  );

  print('The status code is ${response.statusCode}');


  if(response.statusCode == 200){
    return 'Success';
  }else{
    throw Exception('Failed to update');
  }

}