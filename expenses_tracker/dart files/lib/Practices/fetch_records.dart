import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'dart:io';


// DASHBOARD RECORDS
void main(){
  runApp(FetchRecords());
}

class FetchRecords extends StatefulWidget{
  @override
  _FetchRecords createState() => _FetchRecords();
}

class _FetchRecords extends State<FetchRecords>{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<RecordsCategory>(
          future: getRecords(),
            builder: (context , snapshot){
              if(snapshot.hasData){
                if(snapshot.data.pagination.count == 2){
                  return Center(child: Text('Hehehe'));
                }
              }else if(snapshot.hasError){
                return Center(child: Text("Error"));
              }
              if(snapshot == null){
                return Center(child: Text('Null'),);
              }
              return Center(child: CircularProgressIndicator());
            },
        ),
      ),
    );
  }
}

// eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyN30.rMWXUi0fmLGmgB7BubGnSBBNfRHQMn0Se9ZmhQeJC8g
// eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNX0.DOueXZ9-xQcdSz294L21oe4ZLOkOty9Au_FxniFMD64

Future<RecordsCategory> getRecords() async{
  final response = await http.get('http://expenses.koda.ws/api/v1/records',
    headers: {
      HttpHeaders.authorizationHeader: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNX0.DOueXZ9-xQcdSz294L21oe4ZLOkOty9Au_FxniFMD64',
    },
  );

  print('The status code is ${response.statusCode}');
  return postFromJson(response.body);
}

RecordsCategory postFromJson(String str){
  final jsonData = json.decode(str);
  var value = RecordsCategory.fromJson(jsonData);
  print('The value is $value');
  return value;
}


class Pagination{
  final String currentUrl;
  final String nextUrl;
  final String previousUrl;
  final int current;
  final int perPage;
  final int pages;
  final int count;

  Pagination({this.currentUrl , this.nextUrl , this.previousUrl , this.current , this.perPage , this.pages , this.count});

  factory Pagination.fromJson(Map<String , dynamic> parsedJson){
    print('The value of parsedJson in Pagiation is $parsedJson');
    return Pagination(
      currentUrl: parsedJson['current_url'],
      nextUrl: parsedJson['next_url'],
      previousUrl: parsedJson['previous_url'],
      current: parsedJson['current'],
      perPage: parsedJson['per_page'],
      pages: parsedJson['pages'],
      count: parsedJson['count'],
    );
  }
}

class RecordsCategory{
  final List<Records> records;
  final Pagination pagination;

  RecordsCategory({this.records , this.pagination});

  factory RecordsCategory.fromJson(Map<String , dynamic> parsedJson){

    var value1 = parsedJson['pagination'];
    Pagination parsedPagination = Pagination.fromJson(value1);
    
    var value2 = parsedJson['records'] as List;
    print('The value of value2 is ${value2.length}');

    List<Records> listRecords = value2.map((e) => Records.fromJson(e)).toList();

    return RecordsCategory(
      records: listRecords,
      pagination: parsedPagination,
    );
  }
}

class Records{
  final int id;
  final String date;
  final String notes;
  final Category category;
  final double amount;
  final int recordType;

  Records({this.id , this.date , this.notes , this.category , this.amount , this.recordType});

  factory Records.fromJson(Map<String , dynamic> parsedJson){
    var list = parsedJson['category'];
    print('The value of list is $list');
    print('The value of parsedJson in Records is $parsedJson');

    Category objectCategory = Category.fromJson(list);
    print('The objectCategory is ${objectCategory.name}');

    return Records(
      id: parsedJson['id'],
      date: parsedJson['date'],
      notes: parsedJson['notes'],
      category: objectCategory,
      amount: parsedJson['amount'],
      recordType: parsedJson['record_type'],
    );
  }
}

class Category{
  final int id;
  final String name;

  Category({this.id , this.name});

  factory Category.fromJson(Map<String , dynamic> parsedJson){
    print('The value of parsedJson is $parsedJson');
    return Category(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}
