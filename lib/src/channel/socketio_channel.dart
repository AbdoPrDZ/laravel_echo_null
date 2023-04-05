import '../util/event_formatter.dart';
import 'channel.dart';

///
/// This class represents a Socket.io channel.
///
class SocketIoChannel extends Channel {
  /// The Socket.io client instance.
  dynamic socket;

  /// The name of the channel.
  String name;

  /// The event formatter.
  late EventFormatter eventFormatter;

  /// The event callbacks applied to the socket.
  Map<String, dynamic> events = {};

  /// User supplied callbacks for events on this channel
  Map<String, List> listeners = {};

  /// Create a new class instance.
  SocketIoChannel(this.socket, this.name, super.options) {
    eventFormatter = EventFormatter(options.namespace);
    subscribe();
  }

  /// Subscribe to a Socket.io channel.
  void subscribe() {
    socket.emit('subscribe', {
      'channel': name,
      'auth': options.auth,
    });
  }

  /// Unsubscribe from channel and ubind event callbacks.
  @override
  void unsubscribe() {
    unbind();
    socket.emit('unsubscribe', {
      'channel': name,
      'auth': options.auth,
    });
  }

  /// Listen for an event on the channel instance.
  @override
  SocketIoChannel listen(String event, Function callback) {
    on(eventFormatter.format(event), callback);

    return this;
  }

  /// Stop listening for an event on the channel instance.
  @override
  SocketIoChannel stopListening(String event, [Function? callback]) {
    _unbindEvent(eventFormatter.format(event), callback);

    return this;
  }

  /// Register a callback to be called anytime a subscription succeeds.
  @override
  SocketIoChannel subscribed(Function callback) {
    on('connect', (socket) => callback(socket));

    return this;
  }

  /// Register a callback to be called anytime an error occurs.
  @override
  SocketIoChannel error(Function callback) {
    return this;
  }

  /// Bind the channel's socket to an event and store the callback.
  SocketIoChannel on(String event, Function callback) {
    listeners[event] = listeners[event] ?? [];

    if (events[event] == null) {
      events[event] = (props) {
        String channel = props[0];
        dynamic data = props[1];
        if (name == channel && listeners[event]!.isNotEmpty) {
          for (var cb in listeners[event]!) {
            cb(data);
          }
        }
      };

      socket.on(event, events[event]);
    }

    listeners[event]?.add(callback);

    return this;
  }

  /// Unbind the channel's socket from all stored event callbacks.
  void unbind() {
    for (var event in List.from(events.keys)) {
      _unbindEvent(event);
    }
  }

  /// Unbind the listeners for the given event.
  void _unbindEvent(String event, [Function? callback]) {
    listeners[event] = listeners[event] ?? [];

    if (callback != null) {
      listeners[event] =
          listeners[event]!.where((cb) => cb != callback).toList();
    }

    if (callback == null || listeners[event]!.isEmpty) {
      if (events[event] != null) {
        socket.off(event, events[event]);

        events.remove(event);
      }

      listeners.remove(event);
    }
  }
}
