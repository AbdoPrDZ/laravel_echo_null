import 'package:pusher_client_fixed/pusher_client_fixed.dart' as PUSHER;

import 'event_formatter.dart';
import 'channel.dart';

///
/// This class represents a pusher channel.
///
class PusherChannel extends Channel {
  /// The Pusher client instance.
  final PUSHER.PusherClient pusher;

  /// The name of the channel.
  final String name;

  /// The subscription of the channel.
  late PUSHER.Channel subscription;

  /// Create a new class instance.
  PusherChannel(this.pusher, this.name, super.options) {
    subscribe();
  }

  /// Subscribe to a Pusher channel.
  @override
  void subscribe() => subscription = pusher.subscribe(name);

  /// Unsubscribe from a channel.
  @override
  void unsubscribe() => pusher.unsubscribe(name);

  /// Listen for an event on the channel instance.
  @override
  PusherChannel listen(String event, Function callback) =>
      on(EventFormatter.format(event, options.nameSpace), callback);

  /// Stop listening for an event on the channel instance.
  @override
  PusherChannel stopListening(String event, [Function? callback]) {
    subscription.unbind(EventFormatter.format(event, options.nameSpace));
    return this;
  }

  /// Register a callback to be called anytime a subscription succeeds.
  @override
  PusherChannel subscribed(Function callback) =>
      on('pusher:subscription_succeeded', () => callback());

  /// Register a callback to be called anytime a subscription error occurs.
  @override
  PusherChannel error(Function callback) =>
      on('pusher:subscription_error', (status) => callback(status));

  /// Bind a channel to an event.
  PusherChannel on(String event, Function callback) {
    subscription.bind(event, (event) => callback(event?.data));
    return this;
  }
}
