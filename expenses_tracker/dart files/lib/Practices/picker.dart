// import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main(){
  runApp(
    MaterialApp(
      home: Picker(),
    ),
  );
}

class Picker extends StatefulWidget{
  @override
  _Picker createState() => _Picker();
}

class _Picker extends State<Picker>{

  DateTime _dateTime = DateTime.now();
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.blue,
                // child: Text('$_dateTime'),
              ),
            ),
            Expanded(
              child: TextFormField(
                readOnly: true,
                showCursor: true,
                controller: _controller,
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

                                            // String formatDateTime(DateTime dateTime){
                                            //   return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
                                            // }

                                            // _controller.text = _dateTime.toString();

                                            String formatDateTime(DateTime dateTime){
                                              return '${dateTime.hour}:${dateTime.minute}';
                                            }
                                            _controller.text = formatDateTime(_dateTime).toString();

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

        //                   FlatButton(
        //   child: Text("Yes"),
        //   onPressed: (){
        //     Navigator.of(context).pop(true);
        //   },
        // ),
                // onTap: (){
                //   setState(() {
                //     CupertinoDatePicker(
                    
                //       use24hFormat: true,
                //       initialDateTime: _dateTime,
                //       onDateTimeChanged: (dateTime){
                //         print(dateTime);
                //         setState(() {
                //           _dateTime = dateTime;
                //           // _controller.text = _dateTime.toString();
                //         });
                //       },
                //     );
                //   });
                // },
              ),


            ),
          ],
        )
      ),
    );
  }
}