import 'package:expenses_tracker/Extras/extras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dashboard.dart';
import 'onboarding.dart';
import 'records.dart';

import 'package:date_format/date_format.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;


Future<Route> createRecord(double amount, String notes, String date , String time , int recordType , int categoryId, String hash) async{
  final http.Response response = await http.post('http://expenses.koda.ws/api/v1/records',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $hash',
    },
    body: jsonEncode(<String , dynamic>{
      'record': {
        'amount': amount,
        'notes': notes,
        'record_type': recordType,
        'date': '${date+time}',
        'category_id': categoryId
      },
    }),
  );

  // dynamic fromJsonId(Map<String, dynamic> json){
  //   var id = json['id'];
  //   return id;
  // }


  print('The status code is ${response.statusCode}');

  if(response.statusCode == 200){
    // BuildContext context;
    // return Navigator.of(context).push(MaterialPageRoute(builder: (_) => Dashboard(hash: hash,)));
    Route route = MaterialPageRoute(builder: (context) => Dashboard(hash: hash));
    return route;
    // return fromJsonId(json.decode(response.body));
  }else{
    throw Exception('Failed to login');
  }
}

class ModifyRecord extends StatefulWidget{
  final bool isEmpty;
  final String hash;

  ModifyRecord({this.isEmpty , this.hash});

  
  @override
  _ModifyRecord createState() => _ModifyRecord(isEmpty: isEmpty, hash: hash);
}


class _ModifyRecord extends State<ModifyRecord>{

  // final GlobalKey<NavigatorState> _navigator = GlobalKey<NavigatorState>();

  @override
  void dispose(){
    super.dispose();
  }

  final bool isEmpty;
  final String hash;

  _ModifyRecord({this.isEmpty , this.hash});
  
  List<bool> _selections = List.generate(2, (_) => false);
  DateTime _dateTime = DateTime.now();
  DateTime _date = DateTime.now();
  int _recordType;

  String _convertedDate;
  String _convertedTime;
  int _categoryId;
  
  TextEditingController _controller1 = new TextEditingController();
  TextEditingController _controller2 = new TextEditingController();
  TextEditingController _controller3 = new TextEditingController();
  TextEditingController _controller4 = new TextEditingController();
  TextEditingController _controller5 = new TextEditingController();

  Future<Route> _futureRecord;

