import 'private_channel.dart';
import 'pusher_channel.dart';

///
/// This class represents a Pusher private channel.
///
class PusherPrivateChannel extends PusherChannel implements PrivateChannel {
  PusherPrivateChannel(
    super.pusher,
    super.name,
    super.options,
  );

  /// Trigger client event on the channel.
  @override
  PusherPrivateChannel whisper(String eventName, dynamic data) {
    // pusher.channels[name].trigger('client-$eventName', data);
    subscription.trigger('client-$eventName', data);
    return this;
  }
}
