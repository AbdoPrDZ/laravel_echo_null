import 'dart:typed_data';

import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

import '../channels/pusher/pusher_channel.dart';
import '../channels/pusher/pusher_private_encrypted_channel.dart';
import '../channels/pusher/pusher_presence_channel.dart';
import '../channels/pusher/pusher_private_channel.dart';
import 'connector.dart';

class PusherConnector extends Connector<PUSHER.PusherClient, PusherChannel> {
  PUSHER.PusherClient get pusher => options.client;

  @override
  PUSHER.PusherClient get client => pusher;

  PusherConnector(
    String key, {
    required String authEndPoint,
    String? cluster,
    Map<String, String> authHeaders = const {
      'Content-Type': 'application/json'
    },
    String? host,
    Map<String, dynamic> Function(Uint8List, Map<String, dynamic>)?
        channelDecryption,
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
  }) : super(
          ConnectorOptions(
            client: PUSHER.PusherClient(
              options: PUSHER.PusherOptions(
                key: key,
                authOptions: PUSHER.PusherAuthOptions(
                  authEndPoint,
                  headers: authHeaders,
                ),
                cluster: cluster,
                channelDecryption: channelDecryption,
                host: host,
                wsPort: wsPort,
                wssPort: wssPort,
                encrypted: encrypted,
                activityTimeout: activityTimeout,
                pongTimeout: pongTimeout,
                maxReconnectionAttempts: maxReconnectionAttempts,
                reconnectGap: reconnectGap,
                enableLogging: enableLogging,
                autoConnect: autoConnect,
              ),
            ),
            nameSpace: nameSpace,
          ),
        );

  /// Listen for an event on a channel instance.
  @override
  void listen(String name, String event, Function callback) =>
      channel(name).listen(event, callback);

  /// Get a channel instance by name.
  @override
  PusherChannel channel(String name) {
    if (channels[name] == null) {
      if (name.startsWith('private-encrypted-')) {
        channels[name] = PusherPrivateEncryptedChannel(
          pusher,
          name,
          options,
        );
      } else if (name.startsWith('private-')) {
        channels[name] = PusherPrivateChannel(pusher, name, options);
      } else if (name.startsWith('presence-')) {
        channels[name] = PusherPresenceChannel(pusher, name, options);
      } else {
        channels[name] = PusherChannel(pusher, name, options);
      }
    }
    return channels[name] as PusherChannel;
  }

  /// Get a private channel instance by name.
  @override
  PusherPrivateChannel privateChannel(String name) {
    if (!name.startsWith("private-")) {
      name = "private-$name";
    }

    return channel(name) as PusherPrivateChannel;
  }

  /// Get a private encrypted channel instance by name.
  @override
  PusherPrivateEncryptedChannel privateEncryptedChannel(String name) {
    if (!name.startsWith("private-encrypted-")) {
      name = "private-encrypted-$name";
    }

    return channel(name) as PusherPrivateEncryptedChannel;
  }

  /// Get a presence channel instance by name.
  @override
  PusherPresenceChannel presenceChannel(String name) {
    if (!name.startsWith("presence-")) {
      name = "presence-$name";
    }

    return channel(name) as PusherPresenceChannel;
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
  String? get socketId => pusher.socketId;

  /// Create a fresh Pusher connection.
  @override
  void connect() => pusher.connect();

  /// Disconnect Pusher connection.
  @override
  void disconnect() => pusher.disconnect();

  /// Listen for the on connect event.
  @override
  void onConnect(Function(dynamic data) handler) =>
      pusher.onConnectionEstablished(handler);

  /// Listen for the on connect error event.
  @override
  void onConnectError(Function(dynamic data) handler) =>
      pusher.onConnectionError((data) => handler(data));

  /// Listen for the on connect timeout event.
  @override
  void onConnecting(Function(dynamic data) handler) =>
      pusher.onConnecting((data) => handler(data));

  /// Listen for the on connect timeout event.
  @override
  void onDisconnect(Function(dynamic data) handler) =>
      pusher.onDisconnected((data) => handler(data));

  /// Listen for the on error event.
  @override
  void onError(Function(dynamic data) handler) =>
      pusher.onError((data) => handler(data));

  /// Listen for the on reconnect event.
  @override
  void onReconnect(Function(dynamic data) handler) =>
      pusher.onReconnected((data) => handler(data));

  /// Listen for the on reconnect attempt event.
  @override
  void onReconnecting(Function(dynamic data) handler) =>
      pusher.onReconnecting((data) => handler(data));
}
