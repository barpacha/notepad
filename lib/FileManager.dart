import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class Note{
  final String text;
  final String date;
  String short = '';

  Note(this.text, this.date)
  {
    if (text.length >= 20)
      short += text.substring(0, 20);
    else
      {
        short += text;
        for (int i = 0; i < 20 - text.length; i++)
          short += ' ';
      }
    short += date;
  }
}

class FileManager {
  String _filePath;
  FileManager(this._filePath);

  static Future<List<String>> get allFilePath async
  {
    final path = await _localPath + 'Notes/';
    Directory dir = new Directory(path);
    List<String> list = [];
    for (var file in await dir.list().toList())
      if (file is File) list.add((file as File).path);
    return list;
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    if (!(await Directory(directory.path + 'Notes').exists()))
      await Directory(directory.path + 'Notes').create();
    return directory.path;
  }

  static Future<int> _newNumber() async
  {
    int i = 1;
    int base_lenth = (await _localPath + 'Notes/').length;
    bool unic = false;
    while (true)
      {
        unic = true;
        for (var path in await allFilePath)
          if (path.substring(base_lenth) == i.toString())
          {
            unic = false;
            break;
          }
        if (unic)
          return i;
        i++;
      }
  }

  Future<Note> readFile() async {
    try {
      List<String> text_file = await File(_filePath).readAsLines();
      String text = '';
      for (int i = 1; i < text_file.length; i++)
        text = text_file[i];
      return new Note(text, text_file[0]);
    } catch (e) {
      return new Note('', '');
    }
  }

  Future writeFile(String text) async {
    if (text == '')
      return;
    Note pre_state = await readFile();
    if (text == pre_state.text)
      return;
    File f = File(_filePath);
    DateTime date = DateTime.now();
    await f.writeAsString(DateFormat('yyyy-MM-dd').format(date) + '\n');
    await f.writeAsString(text, mode: FileMode.append);
  }

  Future deleteFile() async {
    try {
      final file = File(_filePath);
      await file.delete();
    } catch (e) {
      return ;
    }
  }

  static Future<String> newFile() async {
    String path = await _localPath + 'Notes/' + (await _newNumber()).toString();
    await File(path).create();
    return path;
  }
}


