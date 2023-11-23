import 'dart:io';

import 'package:diary/misc/diary.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../add_entry_page/add_entry_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _displayText;
  DateTime? _displayDate;
  int? _displayId;

  @override
  void initState() {
    super.initState();

    Diary.instance.load().then((value) => setState(() {
          _displayText = Diary.instance.current?.text;
          _displayDate = Diary.instance.current?.date;
          _displayId = Diary.instance.current?.id;
        }));
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _displayText = Diary.instance.current?.text;
      _displayDate = Diary.instance.current?.date;
      _displayId = Diary.instance.current?.id;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary'),
        actions: [
          IconButton(
              onPressed: () {
                Diary.instance.save().then((_) => {exit(0)});
              },
              icon: const Icon(Icons.close)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
            left: 24.0, right: 24.0, bottom: 128.0, top: 80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              children: [
                Text(
                  _displayId == null ? "No entries" : "Entry $_displayId",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                Text(
                  _displayDate == null
                      ? ""
                      : DateFormat("dd.MM.yyyy").format(_displayDate!),
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  _displayText == null ? "" : _displayText!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.justify,
                  maxLines: 100,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        onPressed: () {
                          Diary.instance.goToPrev();
                          setState(() {});
                        },
                        icon: const Icon(Icons.arrow_back)),
                    IconButton(
                        onPressed: () {
                          Diary.instance.goToNext();
                          setState(() {});
                        },
                        icon: const Icon(Icons.arrow_forward)),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Are you sure?"),
                                  content: const Text(
                                      "This will delete the current entry"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("Cancel")),
                                    TextButton(
                                        onPressed: () {
                                          try {
                                            Diary.instance.removeCurrent();
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          } catch (e) {
                                            Fluttertoast.showToast(
                                                msg: "No entries to remove");
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: const Text("Delete")),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.delete)),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const AddEntryPage()));
                        },
                        icon: const Icon(Icons.add)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
