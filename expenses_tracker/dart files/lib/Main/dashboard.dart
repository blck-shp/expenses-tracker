import 'package:expenses_tracker/Extras/extras.dart';
import 'package:expenses_tracker/Main/modify_record.dart';
import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'records.dart';

class Dashboard extends StatefulWidget{
  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
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
      floatingActionButton: FloatingButton(nextPage: ModifyRecord(isEmpty: true,),),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: Center(child: Image.asset('assets/images/empty_icon.png'),)
                ),
                Expanded(
                  child: Center(child: Text("There are no records here yet.", style: TextStyle(fontSize: 16.0 , color: Color(0xff555555)),),),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Expanded(
                  child: Container(
                    child: ButtonFilled(width: .75 , height: 0, fontSize: 20.0, text: "START TRACKING", backgroundColor: Colors.white, fontWeight: FontWeight.bold, nextPage: ModifyRecord(isEmpty: true,),),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}