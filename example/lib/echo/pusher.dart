import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';

const String appId = "1321495";
const String key = "037c47e0cbdc81fb7144";
const String cluster = "mt1";
const String hostEndPoint = "192.168.1.105";
const String hostAuthEndPoint = "http://$hostEndPoint/broadcasting/auth";
const String token = "34|yzWaxwGZz75Xqk4tXviP4uhAc0sVB14OLVXEmoxg";
const int port = 6001;

Echo<PusherClient, PusherChannel> initPusherClient(
    Function(String message) log) {
  PusherOptions options = PusherOptions(
    host: hostEndPoint,
    wsPort: port,
    cluster: cluster,
    encrypted: true,
    auth: PusherAuth(
      hostAuthEndPoint,
      headers: {
        'Authorization': 'Bearer $token',
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
    (error) => log('[Pusher Connection Error]: ${error?.message}'),
  );
  return pusherEcho;
}
