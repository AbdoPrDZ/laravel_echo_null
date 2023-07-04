import 'event_formatter.dart';
import 'channel.dart';

///
/// This class represents a pusher channel.
///
class PusherChannel extends Channel {
  /// The Pusher client instance.
  dynamic pusher;

  /// The name of the channel.
  String name;

  /// The event formatter.
  // late EventFormatter eventFormatter;

  /// The subscription of the channel.
  dynamic subscription;

  /// Create a new class instance.
  PusherChannel(this.pusher, this.name, super.options) {
    // eventFormatter = EventFormatter(options.namespace);
    subscribe();
  }

  /// Subscribe to a Pusher channel.
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
  PusherChannel listen(String event, Function callback) {
    // return on(eventFormatter.format(event), callback);
    return on(EventFormatter.format(event, options.namespace), callback);
    // return this;
  }

  /// Listen for all events on the channel instance.
  PusherChannel listenToAll(Function callback) {
    subscription.bind_global((String event, dynamic data) {
      if (event.startsWith('pusher:')) return;

      String namespace =
          options.namespace?.replaceAll(RegExp(r'\.'), '\\') ?? '';
      String formattedEvent = event.startsWith(namespace)
          ? event.substring(namespace.length + 1)
          : '.$event';

      callback(formattedEvent, data);
    });
    return this;
  }

  /// Stop listening for an event on the channel instance.
  @override
  PusherChannel stopListening(String event, [Function? callback]) {
    if (callback != null) {
      // subscription.unbind(eventFormatter.format(event), callback);
      subscription.unbind(
          EventFormatter.format(event, options.namespace), callback);
    } else {
      // subscription.unbind(eventFormatter.format(event));
      subscription.unbind(EventFormatter.format(event, options.namespace));
    }
    return this;
  }

  /// Stop listening for all events on the channel instance.
  PusherChannel stopListeningAll([Function? callback]) {
    if (callback != null) {
      subscription.unbind_global(callback);
    } else {
      subscription.unbind_global();
    }
    return this;
  }

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
    if (subscription is Future) {
      subscription.then((channel) => channel.bind(event, callback));
    } else {
      subscription.bind(event, callback);
    }
    return this;
  }
}
