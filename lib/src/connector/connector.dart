import 'dart:convert';

import 'package:pinenacl/api.dart';
import 'package:pinenacl/x25519.dart' show SecretBox;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../channels/channel.dart';
import '../channels/presence_channel.dart';
import '../channels/private_channel.dart';
import '../channels/private_encrypted_channel.dart';

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
  void listen(String channel, String event, Function callback);

  PrivateEncryptedChannel privateEncryptedChannel(String channel);

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

class SocketIoConnectorOptions extends ConnectorOptions<IO.Socket> {
  /// The channel decryption handler.
  final Map<String, dynamic> Function(
    String sharedSecret,
    Map data,
  )? channelDecryption;

  const SocketIoConnectorOptions({
    required super.client,
    super.authHeaders,
    super.nameSpace,
    this.channelDecryption,
  });

  ByteList _decodeCipherText(String cipherText) {
    Uint8List uint8list = base64Decode(cipherText);
    ByteData byteData = ByteData.sublistView(uint8list);
    List<int> data = List<int>.generate(
        byteData.lengthInBytes, (index) => byteData.getUint8(index));
    return ByteList(data);
  }

  Map<String, dynamic> decryptChannelData(
    String sharedSecret,
    Map data,
  ) =>
      (channelDecryption ?? defaultChannelDecryptionHandler)(
        sharedSecret,
        data,
      );

  Map<String, dynamic> defaultChannelDecryptionHandler(
    String sharedSecret,
    Map data,
  ) {
    if (!data.containsKey("ciphertext") || !data.containsKey("nonce")) {
      throw Exception(
        "Unexpected format for encrypted event, expected object with `ciphertext` and `nonce` fields, got: $data",
      );
    }

    final ByteList cipherText = _decodeCipherText(data["ciphertext"]);

    final Uint8List nonce = base64Decode(data["nonce"]);

    final SecretBox secretBox = SecretBox(base64Decode(sharedSecret));
    final Uint8List decryptedData = secretBox.decrypt(cipherText, nonce: nonce);

    return jsonDecode(utf8.decode(decryptedData)) as Map<String, dynamic>;
  }
}
