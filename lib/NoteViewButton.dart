import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'FileManager.dart';
import 'MainScreen.dart';

class NoteViewButton extends StatefulWidget {
  final String path;
  NoteViewButton({Key? key, required this.path}) : super(key: key);

  @override
  _NoteViewButtonState createState() => _NoteViewButtonState();
}

class _NoteViewButtonState extends State<NoteViewButton> {
  String text = '';
  bool deleting = false;
  Widget current_widget = new Container();

  @override
  void initState() {
    FileManager File = FileManager(widget.path);
    File.readFile().then((value) => setState(() {
      text = value.short;
      current_widget = first_position();}));
    super.initState();
  }

  void onPressDelete()
  {
    setState(() {
      current_widget = second_position();
    });
    deleting = true;
    Future(() async{
      for (int i = 0; i < 300; i++)
        {
          await Future.delayed(new Duration(milliseconds: 10));
          if (deleting = false)
            {
              setState(() {
                current_widget = first_position();
              });
              return;
            }
        }
      FileManager File = FileManager(widget.path);
      await File.deleteFile();
      need_reload = true;
      setState(() {
        current_widget = new Container();
      });
    });
  }

  void onPressCancel()
  {
    deleting = false;
  }

  void onTapTextEdit()
  {
    Navigator.pushNamed(context, '/textEdit', arguments: widget.path);
  }

  Widget first_position()
  {
    return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white30,
              border: Border.all(color: Colors.blueAccent),
            ),
            child: Center(
              child: Text(text)),
          ),
          onLongPress: onPressDelete,
          onTap: onTapTextEdit,
        );
  }

  Widget second_position()
  {
    return
        GestureDetector(
      child:
      Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [BoxShadow(blurRadius: 3)]
        ),
        child: Center(
          child:Text('long tap for cancel')),
      ),
      onLongPress: onPressCancel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: current_widget,
      height: 100,
    );
  }

}