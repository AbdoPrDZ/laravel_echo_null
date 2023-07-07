library laravel_echo_null;

// Imports
import 'package:laravel_echo_null/src/channel/pusher_channel.dart';

import 'src/channel/channel.dart';
import 'src/channel/presence_channel.dart';
import 'src/channel/socketio_channel.dart';
import 'src/connector/connector.dart';
import 'src/connector/pusher_connector.dart';
import 'src/connector/socketio_connector.dart';

// Clients
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:pusher_client_fixed/pusher_client_fixed.dart' as PUSHER;

// Exports
export 'src/connector/connector.dart';
export 'src/connector/pusher_connector.dart';
export 'src/connector/socketio_connector.dart';
export 'src/channel/channel.dart';
export 'src/channel/socketio_channel.dart';
export 'src/channel/pusher_channel.dart';

///
/// This class is the primary API for interacting with broadcasting.
///
class Echo<ClientType, ChannelType> {
  /// The broadcasting connector.
  Connector<ClientType, ChannelType> connector;

  /// Create a class instance.
  Echo(this.connector);

  /// Get a channel instance by name.
  Channel channel(String channel) {
    return connector.channel(channel);
  }

  /// Get a presence channel instance by name.
  PresenceChannel join(String channel) {
    return connector.presenceChannel(channel);
  }

  /// Listen for an event on a channel instance.
  Channel listen(String channel, String event, Function callback) =>
      connector.listen(channel, event, callback);

  /// Get a private channel instance by name.
  Channel private(String channel) => connector.privateChannel(channel);

  /// Get a private encrypted channel instance by name.
  Channel? encryptedPrivate(String channel) =>
      connector.encryptedPrivateChannel(channel);

  /// Leave the given channel, as well as its private and presence variants.
  void leave(String channel) => connector.leave(channel);

  /// Leave the given channel.
  void leaveChannel(String channel) => connector.leaveChannel(channel);

  /// Create a connection.
  void connect() => connector.connect();

  /// Disconnect from the Echo server.
  void disconnect() => connector.disconnect();

  /// Get the Socket ID for the connection.
  String? get socketId => connector.socketId;

  // Init Echo with Socket
  static Echo<IO.Socket, SocketIoChannel> socket(
    String host, {
    Map? auth,
    String? authEndpoint,
    String? key,
    String? namespace,
    bool autoConnect = false,
    Map moreOptions = const {},
  }) =>
      Echo<IO.Socket, SocketIoChannel>(SocketIoConnector(
        IO.io(host, <String, dynamic>{
          'autoConnect': autoConnect,
          'transports': moreOptions.containsKey('transports')
              ? moreOptions['transports']
              : []
        }),
        auth: auth,
        authEndpoint: authEndpoint,
        host: host,
        key: key,
        namespace: namespace,
        autoConnect: autoConnect,
        moreOptions: moreOptions,
      ));

  // Init Echo with Pusher
  static Echo<PUSHER.PusherClient, PusherChannel> pusher(
    String appKey,
    PUSHER.PusherOptions options, {
    Map? auth,
    String? authEndpoint,
    String? host,
    String? key,
    String? namespace,
    bool autoConnect = true,
    bool enableLogging = true,
    Map moreOptions = const {},
  }) =>
      Echo<PUSHER.PusherClient, PusherChannel>(PusherConnector(
        PUSHER.PusherClient(
          appKey,
          options,
          autoConnect: autoConnect,
          enableLogging: enableLogging,
        ),
        auth: auth,
        authEndpoint: authEndpoint,
        host: host,
        key: key,
        namespace: namespace,
        autoConnect: autoConnect,
        moreOptions: moreOptions,
      ));
}
