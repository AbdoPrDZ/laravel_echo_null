import 'package:socket_io_client/socket_io_client.dart';

import '../channel/socketio_channel.dart';
import '../channel/socketio_presence_channel.dart';
import '../channel/socketio_private_channel.dart';
import 'connector.dart';

///
/// This class creates a connector to a Socket.io server.
///
class SocketIoConnector extends Connector<Socket, SocketIoChannel> {
  /// The Socket.io connection instance.
  // Socket get socket => options.client;
  // final Socket socket;

  @override
  Socket get client => options.client;

  Socket get socket => client;

  SocketIoConnector(
    String host, {
    Map<String, String>? authHeaders,
    String? authEndpoint,
    String? namespace,
    bool autoConnect = true,
    Map moreOptions = const {},
  }) : super(ConnectorOptions(
          client: io(host, {'autoConnect': autoConnect, ...moreOptions}),
          authHeaders: authHeaders,
          nameSpace: namespace,
        ));

  /// Listen for an event on a channel instance.
  @override
  SocketIoChannel listen(String name, String event, Function callback) =>
      channel(name).listen(event, callback);

  /// Get a channel instance by name.
  @override
  SocketIoChannel channel(String name) {
    if (channels[name] == null) {
      channels[name] = SocketIoChannel(socket, name, options);
    }

    return channels[name] as SocketIoChannel;
  }

  /// Get a private channel instance by name.
  @override
  SocketIoPrivateChannel privateChannel(String name) {
    if (channels['private-$name'] == null) {
      channels['private-$name'] = SocketIoPrivateChannel(
        socket,
        'private-$name',
        options,
      );
    }

    return channels['private-$name'] as SocketIoPrivateChannel;
  }

  /// Get a presence channel instance by name.
  @override
  SocketIoPresenceChannel presenceChannel(String name) {
    if (channels['presence-$name'] == null) {
      channels['presence-$name'] = SocketIoPresenceChannel(
        socket,
        'presence-$name',
        options,
      );
    }

    return channels['presence-$name'] as SocketIoPresenceChannel;
  }

  /// Leave the given channel, as well as its private and presence variants.
  @override
  void leave(String name) {
    List<String> channels = [name, 'private-$name', 'presence-$name'];

    for (var name in channels) {
      leaveChannel(name);
    }
  }

  /// Leave the given channel.
  @override
  void leaveChannel(String name) {
    if (channels[name] != null) {
      channels[name]!.unsubscribe();
      channels.remove(name);
    }
  }

  /// Get the socket ID for the connection.
  @override
  String? get socketId => socket.id;

  /// Create a fresh Socket.io connection.
  @override
  void connect() {
    socket.connect();

    socket.on('reconnect', (_) {
      for (var channel in channels.values) {
        channel.subscribe();
      }
    });
  }

  /// Disconnect Socketio connection.
  @override
  void disconnect() => socket.disconnect();

  @override
  void onConnect(Function(dynamic data) handler) =>
      socket.onConnect((data) => handler(data));

  @override
  void onConnectError(Function(dynamic data) handler) =>
      socket.onConnectError((data) => handler(data));

  @override
  void onDisconnect(Function(dynamic data) handler) =>
      socket.onDisconnect((data) => handler(data));

  @override
  void onError(Function(dynamic data) handler) =>
      socket.onError((data) => handler(data));
}
