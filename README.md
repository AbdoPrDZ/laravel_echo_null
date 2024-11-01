# laravel_echo_null

## Getting started

### Important information before using

- The `laravel_echo_null` package relies on the following packages:

  | Package                   | Version | URL Source                                                             |
  | ------------------------- | ------- | ---------------------------------------------------------------------- |
  | socket_io_client          | 3.0.0   | [pub.dev](https://pub.dev/packages/socket_io_client)                   |
  | pusher_client_socket      | 0.0.2+4 | [pub.dev](https://pub.dev/packages/pusher_client_socket)               |
  | fixed-laravel-echo-server | 0.1.4   | [npm](https://www.npmjs.com/package/@abdopr/fixed-laravel-echo-server) |

  To include these packages in your project, add the following dependencies to your `pubspec.yaml` file:

  ```yaml
  dependencies:
    socket_io_client: ^3.0.0
    pusher_client_socket: ^0.0.2+4
  ```

  Please note that the `laravel_echo_null` package requires the `socket_io_client` package at version 2.0.2. Additionally, to ensure compatibility with the package, use the `fixed-laravel-echo-server` version 0.0.1, which is available on npm. You can install it globally by running the following command:

  ```bash
  npm i -g @abdopr/fixed-laravel-echo-server
  ```

  For more information, please refer to the [official documentation](https://www.npmjs.com/package/@abdopr/fixed-laravel-echo-server) of `fixed-laravel-echo-server`.

  Make sure to add these dependencies and follow the instructions to include them properly in your project

### Importing

- ```dart
  import 'package:laravel_echo_null/laravel_echo_null.dart';
  ```

### Initializing

- Initialization using connector:

  ```dart
  //// Socket IO ////
  import 'package:socket_io_client/socket_io_client.dart' as IO;

  Echo<IO.Socket, SocketIoChannel> echo = Echo<IO.Socket, SocketIoChannel>(SocketIoConnector(
    'http://localhost:6001', // String: host
    nameSpace: 'nameSpace', // String?: namespace
    autoConnect: false, // bool: client connection automatically
    authHeaders: {
      'Authorization': 'Bearer token'
    },
    moreOptions: {// Map: more io options
      'transports': ['websocket']
    },
  ));

  ///// Pusher ////
  import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

  Echo<PUSHER.PusherClient, PusherChannel> echo = Echo<PUSHER.PusherClient, PusherChannel>(PusherConnector(
    'PUSHER_APP_KEY',
    authEndPoint: 'http://localhost/broadcasting/auth', // String?: auth host
    authHeaders: { // authenticate headers
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    cluster: 'PUSHER_CLUSTER', // String?: pusher cluster
    wsPort: 80,
    wssPort: 443,
    encrypted: true,
    activityTimeout: 120000,
    pongTimeout: 30000,
    maxReconnectionAttempts: 6,
    reconnectGap: Duration(seconds: 2),
    enableLogging: true,
    autoConnect: false, // bool: client connection automatically
    nameSpace: 'nameSpace',
  ));

  ///// Pusher With Laravel/Reverb  ////
  import 'package:pusher_client_socket/pusher_client_socket.dart' as PUSHER;

  Echo<PUSHER.PusherClient, PusherChannel> echo = Echo<PUSHER.PusherClient, PusherChannel>(PusherConnector(
    'PUSHER_APP_KEY',
    authEndPoint: 'http://localhost/broadcasting/auth', // String?: auth host
    authHeaders: { // authenticate headers
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    host: 'localhost',
    wsPort: 6001,
    encrypted: false,
    activityTimeout: 120000,
    pongTimeout: 30000,
    enableLogging: true,
    autoConnect: false, // bool: client connection automatically
    nameSpace: 'nameSpace',
  ));
  ```

- Easy initialization:

  ```dart
  //// Socket IO ////
  import 'package:socket_io_client/socket_io_client.dart';

  Echo<IO.Socket, SocketIoChannel> echo = Echo.socket(
    'http://localhost:6001', // String: host
    nameSpace: 'nameSpace', // String?: namespace
    autoConnect: false, // bool: client connection automatically
    authHeaders: {
      'Authorization': 'Bearer token'
    },
    moreOptions: {// Map: more io options
      'transports': ['websocket']
    },
  );

  ///// Pusher ////
  import 'package:pusher_client_socket/pusher_client_socket.dart';

  Echo<PUSHER.PusherClient, PusherChannel> echo = Echo.pusher(
    'PUSHER_APP_KEY',
    authEndPoint: 'http://localhost/broadcasting/auth', // String?: auth host
    authHeaders: { // authenticate headers
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    cluster: 'PUSHER_CLUSTER', // String?: pusher cluster
    wsPort: 80,
    wssPort: 443
    encrypted: true,
    activityTimeout: 120000,
    pongTimeout: 30000,
    maxReconnectionAttempts: 6,
    reconnectGap: Duration(seconds: 2),
    enableLogging: true,
    autoConnect: false, // bool: client connection automatically
    nameSpace: 'nameSpace',
  );

  ```

### Channels

- ```dart
  // public channel
  Channel publicChannel = echo.channel('my-channel');
  publicChannel.listen('MyEvent', (data) {
    print(data);
  });

  // private channel
  PrivateChannel privateChannel = echo.private('my-channel.1')
  privateChannel.listen('MyEvent', (data) {
    print(data);
  });

  // private encrypted channel
  PrivateEncryptedChannel privateEncryptedChannel = echo.privateEncrypted('my-channel.1')
  privateEncryptedChannel.listen('MyEvent', (data) {
    print(data);
  });

  // presence channel
  PresenceChannel presenceChannel = echo.join('presence-channel');
  presenceChannel.listen((data) {
    print(data);
  });
  ```

---

## `Note: This Package is the improved version of the original package "laravel_echo", with some modifications and features`

---

## Powered By Abdo-Pr

- GitHub Profile: <https://github.com/AbdoPrDZ>
- WhatsApp + Telegram (+213778185797)
- Facebook Account: <https://www.facebook.com/abdoprdz>
