import '../channel/channel.dart';
import '../channel/presence_channel.dart';

abstract class Connector<ClientType, ChannelType> {
  /// Connector options.
  // ConnectorOptions options;
  ConnectorOptions<ClientType> options;

  /// Create a new class instance.
  Connector(this.options);

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
  final Map? authHeaders;
  final String? nameSpace;
  final T client;

  const ConnectorOptions({
    required this.client,
    this.authHeaders,
    this.nameSpace,
  });
}
