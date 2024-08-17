import 'channel.dart';

///
/// This interface represents a presence channel.
///
abstract class PrivateEncryptedChannel extends Channel {
  const PrivateEncryptedChannel(super.options);

  /// listen to on subscribe success event
  void onSubscribedSuccess(Function callback);

  /// Register a callback to be called anytime the member list changes.
  void whisper(String eventName, dynamic data) {
    throw Exception('This method is not available for encrypted channels');
  }
}
