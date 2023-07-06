import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChannelOptions {
  final String channelName;
  final ChannelType channelType;
  final String event;

  ChannelOptions(this.channelName, this.channelType, this.event);
}

enum ChannelType {
  public,
  private,
  presence,
}

class ListenToChannelView extends StatefulWidget {
  final ValueChanged<ChannelOptions> onListen;

  const ListenToChannelView({
    Key? key,
    required this.onListen,
  }) : super(key: key);

  @override
  createState() => _ListenToChannelViewState();
}

class _ListenToChannelViewState extends State<ListenToChannelView> {
  String channelName = 'public-channel';
  String event = 'PublicEvent';
  ChannelType channelType = ChannelType.public;
  late TextEditingController channelNameController;
  late TextEditingController eventController;

  @override
  void initState() {
    super.initState();
    channelNameController = TextEditingController(text: channelName);
    eventController = TextEditingController(text: event);
  }

  void onChannelTypeChange(ChannelType value) {
    switch (value) {
      case ChannelType.private:
        channelName = 'private-channel.1';
        event = 'PrivateEvent';
        break;
      case ChannelType.presence:
        channelName = 'presence-channel.1';
        event = 'PresenceEvent';
        break;
      default:
        channelName = 'public-channel';
        event = 'PublicEvent';
        break;
    }

    setState(() {
      channelNameController.text = channelName;
      eventController.text = event;
      channelType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          CupertinoSegmentedControl<ChannelType>(
            groupValue: channelType,
            onValueChanged: onChannelTypeChange,
            children: const {
              ChannelType.public: Text('public'),
              ChannelType.private: Text('private'),
              ChannelType.presence: Text('presence'),
            },
          ),
          const SizedBox(height: 25),
          TextField(
            controller: channelNameController,
            decoration: const InputDecoration(
              labelText: 'Channel name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
            ),
            onChanged: (String value) {
              setState(() => channelName = value);
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: eventController,
            decoration: const InputDecoration(
              labelText: 'Event name',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
            ),
            onChanged: (String value) => setState(() => event = value),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: const Size.fromHeight(44),
            ),
            child: const Text('Listen'),
            onPressed: () {
              if (channelName.isEmpty || event.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please fill all fields'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              widget.onListen(ChannelOptions(
                channelName,
                channelType,
                event,
              ));
            },
          ),
        ],
      ),
    );
  }
}
