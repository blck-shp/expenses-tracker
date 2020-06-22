import 'package:flutter/material.dart';

// void main() => runApp(
//   LoadApp();
// );

void main(){
  runApp(
    MaterialApp(
      home: LoadApp(),
    ),
  );
}

class LoadApp extends StatefulWidget{
  @override
  _LoadApp createState() => _LoadApp();
}


class _LoadApp extends State<LoadApp>{


  int page = 1;
  List<String> items = ['item 1' , 'item 2'];
  bool isLoading = false;

  Future _loadData() async{
    await new Future.delayed(new Duration(seconds: 2));
    print('load more');

    setState(() {
      items.addAll(['item 1']);
      print('items: ' + items.toString());
      isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Hehehehe"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo){
                if(!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){
                  _loadData();

                  setState(() {
                    isLoading = true;
                  });
                }
                return isLoading;
              },
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context , index){
                  return ListTile(
                    title: Text('${items[index]}'),
                  );
                },
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
      ),
    );
  }
}