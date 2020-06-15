import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:expenses_tracker/Extras/extras.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'onboarding.dart';
import 'records.dart';

// import 'package:date_picker_timeline/date_picker_timeline.dart';



class ModifyRecord extends StatefulWidget{
  final bool isEmpty;

  ModifyRecord({this.isEmpty});

  
  @override
  _ModifyRecord createState() => _ModifyRecord();
}


class _ModifyRecord extends State<ModifyRecord>{
  
  List<bool> _selections = List.generate(2, (_) => false);
  // DateTime _dateTime;

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
      body: Column(
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
                          child: MaterialButton(
                            onPressed: (){

                            },
                          ),
                          // child: TextFormField(
                          //   decoration: InputDecoration(
                          //     enabledBorder: UnderlineInputBorder(
                          //       borderSide: BorderSide(
                          //         color: Color(0xff555555),
                          //       ),
                          //     ),
                          //     focusedBorder: UnderlineInputBorder(
                          //       borderSide: BorderSide(
                          //         color: Color(0xff246c55),
                          //         width: 2.0,
                          //       ),                            
                          //     ),
                          //     focusColor: Color(0xff246c55),
                          //     focusedErrorBorder: UnderlineInputBorder(
                          //       borderSide: BorderSide(
                          //         color: Color(0xff246c55),
                          //       ),                            
                          //     ),
                          //     labelText: "Date",
                          //     labelStyle: TextStyle(
                          //       color: Color(0xff555555),
                          //     ),
                          //   ),
                          // ),
                        ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  DatePicker(
                    DateTime.now(),
                    height: 100.0,
                    initialSelectedDate: DateTime.now(),
                    selectionColor: Colors.black,
                    selectedTextColor: Colors.white,
                    onDateChange: (date){
                      // _dateTime = date;
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}