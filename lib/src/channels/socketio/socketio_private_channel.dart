import 'package:meta/meta.dart';

import '../private_channel.dart';
import 'socketio_channel.dart';

///
/// This class represents a Socket.io presence channel.
///
class SocketIoPrivateChannel extends SocketIoChannel implements PrivateChannel {
  SocketIoPrivateChannel(
    super.socket,
    super.name,
    super.options,
  );

  /// Trigger client event on the channel.
  @override
  void whisper(String eventName, dynamic data) => socket.emit('client event', {
        'channel': name,
        'event': 'client-$eventName',
        'data': data,
      });

  @override
  void onSubscribedSuccess(Function callback) =>
      listen('channel_subscribe_success', callback);

  AuthData? _authData;

  AuthData? get authData => _authData;

  @override
  void on(String event, Function callback) {
    super.on(event, (data) => callback(eventHandler(event, data)));
  }

  @protected
  Map eventHandler(String event, data) {
    if (event == 'channel_subscribe_success') {
      _authData = AuthData.fromJson(data);
    }

    return data;
  }
}

class AuthData {
  final Map<String, dynamic>? channelData;
  final String? sharedSecret;

  const AuthData(this.channelData, this.sharedSecret);

  factory AuthData.fromJson(Map<String, dynamic> json) => AuthData(
        json['channel_data'],
        json['shared_secret'],
      );
}
