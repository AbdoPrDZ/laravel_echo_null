import 'channel.dart';

///
/// This interface represents a presence channel.
///
abstract class PrivateChannel extends Channel {
  PrivateChannel(super.options);

  /// Register a callback to be called anytime the member list changes.
  PrivateChannel whisper(String eventName, dynamic data);

  Channel onSubscribedSuccess(Function callback);
}
