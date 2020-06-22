import 'package:expenses_tracker/Extras/extras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'dashboard.dart';
import 'list_records.dart';
import 'onboarding.dart';
import 'records.dart';

import 'package:date_format/date_format.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;



class ModifyRecord extends StatefulWidget{
  final bool isEmpty;
  final String hash;

  final String notes;
  final String amount;
  final DateTime date;
  final DateTime time;
  final String categoryName;
  final int recordType;
  final int categoryId;
  final int id;


  ModifyRecord({this.isEmpty , this.hash, this.notes, this.amount, this.date, this.time, this.categoryName, this.recordType, this.categoryId, this.id});


  @override
  _ModifyRecord createState() => _ModifyRecord(isEmpty: isEmpty, hash: hash, notes: notes, amount: amount, date: date, time: time, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id);
}


class _ModifyRecord extends State<ModifyRecord>{

  @override
  void dispose(){
    super.dispose();
  }
  
  final bool isEmpty;
  final String hash;

  final String notes;
  final String amount;
  final DateTime date;
  final DateTime time;
  final String categoryName;
  final int recordType;
  final int categoryId;
  final int id;

  _ModifyRecord({this.isEmpty, this.hash, this.notes, this.amount, this.date, this.time, this.categoryName, this.recordType, this.categoryId, this.id});
  
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

  final _formKey = GlobalKey<FormState>();



