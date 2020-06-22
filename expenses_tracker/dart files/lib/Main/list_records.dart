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
  bool isLoading = false;

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

  

  bool _searching = false;
  TextEditingController _controller = new TextEditingController();
  String searchValue = '';


  List<RecordsName> items = [];
  int currentCount = 0;

  int count = 1;

  Future _getListRecords(String hash, int count) async{
    final response = await http.get('http://expenses.koda.ws/api/v1/records?page=$count',
      headers: {
        HttpHeaders.authorizationHeader: hash,
      }
    );

    setState(() {
      var val = postFromJsonRecords(response.body);

      items.addAll(val.records);
      print('The value of items is $items');
      isLoading = false;
    });
  }

  @override
    void initState(){
    super.initState();
    _getListRecords(hash, count);
    count = 2;
  }


  

  @override
  Widget build(BuildContext context){
    // _getListRecords(hash, count);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
        title: _searching == true
          ? TextFormField(
            style: TextStyle(
              color: Color(0xffffffff),
            ),
            cursorColor: Color(0xffffffff),

            controller: _controller,
            onFieldSubmitted: (value){
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
                  _searching = false;
                });
              },
              icon: Icon(Icons.clear),
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Route route = MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: true, hash: hash));
          Navigator.push(context , route);
        },
        backgroundColor: Color(0xff246c55),
        child: Icon(Icons.add),
      ),
      body: searchValue == ''
      ? Column(
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
                  String date = items[index].date;
                  String dateWithT = date.substring(0, 10);
                  // int countIcon = index + 2;

                  print(';lkasjdf;lkjasddf;lkjasd is $items');
                  // return ListTile(
                  //   title: Text('${items[index].notes}'),
                  // );

                  return Dismissible(
                  // key: ValueKey(snapshot.data.categories[index].id),
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
                    print('The value of result is $result');
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
                    // leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${(items[index].category.id - 1).toString()}')),
                    leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${icons[items[index].category.id - 1]}')),
                    title: Text('P' + '${items[index].amount}' + '0'),
                    subtitle: Text('${items[index].category.name}' + ' — ' + '${items[index].notes}'),
                    trailing: Text('$dateWithT', style: TextStyle(fontSize: 12.0,),),

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
                       
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id,))); 
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, updateData: snapshot.data.records[index].id))); 
                    },

                    onLongPress: ()async{
                      
                      final result = await showDialog(
                        context: context,
                        builder: (_) => DeleteRecord(),
                      );
                      print('The value of result is $result');

                      if(result == true){
                        deleteRecord(hash, items[index].id);
                        setState(() {
                          
                          // print('The value is of id is ${snapshot.data.records[index].id}');
                        });
                        // deleteRecord(hash, snapshot.data.records[index].id);
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
      )
      : FutureBuilder<ListRecordsCategory>(
        future: searchRecords(hash, searchValue),
        builder: (context, snapshot){
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
                    setState(() {
                      items.removeAt(index);
                    });
                  },
                  confirmDismiss: (direction) async{
                    final result = await showDialog(
                      context: context,
                      builder: (_) => DeleteRecord(),
                      
                    );
                    print('The value of result is $result');
                    if(result == true){
                      deleteRecord(hash, snapshot.data.records[index].id);
                    }

                    return result;
                    

                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 10.0),
                    child: Align(child: Icon(Icons.delete, color: Color(0xffffffff)) , alignment: Alignment.centerLeft,)
                  ),
                  
                  child: ListTile(
                    leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${icons[snapshot.data.records[index].category.id - 1]}')),
                    title: Text('P' + '${snapshot.data.records[index].amount}' + '0'),
                    subtitle: Text('${snapshot.data.records[index].category.name}' + ' — ' + '${snapshot.data.records[index].notes}'),
                    trailing: Text('$dateWithT', style: TextStyle(fontSize: 12.0,),),
                  

                    onTap: (){
                      String notes = snapshot.data.records[index].notes;
                      String amount = snapshot.data.records[index].amount.toString();
                      
                      String date = snapshot.data.records[index].date.substring(0, 10);
                      DateTime finalDate = DateTime.parse(date);

                      String time = snapshot.data.records[index].date;
                      DateTime finalTime = DateTime.parse(time);

                      String categoryName = snapshot.data.records[index].category.name;

                      int recordType = snapshot.data.records[index].recordType;
                      int categoryId = snapshot.data.records[index].category.id;

                      int id = snapshot.data.records[index].id;

                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id))); 
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, updateData: snapshot.data.records[index].id)));
                    },

                    onLongPress: ()async{
                      
                      final result = await showDialog(
                        context: context,
                        builder: (_) => DeleteRecord(),
                      );
                      print('The value of result is $result');

                      if(result == true){
                        deleteRecord(hash, snapshot.data.records[index].id);
                        setState(() {
                          
                        });
                      }
                        
                    },
                    
                  ),
                );
              }, 
              separatorBuilder: (_, __) => Divider(height: 0),
              // itemCount: snapshot.data.pagination.count <= snapshot.data.pagination.perPage ? snapshot.data.records.length + 1: snapshot.data.records.length,
              itemCount: snapshot.data.pagination.count,
            );
          }else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}

