import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      home: SearchApp(),
    ),
  );
}

class SearchApp extends StatefulWidget{

  @override
  _SearchApp createState() => _SearchApp();
}

class _SearchApp extends State<SearchApp>{

  bool _searching = false;
  TextEditingController _controller = new TextEditingController();
  
  String searchValue = '';

  @override
  Widget build(BuildContext context){
    _controller.text = 'Hehehehe';
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        centerTitle: true,
        title: _searching == true 
        ? TextFormField(
          controller: _controller,
          onFieldSubmitted: (value){
            print('The value of value is $value');
            
            setState(() {
              searchValue = value;  
            });
          },
          decoration: InputDecoration(
            prefixIcon: IconButton(
              onPressed: (){},
              icon: Icon(Icons.search, color: Color(0xffffffff)),
            ),
            hintText: "Search...",
            
            
          ),
          
        )
        : Text('Records'),
        actions: <Widget>[
          _searching == false
          ? IconButton(
            onPressed: (){
              setState(() {
                print('The value of searchValue is $searchValue');
                _searching = true;
              });
            },
            icon: Icon(Icons.search),
          )
          : IconButton(
            onPressed: (){
              setState(() {
                // _controller.text = '';
                searchValue = '';
                _searching = false;
              });
            },
            icon: Icon(Icons.clear),
          ),
          
        ],
      ),
      body: searchValue == ''
      ? Container()
      : FutureBuilder<SearchRecordsCategory>(
        future: searchRecords(searchValue),
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Center(child: Text('${snapshot.data.records.map((e) => e.notes)}'));
          }else if(snapshot.hasError){
            return Center(child: Text('Failed'));
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
    );
  }
}


Future<SearchRecordsCategory> searchRecords(String search) async{
  final response = await http.get('http://expenses.koda.ws/api/v1/records?q=$search',
    headers: {
      HttpHeaders.authorizationHeader: 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjo0NH0._wrHD2srsj-6uDQofWsCnnee7mFzh9N8LO5e4EhiOmI',
    },
  );

  print('The status code is ${response.statusCode}');
  return postFromJsonRecords(response.body);
}

SearchRecordsCategory postFromJsonRecords(String str){
  final jsonData = json.decode(str);
  var value = SearchRecordsCategory.fromJson(jsonData);
  print('The value is $value');
  return value;
}


class SearchPagination{
  final String currentUrl;
  final String nextUrl;
  final String previousUrl;
  final int current;
  final int perPage;
  final int pages;
  final int count;

  SearchPagination({this.currentUrl , this.nextUrl , this.previousUrl , this.current , this.perPage , this.pages , this.count});

  factory SearchPagination.fromJson(Map<String , dynamic> parsedJson){
    print('The value of parsedJson in Pagiation is $parsedJson');
    return SearchPagination(
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

class SearchRecordsCategory{
  final List<SearchRecordsName> records;
  final SearchPagination pagination;

  SearchRecordsCategory({this.records , this.pagination});

  factory SearchRecordsCategory.fromJson(Map<String , dynamic> parsedJson){

    var value1 = parsedJson['pagination'];
    SearchPagination parsedPagination = SearchPagination.fromJson(value1);
    
    var value2 = parsedJson['records'] as List;
    print('The value of value2 is ${value2.length}');

    List<SearchRecordsName> listRecords = value2.map((e) => SearchRecordsName.fromJson(e)).toList();

    return SearchRecordsCategory(
      records: listRecords,
      pagination: parsedPagination,
    );
  }
}

class SearchRecordsName{
  final int id;
  final String date;
  final String notes;
  final SearchCategory category;
  final double amount;
  final int recordType;

  SearchRecordsName({this.id , this.date , this.notes , this.category , this.amount , this.recordType});

  factory SearchRecordsName.fromJson(Map<String , dynamic> parsedJson){
    var list = parsedJson['category'];
    print('The value of list is $list');
    print('The value of parsedJson in Records is $parsedJson');

    SearchCategory objectCategory = SearchCategory.fromJson(list);
    print('The objectCategory is ${objectCategory.name}');

    return SearchRecordsName(
      id: parsedJson['id'],
      date: parsedJson['date'],
      notes: parsedJson['notes'],
      category: objectCategory,
      amount: parsedJson['amount'],
      recordType: parsedJson['record_type'],
    );
  }
}

class SearchCategory{
  final int id;
  final String name;

  SearchCategory({this.id , this.name});

  factory SearchCategory.fromJson(Map<String , dynamic> parsedJson){
    print('The value of parsedJson is $parsedJson');
    return SearchCategory(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}


