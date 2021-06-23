import 'dart:async';

import 'package:flutter/material.dart';
import 'package:untitled/FileManager.dart';
import 'package:untitled/NoteViewButton.dart';
import 'package:loading_animations/loading_animations.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ButtonRows(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.pushNamed(context, '/textEdit', arguments: null);
      })
    );

  }
}

class NoteList extends StatelessWidget
{
  List<Widget> list = [];

  NoteList(value){
    for (String path in value)
      list.add(NoteViewButton(path: path));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(children: list);
  }
}


bool need_reload = true;

class ButtonRows extends StatefulWidget{

  _ButtonRowsState state = _ButtonRowsState();

  @override
  _ButtonRowsState createState() {
    return state;
  }

}

class _ButtonRowsState extends State<ButtonRows> {
  Widget child = Center(child: LoadingBouncingGrid(),);
  bool active = true;

  Future reload() async
  {
    setState(() {child = Center(child: LoadingBouncingGrid(),);});
    FileManager.allFilePath.then((value) {
      setState(() {child = NoteList(value);});
      });
  }

  @override
  initState() {
    Future(() async {
      while (active)
        {
          await Future.delayed(new Duration(milliseconds: 1));
          if (need_reload)
            {
              need_reload = false;
              await reload();
            }
        }
    });
  super.initState();
  }

  @override
  void dispose() {
    active = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return child;
  }
}