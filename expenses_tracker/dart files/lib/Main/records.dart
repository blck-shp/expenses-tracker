import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Records extends StatefulWidget{
  final int listCategory;

  Records({this.listCategory});

  @override
  _Records createState() => _Records(listCategory: listCategory);
}

class _Records extends State<Records>{

  int listCategory;

  _Records({this.listCategory});

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.of(context).pop(true);
              },
            );
          },
        ),
        title: Text("Categories"),
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
      ),
      body: FutureBuilder<CategoryList>(
        future: getList(),
        builder: (context , snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasError){
              return Center(child: Text("Error"));
            }
            return ListView.separated(
              itemBuilder: (_, index){
                return Container(
                  color: index == listCategory ? Color(0xffeeeeee) : Colors.white,
                  child: ListTile(
                    leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${snapshot.data.categories[index].icon}')),
                    title: Text(snapshot.data.categories[index].name),
                    onTap: (){
                      Navigator.pop(context, ['${snapshot.data.categories[index].name}' , snapshot.data.categories[index].id, index]);
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