import 'private_channel.dart';

///
/// This interface represents a presence channel.
///
abstract class PresenceChannel extends PrivateChannel {
  const PresenceChannel(super.options);

  /// listen to on subscribe count event
  void onSubscribedCount(Function callback);

  /// Register a callback to be called anytime the member list changes.
  void here(Function callback);

  /// Listen for someone joining the channel.
  void joining(Function callback);

  /// Listen for someone leaving the channel.
  void leaving(Function callback);
}
