import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget{
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp>{
  bool yes=false;
  Container hey(){
    Container(
      height: 40,
      width: 40,
      color: yes?Colors.black:Colors.red,
    );
  }
  @override
  Widget build(BuildContext context){
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: Column(
                  children: [
                    hey(),
                    TextButton(
                      child: Text("Change"),
                      onPressed: (){
                        setState(() {
                          yes=!yes;
                        });
                      },
                    )
                  ],
                )
            )
        )
    );
  }
}