  @override
  
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: widget.isEmpty == true ? Text("Add Record") : Text("Edit Record"),
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
        actions: widget.isEmpty == true
        ? <Widget>[
          IconButton(
            onPressed: (){
              setState(() {
                print('The value of hash in modify record is $hash');
                print('The value of amount is ${double.parse(_controller2.text)}');
                print('The value of notes is ${_controller1.text}');
                print('The value of date is $_convertedDate');
                print('The value of time is $_convertedTime');
                print('The value of categoryId is $_categoryId');
                print('The value of recordType is $_recordType');
                _futureRecord = createRecord(double.parse(_controller2.text) , _controller1.text , _convertedDate , _convertedTime , _recordType , _categoryId , hash);
              });
            },
            icon: Icon(Icons.check),
          ),
        ]
        : <Widget>[
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
      floatingActionButton: FloatingButton(nextPage: ModifyRecord(),),
      body: (_futureRecord == null)
        ? Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: ToggleButtons(
                        fillColor: Color(0xff246c55),
                        children: <Widget>[
                          SizedBox(
                            width: 100.0,
                            child: Text("Income", textAlign: TextAlign.center,),
                          ),
                          SizedBox(
                            width: 100.0,
                            child: Text("Expense", textAlign: TextAlign.center,),
                          ),
                        ],
                        selectedColor: Color(0xff90b4aa),
                        onPressed: (int index){
                          setState(() {
                            _recordType = index;
                            for(int i = 0; i < _selections.length; i++){
                              if(i == index){
                                _selections[i] = true;
                              }else{
                                _selections[i] = false;
                              }
                            }    
                          });
                        },
                        isSelected: _selections,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _controller1,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff555555),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff246c55),
                            width: 2.0,
                          ),                            
                        ),
                        focusColor: Color(0xff246c55),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff246c55),
                          ),                            
                        ),
                        labelText: "Notes",
                        labelStyle: TextStyle(
                          color: Color(0xff555555),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _controller2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff555555),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff246c55),
                            width: 2.0,
                          ),                            
                        ),
                        focusColor: Color(0xff246c55),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff246c55),
                          ),                            
                        ),
                        labelText: "Amount",
                        labelStyle: TextStyle(
                          color: Color(0xff555555),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            showCursor: true,
                            controller: _controller3,
                            
                            onTap: (){
                            showCupertinoModalPopup(
                              context: context, 
                              builder: (context) => 
                                Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(color: Colors.transparent,),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 50.0,
                                            color: Color(0xffffffff),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: FlatButton(
                                                    color: Color(0xffffffff),
                                                    child: Text("Cancel"),
                                                    onPressed: (){
                                                      Navigator.of(context).pop(false);
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: FlatButton(
                                                    color: Color(0xffffffff),
                                                    child: Text("Done"),
                                                    onPressed: (){
                                                      _convertedDate = formatDate(DateTime(int.parse('${_date.year}') , int.parse('${_date.month}') , int.parse('${_date.day}')), [yyyy , '-' , mm , '-' , dd]).toString();
                                                      _controller3.text = formatDate(DateTime(int.parse('${_date.year}') , int.parse('${_date.month}') , int.parse('${_date.day}')), [yyyy , ' ' , M , ' ' , dd]).toString();

                                                      Navigator.of(context).pop(false);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: CupertinoDatePicker(
                                              backgroundColor: Color(0xffffffff),
                                              mode: CupertinoDatePickerMode.date,
                                              use24hFormat: true,
                                              initialDateTime: _date,
                                              onDateTimeChanged: (date){
                                                print(date);
                                                setState(() {
                                                  _date = date;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff555555),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff246c55),
                                  width: 2.0,
                                ),                            
                              ),
                              focusColor: Color(0xff246c55),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff246c55),
                                ),                            
                              ),
                              labelText: "Date",
                              labelStyle: TextStyle(
                                color: Color(0xff555555),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            readOnly: true,
                            showCursor: true,
                            controller: _controller4,
                            onTap: (){
                            showCupertinoModalPopup(
                              context: context, 
                              builder: (context) => 
                                Column(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(color: Colors.transparent,),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            height: 50.0,
                                            color: Color(0xffffffff),
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                  child: FlatButton(
                                                    color: Color(0xffffffff),
                                                    child: Text("Cancel"),
                                                    onPressed: (){
                                                      Navigator.of(context).pop(false);
                                                    },
                                                  ),
                                                ),
                                                Expanded(
                                                  child: FlatButton(
                                                    color: Color(0xffffffff),
                                                    child: Text("Done"),
                                                    onPressed: (){

                                                      String formatDateTime(DateTime dateTime){
                                                        return '${dateTime.hour}:${dateTime.minute}';
                                                      }
                                                      _convertedTime = 'T' + formatDateTime(_dateTime).toString() + ':00.000Z';
                                                      _controller4.text = formatDateTime(_dateTime).toString();

                                                      Navigator.of(context).pop(false);
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5,
                                            child: CupertinoDatePicker(
                                              backgroundColor: Color(0xffffffff),
                                              mode: CupertinoDatePickerMode.time,
                                              use24hFormat: true,
                                              initialDateTime: _dateTime,
                                              onDateTimeChanged: (dateTime){
                                                print(dateTime);
                                                setState(() {
                                                  _dateTime = dateTime;
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff555555),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff246c55),
                                  width: 2.0,
                                ),                            
                              ),
                              focusColor: Color(0xff246c55),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff246c55),
                                ),                            
                              ),
                              labelText: "Time",
                              labelStyle: TextStyle(
                                color: Color(0xff555555),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      showCursor: true,
                      controller: _controller5,
                      onTap: () async{
                        final result = await Navigator.of(context).push(MaterialPageRoute(builder: (value) => Records()));

                        _categoryId = result[1];
                        _controller5.text = result[0].toString();
                      },
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff555555),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff246c55),
                            width: 2.0,
                          ),                            
                        ),
                        focusColor: Color(0xff246c55),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff246c55),
                          ),                            
                        ),
                        labelText: "Category",
                        labelStyle: TextStyle(
                          color: Color(0xff555555),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
            ),
          ),
        ],
      )
      : FutureBuilder<Route>(
          
          future: _futureRecord,
          builder: (context , snapshot){
            if(snapshot.hasData){
              return Dashboard(hash: hash);
              // Navigator.of(context).push(MaterialPageRoute(builder: (_) => Dashboard(hash: hash)));
              
              // return RefreshIndicator(
              //   child: Scaffold(), 
              //   onRefresh: (){
              //     return Navigator.of(context).push(MaterialPageRoute(builder: (_) => Dashboard(hash: hash)));
              //   }
              // );

              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Dashboard(hash: hash)));
              // Overlay()
              // setState(() {
              //   Navigator.of(context).push(MaterialPageRoute(builder: (_) => Dashboard(hash: hash)));
              // });

              // Route route = MaterialPageRoute(builder: (context) => Dashboard(hash: hash,));
              // Navigator.push(context , route);
              // return Dashboard(hash: hash);
              // return Container(child: Dashboard(hash: hash));
              // return Center(child: snap,);
              // return Scaffold(
                // return MaterialApp(

                // );
                
                // routes: 
                //   (BuildContext context) => new Dashboard(hash: hash,), 
                // Route route = MaterialPageRoute
        //                 Route route = MaterialPageRoute(builder: (context) => nextPage);
        // Navigator.push(context , route); 
                // builder: (context) => Dashboard(hash: hash,);
                // routes: <String, WidgetBuilder>{
                //   'Dashboard': Navigator.pushNamed(context, routeName)
                // },
                // builder: (context, child){
                //   return Dashboard(hash: hash);
                // },
                
              // );
                // return MaterialApp(
                //   navigatorKey: _navigator,
                //   routes: <String, WidgetBuilder>{
                //     '/': (context) => Dashboard(hash: hash),
                //   }
                // );
              
            }else if(snapshot.hasError){
              return Center(child: Text('Error'));
            }
            return Center(child: CircularProgressIndicator());
          },
          
      ),
      
    );
    
  }
}




