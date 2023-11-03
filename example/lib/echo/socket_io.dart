import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:socket_io_client/socket_io_client.dart';

const String token = '2|2gAA0Z1w43jasatIFaw0MD3H8LSDeGIoK2sCtTDw6ac6eb51';

Echo<Socket, SocketIoChannel> initSocketIOClient() => Echo.socket(
      'http://localhost:6001',
      autoConnect: false,
      authHeaders: {'Authorization': 'Bearer $token'},
      moreOptions: {
        'transports': ['websocket']
      },
    );
