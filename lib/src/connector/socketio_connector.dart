import 'package:socket_io_client/socket_io_client.dart';

import '../channels/socketio/socketio_channel.dart';
import '../channels/socketio/socketio_private_encrypted_channel.dart';
import '../channels/socketio/socketio_presence_channel.dart';
import '../channels/socketio/socketio_private_channel.dart';
import 'connector.dart';

///
/// This class creates a connector to a Socket.io server.
///
class SocketIoConnector extends Connector<Socket, SocketIoChannel> {
  /// getting the client
  @override
  Socket get client => options.client;

  /// getting socket client
  Socket get socket => client;

  SocketIoConnector(
    String host, {
    Map<String, String>? authHeaders,
    String? namespace,
    bool autoConnect = true,
    Map moreOptions = const {},
    Map<String, dynamic> Function(String, Map)? channelDecryption,
  }) : super(SocketIoConnectorOptions(
            client: io(host, {
              'autoConnect': autoConnect,
              ...moreOptions,
              'auth': {'headers': authHeaders},
            }),
            authHeaders: authHeaders,
            nameSpace: namespace,
            channelDecryption: channelDecryption));

  /// Listen for an event on a channel instance.
  @override
  void listen(String channel, String event, Function callback) =>
      this.channel(channel).listen(event, callback);

  /// Get a channel instance by name.
  @override
  SocketIoChannel channel(String name) {
    if (channels[name] == null) {
      if (name.startsWith('private-encrypted-')) {
        channels[name] = SocketIoPrivateEncryptedChannel(
          socket,
          name,
          options as SocketIoConnectorOptions,
        );
      } else if (name.startsWith('private-')) {
        channels[name] = SocketIoPrivateChannel(
          socket,
          name,
          options as SocketIoConnectorOptions,
        );
      } else if (name.startsWith('presence-')) {
        channels[name] = SocketIoPresenceChannel(
          socket,
          name,
          options as SocketIoConnectorOptions,
        );
      } else {
        channels[name] = SocketIoChannel(
          socket,
          name,
          options as SocketIoConnectorOptions,
        );
      }
    }

    return channels[name] as SocketIoChannel;
  }

  /// Get a private channel instance by name.
  @override
  SocketIoPrivateChannel privateChannel(String name) {
    if (!name.startsWith("private-")) {
      name = "private-$name";
    }

    return channel(name) as SocketIoPrivateChannel;
  }

  /// Get a private encrypted channel instance by name.
  @override
  SocketIoPrivateEncryptedChannel privateEncryptedChannel(String name) {
    if (!name.startsWith("private-encrypted-")) {
      name = "private-encrypted-$name";
    }

    return channel(name) as SocketIoPrivateEncryptedChannel;
  }

  /// Get a presence channel instance by name.
  @override
  SocketIoPresenceChannel presenceChannel(String name) {
    if (!name.startsWith("presence-")) {
      name = "presence-$name";
    }

    return channel(name) as SocketIoPresenceChannel;
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

    // Reconnect to all channels
    onReconnect(
      (_) => [
        for (final channel in channels.values) channel.subscribe(),
      ],
    );
  }

  /// Disconnect Socket.io connection.
  @override
  void disconnect() => socket.disconnect();

  /// listen to on connect event
  @override
  void onConnect(Function(dynamic data) handler) =>
      socket.onConnect((data) => handler(data));

  /// listen to on connect error event
  @override
  void onConnectError(Function(dynamic data) handler) =>
      socket.onConnectError((data) => handler(data));

  /// listen to on connect timeout event
  // @override
  // void onConnectTimeout(Function(dynamic data) handler) =>
  //     socket.onConnectTimeout((data) => handler(data));

  /// listen to on connecting event
  // @override
  // void onConnecting(Function(dynamic data) handler) =>
  //     socket.onConnecting((data) => handler(data));

  /// listen to on disconnect event
  @override
  void onDisconnect(Function(dynamic data) handler) =>
      socket.onDisconnect((data) => handler(data));

  /// listen to on error event
  @override
  void onError(Function(dynamic data) handler) =>
      socket.onError((data) => handler(data));

  /// listen to on reconnect event
  @override
  void onReconnect(Function(dynamic data) handler) =>
      socket.onReconnect((data) => handler(data));

  /// listen to on reconnect attempt event
  @override
  void onReconnectAttempt(Function(dynamic data) handler) =>
      socket.onReconnectAttempt((data) => handler(data));

  /// listen to on reconnect failed event
  @override
  void onReconnectFailed(Function(dynamic data) handler) =>
      socket.onReconnectFailed((data) => handler(data));

  /// listen to on reconnect error event
  @override
  void onReconnectError(Function(dynamic data) handler) =>
      socket.onReconnectError((data) => handler(data));

  /// listen to on reconnecting event
  // @override
  // void onReconnecting(Function(dynamic data) handler) =>
  //     socket.onReconnecting((data) => handler(data));
}
