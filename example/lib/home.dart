import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'app_state.dart';
import 'widgets/logs_view.dart';
import 'widgets/actions_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String broadcaster = 'pusher';
  List<LogString> logs = [];

  log(String event) {
    var now = DateTime.now();
    String date = now.hour.toString().padLeft(2, '0');
    date += ":${now.minute.toString().padLeft(2, '0')}";
    date += ":${now.second.toString().padLeft(2, '0')}";
    print('$date: $event');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => logs.insert(0, LogString(date: date, text: event)));
    });
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
            setState(() => broadcaster = value);
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
      body: AppState(
        logs: logs,
        log: log,
        child: Scaffold(
          body: Column(
            children: [
              const Flexible(child: LogsView()),
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: ActionsView(broadcaster: broadcaster),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
