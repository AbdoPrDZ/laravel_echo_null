import '../channel/channel.dart';
import '../channel/presence_channel.dart';
import '../channel/private_channel.dart';

abstract class Connector<ClientType, ChannelType> {
  /// Connector options.
  ConnectorOptions<ClientType> options;

  /// Create a new class instance.
  Connector(this.options);

  /// getting client
  ClientType get client;

  /// All of the subscribed channel names.
  Map<String, ChannelType> channels = {};

  /// Get a channel instance by name.
  Channel channel(String channel);

  /// Get a private channel instance by name.
  PrivateChannel privateChannel(String channel);

  /// Get a presence channel instance by name.
  PresenceChannel presenceChannel(String channel);

  /// listen to channel event
  Channel listen(String channel, String event, Function callback);

  Channel? encryptedPrivateChannel(String channel) => null;

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

  /// listen to on connect event
  void onConnect(Function(dynamic data) handler) {}

  /// listen to on connect error event
  void onConnectError(Function(dynamic data) handler) {}

  /// listen to on connect timeout event
  void onConnectTimeout(Function(dynamic data) handler) {}

  /// listen to on connecting event
  void onConnecting(Function(dynamic data) handler) {}

  /// listen to on disconnect event
  void onDisconnect(Function(dynamic data) handler) {}

  /// listen to on error event
  void onError(Function(dynamic data) handler) {}

  /// listen to on reconnected event
  void onReconnect(Function(dynamic data) handler) {}

  /// listen to on reconnect attempt event
  void onReconnectAttempt(Function(dynamic data) handler) {}

  /// listen to on reconnect failed event
  void onReconnectFailed(Function(dynamic data) handler) {}

  /// listen to on reconnect error event
  void onReconnectError(Function(dynamic data) handler) {}

  /// listen to on reconnecting event
  void onReconnecting(Function(dynamic data) handler) {}
}

class ConnectorOptions<T> {
  final Map? authHeaders;
  final String? nameSpace;
  final T client;

  const ConnectorOptions({
    required this.client,
    this.authHeaders,
    this.nameSpace,
  });
}
