import 'package:pusher_client_fixed/pusher_client_fixed.dart' as PUSHER;

import '../channel/channel.dart';
import '../channel/presence_channel.dart';

abstract class Connector<ClientType, ChannelType> {
  /// Connector options.
  // ConnectorOptions options;
  ConnectorOptions<ClientType> options;

  /// Create a new class instance.
  Connector(this.options) {
    if (options.autoConnect) connect();
  }

  // getting client
  ClientType get client;

  // All of the subscribed channel names.
  Map<String, ChannelType> channels = {};

  /// Get a channel instance by name.
  Channel channel(String channel);

  /// Get a private channel instance by name.
  Channel privateChannel(String channel);

  Channel listen(String channel, String event, Function callback);

  Channel? encryptedPrivateChannel(String channel) => null;

  /// Get a presence channel instance by name.
  PresenceChannel presenceChannel(String channel);

  /// Leave the given channel, as well as its private and presence variants.
  void leave(String channel);

  /// Leave the given channel.
  void leaveChannel(String channel);

  /// Get the socket_id of the connection.
  String? get socketId;

  /// Create a fresh connection.
  void connect();

  /// Disconnect from the Echo server.
  void disconnect();

  void onConnect(Function(dynamic data) handler) {}

  void onConnectError(Function(dynamic data) handler) {}

  void onDisconnect(Function(dynamic data) handler) {}

  void onError(Function(dynamic data) handler) {}
}

class ConnectorOptions<T> {
  final Map? auth;
  final String? authEndpoint;
  final String? host;
  final String? key;
  final String? namespace;
  final bool autoConnect;
  final T client;
  final Map moreOptions;

  const ConnectorOptions({
    required this.client,
    this.auth,
    this.authEndpoint,
    this.host,
    this.key,
    this.namespace,
    this.autoConnect = false,
    this.moreOptions = const {},
  });

  // get Options from PusherOptions
  static ConnectorOptions<PUSHER.PusherClient> fromPusherOptions(
    PUSHER.PusherClient client,
    PUSHER.PusherOptions options, {
    bool autoConnect = false,
  }) =>
      ConnectorOptions<PUSHER.PusherClient>(
        client: client,
        auth: {'headers': options.auth?.headers ?? {}},
        authEndpoint: options.auth?.endpoint,
        autoConnect: autoConnect,
        host: options.host,
        moreOptions: {
          'cluster': options.cluster,
          'encrypted': options.encrypted,
          'activityTimeout': options.activityTimeout,
          'pongTimeout': options.pongTimeout,
          'wsPort': options.wsPort,
          'wssPort': options.wssPort,
          'maxReconnectionAttempts': options.maxReconnectionAttempts,
          'maxReconnectGapInSeconds': options.maxReconnectGapInSeconds,
        },
      );

  // add Option item
  addOption(String key, dynamic value) => moreOptions[key] = value;

  // remove Options item by key
  removeOption(String key) => moreOptions.remove(key);

  // All Options
  Map get options => {
        'auth': auth,
        'authEndpoint': authEndpoint,
        'host': host,
        'key': key,
        'namespace': namespace,
        'autoConnect': autoConnect,
        ...moreOptions,
      };

  // Get Options
  Map get toMap => options;
}
