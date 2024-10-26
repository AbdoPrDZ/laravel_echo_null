library laravel_echo_null;

// Imports
import 'dart:typed_data';

import 'src/channels/channel.dart';
import 'src/channels/presence_channel.dart';
import 'src/channels/private_channel.dart';
import 'src/channels/private_encrypted_channel.dart';
import 'src/channels/pusher/pusher_channel.dart';
import 'src/channels/socketio/socketio_channel.dart';
import 'src/connector/connector.dart';
import 'src/connector/pusher_connector.dart';
import 'src/connector/socketio_connector.dart';

// Clients
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

// Exports
export 'src/connector/connector.dart';
export 'src/connector/pusher_connector.dart';
export 'src/connector/socketio_connector.dart';

export 'src/channels/channel.dart';
export 'src/channels/presence_channel.dart';
export 'src/channels/private_channel.dart';
export 'src/channels/private_encrypted_channel.dart';

export 'src/channels/socketio/socketio_channel.dart';
export 'src/channels/socketio/socketio_presence_channel.dart';
export 'src/channels/socketio/socketio_private_channel.dart';
export 'src/channels/socketio/socketio_private_encrypted_channel.dart';

export 'src/channels/pusher/pusher_channel.dart';
export 'src/channels/pusher/pusher_presence_channel.dart';
export 'src/channels/pusher/pusher_private_channel.dart';
export 'src/channels/pusher/pusher_private_encrypted_channel.dart';

///
/// This class is the primary API for interacting with broadcasting.
///
class Echo<ClientType, ChannelType> {
  /// The broadcasting connector.
  Connector<ClientType, ChannelType> connector;

  /// Create a class instance.
  Echo(this.connector);

  /// Get a channel instance by name.
  Channel channel(String channel) => connector.channel(channel);

  /// Get a presence channel instance by name.
  PresenceChannel join(String channel) {
    return connector.presenceChannel(channel);
  }

  /// Listen for an event on a channel instance.
  void listen(String channel, String event, Function callback) =>
      connector.listen(channel, event, callback);

  /// Get a private channel instance by name.
  PrivateChannel private(String channel) => connector.privateChannel(channel);

  /// Get a presence channel instance by name.
  PresenceChannel presence(String channel) =>
      connector.presenceChannel(channel);

  /// Get a private encrypted channel instance by name.
  PrivateEncryptedChannel privateEncrypted(String channel) =>
      connector.privateEncryptedChannel(channel);

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
    Map<String, dynamic> Function(String, Map)? channelDecryption,
  }) =>
      Echo<IO.Socket, SocketIoChannel>(SocketIoConnector(
        host,
        namespace: namespace,
        autoConnect: autoConnect,
        authHeaders: authHeaders,
        moreOptions: moreOptions,
        channelDecryption: channelDecryption,
      ));

  /// Init Echo with Pusher client
  static Echo<PUSHER.PusherClient, PusherChannel> pusher(
    String appKey, {
    String? cluster,
    required String authEndPoint,
    Map<String, String> authHeaders = const {
      'Content-Type': 'application/json'
    },
    Map<String, dynamic> Function(Uint8List, Map<String, dynamic>)?
        channelDecryption,
    String? host,
    int wsPort = 80,
    int wssPort = 443,
    bool encrypted = true,
    int activityTimeout = 120000,
    int pongTimeout = 30000,
    int maxReconnectionAttempts = 6,
    Duration reconnectGap = const Duration(seconds: 2),
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
          channelDecryption: channelDecryption,
          wsPort: wsPort,
          encrypted: encrypted,
          activityTimeout: activityTimeout,
          pongTimeout: pongTimeout,
          maxReconnectionAttempts: maxReconnectionAttempts,
          reconnectGap: reconnectGap,
          enableLogging: enableLogging,
          autoConnect: autoConnect,
          nameSpace: nameSpace,
        ),
      );
}
