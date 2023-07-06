import 'package:flutter/material.dart';

class LeaveChannelView extends StatefulWidget {
  final ValueChanged<String?> onLeave;
  final List<String> listeningChannels;

  const LeaveChannelView({
    Key? key,
    required this.onLeave,
    required this.listeningChannels,
  }) : super(key: key);

  @override
  createState() => _LeaveChannelViewState();
}

class _LeaveChannelViewState extends State<LeaveChannelView> {
  late String name;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    if (widget.listeningChannels.isNotEmpty) {
      name = widget.listeningChannels.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.listeningChannels.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No listening channels',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          DropdownButton<String>(
            value: name,
            isExpanded: true,
            hint: const Text('Please choose channel name'),
            items: widget.listeningChannels.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) => setState(() => name = value!),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(44),
            ),
            child: const Text(
              'Leave',
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () => widget.onLeave(name),
          ),
        ],
      ),
    );
  }
}
