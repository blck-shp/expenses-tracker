import 'package:expenses_tracker/Main/list_records.dart';
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

class DeleteRecord extends StatelessWidget{

  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text("Warning"),
      content: Text("Are you sure you want to delete this note?"),
      actions: <Widget>[
        FlatButton(
          child: Text("No"),
          onPressed: (){
            Navigator.of(context).pop(false);
          },
        ),
        FlatButton(
          child: Text("Yes"),
          onPressed: (){
            Navigator.of(context).pop(true);
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
          child: Text("OK"),
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
      title: Text(header),
      content: Text(text),
      actions: <Widget>[
        FlatButton(
          child: Text("NO"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("YES"),
          onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
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
      title: Text(header),
      content: Text(text),
      actions: <Widget>[
        FlatButton(
          child: Text("NO"),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text("YES"),
          onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListRecords(hash: hash)));
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
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
      ],
    );
  }
}
