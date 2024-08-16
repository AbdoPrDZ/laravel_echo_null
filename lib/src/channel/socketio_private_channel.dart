import 'private_channel.dart';
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
  SocketIoPrivateChannel whisper(String eventName, dynamic data) => this
    ..socket.emit('client event', {
      'channel': name,
      'event': 'client-$eventName',
      'data': data,
    });

  @override
  SocketIoChannel onSubscribedSuccess(Function callback) =>
      listen('channel_subscribe_success', callback);
}
