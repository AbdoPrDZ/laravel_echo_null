import 'package:laravel_echo_null/laravel_echo_null.dart';

import '../private_encrypted_channel.dart';
import 'socketio_private_channel.dart';

///
/// This class represents a Socket.io presence channel.
///
class SocketIoPrivateEncryptedChannel extends SocketIoPrivateChannel
    implements PrivateEncryptedChannel {
  SocketIoPrivateEncryptedChannel(
    super.socket,
    super.name,
    super.options,
  );

  /// Trigger client event on the channel.
  @override
  void whisper(String eventName, dynamic data) {
    throw Exception('This method is not available for encrypted channels');
  }

  @override
  void onSubscribedSuccess(Function callback) =>
      listen('channel_subscribe_success', callback);

  @override
  Map eventHandler(String event, data) {
    if (event == 'channel_subscribe_success') {
      return super.eventHandler(event, data);
    }

    if (data is Map) {
      if (authData?.sharedSecret == null) {
        throw Exception(
          'The shared secret is required to decrypt the event data for event: $event',
        );
      }

      if (data.containsKey("ciphertext") && data.containsKey('nonce')) {
        return {
          'event': event,
          'data': (options as SocketIoConnectorOptions)
              .decryptChannelData(authData!.sharedSecret!, data),
        };
      }
    } else {
      throw Exception(
        'Invalid event data type for event: $event, expected Map but got ${data.runtimeType}',
      );
    }

    return data;
  }
}
