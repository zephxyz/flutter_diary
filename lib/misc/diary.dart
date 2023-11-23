import 'dart:collection';

import 'package:diary/misc/storage.dart';

import 'entry.dart';

class Diary {
  static final Diary instance = Diary._();

  final LinkedList<Entry> _entries = LinkedList<Entry>();

  Entry? _head;
  Entry? _tail;
  Entry? _current;

  bool _isLoaded = false;

  Diary._() {
    _current = null;
    _head = null;
    _tail = null;
  }

  Entry? get current => _current;

  LinkedList<Entry> get entries => _entries;

  void addNew(String text, DateTime date) {
    if (_entries.isEmpty) {
      Entry entry = Entry(date, text, 1);
      _entries.add(entry);
      _current = entry;
      _head = entry;
      _tail = entry;
      return;
    }
    Entry entry = Entry(date, text, _tail!.id + 1);
    _entries.add(entry);
    _tail = entry;
    _current = entry;
  }

  void addEntry(Entry entry) {
    if (_entries.isEmpty) {
      _entries.add(entry);
      _current = entry;
      _head = entry;
      _tail = entry;
      return;
    }
    _entries.add(entry);
    _tail = entry;
    _current = entry;
  }

  void removeCurrent() {
    if (_entries.isEmpty) {
      throw Exception("No entries to remove");
    }
    if (_current == _head) {
      _head = _head?.next;
    }
    if (_current == _tail) {
      _tail = _tail?.previous;
    }
    Entry? temp = _current?.next;
    _entries.remove(_current!);
    if (temp == null) {
      _current = _tail;
      return;
    }
    _current = temp;
  }

  void goToNext() {
    if (_current == _tail) {
      _current = _head;
      return;
    }
    _current = _current?.next;
  }

  void goToPrev() {
    if (_current == _head) {
      _current = _tail;
      return;
    }
    _current = _current?.previous;
  }

  Future<void> save() async {
    await Storage.instance.save();
  }

  Future<void> load() async {
    if (_isLoaded) {
      return;
    } else {
      await Storage.instance.load();
      _isLoaded = true;
    }
  }
}
