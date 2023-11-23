import "package:localstorage/localstorage.dart";

import "diary.dart";
import "entry.dart";

class Storage {
  static final Storage instance = Storage._();

  final LocalStorage _storage = LocalStorage("diary");

  Storage._();

  Future<void> save() async {
    Map<String, dynamic> json = {};
    for (Entry entry in Diary.instance.entries) {
      json[entry.id.toString()] = entry.toJson();
    }
    await _storage.setItem("entries", json);
  }

  Future<void> load() async {
    await _storage.ready;
    Map<String, dynamic>? json = _storage.getItem("entries");
    if (json == null) {
      return;
    }
    for (String key in json.keys) {
      Diary.instance.addEntry(Entry.fromJson(json[key]));
    }
  }
}
