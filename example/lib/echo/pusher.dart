import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';

const String appId = "PUSHER_APP_ID";
const String key = "PUSHER_KEY";
const String cluster = "PUSHER_CLUSTER";
const String hostEndPoint = "http://localhost";
const String hostAuthEndPoint = "$hostEndPoint/broadcasting/auth";
const String token = "API_TOKEN";
const int port = 6001;

Echo<PusherClient, PusherChannel> initPusherClient() {
  PusherOptions options = PusherOptions(
    host: hostEndPoint,
    wsPort: port,
    cluster: cluster,
    auth: PusherAuth(
      hostAuthEndPoint,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Echo<PusherClient, PusherChannel> pusherEcho = Echo.pusher(
    key,
    options,
    autoConnect: false,
    auth: options.auth?.toJson(),
    authEndpoint: options.auth?.endpoint,
    host: options.host,
    moreOptions: {
      'cluster': options.cluster,
      'encrypted': options.encrypted,
      'activityTimeout': options.activityTimeout,
      'pongTimeout': options.pongTimeout,
      'wsPort': options.wsPort,
      'wssPort': options.wssPort,
      'maxReconnectionAttempts': options.maxReconnectionAttempts,
      'maxReconnectGapInSeconds': options.maxReconnectGapInSeconds,
    },
  );
  pusherEcho.connector.onConnectError(
    (error) => print('[Pusher Connection Error]: ${error?.message}'),
  );
  return pusherEcho;
}
