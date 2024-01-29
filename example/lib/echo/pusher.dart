import 'package:laravel_echo_null/laravel_echo_null.dart';
import 'package:pusher_client_fixed/pusher_client_fixed.dart';

const String appId = "1321495";
const String key = "037c47e0cbdc81fb7144";
const String cluster = "mt1";
const String hostAuthEndPoint = "http://192.168.1.100/broadcasting/auth";
const String token = "1|4X1WDn5stL0e8FK9TDRNodkTcc7CrT6GsKzDf9Cd62b08640";

Echo<PusherClient, PusherChannel> initPusherClient(
  Function(String message) log,
) {
  Echo<PusherClient, PusherChannel> pusherEcho = Echo.pusher(
    key,
    authEndPoint: hostAuthEndPoint,
    authHeaders: {'Authorization': 'Bearer $token'},
    cluster: cluster,
    enableLogging: true,
    autoConnect: false,
  );
  pusherEcho.connector.onConnectError(
    (error) => log('[Pusher Connection Error]: ${error?.message}'),
  );
  return pusherEcho;
}