  Future<int> updateRecord(double amount, String notes, String date , String time , int recordType , int categoryId, String hash, int id) async{
  final http.Response response = await http.patch('http://expenses.koda.ws/api/v1/records/$id',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': '$hash',
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

  print('The status code of the patch is ${response.statusCode}');

  if(response.statusCode == 200){
    return fromJsonId(json.decode(response.body));
    
    }else{
      throw Exception('Failed to login');
    }
  }


  Future<int> createRecord(double amount, String notes, String date , String time , int recordType , int categoryId, String hash) async{
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

  print('The status code is ${response.statusCode}');

  if(response.statusCode == 200){
    return fromJsonId(json.decode(response.body));
    
    }else{
      throw Exception('Failed to login');
    }
  }

  dynamic fromJsonId(Map<String, dynamic> json){
    var id = json['id'];
    setState(() {
      if(id != null)
        Navigator.of(context).pop(true);
        Navigator.of(context).push(MaterialPageRoute(builder: (_) => Dashboard(hash: hash)));
    });
    return id;
  }



  @override  
  Widget build(BuildContext context){


    if(isEmpty == false){
      _controller1.text = notes;
      _controller2.text = amount;

      print(';zcxvjl;ksoipuewrlkjs');

      _convertedDate = formatDate(DateTime(int.parse('${date.year}') , int.parse('${date.month}') , int.parse('${date.day}')), [yyyy , '-' , mm , '-' , dd]).toString();
      _controller3.text = formatDate(DateTime(int.parse('${date.year}') , int.parse('${date.month}') , int.parse('${date.day}')), [yyyy , '-' , mm , '-' , dd]).toString();

      print('asdfsdafasdfsa');

      String formatDateTime(DateTime time){
        return '${time.hour}:${time.minute}';
      }

      _convertedTime = 'T' + formatDateTime(time).toString() + ':00.000Z';
      _controller4.text = formatDateTime(time).toString();

      _controller5.text = categoryName;

      setState(() {
        _recordType = recordType;
        for(int i = 0; i < _selections.length; i++){
          if(i == recordType){
            _selections[i] = true;
          }else{
            _selections[i] = false;
          }
        }    
      });

      _categoryId = categoryId;

    }
    
    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: widget.isEmpty == true ? Text("Add Record") : Text("Edit Record"),
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
        actions: widget.isEmpty == true
        ? <Widget>[
          IconButton(
            onPressed: ()async{
              if(_formKey.currentState.validate() == true && (_selections[0] == true || _selections[1] == true)){
                print('The value of formkey is ${_formKey.currentState.validate()}');
                print('Hehehehe');
                createRecord(double.parse(_controller2.text) , _controller1.text , _convertedDate , _convertedTime , _recordType , _categoryId , hash);
              }
              else{
                setState(() {
                  showDialog(
                    context: context,
                    builder: (context) => ErrorMessage(header: "Error" , text: "Please complete the form before proceeding."), 
                  );
                });
              }
            },
            icon: Icon(Icons.check),
          ),
          IconButton(
            onPressed: (){
              setState(() {
                Navigator.of(context).pop(true);
              });
            },
            icon: Icon(Icons.delete)
          ),
        ]
        : <Widget>[
          IconButton(
            onPressed: (){
              print('Heheheheheheh');
              
              setState((){
                
                showDialog(
                  
                  context: context,
                  builder: (context) => PromptMessage(header: "Prompt" , text: "Are you sure you want to discard these changes?"),
                );
              });
              
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: ()async{
              // updateRecord(double.parse(_controller2.text) , _controller1.text , _convertedDate , _convertedTime , _recordType , _categoryId , hash, id);
              // Future<int> updateRecord(double amount, String notes, String date , String time , int recordType , int categoryId, String hash, int id) async{
              if(_formKey.currentState.validate() == true && (_selections[0] == true || _selections[1] == true)){
                print('The value of formkey is ${_formKey.currentState.validate()}');
                print('Hasdfzxcvczxvzxcddsfasd');
                updateRecord(double.parse(_controller2.text) , _controller1.text , _convertedDate , _convertedTime , _recordType , _categoryId , hash, id);
              }
              else{
                setState(() {
                  showDialog(
                    context: context,
                    builder: (context) => ErrorMessage(header: "Error" , text: "Please complete the form before proceeding."), 
                  );
                });
              }
            },
            icon: Icon(Icons.check),
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
      body:  Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
              child: Form(
                key: _formKey,
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
                        validator: (value){
                          if(value.isNotEmpty)
                            return null;
                          return null;
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
                        validator: (value){
                          if(value.isNotEmpty)
                            return null;
                          return null;
                        },
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
                              validator: (value){
                                if(value.isNotEmpty)
                                  return null;
                                return null;
                              },
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
                              validator: (value){
                                if(value.isNotEmpty)
                                  return null;
                                return null;
                              },
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
                        validator: (value){
                          if(value.isNotEmpty)
                            return null;
                          return null;
                        },
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
          ),
          Expanded(
            child: Container(
            ),
          ),
        ],
      ),
    );
  }
}












// ================================

      // Future<String> modifyRecords(String hash, int updateData) async{
      //   final response = await http.get('http://expenses.koda.ws/api/v1/records/$updateData',
      //     headers: {
      //       HttpHeaders.authorizationHeader: hash,
      //     },
      //   );

      //   print('The status code is ${response.statusCode}');

      //   void recordsFromJsonCategory(Map<String, dynamic> parsedJson){

      //     _controller5.text = parsedJson['name'];
          
      //   }

      //   void recordsFromJson(Map<String , dynamic> parsedJson){
      //     var list = parsedJson['category'];
      //     recordsFromJsonCategory(list);
      //     _controller1.text = parsedJson['notes'];
      //     _controller2.text = parsedJson['amount'].toString();
      //     var recordType = parsedJson['record_type'];
          
          
      //     print('The value of _controller1.text ${_controller1.text}');
      //     for(int i = 0; i < _selections.length; i++){
      //       if(i == recordType){
      //         _selections[i] = true;
      //       }else{
      //         _selections[i] = false;
      //       }
      //     }
      //   }

        
      //   if(response.statusCode == 200){
      //     recordsFromJson(json.decode(response.body));
      //     return 'Success';
      //   }else{
      //     throw Exception('Failed to get the data');
      //   }
      // }

      // print('The value of _controller1.text ${_controller1.text}');

      // modifyRecords(hash, updateData);
      // print('The value of _controller1.text ${_controller1.text}');
