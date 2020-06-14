import 'package:expenses_tracker/Extras/extras.dart';
import 'package:expenses_tracker/Main/modify_record.dart';
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'onboarding.dart';
import 'package:expenses_tracker/API/fetch.dart';


class Records extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Records"),
        backgroundColor: Color(0xff246c55),
        centerTitle: true,
        actions: <Widget>[
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
      floatingActionButton: FloatingButton(nextPage: Records(),),
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
                      builder: (_) => AlertDialog(),
                    );
                    return result;
                  },
                  background: Container(
                    color: Colors.red,
                    padding: EdgeInsets.only(left: 10.0),
                    child: Align(child: Icon(Icons.delete, color: Color(0xffffffff)) , alignment: Alignment.centerLeft,)
                  ),
                  child: ListTile(
                    title: Text(snapshot.data.categories[index].name),
                    subtitle: Text(snapshot.data.categories[index].icon),
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (_) => ModifyRecord(isEmpty: false,)));
                    },
                  ),
                );
              }, 
              separatorBuilder: (_, __) => Divider(height: 1.0 , color: Color(0xff246c55)), 
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