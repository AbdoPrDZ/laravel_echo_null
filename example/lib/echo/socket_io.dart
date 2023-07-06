import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:socket_io_client/socket_io_client.dart';

const String token = 'API_TOKEN';

Echo<Socket, SocketIoChannel> initSocketIOClient() => Echo.socket(
      'http://localhost:3000',
      autoConnect: false,
      auth: {
        'headers': {'Authorization': 'Bearer $token'}
      },
      moreOptions: {
        // 'transports': ['websocket', 'polling', 'flashsocket']
        'transports': ['websocket']
      },
    );
