import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

import '../channel.dart';
import '../event_formatter.dart';

///
/// This class represents a pusher channel.
///
class PusherChannel<PChannelT extends PUSHER.Channel> extends Channel {
  /// The Pusher client instance.
  final PUSHER.PusherClient pusher;

  /// The name of the channel.
  final String name;

  /// The subscription of the channel.
  late PChannelT subscription;

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
  void listen(String event, Function callback) =>
      on(EventFormatter.format(event, options.nameSpace), callback);

  /// Stop listening for an event on the channel instance.
  @override
  void stopListening(String event, [Function? callback]) =>
      subscription.unbind(EventFormatter.format(event, options.nameSpace));

  /// Register a callback to be called anytime a subscription succeeds.
  @override
  void subscribed(Function callback) =>
      subscription.onSubscriptionSuccess((event) => callback(event?.data));

  /// Register a callback to be called anytime a subscription error occurs.
  @override
  void error(Function callback) {}

  /// Bind a channel to an event.
  void on(String event, Function callback) =>
      subscription.bind(event, (event) => callback(event?.data));
}
