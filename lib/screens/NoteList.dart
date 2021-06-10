import 'package:expansion_card/expansion_card.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
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
  Note note;
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
  @override
  Widget build(BuildContext context) {

    if(noteList==null){
      noteList=List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('100 hours work of week',style:
        TextStyle( fontFamily: 'poppins_regular',),),
        backgroundColor: Color(0Xff055a8c),
      ),
      body: Container(child: getNoteListView()),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0Xff055a8c),
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
        return noteList[position].title==null?Container(child: Image.asset("assets/bg_home.jpg")):
        Padding(
        padding: const EdgeInsets.all(8.0),
          child:
            ExpansionTileCard(
              shadowColor: Colors.black,
              baseColor: Colors.cyan[50],
              expandedColor: Colors.white,

              // key: cardA,
         title: Text(this.noteList[position].title,
         style: TextStyle(
               fontFamily: 'poppins_regular',
             fontSize: 17.5,
             color:Colors.black,
             fontWeight: FontWeight.w600,

         ),),
              subtitle: Text(this.noteList[position].date,
                  style: TextStyle(
                      fontFamily: 'poppins_regular',
                      color:Colors.black87,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400
                  )),
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:18.0),
                      child: Text(this.noteList[position].description,
                          style: TextStyle(
                              fontFamily: 'poppins_regular',
                              color:Colors.black87,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400
                          )),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,8,16,8),
                      child: GestureDetector(
                          child: Icon(Icons.edit,size: 22,),
                          onTap: (){
                            setState(() {
                              debugPrint('save button click');
                              // _delete();
                            });
                            navigateToDetailsScreen(this.noteList[position],'Edit Todo');
                          }
                      ),
                    ),
                  ],
                )

              ],
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

  // void _delete() async {
  //   // moveToLastScreen();
  //
  //   if (note.id == null) {
  //     _showAlertDailog('Status', 'Frist add a note');
  //   }
  //
  //   int result = await databaseHelper.deleteNote(note.id);
  //   if (result != 0) {
  //     _showAlertDailog('Status', 'Note Deleted Successfully');
  //   } else {
  //     _showAlertDailog('Status', 'Error');
  //   }
  // }

  void _showAlertDailog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
