import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:untitled/FileManager.dart';
import 'package:untitled/MainScreen.dart';

class EditScreen extends StatelessWidget {
  String? path;
  EditScreen(this.path);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
        ),
        body: _TextEditor(path),
    );
  }

}

class _TextEditor extends StatefulWidget
{
  final String? path;

  _TextEditor(this.path);

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<_TextEditor>{
  String path = '';
  Widget child = Center(child: LoadingBouncingGrid(),);
  String text = '';
  TextEditingController _controller = TextEditingController();

  Future _saveFile() async
  {
    FileManager File = new FileManager(path);
    File.writeFile(_controller.text);
  }

  void _loadText(String? text)
  {
    _controller.text = text ?? '';
    setState(() {
    child = TextField(controller: _controller, onSubmitted: (val) {
      FocusScope.of(context).requestFocus(FocusNode());
    },);});
  }

  @override
  void initState() {
    if (widget.path != null)
      {
        FileManager File = new FileManager(widget.path!);
        File.readFile().then((value) => setState(() {
          path = widget.path!;
          text = value.text;
          _loadText(text);
        }));
      }
    else
      FileManager.newFile().then((value) => setState(() {
        path = value;
        text = '';
        _loadText(text);
      }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: child, onWillPop: () async {
      if (_controller.text == '')
        {
          FileManager File = new FileManager(path);
          await File.deleteFile();
        }
      else await _saveFile();
      need_reload = true;
      return true;});
  }
}