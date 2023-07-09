# laravel_echo_null

## Getting started

### Important information before using

- The `laravel_echo_null` package relies on the following packages:

  | Package                    | Version   | URL Source                                                             |
  | -------------------------- | --------- | ---------------------------------------------------------------------- |
  | socket_io_client           | 2.0.2     | [pub.dev](https://pub.dev/packages/socket_io_client)                   |
  | pusher_client_fixed        | 0.0.2     | [pub.dev](https://pub.dev/packages/pusher_client_fixed)                |
  | fixed-laravel-echo-server  | 0.0.1     | [npm](https://www.npmjs.com/package/@abdopr/fixed-laravel-echo-server) |

  To include these packages in your project, add the following dependencies to your `pubspec.yaml` file:

  ```yaml
  dependencies:
    socket_io_client: ^2.0.2
    pusher_client_fixed: ^0.0.2
  ```

  Please note that the `laravel_echo_null` package requires the `socket_io_client` package at version 2.0.2. Additionally, to ensure compatibility with the package, use the `fixed-laravel-echo-server` version 0.0.1, which is available on npm. You can install it globally by running the following command:

  ```bash
  npm i -g @abdopr/fixed-laravel-echo-server
  ```

  For more information, please refer to the [official documentation](https://pub.dev/packages/socket_io_client) of `fixed-laravel-echo-server`.

  Make sure to add these dependencies and follow the instructions to include them properly in your project  

### Importing

- ```dart
  import 'package:laravel_echo_null/laravel_echo_null.dart';
  ```

### Initializing

- Simple initialization:

  ```dart
  Echo echo = Echo(Connector(ConnectorOptions(
    client, // T: Socket / PusherClient
    auth: {}, // Map?: auth options
    authEndpoint: 'http://localhost/broadcasting/auth', // String?: auth host
    host: 'http://localhost', // String?: host
    key: 'CLIENT_KEY', // String?: client key
    namespace: 'namespace', // String?: namespace
    autoConnect: false, // bool: client connection automatically
    moreOptions: {}, // Map: more echo options
  )));
  ```

- Initialization using connector:

  ```dart
  //// Socket IO ////
  import 'package:socket_io_client/socket_io_client.dart';

  Socket socket = io('http://localhost');
  Echo<Socket> echo = Echo<Socket>(SocketIoConnector(
    socket, // Socket: Socket client
    auth: {}, // Map?: auth options
    authEndpoint: 'http://localhost/broadcasting/auth', // String?: auth host
    host: 'http://localhost', // String?: host
    key: 'CLIENT_KEY', // String?: client key
    namespace: 'namespace', // String?: namespace
    autoConnect: false, // bool: client connection automatically
    moreOptions: {}, // Map: more echo options
  ));

  ///// Pusher ////
  import 'package:pusher_client_fixed/pusher_client_fixed.dart';

  PusherClient pusher = PusherClient(
    'PUSHER_APP_KEY',
    PusherOptions(
      host: 'http://localhost',
      wsPort: 6001,
      cluster: 'mt1',
      auth: PusherAuth(
        'http://localhost/broadcasting/auth',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    ),
    autoConnect: false,
    enableLogging: true,
  );
  Echo<PusherClient> echo = Echo<PusherClient>(PusherConnector(
    pusher, // PusherClient: Pusher client
    auth: {}, // Map?: auth options
    authEndpoint: 'http://localhost/broadcasting/auth', // String?: auth host
    host: 'http://localhost', // String?: host
    key: 'PUSHER_KEY', // String?: client key
    namespace: 'namespace', // String?: namespace
    autoConnect: false, // bool: client connection automatically
    moreOptions: {}, // Map: more echo options
  ));
  ```

- Easy initialization:

  ```dart
  //// Socket IO ////
  import 'package:socket_io_client/socket_io_client.dart';

  Echo echo = Echo.socket(
    'http://127.0.0.1:6001',
    autoConnect: false,
    auth: {
      'headers': {'Authorization': 'Bearer $token'}
    },
    moreOptions: {
      'transports': ['websocket'],
    },
  );

  ///// Pusher ////
  import 'package:pusher_client_fixed/pusher_client_fixed.dart';
  
  PusherOptions options = PusherOptions(
    host: 'http://localhost',
    wsPort: 6001,
    cluster: 'mt1',
    auth: PusherAuth(
      'http://localhost/broadcasting/auth',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Echo echo = Echo.pusher(
    'PUSHER_KEY',
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

  ```

### Channels

- ```dart
  // public channel
  Channel publicChannel = echo.channel('my-channel');
  publicChannel.listen('MyEvent', (data) {
    print(data);
  });

  // private channel
  Channel privateChannel = echo.private('my-channel.1')
  privateChannel.listen('MyEvent', (data) {
    print(data);
  });

  // presence channel
  PresenceChannel presenceChannel = echo.join('presence-channel');
  presenceChannel.listen((data) {
    print(data);
  });
  ```

----------------------------------------------------------------------------------------------------------------------------

## `Note: This Package is the improved version of the original package "laravel_echo", with some modifications and features`

----------------------------------------------------------------------------------------------------------------------------

## Powered By Abdo-Pr

- GitHub Profile: <https://github.com/AbdoPrDZ>
- WhatsApp + Telegram (+213778185797)
- Facebook Account: <https://www.facebook.com/profile.php?id=100008024286034>