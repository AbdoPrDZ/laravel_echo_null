import 'package:pusher_client_fixed/pusher_client_fixed.dart' as PUSHER;

// import 'package:dart_pusher_channels/dart_pusher_channels.dart'  as PUSHER;

import 'event_formatter.dart';
import 'channel.dart';

///
/// This class represents a pusher channel.
///
class PusherChannel extends Channel {
  /// The Pusher client instance.
  PUSHER.PusherClient pusher;
  // dynamic pusher;

  /// The name of the channel.
  String name;

  /// The subscription of the channel.
  // dynamic subscription;
  late PUSHER.Channel subscription;

  /// Create a new class instance.
  PusherChannel(this.pusher, this.name, super.options) {
    subscribe();
  }

  /// Subscribe to a Pusher channel.
  @override
  void subscribe() {
    subscription = pusher.subscribe(name);
  }

  /// Unsubscribe from a channel.
  @override
  void unsubscribe() {
    pusher.unsubscribe(name);
  }

  /// Listen for an event on the channel instance.
  @override
  PusherChannel listen(String event, Function callback) =>
      on(EventFormatter.format(event, options.nameSpace), callback);

  /// Listen for all events on the channel instance.
  // PusherChannel listenToAll(Function callback) {
  //   subscription.bind_global((String event, dynamic data) {
  //     if (event.startsWith('pusher:')) return;

  //     String namespace =
  //         options.nameSpace?.replaceAll(RegExp(r'\.'), '\\') ?? '';
  //     String formattedEvent = event.startsWith(namespace)
  //         ? event.substring(namespace.length + 1)
  //         : '.$event';

  //     callback(formattedEvent, data);
  //   });
  //   return this;
  // }

  /// Stop listening for an event on the channel instance.
  @override
  PusherChannel stopListening(String event, [Function? callback]) {
    if (callback != null) {
      subscription.unbind(
          // EventFormatter.format(event, options.nameSpace), callback);
          EventFormatter.format(event, options.nameSpace));
    } else {
      subscription.unbind(EventFormatter.format(event, options.nameSpace));
    }
    return this;
  }

  /// Stop listening for all events on the channel instance.
  // PusherChannel stopListeningAll([Function? callback]) {
  //   if (callback != null) {
  //     subscription.unbind_global(callback);
  //   } else {
  //     subscription.unbind_global();
  //   }
  //   return this;
  // }

  /// Register a callback to be called anytime a subscription succeeds.
  @override
  PusherChannel subscribed(Function callback) =>
      on('pusher:subscription_succeeded', () => callback());

  ///  Register a callback to be called anytime a subscription error occurs.
  @override
  PusherChannel error(Function callback) =>
      on('pusher:subscription_error', (status) => callback(status));

  /// Bind a channel to an event.
  PusherChannel on(String event, Function callback) {
    // if (subscription is Future) {
    //   subscription.then((channel) => channel.bind(event, callback));
    // } else {
    subscription.bind(event, (event) => callback(event?.data));
    // }
    return this;
  }
}
