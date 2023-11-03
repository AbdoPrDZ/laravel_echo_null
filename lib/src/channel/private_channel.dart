import 'channel.dart';

///
/// This interface represents a presence channel.
///
abstract class PrivateChannel extends Channel {
  const PrivateChannel(super.options);

  /// Register a callback to be called anytime the member list changes.
  PrivateChannel whisper(String eventName, dynamic data);

  /// listen to on subscribe success event
  Channel onSubscribedSuccess(Function callback);
}
