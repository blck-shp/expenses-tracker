import 'package:flutter/material.dart';
import 'sizes.dart';


class ButtonFilled extends MaterialButton{

  final double width;
  final double height;
  final double fontSize;
  final String text;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final Object nextPage;

  ButtonFilled({this.width, this.height , this.fontSize , this.text , this.backgroundColor , this.fontWeight , this.nextPage});

  @override

  Widget build(BuildContext context){
    return MaterialButton(
      height: displayHeight(context) * height,
      minWidth: displayWidth(context) * width,
      onPressed: (){
          Route route = MaterialPageRoute(builder: (context) => nextPage);
          Navigator.push(context , route);
      },
      color: backgroundColor,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

class ButtonChoices extends MaterialButton{

  final double width;
  final double height;
  final double fontSize;
  final String text;
  final Color backgroundColor;
  final FontWeight fontWeight;
  final Color fontColor;


  ButtonChoices({this.width , this.height , this.fontSize , this.text , this.backgroundColor , this.fontWeight , this.fontColor});

  @override

  Widget build(BuildContext context){
    bool choice;
    return MaterialButton(
      height: displayHeight(context) * height,
      minWidth: displayWidth(context) * width,
      onPressed: (){
        
      },
      
      color: choice == true ? backgroundColor : Color(0xffffffff),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: choice == true ? fontColor : Color(0xff555555),
        ),
      ),
    );
  }

}

                    // child: DatePicker(
                    //         DateTime.now(),
                    //         dateTextStyle: TextStyle(
                    //           backgroundColor: Colors.red,
                    //         ),
                    //         initialSelectedDate: DateTime.now(),
                    //         selectionColor: Colors.black,
                    //         selectedTextColor: Colors.white,
                    //         onDateChange: (date){
                              
                    //           setState(() {
                                
                    //           });
                    //         },                
                    // ),

class TextLink extends Text{

  final String text;
  final double fontSize;
  final Color fontColor;
  final Object nextPage;

  TextLink({this.text , this.fontSize , this.fontColor , this.nextPage}) : super('');

  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Route route = MaterialPageRoute(builder: (context) => nextPage);
        Navigator.push(context , route);
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: fontColor,
        ),
      ),
    );
  }
}

class IconLink extends GestureDetector{

  final String text;
  final Icon icon;
  final double fontSize;
  final FontWeight fontWeight;
  final Color fontColor;
  final Object nextPage;

  IconLink({this.text , this.icon , this.fontSize , this.fontWeight , this.fontColor , this.nextPage});

  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        // Route route = MaterialPageRoute(builder: (context) => nextPage);
        // Navigator.push(context , route);
        Future.delayed(Duration.zero, (){
          Navigator.of(context).push(MaterialPageRoute(builder: (_) => nextPage));
        });
        
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: icon,
          ),
          Expanded(
            flex: 2,
            child: Text(text, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight , color: fontColor)),
          ),
        ],
      ),
    );
  }
}

class FloatingButton extends FloatingActionButton{

  final Object nextPage;

  FloatingButton({this.nextPage});

  Widget build(BuildContext context){
    return FloatingActionButton(
      onPressed: (){
        Route route = MaterialPageRoute(builder: (context) => nextPage);
        Navigator.push(context , route); 
      },
      backgroundColor: Color(0xff246c55),
      child: Icon(Icons.add),
    );
  }
}

class DeleteRecord extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text("Warning"),
      content: Text("Are you sure you want to delete this note?"),
      actions: <Widget>[
        FlatButton(
          child: Text("Yes"),
          onPressed: (){
            Navigator.of(context).pop(true);
          },
        ),
        FlatButton(
          child: Text("No"),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}


class ErrorMessage extends StatelessWidget{

  final String header;
  final String text;

  ErrorMessage({this.header , this.text});

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(header),
      content: Text(text),
      actions: <Widget>[
        FlatButton(
          child: Text("Ok"),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}

// class Input extends TextFormField{

//   final String labelText;

//   Input({this.labelText});

//   Widget build(BuildContext context){
//     return TextFormField(
//       decoration: InputDecoration(
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xff555555),
//           ),
//         ),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             // color: Color(0xff246c55),
//             color: Colors.red,
//             width: 2.0,
//           ),                            
//         ),
//         focusColor: Color(0xff246c55),
//         focusedErrorBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xff246c55),
//           ),                            
//         ),
//         labelText: labelText,
//         labelStyle: TextStyle(
//           color: Color(0xff555555),
//         ),
//       ),
//     );
//   }
// }