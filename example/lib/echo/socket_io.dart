import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:socket_io_client/socket_io_client.dart';

const String token = '1|EQCv4LXWHr8Ku9K8b859VhLk2jLdkZdUHRbAmIQhf2eae418';

Echo<Socket, SocketIoChannel> initSocketIOClient() => Echo.socket(
      'http://localhost:6001',
      autoConnect: false,
      authHeaders: {'Authorization': 'Bearer $token'},
      moreOptions: {
        'transports': ['websocket']
      },
    );
