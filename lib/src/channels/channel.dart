import '../connector/connector.dart';

abstract class Channel {
  /// The Echo options.
  final ConnectorOptions options;

  const Channel(this.options);

  /// Listen for an event on the channel instance.
  void listen(String event, Function callback);

  /// subscribe channel
  void subscribe();

  /// Unsubscribe channel
  void unsubscribe();

  /// Listen for a whisper event on the channel instance.
  void listenForWhisper(String event, Function callback) =>
      listen('.client-$event', callback);

  /// Listen for an event on the channel instance.
  void notification(Function callback) => listen(
        '.Illuminate\\Notifications\\Events\\BroadcastNotificationCreated',
        callback,
      );

  /// Stop listening to an event on the channel instance.
  void stopListening(String event, [Function? callback]);

  /// Stop listening for a whisper event on the channel instance.
  void stopListeningForWhisper(String event, [Function? callback]) =>
      stopListening('.client-$event', callback);

  /// Register a callback to be called anytime a subscription succeeds.
  void subscribed(Function callback);

  /// Register a callback to be called anytime an error occurs.
  void error(Function callback);
}
