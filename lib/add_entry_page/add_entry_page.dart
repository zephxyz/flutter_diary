import 'package:flutter/material.dart';
import 'package:diary/misc/diary.dart';
import 'package:intl/intl.dart';

import '../home_page/home_page.dart';

class AddEntryPage extends StatefulWidget {
  const AddEntryPage({super.key});

  @override
  State<AddEntryPage> createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  String? _text;
  DateTime? _date;
  String? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                },
                icon: const Icon(Icons.arrow_back)),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Add Entry',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter your entry here',
                  ),
                  onChanged: (value) => {
                    _text = value,
                  },
                  maxLines: 10,
                  maxLength: 1000,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100))
                          .then((value) => setState(() {
                                _date = value!;
                              }));
                    },
                    child: Text(_date == null
                        ? "Select Date"
                        : DateFormat('dd.MM.yyyy').format(_date!))),
                Text(error ?? ""),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        child: const Text('Cancel')),
                    ElevatedButton(
                        onPressed: () {
                          if (_text == null || _date == null) {
                            setState(() {
                              error = "Please fill all fields";
                            });
                            return;
                          }
                          Diary.instance.addNew(_text!, _date!);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()));
                        },
                        child: const Text('Save')),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
