import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:socket_io_client/socket_io_client.dart';

const String token = '1|swt4l3JNT7nq9WlNfiueb0FXcCl0MdJ32zIpnD9Ha93f0720';

Echo<Socket, SocketIoChannel> initSocketIOClient() => Echo.socket(
      'http://localhost:6001',
      autoConnect: false,
      authHeaders: {'Authorization': 'Bearer $token'},
      moreOptions: {
        'transports': ['websocket']
      },
    );
