import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

import '../private_channel.dart';
import 'pusher_channel.dart';

///
/// This class represents a Pusher private channel.
///
class PusherPrivateChannel extends PusherChannel<PUSHER.PrivateChannel>
    implements PrivateChannel {
  PusherPrivateChannel(
    super.pusher,
    super.name,
    super.options,
  );

  /// Trigger client event on the channel.
  @override
  void whisper(String eventName, dynamic data) =>
      subscription.trigger('client-$eventName', data);

  /// listen to on subscribe success event
  @override
  void onSubscribedSuccess(Function callback) =>
      subscription.onSubscriptionSuccess(callback);

  /// listen to on subscribe count event
  @override
  void onSubscribedCount(Function callback) =>
      subscription.onSubscriptionCount(callback);
}
