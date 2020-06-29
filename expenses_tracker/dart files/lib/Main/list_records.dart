import 'dart:convert';
import 'dart:io';
import 'package:expenses_tracker/Extras/extras.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dashboard.dart';
import 'modify_record.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class ListRecords extends StatefulWidget{
  final String hash;

  ListRecords({this.hash});

  @override
  _ListRecords createState() => _ListRecords(hash: hash);
}

class _ListRecords extends State<ListRecords>{

  final String hash;

  _ListRecords({this.hash});

  bool _searching = false;
  TextEditingController _controller = new TextEditingController();
  String searchValue = '';

  List<RecordsName> items = [];
  List<RecordsName> items2 = [];
  
  int count = 1;
  int count2 = 1;

  bool isLoading = false;
  bool isLoading2 = false;

  List<String> _icons = [];

  @override
  void dispose(){
    super.dispose();
  }

  @override
    void initState(){

    super.initState();

    if(searchValue == ''){
      _getListRecords(hash, count);
    }

    count = 2;
    count2 = 0;
  }


  Future getList() async{
    final response = await http.get('http://expenses.koda.ws/api/v1/categories');

    _categoryName(Map<String, dynamic> parsedJson){
        _icons.add(parsedJson['icon']);
    }

    _category(Map<String, dynamic> parsedJson){
      var list = parsedJson['categories'] as List;
      list.map((e) => _categoryName(e)).toList();
    }

    if(response.statusCode == 200){
      _category(json.decode(response.body));
      return _icons;
    }else{
      throw Exception('Failed to get the icons');
    }

  }

  Future _getListRecords(String hash, int count) async{
    final response = await http.get('http://expenses.koda.ws/api/v1/records?page=$count',
      headers: {
        HttpHeaders.authorizationHeader: hash,
      }
    );

    setState(() {
      var val = postFromJsonRecords(response.body);
      items.addAll(val.records);
      isLoading = false;
    });
  }

  Future searchRecords(String hash, String search, int count) async{
    final response = await http.get('http://expenses.koda.ws/api/v1/records?q=$search&page=$count',
      headers: {
        HttpHeaders.authorizationHeader: hash,
      },
    );

    setState(() {
      var val = postFromJsonRecords(response.body);

      if(items2.length <= val.pagination.count){
        if(val.pagination.pages >= count){
          items2.addAll(val.records);
        }
      }
      
      isLoading2 = false;
    });
  } 

