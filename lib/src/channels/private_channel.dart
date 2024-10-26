import 'channel.dart';

///
/// This interface represents a presence channel.
///
abstract class PrivateChannel extends Channel {
  const PrivateChannel(super.options);

  /// Register a callback to be called anytime the member list changes.
  void whisper(String eventName, dynamic data);

  /// listen to on subscribe success event
  void onSubscribedSuccess(Function callback);
}