// void main() => runApp(Post());

// class Post extends StatefulWidget{
//   @override
//   _Post createState() => _Post();
// }

// class _Post extends State<Post>{
//   final TextEditingController _controller1 = TextEditingController();
//   final TextEditingController _controller2 = TextEditingController();

//   Account account;

//   Future<Account> _futureAccount;

//   @override

//   Widget build(BuildContext context){
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Post"),
//         ),
//         body: Container(
//           alignment: Alignment.center,
//           padding: const EdgeInsets.all(8.0),
//           child: (_futureAccount == null)
//             ? Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 TextField(
//                   controller: _controller1,
//                   decoration: InputDecoration(
//                     hintText: 'Email: '
//                   ),
//                 ),
//                 TextField(
//                   controller: _controller2,
//                   decoration: InputDecoration(
//                     hintText: 'Password: '
//                   ),
//                 ),
//                 RaisedButton(
//                   child: Text("Login"),
//                   onPressed: (){
//                     setState(() {
//                       _futureAccount = createAccount(_controller1.text , _controller2.text);
//                     });
//                   },
//                 ),
//               ],
//             )
//             : FutureBuilder<Account>(
//               future: _futureAccount,
//               builder: (context , snapshot){
//                 if(snapshot.hasData){
//                   return Text('${snapshot.data.message}');
//                 }else if(snapshot.hasError){
//                   return Text('${snapshot.error}');
//                 }
//                 return CircularProgressIndicator();
//               },
//             ),
//         ),
//       ),
//     );
//   }
// }
