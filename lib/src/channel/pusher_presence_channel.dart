import 'presence_channel.dart';
import 'pusher_channel.dart';

///
/// This class represents a Pusher presence channel.
///
class PusherPresenceChannel extends PusherChannel implements PresenceChannel {
  PusherPresenceChannel(
    super.pusher,
    super.name,
    super.options,
  );

  /// Register a callback to be called anytime the member list changes.
  @override
  PusherPresenceChannel here(Function callback) {
    on('pusher:subscription_succeeded', callback);
    return this;
  }

  /// Listen for someone joining the channel.
  @override
  PusherPresenceChannel joining(Function callback) {
    on('pusher:member_added', callback);
    return this;
  }

  /// Listen for someone leaving the channel.
  @override
  PusherPresenceChannel leaving(Function callback) {
    on('pusher:member_removed', callback);
    return this;
  }

  /// Trigger client event on the channel.
  PusherPresenceChannel whisper(String eventName, dynamic data) {
    // pusher.channels[name].trigger('client-$eventName', data);
    subscription.trigger('client-$eventName', data);
    return this;
  }
}
