import 'package:expenses_tracker/Extras/extras.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'onboarding.dart';
import 'records.dart';


class ModifyRecord extends StatelessWidget{
  
  final bool isEmpty;

  ModifyRecord({this.isEmpty});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: isEmpty == true ? Text("Add Record") : Text("Edit Record"),
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
        actions: isEmpty == true
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