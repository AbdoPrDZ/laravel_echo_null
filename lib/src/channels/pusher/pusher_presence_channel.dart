import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

import '../presence_channel.dart';
import 'pusher_channel.dart';

///
/// This class represents a Pusher presence channel.
///
class PusherPresenceChannel extends PusherChannel<PUSHER.PresenceChannel>
    implements PresenceChannel {
  PusherPresenceChannel(
    super.pusher,
    super.name,
    super.options,
  );

  /// Register a callback to be called anytime the member list changes.
  @override
  void here(Function callback) => on('pusher:subscription_succeeded', callback);

  /// Listen for someone joining the channel.
  @override
  void joining(Function callback) => on('pusher:member_added', callback);

  /// Listen for someone leaving the channel.
  @override
  void leaving(Function callback) => on('pusher:member_removed', callback);

  /// Trigger client event on the channel.
  void whisper(String eventName, dynamic data) =>
      subscription.trigger('client-$eventName', data);
}
