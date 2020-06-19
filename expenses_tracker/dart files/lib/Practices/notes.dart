// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       centerTitle: true,
//       title: Text(widget.title),
//       actions: <Widget>[
//         IconButton(
//           icon: Icon(Icons.check),
//           onPressed: () async {
//             // edit record
//             await sendEditRecordRequest();
//           },
//         )
//       ]
//     ),
//     body: Stack(
//       ...
//     )
//   );
// }
// void sendEditRecordRequest() async {
//   print("Editing record...");
//   setState(() {
//     _loading = true;
//   });
//   editRecord(_record).then((value)
//   {
//     setState(() {
//       _loading = false;
//     });
//     Navigator.pop(context, true);
//   }).catchError( (error) {
//     _loading = false;
//   });
// }
// Future<int> editRecord(Record record) async  {
//   String token = "lalala";
//   Map<String,String> headers = {
//     'Content-type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer ${token}'
//   };
//   final response = await http.patch('${Urls.BASE_URL}${Urls.RECORDS}/${record.id}',
//       headers: headers,
//       body: recordJson
//   );
//   if (response.statusCode == 200) {
//     var json = jsonDecode(response.body);
//     return json["id"];
//   } else {
//     var json = jsonDecode(response.body);
//     return Future.error(json["error"], StackTrace.fromString(response.body));
//   }
// }




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      home: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatefulWidget{

  @override
  _MyHomePage createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage>{

  int present = 0;
  int perPage = 15;

  final originalItems = List<String>.generate(10000, (index) => "Item $index");
  var items = List<String>();

  @override
  void initState(){
    super.initState();
    setState(() {
      items.addAll(originalItems.getRange(present, present + perPage));
      present = present + perPage;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      backgroundColor: Colors.blue,
      appBar: new AppBar(
        title: Text('Hehehehe'),
      ),
      body: ListView.builder(
        itemCount: (present <= originalItems.length) ? items.length + 1 : items.length,
        itemBuilder: (context , index){
          return (index == items.length) 
          // ? Container(
          //   color: Colors.greenAccent,
          //   child: FlatButton(
          //     child: Text("Load More"),
          //     onPressed: (){
          //       setState(() {
          //         if((present + perPage) > originalItems.length){
          //           items.addAll(originalItems.getRange(present, originalItems.length));
          //         }else{
          //           items.addAll(originalItems.getRange(present, present + perPage));
          //         }
          //         present = present + perPage;
          //       });
          //     },
          //   ),
          // )
          ? RefreshIndicator(child: CircularProgressIndicator(), onRefresh: null)
          : ListTile(
            title: Text('${items[index]}'),
          );
        },
      ),
    );
  }
}