ListRecordsCategory postFromJsonRecords(String str){
  final jsonData = json.decode(str);
  var value = ListRecordsCategory.fromJson(jsonData);
  print('The value is $value');
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

  print('The status code is ${response.statusCode}');


  if(response.statusCode == 200){
    return 'Success';
  }else{
    throw Exception('Failed to update');
  }

}

Future<ListRecordsCategory> searchRecords(String hash, String search) async{
  final response = await http.get('http://expenses.koda.ws/api/v1/records?q=$search',
    headers: {
      HttpHeaders.authorizationHeader: hash,
    },
  );

  print('The status code is ${response.statusCode}');
  return postFromJsonRecords(response.body);
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





// FutureBuilder<ListRecordsCategory>(
//         future: getListRecords(hash),
//         builder: (context , snapshot){
//           if(snapshot.connectionState == ConnectionState.done){
//             if(snapshot.hasError){
//               return Center(child: Text("Error"));
//             }

//             return ListView.separated(
//               addAutomaticKeepAlives: true,
//               itemCount: snapshot.data.pagination.count,
//               itemBuilder: (context, index){
//                 String date = snapshot.data.records[index].date;
//                 String dateWithT = date.substring(0, 10);
//                 return Dismissible(
//                   // key: ValueKey(snapshot.data.categories[index].id),
//                   key: ValueKey(snapshot.data.records[index].id),
//                   direction: DismissDirection.startToEnd,
//                   onDismissed: (direction){
//                     setState(() {
                      
//                     });
//                   },
//                   confirmDismiss: (direction) async{
//                     final result = await showDialog(
//                       context: context,
//                       builder: (_) => DeleteRecord(),
                      
//                     );
//                     print('The value of result is $result');
//                     if(result == true){
//                       deleteRecord(hash, snapshot.data.records[index].id);
//                     }

//                     return result;
                    

//                   },
//                   background: Container(
//                     color: Colors.red,
//                     padding: EdgeInsets.only(left: 10.0),
//                     child: Align(child: Icon(Icons.delete, color: Color(0xffffffff)) , alignment: Alignment.centerLeft,)
//                   ),
                  
//                   child: ListTile(
//                     leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${icons[index + 2]}')),
//                     title: Text('P' + '${snapshot.data.records[index].amount}' + '0'),
//                     subtitle: Text('${snapshot.data.records[index].category.name}' + ' — ' + '${snapshot.data.records[index].notes}'),
//                     trailing: Text('$dateWithT', style: TextStyle(fontSize: 12.0,),),
                  



//                     onTap: (){
//                       String notes = snapshot.data.records[index].notes;
//                       String amount = snapshot.data.records[index].amount.toString();
                      
//                       String date = snapshot.data.records[index].date.substring(0, 10);
//                       DateTime finalDate = DateTime.parse(date);
                      
//                       String time = snapshot.data.records[index].date;
//                       DateTime finalTime = DateTime.parse(time);

//                       String categoryName = snapshot.data.records[index].category.name;

//                       int recordType = snapshot.data.records[index].recordType;
//                       int categoryId = snapshot.data.records[index].category.id;

//                       int id = snapshot.data.records[index].id;
                       
//                       Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id,))); 
//                       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, updateData: snapshot.data.records[index].id))); 
//                     },

//                     onLongPress: ()async{
                      
//                       final result = await showDialog(
//                         context: context,
//                         builder: (_) => DeleteRecord(),
//                       );
//                       print('The value of result is $result');

//                       if(result == true){
//                         deleteRecord(hash, snapshot.data.records[index].id);
//                         setState(() {
                          
//                           // print('The value is of id is ${snapshot.data.records[index].id}');
//                         });
//                         // deleteRecord(hash, snapshot.data.records[index].id);
//                       }
                        
//                     },
                    
//                   ),
//                 );
//               }, 
//                             // physics: AlwaysScrollableScrollPhysics(),
//               separatorBuilder: (_, __) => Divider(height: 0),
//               // itemCount: snapshot.data.pagination.count <= snapshot.data.pagination.perPage ? snapshot.data.records.length + 1: snapshot.data.records.length,
//               // itemCount: snapshot.data.pagination.count,
//             );
//           }else{
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       )




