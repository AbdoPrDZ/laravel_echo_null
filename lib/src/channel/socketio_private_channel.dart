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
  SocketIoPrivateChannel whisper(String eventName, dynamic data) {
    socket.emit('client event', {
      'channel': name,
      'event': 'client-$eventName',
      'data': data,
    });

    return this;
  }
}
