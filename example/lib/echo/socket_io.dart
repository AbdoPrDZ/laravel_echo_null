import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:socket_io_client/socket_io_client.dart';

const String token = '34|yzWaxwGZz75Xqk4tXviP4uhAc0sVB14OLVXEmoxg';

Echo<Socket, SocketIoChannel> initSocketIOClient() => Echo.socket(
      'http://192.168.1.105:6001',
      autoConnect: false,
      authHeaders: {'Authorization': 'Bearer $token'},
      moreOptions: {
        'transports': ['websocket']
      },
    );
