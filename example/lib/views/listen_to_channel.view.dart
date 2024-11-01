import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ChannelOptions {
  final String channelName;
  final ChannelType channelType;
  final String event;

  ChannelOptions(this.channelName, this.channelType, this.event);
}

enum ChannelType { public, private, privateEncrypted, presence }

class ListenToChannelView extends StatefulWidget {
  final ValueChanged<ChannelOptions> onListen;

  const ListenToChannelView({super.key, required this.onListen});

  @override
  createState() => _ListenToChannelViewState();
}

class _ListenToChannelViewState extends State<ListenToChannelView> {
  String channelName = 'public-channel';
  String event = 'PublicEvent';
  ChannelType channelType = ChannelType.public;
  late TextEditingController channelNameController = TextEditingController(
    text: channelName,
  );
  late TextEditingController eventController = TextEditingController(
    text: event,
  );

  void onChannelTypeChange(ChannelType value) {
    switch (value) {
      case ChannelType.private:
        channelName = 'private-channel.1';
        event = 'PrivateEvent';
        break;
      case ChannelType.privateEncrypted:
        channelName = 'private-encrypted-channel.1';
        event = 'PrivateEncryptedEvent';
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
  Widget build(BuildContext context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CupertinoSegmentedControl<ChannelType>(
                groupValue: channelType,
                onValueChanged: onChannelTypeChange,
                children: const {
                  ChannelType.public: Text('public'),
                  ChannelType.private: Text('private'),
                  ChannelType.privateEncrypted: Text('encrypted'),
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
                onChanged: (String value) =>
                    setState(() => channelName = value),
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
                  } else {
                    switch (channelType) {
                      case ChannelType.private:
                        if (channelName.startsWith('private-')) {
                          channelName =
                              channelName.replaceFirst('private-', '');
                        }
                        break;
                      case ChannelType.privateEncrypted:
                        if (channelName.startsWith('private-encrypted-')) {
                          channelName = channelName.replaceFirst(
                              'private-encrypted-', '');
                        }
                        break;
                      case ChannelType.presence:
                        if (channelName.startsWith('presence-')) {
                          channelName =
                              channelName.replaceFirst('presence-', '');
                        }
                        break;
                      default:
                        if (channelName.startsWith('public-')) {
                          channelName = channelName.replaceFirst('public-', '');
                        }
                        break;
                    }
                    widget.onListen(ChannelOptions(
                      channelName,
                      channelType,
                      event,
                    ));
                  }
                },
              ),
            ],
          ),
        ),
      );
}
