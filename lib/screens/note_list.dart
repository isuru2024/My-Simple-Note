import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_simple_notes/models/note.dart';
import 'package:my_simple_notes/utils/database_helper.dart';
import 'package:my_simple_notes/screens/note_detail.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int count = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note>? noteList;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = <Note>[];
      updateListView();
      print("Build");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Simple Note'),
        backgroundColor:
            Theme.of(context).primaryColorDark, // AppBar background color
        foregroundColor:
            Theme.of(context).primaryColorLight, // AppBar text/icon color
      ),
      body: getNoteListView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("FAB clicked");
          navigateToDetail(Note('', '', 2), 'Add Note');
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add),
        backgroundColor:
            Theme.of(context).primaryColorDark, // AppBar background color
        foregroundColor:
            Theme.of(context).primaryColorLight, // AppBar text/icon color
      ),
    );
  }

  ListView getNoteListView() {
    TextStyle? titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.noteList![position].priority!),
              child: getPriorityIcon(this.noteList![position].priority!),
            ),
            title: Text(
              this.noteList![position].title!,
              style: titleStyle,
            ),
            subtitle: Text(this.noteList![position].date!),
            trailing: GestureDetector(
              child: Icon(
                Icons.delete,
                color: Colors.grey,
              ),
              onTap: () {
                _delete(context, noteList![position]);
              },
            ),
            onTap: () {
              print("ListTile Tapped");
              navigateToDetail(this.noteList![position], 'Edit Note');
            },
          ),
        );
      },
    );
  }

  // Colors according to the priority
  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;
      default:
        return Colors.yellow;
    }
  }

  // Icon according to the priority
  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.album_rounded);
      case 2:
        return Icon(Icons.album_outlined);
      default:
        return Icon(Icons.album_outlined);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id!);
    if (result != 0) {
      _showSnackBar(context, 'Note Deleted Successfully!');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Note note, String title) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return NoteDetail(note, title);
        },
      ),
    );
    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