  @override
  Widget build(BuildContext context){
    if(searchValue != ''){
      setState(() {
        count2++;
        searchRecords(hash, searchValue, count2);
      });
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context){
            return IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            );
          }
        ),
        title: _searching == true
        ? TextFormField(
          style: TextStyle(
            color: Color(0xffffffff),
            decoration: TextDecoration.none,
          ),
          cursorColor: Color(0xffffffff),
          controller: _controller,
          onFieldSubmitted: (value){
            setState(() {
              searchValue = value;
              
            });

          },
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: IconButton(
              onPressed: (){},
              icon: Icon(Icons.search, color: Color(0xffffffff)),
            ),
            hintText: "Search...",
            hintStyle: TextStyle(
              color: Color(0xffffffff),
            ),
          ),
        )
        : Text('Records'),
        actions: <Widget>[
          _searching == false
          ? IconButton(
            onPressed: (){
              setState(() {
                _searching = true;
              });
            },
            icon: Icon(Icons.search),
          )
          : IconButton(
            onPressed: (){
              setState(() {
                searchValue = '';
                _controller.text = '';
                items2 = [];
                count2 = 0;
                _searching = false;
              });
            },
            icon: Icon(Icons.clear),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Route route = MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: true, hash: hash));
          Navigator.push(context , route);
        },
        backgroundColor: Color(0xff246c55),
        child: Icon(Icons.add),
      ),

      body: FutureBuilder(
        future: getList(),
        builder: (context, listIcons){
          if(listIcons.hasData){
            if(searchValue != ''){
              return Column(
                children: <Widget>[
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo){
                        if(!isLoading2 && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){
                          searchRecords(hash, searchValue, count2);
                          setState(() {
                            isLoading2 = true;
                            count2 = count2 + 1;  
                          }); 
                        }
                        return isLoading2;
                      },
                      child: ListView.separated(
                        itemCount: items2.length,
                        separatorBuilder: (_, __) => Divider(height: 0),
                        itemBuilder: (_, index){

                          String converted = items2[index].date;
                          DateTime date = DateTime.parse(converted.substring(0, 10));
                          String dateWithT = formatDate(date, [MM , ' ' , dd , ', ' , yyyy]).toString();

                          var currencyConverter = NumberFormat.currency(locale: 'fil', symbol: '\u20b1');

                          return Dismissible(
                            key: ValueKey(items2[index].id),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction){
                              setState(() {
                                items2.removeAt(index);
                              });
                            },
                            confirmDismiss: (direction) async{
                              final result = await showDialog(
                                context: context,
                                builder: (context) => DeleteRecord(),
                              );
                              if(result == true){
                                deleteRecord(hash, items2[index].id);
                              }
                              return result;
                            },
                            background: Container(
                              color: Colors.red,
                              padding: EdgeInsets.only(left: 10.0),
                              child: Align(child: Icon(Icons.delete, color: Color(0xffffffff)) , alignment: Alignment.centerLeft,)
                            ),
                            
                            child: ListTile(
                              leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${listIcons.data[items2[index].category.id - 1]}')),
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text('${currencyConverter.format(items2[index].amount)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          fontFamily: 'Nunito',
                                          color: items2[index].recordType == 0 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20.0),
                                      child: Text('$dateWithT',
                                      textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontFamily: 'Nunito',
                                          color: Color(0xff888888),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${items2[index].category.name}',
                                      style: TextStyle(
                                        color: Color(0xffbbbbbb),
                                        fontFamily: 'Nunito',
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' — ',
                                      style: TextStyle(
                                        color: Color(0xffaaaaaa),
                                        fontFamily: 'Nunito',
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${items2[index].notes}',
                                      style: TextStyle(
                                        color: Color(0xff888888),
                                        fontFamily: 'Nunito',
                                        fontSize: 12.0,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              onTap: (){
                                String notes = items2[index].notes;
                                String amount = items2[index].amount.toString();
                                
                                String date = items2[index].date.substring(0, 10);
                                DateTime finalDate = DateTime.parse(date);

                                String time = items2[index].date;
                                DateTime finalTime = DateTime.parse(time);

                                String categoryName = items2[index].category.name;

                                int recordType = items2[index].recordType;
                                int categoryId = items2[index].category.id;

                                int id = items2[index].id;

                                _icons = [];

                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id, listCategory: categoryId - 1,))); 
                              },

                              onLongPress: ()async{
                                final result = await showDialog(
                                  context: context,
                                  builder: (context) => DeleteRecord(),
                                );
                                if(result == true){
                                  deleteRecord(hash, items2[index].id);
                                }
                              },
                            ),
                          );
                        }, 
                      ),
                    ),
                  ),
                  Container(
                    height: isLoading2 ? 50.0 : 0,
                    color: Colors.transparent,
                    child: Center(
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }else{
              return Column(
                children: <Widget>[
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo){
                        if(!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){
                          _getListRecords(hash, count);
                          setState(() {
                            isLoading = true;
                            count = count + 1;  
                          }); 
                        }
                        return isLoading;
                      },
                      child: ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, __) => Divider(height: 0),
                        itemBuilder: (context , index){

                          String converted = items[index].date;
                          DateTime date = DateTime.parse(converted.substring(0, 10));
                          String dateWithT = formatDate(date, [MM , ' ' , dd , ', ' , yyyy]).toString();

                          var currencyConverter = NumberFormat.currency(locale: 'fil', symbol: '\u20b1');

                          return Dismissible(
                            key: ValueKey(items[index].id),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction){
                              setState(() {
                                items.removeAt(index);
                              });
                            },
                            confirmDismiss: (direction) async{
                              final result = await showDialog(
                                context: context,
                                builder: (_) => DeleteRecord(),
                                
                              );
                              if(result == true){
                                deleteRecord(hash, items[index].id);
                              }
                              return result;
                            },
                            background: Container(
                              color: Colors.red,
                              padding: EdgeInsets.only(left: 10.0),
                              child: Align(child: Icon(Icons.delete, color: Color(0xffffffff)) , alignment: Alignment.centerLeft,)
                            ),
                          
                            child: ListTile(
                              leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${listIcons.data[items[index].category.id - 1]}')),
                              title: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text('${currencyConverter.format(items[index].amount)}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                          fontFamily: 'Nunito',
                                          color: items[index].recordType == 0 ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 20.0),
                                      child: Text('$dateWithT',
                                      textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: 10.0,
                                          fontFamily: 'Nunito',
                                          color: Color(0xff888888),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: RichText(
                                text: TextSpan(
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '${items[index].category.name}',
                                      style: TextStyle(
                                        color: Color(0xffbbbbbb),
                                        fontFamily: 'Nunito',
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' — ',
                                      style: TextStyle(
                                        color: Color(0xffaaaaaa),
                                        fontFamily: 'Nunito',
                                        fontSize: 12.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${items[index].notes}',
                                      style: TextStyle(
                                        color: Color(0xff888888),
                                        fontFamily: 'Nunito',
                                        fontSize: 12.0,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: (){
                                String notes = items[index].notes;
                                String amount = items[index].amount.toString();
                                
                                String date = items[index].date.substring(0, 10);
                                DateTime finalDate = DateTime.parse(date);
                                
                                String time = items[index].date;
                                DateTime finalTime = DateTime.parse(time);

                                String categoryName = items[index].category.name;

                                int recordType = items[index].recordType;
                                int categoryId = items[index].category.id;

                                int id = items[index].id;

                                _icons = [];
                                
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id, listCategory: categoryId - 1,))); 
                              },

                              onLongPress: ()async{
                                final result = await showDialog(
                                  context: context,
                                  builder: (_) => DeleteRecord(),
                                );

                                if(result == true){
                                  deleteRecord(hash, items[index].id);
                                }
                              },
                            ),
                          );
                        }
                      ),
                    ),
                  ),
                  Container(
                    height: isLoading ? 50.0 : 0,
                    color: Colors.transparent,
                    child: Center(
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                ],
              );
            }
          }else if(listIcons.hasError){
            return Center(child: Text('Data unavailable. Please check your connection.'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

ListRecordsCategory postFromJsonRecords(String str){
  final jsonData = json.decode(str);
  var value = ListRecordsCategory.fromJson(jsonData);
  return value;
}

Future<String> deleteRecord(String hash, int id) async{
  final http.Response response = await http.delete('http://expenses.koda.ws/api/v1/records/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $hash',
    },
  );

  if(response.statusCode == 200){
    return 'Success';
  }else{
    throw Exception('Failed to update');
  }

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
    Category objectCategory = Category.fromJson(list);

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
    return ListCategory(
      id: parsedJson['id'],
      name: parsedJson['name'],
    );
  }
}