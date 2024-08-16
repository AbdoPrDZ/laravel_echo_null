import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

import 'pusher_channel.dart';

///
/// This class represents a Pusher private channel.
///
class PusherEncryptedPrivateChannel
    extends PusherChannel<PUSHER.PrivateEncryptedChannel> {
  PusherEncryptedPrivateChannel(
    super.pusher,
    super.name,
    super.options,
  );

  /// Trigger client event on the channel.
  PusherEncryptedPrivateChannel whisper(String eventName, dynamic data) =>
      this..subscription.trigger('client-$eventName', data);
}
