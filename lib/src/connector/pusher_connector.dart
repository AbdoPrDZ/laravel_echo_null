import 'dart:typed_data';

import 'package:pusher_client_socket/pusher_client_socket.dart';

import '../channel/pusher_channel.dart';
import '../channel/pusher_encrypted_private_channel.dart';
import '../channel/pusher_presence_channel.dart';
import '../channel/pusher_private_channel.dart';
import 'connector.dart';

class PusherConnector extends Connector<PusherClient, PusherChannel> {
  PusherClient get pusher => options.client;

  @override
  PusherClient get client => pusher;

  PusherConnector(
    String key, {
    required String authEndPoint,
    Map<String, String> authHeaders = const {
      'Content-Type': 'application/json'
    },
    String? cluster,
    Protocol protocol = Protocol.ws,
    String? host,
    Map<String, dynamic> Function(Uint8List, Map<String, dynamic>)?
        channelDecryption,
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
  }) : super(
          ConnectorOptions(
            client: PusherClient(
              options: PusherOptions(
                key: key,
                authOptions: PusherAuthOptions(
                  authEndPoint,
                  headers: authHeaders,
                ),
                cluster: cluster,
                protocol: protocol,
                channelDecryption: channelDecryption,
                host: host,
                // wsPort: wsPort,
                // wssPort: wssPort,
                // encrypted: encrypted,
                activityTimeout: activityTimeout,
                pongTimeout: pongTimeout,
                // maxReconnectionAttempts: maxReconnectionAttempts,
                // maxReconnectGapInSeconds: maxReconnectGapInSeconds,
                enableLogging: enableLogging,
                autoConnect: autoConnect,
              ),
            ),
            nameSpace: nameSpace,
          ),
        );

  /// Listen for an event on a channel instance.
  @override
  PusherChannel listen(String name, String event, Function callback) =>
      channel(name).listen(event, callback);

  /// Get a channel instance by name.
  @override
  PusherChannel channel(String name) {
    if (channels[name] == null) {
      channels[name] = PusherChannel(pusher, name, options);
    }
    return channels[name] as PusherChannel;
  }

  /// Get a private channel instance by name.
  @override
  PusherPrivateChannel privateChannel(String name) {
    if (channels['private-$name'] == null) {
      channels['private-$name'] = PusherPrivateChannel(
        pusher,
        'private-$name',
        options,
      );
    }
    return channels['private-$name'] as PusherPrivateChannel;
  }

  /// Get a private encrypted channel instance by name.
  @override
  PusherEncryptedPrivateChannel encryptedPrivateChannel(String name) {
    if (channels['private-encrypted-$name'] == null) {
      channels['private-encrypted-$name'] = PusherEncryptedPrivateChannel(
        pusher,
        'private-encrypted-$name',
        options,
      );
    }
    return channels['private-encrypted-$name'] as PusherEncryptedPrivateChannel;
  }

  /// Get a presence channel instance by name.
  @override
  PusherPresenceChannel presenceChannel(String name) {
    if (channels['presence-$name'] == null) {
      channels['presence-$name'] = PusherPresenceChannel(
        pusher,
        'presence-$name',
        options,
      );
    }
    return channels['presence-$name'] as PusherPresenceChannel;
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
  void connect() {
    pusher.connect();
  }

  /// Disconnect Pusher connection.
  @override
  void disconnect() => pusher.disconnect();

  @override
  void onConnectError(Function(dynamic data) handler) =>
      pusher.onConnectionError((data) => handler(data));
}
