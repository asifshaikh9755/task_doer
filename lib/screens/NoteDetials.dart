import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_doer/Database_helper.dart';
import '../Note.dart';

class NoteDetials extends StatefulWidget {
  final String AppBarTitle;
  final Note note;

  const NoteDetials(this.note, this.AppBarTitle);

  @override
  _NoteDetialsState createState() {
    return _NoteDetialsState(this.note, this.AppBarTitle);
  }
}

class _NoteDetialsState extends State<NoteDetials> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  String AppBarTitle;
  Note note;
  static var _priorities = ['High', 'Low'];

  _NoteDetialsState(this.note, this.AppBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
              title: Text(AppBarTitle),
              backgroundColor: Colors.purple,
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                },
              )),
          body: Padding(
              padding: EdgeInsets.all(10.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListView(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child: new ListTile(
                            leading: const Icon(Icons.low_priority),
                            title: DropdownButton(
                              items:
                                  _priorities.map((String dropDownStringItem) {
                                return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(
                                      dropDownStringItem,
                                      style: TextStyle(fontSize: 20.0),
                                    ));
                              }).toList(),
                              value: _getPriorityAsString(note.priority),
                              onChanged: (valueSelectedByUser){
                                _updatePriorityAsInt(valueSelectedByUser);
                              },
                            ))),

            ///
            Padding(
              padding: EdgeInsets.all(10.0),
              child:TextField(
                controller: titleController,
                style: textStyle,
                onChanged: (value){
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelText: 'title',
                  labelStyle: textStyle,
                  icon: Icon(Icons.title)
                ),
              ),
            ),

                    ///
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:TextField(
                        controller: descriptionController,
                        style: textStyle,
                        onChanged: (value){
                          updateDescription();
                        },
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: textStyle,
                            icon: Icon(Icons.details)
                        ),
                      ),
                    ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child:
           Row(
             children: <Widget>[
               Expanded(child: RaisedButton(
                 textColor: Colors.white,
                 color: Colors.green,
                 padding: EdgeInsets.all(10.0),
                 child: Text('save',textScaleFactor: 1.5,),
               onPressed: (){
                   setState(() {
                     debugPrint('save button click');
                     _save();
                   });

               },
               )
               ),
               Container(
                 width: 5.0,
               ),
               Expanded(child: RaisedButton(
                 textColor: Colors.white,
                 color: Colors.green,
                 padding: EdgeInsets.all(10.0),
                 child: Text('delete',textScaleFactor: 1.5,),
                 onPressed: (){
                   setState(() {
                     debugPrint('save button click');
                     _delete();
                   });

                 },
               )
               )
             ],
           )   ,
            )

                  ],
                ),
              )),
        ));
  }

  void _save() async {
    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (note.id != null) {
      result = await databaseHelper.updateNote(note);
    } else {
      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
      _showAlertDailog('Status', 'Note Saved Successfully');
    } else {
      _showAlertDailog('Status', 'Problem Saving Note');
    }
  }

  void _delete() async {
    moveToLastScreen();

    if (note.id == null) {
      _showAlertDailog('Status', 'Frist add a note');
    }

    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDailog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDailog('Status', 'Error');
    }
  }

  //convert int to save into database
  void _updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  //convert int to string to show user
  String _getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  void updateTitle() {
    note.title = titleController.text;
  }

  void updateDescription() {
    note.description = titleController.text;
  }

  void _showAlertDailog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
