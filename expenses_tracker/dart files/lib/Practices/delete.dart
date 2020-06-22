import 'package:flutter/material.dart';
// import 'dart:convert';
import 'package:http/http.dart' as http;

void main(){
  runApp(
    MaterialApp(
      home: DeleteRecord(),
    ),
  );
}

class DeleteRecord extends StatefulWidget{
  @override
  _DeleteRecord createState() => _DeleteRecord();
}

class _DeleteRecord extends State<DeleteRecord>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.blue,
      body: FutureBuilder<String>(
        future: deleteRecord(),
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

Future<String> deleteRecord() async{
  final http.Response response = await http.delete('http://expenses.koda.ws/api/v1/records/190',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0NH0._wrHD2srsj-6uDQofWsCnnee7mFzh9N8LO5e4EhiOmI',
    },
  );

  print('The status code is ${response.statusCode}');


  if(response.statusCode == 200){
    return 'Success';
  }else{
    throw Exception('Failed to update');
  }

}