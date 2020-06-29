import 'package:flutter/material.dart';

class TextInputDecoration extends StatelessWidget{
  
  final TextEditingController controller;
  final String name;
  final bool obscureText;

  TextInputDecoration({this.controller, this.name, this.obscureText});

  Widget build(BuildContext context){
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: (value){
        if(value.isEmpty)
          return null;
        return null;
      },
      
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff555555),
            width: 1.0,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xff246c55),
            width: 2.0,
          ),                            
        ),
        focusColor: Color(0xff246c55),
        labelText: name,
        labelStyle: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          color: Color(0xff555555),
        ),
      ),
    );
  }
}

class TextLink extends Text{

  final String text;
  final double fontSize;
  final Color fontColor;
  final Object nextPage;

  TextLink({this.text , this.fontSize , this.fontColor , this.nextPage}) : super('');

  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => nextPage));
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
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => nextPage));
        // Navigator.of(context).pushReplacement(nextPage);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextPage));
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

// class LogoutLink extends GestureDetector{

//   final String text;
//   final Icon icon;
//   final double fontSize;
//   final FontWeight fontWeight;
//   final Color fontColor;
//   final Object nextPage;

//   LogoutLink({this.text , this.icon , this.fontSize , this.fontWeight , this.fontColor , this.nextPage});

//   Widget build(BuildContext context){
//     return GestureDetector(
//       onTap: (){
//         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => nextPage));
//         // Navigator.of(context).pushReplacement(nextPage);
//         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => nextPage));
//       },
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: icon,
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(text, style: TextStyle(fontSize: fontSize, fontWeight: fontWeight , color: fontColor)),
//           ),
//         ],
//       ),
//     );
//   }
// }

class DeleteRecord extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text("Warning", 
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff555555),
        ),
      ),
      content: Text("Are you sure you want to delete this note?", 
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          color: Color(0xff555555),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("No", 
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff555555),
            ),
          ),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text("Yes", 
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          onPressed: (){
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}


class ErrorMessage extends AlertDialog{

  final String header;
  final String text;

  ErrorMessage({this.header , this.text});

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(header,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
          color: Colors.red,
        ),
      ),
      content: Text(text,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          color: Color(0xff555555),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("OK",
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}

class PromptMessage extends StatelessWidget{

  final String header;
  final String text;

  PromptMessage({this.header , this.text});

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(header,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff555555),
        ),
      ),
      content: Text(text,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          color: Color(0xff555555),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("NO", 
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff555555),
            ),
          ),
          onPressed: (){
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: Text("YES", 
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff246c55),
            ),
          ),
          onPressed: (){
            Navigator.pop(context, true);
            // Navigator.popUntil(context, ModalRoute.withName('/'));
            // Navigator.popAndPushNamed(context, '/');
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard(hash: hash,)));
          },
        ),
      ],
    );
  }
}

class DeleteMessage extends StatelessWidget{

  final String header;
  final String text;
  final String hash;

  DeleteMessage({this.header , this.text, this.hash});

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(header, 
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff555555),
        ),
      ),
      content: Text(text, 
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          color: Color(0xff555555),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("NO", 
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Color(0xff555555),
            ),
          ),
          onPressed: (){
            Navigator.pop(context, false);
          },
        ),
        FlatButton(
          child: Text("YES", 
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          onPressed: (){
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}

class ShowMessage extends StatelessWidget{

  final String title, content;

  ShowMessage({this.title, this.content});

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(title, 
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff246c55),
        ),
      ),
      content: Text(content,
        style: TextStyle(
          fontFamily: 'Nunito',
          fontSize: 14.0,
          color: Color(0xff555555),
        ),
      ),
      actions: <Widget>[
      ],
    );
  }
}
