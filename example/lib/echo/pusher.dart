import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_client_socket/pusher_client_socket.dart';

const String host = "localhost";
const int wsPort = 6001;
const String key = "PUSHER_KEY";
const String hostAuthEndPoint = "http://localhost/broadcasting/auth";
const String token = "AUTH_TOKEN";

Echo<PusherClient, PusherChannel> initPusherClient(
  Function(String message) log,
) =>
    Echo.pusher(
      key,
      host: host,
      wsPort: wsPort,
      authEndPoint: hostAuthEndPoint,
      authHeaders: {'Authorization': 'Bearer $token'},
      enableLogging: true,
      autoConnect: false,
      encrypted: false,
    )..connector.onConnectError(
        (error) => log('[Pusher Connection Error]: ${error?.message}'),
      );
