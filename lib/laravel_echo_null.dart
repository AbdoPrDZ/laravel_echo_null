library laravel_echo_null;

// Imports
import 'src/channel/channel.dart';
import 'src/channel/presence_channel.dart';
import 'src/channel/private_channel.dart';
import 'src/channel/pusher_channel.dart';
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
export 'src/channel/private_channel.dart';
export 'src/channel/socketio_private_channel.dart';
export 'src/channel/presence_channel.dart';
export 'src/channel/pusher_presence_channel.dart';
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
  PrivateChannel private(String channel) => connector.privateChannel(channel);

  /// Get a presence channel instance by name.
  PresenceChannel presence(String channel) =>
      connector.presenceChannel(channel);

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

  /// Init Echo with Socket client
  static Echo<IO.Socket, SocketIoChannel> socket(
    String host, {
    String? namespace,
    bool autoConnect = true,
    Map<String, String> authHeaders = const {
      'Content-Type': 'application/json'
    },
    Map moreOptions = const {},
  }) =>
      Echo<IO.Socket, SocketIoChannel>(SocketIoConnector(
        host,
        namespace: namespace,
        autoConnect: autoConnect,
        authHeaders: authHeaders,
        moreOptions: moreOptions,
      ));

  /// Init Echo with Pusher client
  static Echo<PUSHER.PusherClient, PusherChannel> pusher(
    String appKey, {
    required String authEndPoint,
    Map<String, String> authHeaders = const {
      'Content-Type': 'application/json'
    },
    String? cluster,
    String host = "ws.pusherapp.com",
    int wsPort = 80,
    int wssPort = 443,
    bool encrypted = true,
    int activityTimeout = 120000,
    int pongTimeout = 30000,
    int maxReconnectionAttempts = 6,
    int maxReconnectGapInSeconds = 30,
    bool enableLogging = true,
    bool autoConnect = true,
    String? nameSpace,
  }) =>
      Echo<PUSHER.PusherClient, PusherChannel>(
        PusherConnector(
          appKey,
          authEndPoint: authEndPoint,
          authHeaders: authHeaders,
          cluster: cluster,
          host: host,
          wsPort: wsPort,
          encrypted: encrypted,
          activityTimeout: activityTimeout,
          pongTimeout: pongTimeout,
          maxReconnectionAttempts: maxReconnectionAttempts,
          maxReconnectGapInSeconds: maxReconnectGapInSeconds,
          enableLogging: enableLogging,
          autoConnect: autoConnect,
          nameSpace: nameSpace,
        ),
      );
}
