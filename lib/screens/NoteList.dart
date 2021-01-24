import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_doer/Note.dart';
import '../Database_helper.dart';
import 'package:sqflite/sql.dart';
import 'NoteDetials.dart';
import 'dart:async';

class NoteList extends StatefulWidget {
  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;
  int count = 0;

  @override
  Widget build(BuildContext context) {

    if(noteList==null){
      noteList=List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Doer'),
        backgroundColor: Colors.purple,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          navigateToDetailsScreen(Note('', '', 2), 'Add Note');
        },
      ),
    );
  }

  void navigateToDetailsScreen(Note note, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetials(note, title);
    }));

    if (result == true) {
      //update view
      updateListView();
    }
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, position) {
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          color:Colors.white,
          elevation: 4.0,
          child: ListTile(
         title: Text(this.noteList[position].title,
         style: TextStyle(
           color:Colors.black,
           fontWeight: FontWeight.w700,
           fontSize: 25.0
         ),),
            subtitle: Text(this.noteList[position].date,
                style: TextStyle(
                    color:Colors.black87,
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0
                )),
            trailing: GestureDetector(
              child: Icon(Icons.open_in_new),
              onTap: (){navigateToDetailsScreen(this.noteList[position],'Edit Todo');}
            ),

          ),
        );
      },
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = databaseHelper.getNotList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
