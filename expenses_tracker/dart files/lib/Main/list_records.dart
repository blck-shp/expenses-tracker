import 'dart:convert';
import 'dart:io';

import 'package:expenses_tracker/Extras/extras.dart';
// import 'package:expenses_tracker/Main/modify_record.dart';
// import 'package:expenses_tracker/Main/records.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';
import 'modify_record.dart';
import 'onboarding.dart';


class ListRecords extends StatefulWidget{
  final String hash;
  ListRecords({this.hash});

  @override
  _ListRecords createState() => _ListRecords(hash: hash);
}

class _ListRecords extends State<ListRecords>{

  final String hash;
  _ListRecords({this.hash});

    List<String> icons = [
    "/images/ic_food_drinks.png",
    "/images/ic_groceries.png",
    "/images/ic_clothes.png",
    "/images/ic_electronics.png",
    "/images/ic_healthcare.png",
    "/images/ic_gifts.png",
    "/images/ic_transportation.png",
     "/images/ic_education.png",
     "/images/ic_entertainment.png",
     "/images/ic_utilities.png",
     "/images/ic_rent.png",
     "/images/ic_household.png",
     "/images/ic_investments.png",
     "/images/ic_other.png",
  ];


  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Records"),
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.delete)
          ),
          IconButton(
            onPressed: (){

            },
            icon: Icon(Icons.search),
          ),
        ],
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
                      child: IconLink(text: "HOME" , icon: Icon(Icons.add , color: Color(0xffffffff)) , fontSize: 16.0, fontWeight: FontWeight.bold, fontColor: Color(0xffffffff), nextPage: Dashboard(hash: hash,)),
                    ),
                    Expanded(
                      child: IconLink(text: "RECORDS" , icon: Icon(Icons.add , color: Color(0xffffffff)) , fontSize: 16.0, fontWeight: FontWeight.bold, fontColor: Color(0xffffffff), nextPage: ListRecords(hash: hash,)),
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
      floatingActionButton: FloatingButton(nextPage: ModifyRecord(isEmpty: true, hash: hash,),),
      body: FutureBuilder<ListRecordsCategory>(
        future: getListRecords(hash),
        builder: (context , snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(child: Text("Error"));
            }

            return ListView.separated(
              addAutomaticKeepAlives: true,

              itemBuilder: (_, index){
                String date = snapshot.data.records[index].date;
                String dateWithT = date.substring(0, 10);
                return Dismissible(
                  // key: ValueKey(snapshot.data.categories[index].id),
                  key: ValueKey(snapshot.data.records[index].id),
                  direction: DismissDirection.startToEnd,
                  onDismissed: (direction){

                  },
                  confirmDismiss: (direction) async{
                    final result = await showDialog(
                      context: context,
                      builder: (_) => DeleteRecord(),
                      
                    );
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 10.0),
                    child: Align(child: Icon(Icons.delete, color: Color(0xffffffff)) , alignment: Alignment.centerLeft,)
                  ),
                  
                  child: ListTile(
                    leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${icons[index + 2]}')),
                    title: Text('P' + '${snapshot.data.records[index].amount}' + '0'),
                    subtitle: Text('${snapshot.data.records[index].category.name}' + ' — ' + '${snapshot.data.records[index].notes}'),
                    trailing: Text('$dateWithT', style: TextStyle(fontSize: 12.0,),),

                    

                    // onTap: (){
                    //   Navigator.pop(context, ['${snapshot.data.categories[index].name}' , snapshot.data.categories[index].id]);
                    // },
                    onLongPress: (){
                      
                      showDialog(
                        context: context,
                        builder: (_) => DeleteRecord(),
                      );
                    },
                  ),
                );
              }, 
              separatorBuilder: (_, __) => Divider(height: 0),
              itemCount: snapshot.data.pagination.count <= snapshot.data.pagination.perPage ? snapshot.data.records.length + 1: snapshot.data.records.length,
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

Future<ListRecordsCategory> getListRecords(String hash) async{
  final response = await http.get('http://expenses.koda.ws/api/v1/records',
    headers: {
      HttpHeaders.authorizationHeader: hash,
    },
  );

  print('The status code is ${response.statusCode}');
  return postFromJsonRecords(response.body);
}

ListRecordsCategory postFromJsonRecords(String str){
  final jsonData = json.decode(str);
  var value = ListRecordsCategory.fromJson(jsonData);
  print('The value is $value');
  return value;
}


class ListPagination{
  final String currentUrl;
  final String nextUrl;
  final String previousUrl;
  final int current;
  final int perPage;
  final int pages;
  final int count;

  ListPagination({this.currentUrl , this.nextUrl , this.previousUrl , this.current , this.perPage , this.pages , this.count});

  factory ListPagination.fromJson(Map<String , dynamic> parsedJson){
    print('The value of parsedJson in Pagiation is $parsedJson');
    return ListPagination(
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

class ListRecordsCategory{
  final List<RecordsName> records;
  final Pagination pagination;

  ListRecordsCategory({this.records , this.pagination});

  factory ListRecordsCategory.fromJson(Map<String , dynamic> parsedJson){

    var value1 = parsedJson['pagination'];
    Pagination parsedPagination = Pagination.fromJson(value1);
    
    var value2 = parsedJson['records'] as List;
    print('The value of value2 is ${value2.length}');

    List<RecordsName> listRecords = value2.map((e) => RecordsName.fromJson(e)).toList();

    return ListRecordsCategory(
      records: listRecords,
      pagination: parsedPagination,
    );
  }
}

class ListRecordsName{
  final int id;
  final String date;
  final String notes;
  final Category category;
  final double amount;
  final int recordType;

  ListRecordsName({this.id , this.date , this.notes , this.category , this.amount , this.recordType});

  factory ListRecordsName.fromJson(Map<String , dynamic> parsedJson){
    var list = parsedJson['category'];
    print('The value of list is $list');
    print('The value of parsedJson in Records is $parsedJson');

    Category objectCategory = Category.fromJson(list);
    print('The objectCategory is ${objectCategory.name}');

    return ListRecordsName(
      id: parsedJson['id'],
      date: parsedJson['date'],
      notes: parsedJson['notes'],
      category: objectCategory,
      amount: parsedJson['amount'],
      recordType: parsedJson['record_type'],
    );
  }
}

class ListCategory{
  final int id;
  final String name;

  ListCategory({this.id , this.name});

  factory ListCategory.fromJson(Map<String , dynamic> parsedJson){
    print('The value of parsedJson is $parsedJson');
    return ListCategory(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}


