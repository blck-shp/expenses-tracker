import 'dart:convert';
import 'dart:io';

import 'package:expenses_tracker/Extras/extras.dart';
import 'package:expenses_tracker/Main/modify_record.dart';
import 'package:expenses_tracker/Main/records.dart';
import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'package:http/http.dart' as http;


class Dashboard extends StatefulWidget{
  final String hash;


  Dashboard({this.hash});

  @override
  _Dashboard createState() => _Dashboard(hash: hash);
}

class _Dashboard extends State<Dashboard>{

  final String hash;

  _Dashboard({this.hash});

  
  @override
  Widget build(BuildContext context){
    print('The value of hash is $hash');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Container(
          color: Color(0xff246c55),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: IconLink(text: "HOME" , icon: Icon(Icons.add , color: Color(0xffffffff)) , fontSize: 16.0, fontWeight: FontWeight.bold, fontColor: Color(0xffffffff), nextPage: Dashboard()),
                    ),
                    Expanded(
                      child: IconLink(text: "RECORDS" , icon: Icon(Icons.add , color: Color(0xffffffff)) , fontSize: 16.0, fontWeight: FontWeight.bold, fontColor: Color(0xffffffff), nextPage: Records()),
                    ),
                    Expanded(
                      child: IconLink(text: "LOGOUT" , icon: Icon(Icons.add , color: Color(0xffffffff)) , fontSize: 16.0, fontWeight: FontWeight.bold, fontColor: Color(0xffffffff), nextPage: Onboarding()),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingButton(nextPage: ModifyRecord(isEmpty: true,),),
      // body: Center(
      //   child: Text('$_recordsCategory'),
      // ),

      body: FutureBuilder<RecordsCategory>(
        future: getRecords(hash),
        builder: (context , snapshot){
              print('The snapshot is ${snapshot.data}');
              if(snapshot.hasData){
                if(snapshot.data.pagination.count == 0){
                  return EmptyDashboard();
                }else{
                  return Center(child: Text('Category Name: ${snapshot.data.records[0].category.name}'));
                }
              }else if(snapshot.hasError){
                return Center(child: Text("Error"));
              }
              if(snapshot == null){
                return Center(child: Text('Null'),);
              }
              return Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}

class EmptyDashboard extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: Center(child: Image.asset('assets/images/empty_icon.png'),)
                  // child: Center(child: Text('$hash'),),
                ),
                Expanded(
                  child: Center(child: Text("There are no records here yet.", style: TextStyle(fontSize: 16.0 , color: Color(0xff555555)),),),
                ),
              ],
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
                    child: ButtonFilled(width: .75 , height: 0, fontSize: 20.0, text: "START TRACKING", backgroundColor: Colors.white, fontWeight: FontWeight.bold, nextPage: ModifyRecord(isEmpty: true,),),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}

Future<Overview> getOverview() async{
  final response = await http.get(
    'http://expenses.koda.ws/api/v1/records/overview',
    headers: {
      HttpHeaders.authorizationHeader: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNX0.DOueXZ9-xQcdSz294L21oe4ZLOkOty9Au_FxniFMD64',
      // HttpHeaders.authorizationHeader: hash,
    },
  );

  print('The status is ${response.statusCode}');
  return postFromJsonOverView(response.body);
}

Overview postFromJsonOverView(String str){
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


Future<RecordsCategory> getRecords(String hash) async{
  final response = await http.get('http://expenses.koda.ws/api/v1/records',
    headers: {
      // HttpHeaders.authorizationHeader: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxNX0.DOueXZ9-xQcdSz294L21oe4ZLOkOty9Au_FxniFMD64',
      HttpHeaders.authorizationHeader: hash,
    },
  );

  print('The status code is ${response.statusCode}');
  return postFromJsonRecords(response.body);
}

RecordsCategory postFromJsonRecords(String str){
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
  final List<RecordsName> records;
  final Pagination pagination;

  RecordsCategory({this.records , this.pagination});

  factory RecordsCategory.fromJson(Map<String , dynamic> parsedJson){

    var value1 = parsedJson['pagination'];
    Pagination parsedPagination = Pagination.fromJson(value1);
    
    var value2 = parsedJson['records'] as List;
    print('The value of value2 is ${value2.length}');

    List<RecordsName> listRecords = value2.map((e) => RecordsName.fromJson(e)).toList();

    return RecordsCategory(
      records: listRecords,
      pagination: parsedPagination,
    );
  }
}

class RecordsName{
  final int id;
  final String date;
  final String notes;
  final Category category;
  final double amount;
  final int recordType;

  RecordsName({this.id , this.date , this.notes , this.category , this.amount , this.recordType});

  factory RecordsName.fromJson(Map<String , dynamic> parsedJson){
    var list = parsedJson['category'];
    print('The value of list is $list');
    print('The value of parsedJson in Records is $parsedJson');

    Category objectCategory = Category.fromJson(list);
    print('The objectCategory is ${objectCategory.name}');

    return RecordsName(
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
