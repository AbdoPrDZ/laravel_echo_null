import 'pusher_channel.dart';

///
/// This class represents a Pusher private channel.
///
class PusherEncryptedPrivateChannel extends PusherChannel {
  PusherEncryptedPrivateChannel(
    super.pusher,
    super.name,
    super.options,
  );

  /// Trigger client event on the channel.
  PusherEncryptedPrivateChannel whisper(String eventName, dynamic data) {
    pusher.channels.channels[name].trigger('client-$eventName', data);
    return this;
  }
}
