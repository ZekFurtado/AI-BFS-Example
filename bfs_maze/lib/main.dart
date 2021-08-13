import 'dart:collection';
import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  // testWidgets('Padding has a number assigned to it',(WidgetTester tester) async{
  //   await tester.pumpWidget(
  //       Padding(
  //           key: Key("6"),
  //           padding: EdgeInsets.all(2),
  //           child: Container()
  //       )
  //   );
  //   expect(find.byKey(Key("6")),findsOneWidget);
  // });
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ]);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
        backgroundColor: Color(0xff015e1a),
        body: Maze()
    )
    );
  }
}
class Maze extends StatefulWidget{
  @override
  MazeState createState() => MazeState();
}

class MazeState extends State<Maze>{
  List<bool> obstcl = [true,false,false,false,false];
  Random random = new Random();
  List<Color> colors = new List();
  Queue<int> bfs_queue = new Queue();
  List<int> already_visited = new List();
  List<int> predecessors = new List(100);
  MazeState(){
    bfs_search();
  }

  void bfs_search(){
    colors.clear();
    bfs_queue.clear();
    already_visited.clear();
    int i;
    colors.add(Colors.lightGreenAccent);
    for(i=1;i<99;i++){
      predecessors[i]=null;
      colors.add(obstcl[random.nextInt(4)]?Colors.red:Colors.white);
    }
    predecessors[99]=null;
    colors.add(Colors.blueAccent);
    bool goal=false;
    bfs_queue.add(0);
    outer: while (bfs_queue.isNotEmpty) {
      for(i=bfs_queue.first;i<99;i=bfs_queue.first) {
        if(!already_visited.contains(i)){
          if ((i + 1) % 10 != 0 && (colors[i + 1] == Colors.white || colors[i + 1] == Colors.blueAccent) && !already_visited.contains(i + 1)) {
            predecessors[i+1]=i;
            if(colors[i + 1] == Colors.blueAccent) {
              goal = true;
              break outer;
            }
            else bfs_queue.add(i + 1);
          }
          if (i % 10 != 0 && (colors[i - 1] == Colors.white) && !already_visited.contains(i - 1)) {
            predecessors[i-1]=i;
            bfs_queue.add(i - 1);
          }
          if ((i <= 89 && (colors[i + 10] == Colors.white || colors[i + 10] == Colors.blueAccent)) && !already_visited.contains(i + 10)) {
            predecessors[i+10]=i;
            if(colors[i + 10] == Colors.blueAccent) {
              goal=true;
              break outer;
            } else bfs_queue.add(i + 10);
          }
          if ((i > 9 && (colors[i - 10] == Colors.white)) && !already_visited.contains(i - 10)) {
            predecessors[i-10]=i;
            bfs_queue.add(i - 10);
          }
          already_visited.add(bfs_queue.first);
        }
        bfs_queue.remove(bfs_queue.first);
        if(bfs_queue.isEmpty) break;
      }
    }
    if(goal){
      for (i; i > 0; i = predecessors[i]) {
        colors[i] = Colors.deepPurpleAccent;
      }
    }
  }
  @override
  Widget build(BuildContext context){
   return Column(
       children: [
         Padding(
             padding: EdgeInsets.fromLTRB(20, 150, 20, 50),
             child:Container(
             decoration: BoxDecoration(
             boxShadow: [
                 BoxShadow(
                 blurRadius: 20
             )
              ],
              color: Color(0xff015e1a),
              ),
               child:GridView.count(
                 padding: EdgeInsets.all(4),
                shrinkWrap: true,
                crossAxisCount: 10,
                children: [
                  Padding(
                      padding: EdgeInsets.all(2),
                      child: Container(
                          height: 4,
                          color: colors[0],
                          child: Text("S",textAlign: TextAlign.center)
                      )
                  ),
                  for(int i=1;i<99;i++) Padding(
                    key: Key(i.toString()),
                   padding: EdgeInsets.all(2),
                   child: Container(
                     height: 4,
                     color: colors[i],
                   )
                  ),
                Padding(
                    padding: EdgeInsets.all(2),
                    child: Container(
                        height: 4,
                        color: colors[99],
                        child: Text("G",textAlign: TextAlign.center)
                    )
                )
              ]
              ))),
             RaisedButton(
               color: Colors.limeAccent,
               textColor: Colors.black,
               elevation: 10,
               child: Text("Restart",style:TextStyle(fontSize: 20)),
               onPressed: (){
                 setState(() {
                   bfs_search();
                 });
               },
             )
       ]
   );
  }
}