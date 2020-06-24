// ========================= Generate hash ===========================

  // String generateMd5(String input){
  //   return md5.convert(utf8.encode(input)).toString();
  // }


// bool email = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(_controller2.text);
// print('The value of email is $email');
// if(email == false){
//   showDialog(
//     context: context,
//     builder: (_) => ErrorMessage(header: "Error" , text: "Invalid email address. Please try again."),                        
//   );                              
// }else if(_controller3.text != _controller4.text){
//   showDialog(
//     context: context,
//     builder: (_) => ErrorMessage(header: "Error" , text: "Passwords don't match. Please try again."),                        
//   );
// }else{
//   print('hehehehe');

//   bool flag = false;
//   int number;

//   do{
//     Random value = new Random();
//     number = value.nextInt(1000000);

//     bool loop = false;

//     for(var i = 0 ; i < numbers.length; i++){
//       if(numbers[i] == number){
//         loop = true;
//         break;
//       }
//     }

//     if(loop == false){
//       flag = true;
//     }

//   }while(flag == false);

//   if(flag == true){
//     print('The number is $number');

//     numbers.add(number);

//     var hash = generateMd5(number.toString());

//     for(var i = 0; i < numbers.length; i++){
//       print('The array of number is ${numbers[i]}');
//     }
//     createAccount(_controller1.text , _controller2.text , _controller3.text , hash);
//   }
// }



// class SampleData{
//   int id;
//   String name;
//   String icon;

//   SampleData({this.id, this.name , this.icon});
// }







