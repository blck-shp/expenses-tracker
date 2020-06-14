import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() => runApp(Fetch());

class Fetch extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder<CategoryList>(
          future: getList(),
          builder: (context , snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return Text("Error");
              }
              return Center(child: Text('${snapshot.data.categories.map((e) => e.icon).toList()}'));
            }else{
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

Future<CategoryList> getList() async{
  final response = await http.get('http://expenses.koda.ws/api/v1/categories');
  return postFromJson(response.body);
}

CategoryList postFromJson(String str){
  final jsonData = json.decode(str);
  var value = CategoryList.fromJson(jsonData);
  return value;
}

class CategoryList{
  final List<CategoryName> categories;

  CategoryList({this.categories});

  factory CategoryList.fromJson(Map<String , dynamic> parsedJson){
    var list = parsedJson['categories'] as List;
    List<CategoryName> categoryList = list.map((e) => CategoryName.fromJson(e)).toList();
    
    return CategoryList(
      categories: categoryList,
    );
  }
}

class CategoryName{
  final int id;
  final String name;
  final String icon;

  CategoryName({this.id , this.name , this.icon});

  factory CategoryName.fromJson(Map<String , dynamic> parsedJson){
    return CategoryName(
      id: parsedJson['id'],
      name: parsedJson['name'],
      icon: parsedJson['icon'],
    );
  }
}