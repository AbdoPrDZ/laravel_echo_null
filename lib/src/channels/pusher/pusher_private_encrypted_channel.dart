import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

import '../private_encrypted_channel.dart';
import 'pusher_channel.dart';

///
/// This class represents a Pusher private channel.
///
class PusherPrivateEncryptedChannel
    extends PusherChannel<PUSHER.PrivateEncryptedChannel>
    implements PrivateEncryptedChannel {
  PusherPrivateEncryptedChannel(
    super.pusher,
    super.name,
    super.options,
  );

  /// listen to on subscribe success event
  @override
  void onSubscribedSuccess(Function callback) =>
      listen('pusher:subscription_succeeded', callback);

  @override
  PrivateEncryptedChannel whisper(String eventName, data) {
    throw Exception('This method is not available for encrypted channels');
  }
}
