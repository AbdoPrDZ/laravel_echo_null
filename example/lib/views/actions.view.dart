import 'package:flutter/material.dart';
import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart' as PUSHER;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../echo/pusher.dart';
import '../echo/socket_io.dart';
import 'leave_channel.view.dart';
import 'listen_to_channel.view.dart';

class ActionsView extends StatefulWidget {
  final Function(String message) log;
  final String broadcaster;

  const ActionsView({
    super.key,
    required this.log,
    required this.broadcaster,
  });

  @override
  State<ActionsView> createState() => _ActionsViewState();
}

class _ActionsViewState extends State<ActionsView> {
  Echo? echo;
  bool isConnected = false;
  List<String> listeningChannels = [];

  void connect() {
    if (echo != null && echo!.connector.client is IO.Socket) {
      widget.log('Disconnecting socket.io');
      (echo!.connector.client as IO.Socket).disconnect();
    } else if (echo != null && echo!.connector.client is PUSHER.PusherClient) {
      widget.log('Disconnecting pusher');
      (echo!.connector.client as PUSHER.PusherClient).disconnect();
    }

    if (widget.broadcaster == 'pusher') {
      widget.log('initializing pusher');
      echo = initPusherClient(widget.log);
      widget.log('pusher initialized successfully');

      (echo!.connector.client as PUSHER.PusherClient)
          .onConnectionStateChange((state) {
        widget.log('pusher ${state!.currentState}');

        if (state.currentState == 'connected') {
          setState(() => isConnected = true);
        } else {
          setState(() => isConnected = false);
        }
      });
    } else {
      widget.log('initializing socket.io');
      echo = initSocketIOClient();
      widget.log('socket.io initialized successfully');
      print((echo?.connector.client as IO.Socket?)?.opts);

      echo!.connector.onConnect((_) {
        widget.log('socket.io connected');
        setState(() => isConnected = true);
      });

      echo!.connector.onDisconnect((_) {
        widget.log('socket.io disconnected');
        setState(() => isConnected = false);
      });

      echo!.connector.onConnectError((err) {
        widget.log('socket.io connection error: $err');
        setState(() => isConnected = false);
      });

      echo!.connector.onError((err) {
        widget.log('socket.io error: $err');
        setState(() => isConnected = false);
      });
    }

    widget.log('connecting ${widget.broadcaster}');
    echo!.connect();
  }

  void listenToChannel(ChannelType type, String name, String event) {
    if (echo == null) return;

    Channel? channel;

    if (type == ChannelType.public) {
      channel = echo!.channel(name);
    } else if (type == ChannelType.private) {
      channel = echo!.private(name);
      (channel as PrivateChannel).onSubscribedSuccess((data) {
        widget.log('channel subscribed data: $data');
      });
    } else if (type == ChannelType.presence) {
      channel = echo!.join(name).here((users) {
        widget.log(users);
      }).joining((user) {
        widget.log(user);
      }).leaving((user) {
        widget.log(user);
      });
    }

    channel?.listen(event, (e) {
      if (e == null) return;

      /**
       * Handle pusher event
       */
      if (e is PUSHER.PusherEvent) {
        String text = 'channel: ${e.channelName}, event: ${e.eventName}';

        if (e.data != null) {
          text += ', data: ${e.data}';
        }

        if (e.userId != null) {
          text += ', userId: ${e.userId}';
        }

        widget.log(text);
        return;
      }

      widget.log('event: $e');
    });
  }

  @override
  void dispose() {
    echo?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text(
            isConnected ? 'disconnect' : 'connect',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: ClipOval(
            child: Container(
              color: isConnected ? Colors.green : Colors.red,
              height: 20,
              width: 20,
            ),
          ),
          onTap: () {
            if (isConnected) {
              widget.log('disconnecting ${widget.broadcaster}');
              echo!.disconnect();
            } else {
              connect();
            }
          },
        ),
        ListTile(
          title: const Text(
            'listen to channel',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: ClipOval(
            child: Container(
              color: Colors.grey[400],
              height: 20,
              width: 20,
              child: Center(
                child: Text(
                  '${listeningChannels.length}',
                ),
              ),
            ),
          ),
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (_) => Scaffold(
              body: ListenToChannelView(
                onListen: (ChannelOptions options) {
                  widget.log(
                    'Listening to ${options.channelType} channel: ${options.channelName}',
                  );

                  listenToChannel(
                    options.channelType,
                    options.channelName,
                    options.event,
                  );

                  if (!listeningChannels.contains(options.channelName)) {
                    setState(() => listeningChannels.add(options.channelName));
                  }

                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
        ),
        ListTile(
          title: const Text(
            'leave channel',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () => showModalBottomSheet(
            context: context,
            builder: (_) => LeaveChannelView(
              listeningChannels: listeningChannels,
              onLeave: (String? channelName) {
                if (channelName != null) {
                  listeningChannels.remove(channelName);
                  widget.log('Leaving channel: $channelName');
                  echo?.leave(channelName);
                }

                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        ListTile(
          title: const Text(
            'get socket-id',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
          onTap: () => widget.log('socket-id: ${echo?.socketId}'),
        ),
      ],
    );
  }
}
