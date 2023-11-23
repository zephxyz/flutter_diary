import 'dart:collection';

base class Entry extends LinkedListEntry<Entry> {
  final DateTime _date;
  final String _text;
  final int _id;

  Entry(this._date, this._text, this._id);

  Entry.fromJson(Map<String, dynamic> json)
      : _date = DateTime.parse(json["date"]),
        _text = json["text"],
        _id = json["id"];

  DateTime get date => _date;
  String get text => _text;
  int get id => _id; 

  Map<String, dynamic> toJson() {
    return {
      "date": _date.toIso8601String(),
      "text": _text,
      "id": _id,
    };
  }
}


