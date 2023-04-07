import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../app_state.dart';
import '../echo/pusher.dart';
import '../echo/socket_io.dart';
import 'leave_channel_modal.dart';
import 'listen_to_channel_modal.dart';

class ActionsView extends StatefulWidget {
  final String broadcaster;

  const ActionsView({
    super.key,
    required this.broadcaster,
  });

  @override
  State<StatefulWidget> createState() => _ActionsView();
}

class _ActionsView extends State<ActionsView> {
  late Echo echo;
  late AppState appState;
  late Function log;
  bool isConnected = false;
  List<String> listeningChannels = [];

  @override
  void initState() {
    super.initState();

    initEcho();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      appState = AppState.of(context);
      log = appState.log;
    });
  }

  @override
  void didUpdateWidget(ActionsView old) {
    super.didUpdateWidget(old);

    if (old.broadcaster == widget.broadcaster) return;

    try {
      echo.disconnect();
    } catch (e) {
      dev.log('$e');
    }
    initEcho();
  }

  void initEcho() {
    if (widget.broadcaster == 'pusher') {
      echo = initPusherClient();
      echo.connector.client.onConnectionStateChange((state) {
        log('pusher ${state!.currentState}');

        if (state.currentState == 'connected') {
          setState(() => isConnected = true);
        } else {
          setState(() => isConnected = false);
        }
      });
    } else {
      echo = initSocketIOClient();

      (echo.connector.client as Socket).onConnect((_) {
        log('socket.io connected');
        setState(() => isConnected = true);
      });

      (echo.connector.client as Socket).onDisconnect((_) {
        log('socket.io disconnected');
        setState(() => isConnected = false);
      });

      (echo.connector.client as Socket).onConnectError((err) {
        log('socket.io connection error: $err');
        setState(() => isConnected = false);
      });
      (echo.connector.client as Socket).onError((err) {
        log('socket.io error: $err');
        setState(() => isConnected = false);
      });
    }
  }

  void listenToChannel(ChannelType type, String name, String event) {
    dynamic channel;

    if (type == ChannelType.public) {
      channel = echo.channel(name);
    } else if (type == ChannelType.private) {
      channel = echo.private(name);
    } else if (type == ChannelType.presence) {
      channel = echo.join(name).here((users) {
        dev.log(users);
      }).joining((user) {
        dev.log(user);
      }).leaving((user) {
        dev.log(user);
      });
    }

    channel.listen(event, (e) {
      if (e == null) return;

      /**
       * Handle pusher event
       */
      if (e is PusherEvent) {
        String text = 'channel: ${e.channelName}, event: ${e.eventName}';

        if (e.data != null) {
          text += ', data: ${e.data}';
        }

        if (e.userId != null) {
          text += ', userId: ${e.userId}';
        }

        log(text);
        return;
      }

      dev.log('event: $e');
      log('event: $e');
    });
  }

  @override
  void dispose() {
    echo.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
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
          onTap: () => isConnected ? echo.disconnect() : echo.connect(),
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
              body: ListenToChannelModal(
                onListen: (ChannelOptions options) {
                  String channelType =
                      options.channelType.toString().substring(12);

                  log('Listening to $channelType channel: ${options.channelName}');

                  listenToChannel(
                    options.channelType,
                    options.channelName,
                    options.event,
                  );

                  if (!listeningChannels.contains(options.channelName)) {
                    setState(() {
                      listeningChannels.add(options.channelName);
                    });
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
            builder: (_) => LeaveChannelModal(
              listeningChannels: listeningChannels,
              onLeave: (String? channelName) {
                if (channelName != null) {
                  listeningChannels.remove(channelName);
                  log('Leaving channel: $channelName');
                  echo.leave(channelName);
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
          onTap: () => log('socket-id: ${echo.socketId}'),
        ),
      ],
    );
  }
}
