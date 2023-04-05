import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:socket_io_client/socket_io_client.dart';

const String token = 'API_TOKEN';

Echo<Socket> initSocketIOClient() => Echo.socket(
      'http://127.0.0.1:6001',
      autoConnect: false,
      auth: {
        'headers': {'Authorization': 'Bearer $token'}
      },
      moreOptions: {
        'transports': ['websocket'],
      },
    );