// ============================

      // : FutureBuilder<ListRecordsCategory>(
      //   future: searchRecords(hash, searchValue),
      //   builder: (context, snapshot){
      //     if(snapshot.connectionState == ConnectionState.done){
      //       if(snapshot.hasError){
      //         return Center(child: Text("Error"));
      //       }
      //       return ListView.separated(
      //         addAutomaticKeepAlives: true,
      //         itemBuilder: (_, index){

      //           String date = snapshot.data.records[index].date;
      //           String dateWithT = date.substring(0, 10);

      //           return Dismissible(
      //             key: ValueKey(snapshot.data.records[index].id),
      //             direction: DismissDirection.startToEnd,
      //             onDismissed: (direction){
      //               setState(() {
      //                 items.removeAt(index);
      //               });
      //             },
      //             confirmDismiss: (direction) async{
      //               final result = await showDialog(
      //                 context: context,
      //                 builder: (_) => DeleteRecord(),
      //               );
      //               if(result == true){
      //                 deleteRecord(hash, snapshot.data.records[index].id);
      //               }
      //               return result;
      //             },
      //             background: Container(
      //               color: Colors.red,
      //               padding: EdgeInsets.only(left: 10.0),
      //               child: Align(child: Icon(Icons.delete, color: Color(0xffffffff)) , alignment: Alignment.centerLeft,)
      //             ),
                  
      //             child: ListTile(
      //               leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${icons[snapshot.data.records[index].category.id - 1]}')),
      //               title: Text('P' + '${snapshot.data.records[index].amount}' + '0'),
      //               subtitle: Text('${snapshot.data.records[index].category.name}' + ' — ' + '${snapshot.data.records[index].notes}'),
      //               trailing: Text('$dateWithT', style: TextStyle(fontSize: 12.0,),),

      //               onTap: (){
      //                 String notes = snapshot.data.records[index].notes;
      //                 String amount = snapshot.data.records[index].amount.toString();
                      
      //                 String date = snapshot.data.records[index].date.substring(0, 10);
      //                 DateTime finalDate = DateTime.parse(date);

      //                 String time = snapshot.data.records[index].date;
      //                 DateTime finalTime = DateTime.parse(time);

      //                 String categoryName = snapshot.data.records[index].category.name;

      //                 int recordType = snapshot.data.records[index].recordType;
      //                 int categoryId = snapshot.data.records[index].category.id;

      //                 int id = snapshot.data.records[index].id;

      //                 Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id))); 
      //               },

      //               onLongPress: ()async{
      //                 final result = await showDialog(
      //                   context: context,
      //                   builder: (_) => DeleteRecord(),
      //                 );
      //                 if(result == true){
      //                   deleteRecord(hash, snapshot.data.records[index].id);
      //                   setState(() {
      //                   });
      //                 }
      //               },
      //             ),
      //           );
      //         }, 
      //         separatorBuilder: (_, __) => Divider(height: 0),
      //         itemCount: snapshot.data.pagination.count,
      //       );
      //     }else{
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   }
      // ),



      // ? Column(
      //   children: <Widget>[
      //     Expanded(
      //       child: NotificationListener<ScrollNotification>(
      //         onNotification: (ScrollNotification scrollInfo){
      //           if(!isLoading2 && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent){
      //             searchRecords(hash, searchValue, count2);
      //             setState(() {
                    
      //               isLoading2 = true;
      //               count2 = count2 + 1;  
      //             }); 
      //           }
      //           return isLoading2;
      //         },
      //         child: ListView.separated(
      //           itemCount: items2.length,
      //           separatorBuilder: (_, __) => Divider(height: 0),
      //           itemBuilder: (_, index){

      //             String date = items2[index].date;
      //             String dateWithT = date.substring(0, 10);

      //             return Dismissible(
      //               key: ValueKey(items2[index].id),
      //               direction: DismissDirection.startToEnd,
      //               onDismissed: (direction){
      //                 setState(() {
      //                   items2.removeAt(index);
      //                 });
      //               },
      //               confirmDismiss: (direction) async{
      //                 final result = await showDialog(
      //                   context: context,
      //                   builder: (_) => DeleteRecord(),
      //                 );
      //                 if(result == true){
      //                   deleteRecord(hash, items2[index].id);
      //                 }
      //                 return result;
      //               },
      //               background: Container(
      //                 color: Colors.red,
      //                 padding: EdgeInsets.only(left: 10.0),
      //                 child: Align(child: Icon(Icons.delete, color: Color(0xffffffff)) , alignment: Alignment.centerLeft,)
      //               ),
                    
      //               child: ListTile(
      //                 leading: IconTheme(data: IconThemeData(size: 10.0), child: Image.asset('assets'+'${icons[items2[index].category.id - 1]}')),
      //                 title: Text('P' + '${items2[index].amount}' + '0'),
      //                 subtitle: Text('${items2[index].category.name}' + ' — ' + '${items2[index].notes}'),
      //                 trailing: Text('$dateWithT', style: TextStyle(fontSize: 12.0,),),

      //                 onTap: (){
      //                   String notes = items2[index].notes;
      //                   String amount = items2[index].amount.toString();
                        
      //                   String date = items2[index].date.substring(0, 10);
      //                   DateTime finalDate = DateTime.parse(date);

      //                   String time = items2[index].date;
      //                   DateTime finalTime = DateTime.parse(time);

      //                   String categoryName = items2[index].category.name;

      //                   int recordType = items2[index].recordType;
      //                   int categoryId = items2[index].category.id;

      //                   int id = items2[index].id;

      //                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => ModifyRecord(isEmpty: false, hash: hash, notes: notes, amount: amount, date: finalDate, time: finalTime, categoryName: categoryName, recordType: recordType, categoryId: categoryId, id: id))); 
      //                 },

      //                 onLongPress: ()async{
      //                   final result = await showDialog(
      //                     context: context,
      //                     builder: (_) => DeleteRecord(),
      //                   );
      //                   if(result == true){
      //                     deleteRecord(hash, items2[index].id);
      //                     setState(() {
      //                     });
      //                   }
      //                 },
      //               ),
      //             );
      //           }, 
      //         ),
      //       ),
      //     ),
      //     Container(
      //       height: isLoading2 ? 50.0 : 0,
      //       color: Colors.transparent,
      //       child: Center(
      //         child: new CircularProgressIndicator(),
      //       ),
      //     ),
      //   ],
      // )