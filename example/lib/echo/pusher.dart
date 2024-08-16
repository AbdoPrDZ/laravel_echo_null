import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_client_socket/pusher_client_socket.dart';

const String host = "localhost:6001";
// const String key = "037c47e0cbdc81fb7144";
const String key = "taefodv8dmh4w452l5e0";
// const String cluster = "mt1";
const String hostAuthEndPoint = "http://localhost/broadcasting/auth";
const String token = "5|QbkevD2CzFW1IsTScHIKX7knfCujcUHU9ETi1mPv3e543b31";

Echo<PusherClient, PusherChannel> initPusherClient(
  Function(String message) log,
) =>
    Echo.pusher(
      key,
      host: host,
      authEndPoint: hostAuthEndPoint,
      authHeaders: {'Authorization': 'Bearer $token'},
      // cluster: cluster,
      enableLogging: true,
      autoConnect: false,
    )..connector.onConnectError(
        (error) => log('[Pusher Connection Error]: ${error?.message}'),
      );
