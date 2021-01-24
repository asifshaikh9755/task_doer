class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  Note(this._title, this._date, this._priority, [this._description]);

  Note.withID(this._id, this._title, this._date, this._priority,
      [this._description]);

  int get priority => _priority;

  String get date => _date;

  String get description => _description;

  String get title => _title;

  int get id => _id;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set description(String newdescription) {
    if (newdescription.length <= 255) {
      this._description = newdescription;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._priority = newPriority;
    }
  }

//convert note object to map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }

    map['title']=_title;
    map['description']=_description;
    map['date']=_date;
    map['priority']=_priority;
    return map;
  }

  Note.fromMapObject(Map<String,dynamic> map){
    this._id=map['id'];
    this._title=map['title'];
    this._description=map['description'];
    this._date=map['date'];
    this._priority=map['priority'];
  }
}