// class Value{
//   String notes;
// }


 // List<ListRecordsCategory> items;
  // ListRecordsCategory items;
  
  // Future<ListRecordsCategory> getListRecords(String hash) async{
  // // final response = await http.get('http://expenses.koda.ws/api/v1/records?page=$count',
  // final response = await http.get('http://expenses.koda.ws/api/v1/records',
  //   headers: {
  //     HttpHeaders.authorizationHeader: hash,
  //   },
  // );

  // print('The status code is ${response.statusCode}');

  // setState(() {
  //   // items.addAll(postFromJsonRecords(response.body));
  //   items = postFromJsonRecords(response.body);
  //   isLoading = false;
  // });

  // return postFromJsonRecords(response.body);
  // }




                 //   return  ListTile(
                  //   // leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${icons[index + 2]}')),
                  //   title: Text('P' + '${items[index].amount}' + '0'),
                  //   subtitle: Text('${items[index].category.name}' + ' — ' + '${items[index].notes}'),
                  //   trailing: Text('$dateWithT', style: TextStyle(fontSize: 12.0,),),
                  



                  //   // onTap: (){
                  //   //   String notes = items[index].notes;
                  //   //   String amount = items[index].amount.toString();
                      
                  //   //   String date = items[index].date.substring(0, 10);
                  //   //   DateTime finalDate = DateTime.parse(date);
                      
                  //   //   String time = items[index].date;
                  //   //   DateTime finalTime = DateTime.parse(time);

                  //   //   String categoryName = items[index].category.name;

                  //   //   int recordType = items[index].recordType;
                  //   //   int categoryId = items[index].category.id;

                  //   //   int id = items[index].id;
                       
                  //   //   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id,))); 
                  //   //   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, updateData: snapshot.data.records[index].id))); 
                  //   // },

                  //   // onLongPress: ()async{
                      
                  //   //   final result = await showDialog(
                  //   //     context: context,
                  //   //     builder: (_) => DeleteRecord(),
                  //   //   );
                  //   //   print('The value of result is $result');

                  //   //   if(result == true){
                  //   //     deleteRecord(hash, items[index].id);
                  //   //     setState(() {
                          
                  //   //       // print('The value is of id is ${snapshot.data.records[index].id}');
                  //   //     });
                  //   //     // deleteRecord(hash, snapshot.data.records[index].id);
                  //   //   }
                        
                  //   // },
                    
                  // );








              //             return ListView.separated(
              // addAutomaticKeepAlives: true,
              // itemCount: snapshot.data.pagination.count,
              // itemBuilder: (context, index){
              //   String date = snapshot.data.records[index].date;
              //   String dateWithT = date.substring(0, 10);
              //   return Dismissible(
              //     // key: ValueKey(snapshot.data.categories[index].id),
              //     key: ValueKey(snapshot.data.records[index].id),
              //     direction: DismissDirection.startToEnd,
              //     onDismissed: (direction){
              //       setState(() {
                      
              //       });
              //     },
              //     confirmDismiss: (direction) async{
              //       final result = await showDialog(
              //         context: context,
              //         builder: (_) => DeleteRecord(),
                      
              //       );
              //       print('The value of result is $result');
              //       if(result == true){
              //         deleteRecord(hash, snapshot.data.records[index].id);
              //       }

              //       return result;
                    

              //     },
              //     background: Container(
              //       color: Colors.red,
              //       padding: EdgeInsets.only(left: 10.0),
              //       child: Align(child: Icon(Icons.delete, color: Color(0xffffffff)) , alignment: Alignment.centerLeft,)
              //     ),
                  
              //     child: ListTile(
              //       leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${icons[index + 2]}')),
              //       title: Text('P' + '${snapshot.data.records[index].amount}' + '0'),
              //       subtitle: Text('${snapshot.data.records[index].category.name}' + ' — ' + '${snapshot.data.records[index].notes}'),
              //       trailing: Text('$dateWithT', style: TextStyle(fontSize: 12.0,),),
                  



              //       onTap: (){
              //         String notes = snapshot.data.records[index].notes;
              //         String amount = snapshot.data.records[index].amount.toString();
                      
              //         String date = snapshot.data.records[index].date.substring(0, 10);
              //         DateTime finalDate = DateTime.parse(date);
                      
              //         String time = snapshot.data.records[index].date;
              //         DateTime finalTime = DateTime.parse(time);

              //         String categoryName = snapshot.data.records[index].category.name;

              //         int recordType = snapshot.data.records[index].recordType;
              //         int categoryId = snapshot.data.records[index].category.id;

              //         int id = snapshot.data.records[index].id;
                       
              //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id,))); 
              //         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, updateData: snapshot.data.records[index].id))); 
              //       },

              //       onLongPress: ()async{
                      
              //         final result = await showDialog(
              //           context: context,
              //           builder: (_) => DeleteRecord(),
              //         );
              //         print('The value of result is $result');

              //         if(result == true){
              //           deleteRecord(hash, snapshot.data.records[index].id);
              //           setState(() {
                          
              //             // print('The value is of id is ${snapshot.data.records[index].id}');
              //           });
              //           // deleteRecord(hash, snapshot.data.records[index].id);
              //         }
                        
              //       },
                    
              //     ),
              //   );
              // }, 
                            // physics: AlwaysScrollableScrollPhysics(),
            //   separatorBuilder: (_, __) => Divider(height: 0),
            //   // itemCount: snapshot.data.pagination.count <= snapshot.data.pagination.perPage ? snapshot.data.records.length + 1: snapshot.data.records.length,
            //   // itemCount: snapshot.data.pagination.count,
            // );