import 'package:expenses_tracker/Extras/extras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dashboard.dart';
// import 'list_records.dart';
// import '../main.dart';
// import 'list_records.dart';
import 'records.dart';
import 'package:date_format/date_format.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ModifyRecord extends StatefulWidget{
  final bool isEmpty;
  final String hash;
  final int listCategory;

  final String notes;
  final String amount;
  final DateTime date;
  final DateTime time;
  final String categoryName;
  final int recordType;
  final int categoryId;
  final int id;

  ModifyRecord({this.isEmpty , this.hash, this.notes, this.amount, this.date, this.time, this.categoryName, this.recordType, this.categoryId, this.id, this.listCategory});

  @override
  _ModifyRecord createState() => _ModifyRecord(isEmpty: isEmpty, hash: hash, notes: notes, amount: amount, date: date, time: time, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id, listCategory: listCategory);
}


class _ModifyRecord extends State<ModifyRecord>{

  @override
  void dispose(){
    super.dispose();
  }
  
  final bool isEmpty;
  final String hash;
  int listCategory;

  final String notes;
  final String amount;
  final DateTime date;
  final DateTime time;
  final String categoryName;
  final int recordType;
  final int categoryId;
  final int id;

  _ModifyRecord({this.isEmpty, this.hash, this.notes, this.amount, this.date, this.time, this.categoryName, this.recordType, this.categoryId, this.id, this.listCategory});
  
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

  String value1;
  String value2;
  String value3;
  String value4;
  String value5;
  int value6;

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

  if(response.statusCode == 200){
    return fromJsonId(json.decode(response.body));
    }else{
      throw Exception('Failed to update');
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

  if(response.statusCode == 200){
    return fromJsonId(json.decode(response.body));
    }else{
      throw Exception('Failed to create');
    }
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
  void initState(){
  super.initState();
  
  if(recordType != null){
    _recordType = recordType;
    for(int i = 0; i < _selections.length; i++){
      if(i == recordType){
        _selections[i] = true;
      }else{
        _selections[i] = false;
      }
    }  
  }

  }

  @override  
  Widget build(BuildContext context){
    if(isEmpty == false){
      _controller1.text = notes;
      _controller2.text = amount;

      _convertedDate = formatDate(DateTime(int.parse('${date.year}') , int.parse('${date.month}') , int.parse('${date.day}')), [yyyy , '-' , mm , '-' , dd]).toString();
      _controller3.text = formatDate(DateTime(int.parse('${date.year}') , int.parse('${date.month}') , int.parse('${date.day}')), [yyyy , '-' , mm , '-' , dd]).toString();

      String formatDateTime(DateTime time){
        return '${time.hour}:${time.minute}';
      }

      _convertedTime = 'T' + formatDateTime(time).toString() + ':00.000Z';
      _controller4.text = formatDateTime(time).toString();

      _controller5.text = categoryName;

      _categoryId = categoryId;

      // listCategory = listCategory;


      value1 = _controller1.text;
      value2 = _controller2.text;
      value3 = _controller3.text;
      value4 = _controller4.text;
      value5 = _controller5.text;
      value6 = _recordType;

    }else{
      _convertedDate = formatDate(DateTime(int.parse('${_date.year}') , int.parse('${_date.month}') , int.parse('${_date.day}')), [yyyy , '-' , mm , '-' , dd]).toString();
      _controller3.text = formatDate(DateTime(int.parse('${_date.year}') , int.parse('${_date.month}') , int.parse('${_date.day}')), [yyyy , ' ' , M , ' ' , dd]).toString();

      String formatDateTime(DateTime dateTime){
        return '${dateTime.hour}:${dateTime.minute}';
      }
      _convertedTime = 'T' + formatDateTime(_dateTime).toString() + ':00.000Z';
      _controller4.text = formatDateTime(_dateTime).toString();

      _controller5.text = 'Food & Drinks';
      listCategory = 0;
      _categoryId = 1;

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
            onPressed: (){
              if(_controller1.text != '' || _controller2.text != '' || _controller3.text != '' || _controller4.text != '' || _controller5.text != '' || (_selections[0] == true || _selections[1] == true)){
                setState(() {
                  showDialog(
                    context: context,
                    builder: (context) => PromptMessage(header: "Prompt" , text: "Are you sure you want to discard these changes?"), 
                  );
                }); 
              }else{
                Navigator.of(context).pop(false);
              }
            },
            icon: Icon(Icons.delete)
          ),
          IconButton(
            onPressed: ()async{
              if(_controller1.text != '' && _controller2.text != '' && _controller3.text != '' && _controller4.text != '' && _controller5.text != '' && (_selections[0] == true || _selections[1] == true)){
                Center(child: CircularProgressIndicator());
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
        ]
        : <Widget>[
          IconButton(
            onPressed: (){
              setState((){
                showDialog(
                  context: context,
                  builder: (context) => DeleteMessage(header: "Prompt" , text: "Are you sure you want to delete this record?", hash: hash),
                  
                );
                deleteRecord(hash, id);
              });
              
            },
            icon: Icon(Icons.delete),
          ),
          IconButton(
            onPressed: ()async{
              if(_controller1.text != '' && _controller2.text != '' && _controller3.text != '' && _controller4.text != '' && _controller5.text != '' && (_selections[0] == true || _selections[1] == true)){
                if(value1 != _controller1.text || value2 != _controller2.text || value3 != _controller3.text || value4 != _controller4.text || value5 != _controller5.text || value6 != recordType){
                  Center(child: CircularProgressIndicator());
                  updateRecord(double.parse(_controller2.text) , _controller1.text , _convertedDate , _convertedTime , _recordType , _categoryId , hash, id);
                }else{
                  Navigator.of(context).pop(false);
                }
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
      body:  Column(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 50.0, right: 50.0),
              child: Form(
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
                          final result = await Navigator.of(context).push(MaterialPageRoute(builder: (value) => Records(listCategory: listCategory,)));
                          
                          if(result == false){

                          }else{
                            _controller5.text = result[0].toString();
                            _categoryId = result[1];
                            listCategory = result[2];
                          }

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

