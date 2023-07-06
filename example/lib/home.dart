import 'dart:developer' as dev;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'views/actions.view.dart';
import 'views/log.view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String broadcaster = 'socket.io';
  List<LogString> logs = [];

  log(String event) {
    var now = DateTime.now();
    String date = now.hour.toString().padLeft(2, '0');
    date += ":${now.minute.toString().padLeft(2, '0')}";
    date += ":${now.second.toString().padLeft(2, '0')}";
    dev.log('$date: $event');

    setState(() => logs.insert(0, LogString(date: date, text: event)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CupertinoSegmentedControl(
          children: const {
            'pusher': Text(
              'pusher',
              style: TextStyle(fontSize: 14),
            ),
            'socket.io': Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'socket.io',
                style: TextStyle(fontSize: 14),
              ),
            ),
          },
          onValueChanged: (String value) {
            setState(() {
              broadcaster = value;
            });
            log('switched to $value');
          },
          groupValue: broadcaster,
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => logs.clear()),
            tooltip: 'Clear log',
            icon: const Icon(
              Icons.block,
              color: Colors.grey,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.zero,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Flexible(child: LogView(logs)),
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: ActionsView(broadcaster: broadcaster, log: log),
            ),
          ),
        ],
      ),
    );
  }
}
