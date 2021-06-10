import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
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
  bool _isVisible = true;

  _NoteDetialsState(this.note, this.AppBarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleController.text = note.title;
    descriptionController.text = note.description;
    return Form(
      key: _formKey,
      child: WillPopScope(
          onWillPop: () {
            moveToLastScreen();
          },
          child: Scaffold(
            appBar: AppBar(
                title: Text(AppBarTitle),
                backgroundColor: Color(0Xff055a8c),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_outlined),
                  onPressed: () {
                    moveToLastScreen();
                  },
                )),
            body: Padding(
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(10.0),
                        child:
                         ListTile(
                            // leading: const Icon(Icons.low_priority),
                            title: DropdownButton(
                              isExpanded: true,
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

                   SizedBox(height: 10,),


                   Padding(
                padding: EdgeInsets.all(10.0),
                child:TextFormField(
                controller: titleController,
                style: textStyle,
                onChanged: (value){
                  updateTitle();
                },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter title';
                    }
                    return null;
                  },
                decoration: InputDecoration(
                  hintText: 'title',
                  labelStyle: textStyle,
                  // icon: Icon(Icons.title)
                ),
                ),
              ),
                    // Image.asset("assets/bg_home.jpg"),
                    SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child:TextFormField(
                        controller: descriptionController,
                        style: textStyle,
                        onChanged: (value){
                          updateDescription();
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Description',
                            labelStyle: textStyle,
                            // icon: Icon(Icons.details)
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),

                     Padding(
                padding: EdgeInsets.all(10.0),
                child:
             Row(
               children: <Widget>[
                 Expanded(child: RaisedButton(
                 textColor: Colors.white,
                 color: Color(0Xff055a8c),
                 padding: EdgeInsets.all(10.0),
                 child: Text('save',textScaleFactor: 1.5,),
                 onPressed: (){
                   if (_formKey.currentState.validate()) {
                     setState(() {
                       debugPrint('save button click');
                       _save();
                     });
                   }
                 },
                 )
                 ),
                 Container(
                 width: 5.0,
                 ),
                 Visibility(
                 visible: _isVisible,
                 child:
                 Expanded(child: RaisedButton(

                 textColor: Colors.black,
                 color: Colors.white,
                 padding: EdgeInsets.all(10.0),
                 child: Text('delete',textScaleFactor: 1.5,),
                 onPressed: (){
                   setState(() {
                     debugPrint('save button click');
                     _delete();
                   });

                 },
                 )
                 ))
               ],
             )   ,
              )

                  ],
                )),
          )),
    );
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
    note.description = descriptionController.text;
  }

  void _showAlertDailog(String title, String message) {
    // AlertDialog alertDialog = AlertDialog(
    //   title: Text(title),
    //   content: Text(message),
    // );
    // showDialog(context: context, builder: (_) => alertDialog);

    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return ClassicGeneralDialogWidget(
          titleText: title,
          contentText: message,
          onPositiveClick: () {
            Navigator.of(context).pop();
          },
          onNegativeClick: () {
            Navigator.of(context).pop();
          },
        );
      },
      animationType: DialogTransitionType.size,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }


}
