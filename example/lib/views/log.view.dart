import 'package:flutter/material.dart';

class LogView extends StatelessWidget {
  final List<LogString> logs;
  const LogView(this.logs, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.grey[100],
      child: ListView.builder(
        reverse: true,
        itemCount: logs.length,
        itemBuilder: (BuildContext context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${logs[index].date} ',
                    style: const TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: ' ${logs[index].text}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class LogString {
  final String date;
  final String text;

  LogString({
    required this.date,
    required this.text,
  });
}
