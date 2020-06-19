import 'dart:convert';

import 'package:expenses_tracker/Extras/extras.dart';
// import 'package:expenses_tracker/Main/modify_record.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dashboard.dart';
import 'onboarding.dart';


class Records extends StatefulWidget{
  final String hash;
  Records({this.hash});

  @override
  _Records createState() => _Records(hash: hash);
}

class _Records extends State<Records>{

  final String hash;
  _Records({this.hash});


  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Records"),
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
        // actions: <Widget>[
        //   IconButton(
        //     onPressed: (){

        //     },
        //     icon: Icon(Icons.delete)
        //   ),
        //   IconButton(
        //     onPressed: (){

        //     },
        //     icon: Icon(Icons.search),
        //   ),
        // ],
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
                      child: IconLink(text: "RECORDS" , icon: Icon(Icons.add , color: Color(0xffffffff)) , fontSize: 16.0, fontWeight: FontWeight.bold, fontColor: Color(0xffffffff), nextPage: Records(hash: hash,)),
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
      // floatingActionButton: FloatingButton(nextPage: ModifyRecord(),),
      body: FutureBuilder<CategoryList>(
        future: getList(),
        builder: (context , snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(child: Text("Error"));
            }

            return ListView.separated(
              itemBuilder: (_, index){
                return Dismissible(
                  key: ValueKey(snapshot.data.categories[index].id),
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
                    leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${snapshot.data.categories[index].icon}')),
                    title: Text(snapshot.data.categories[index].name),
                    // subtitle: Text(snapshot.data.categories[index].icon),

                    onTap: (){
                      Navigator.pop(context, ['${snapshot.data.categories[index].name}' , snapshot.data.categories[index].id]);
                    },
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
              itemCount: snapshot.data.categories.length,
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        },
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