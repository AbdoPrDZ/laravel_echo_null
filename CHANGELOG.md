## 0.0.1

- First Version of laravel_echo_null package whose function is to connect to laravel echo server using Socket.io or Pusher

## 0.0.2

- Generate a channels map in connector class

## 0.0.3

- Add connector connection events

## 0.0.4

- Fixed some issues that were occurring.
- Fixed the pusher_client Kotlin SDK version to ensure compatibility.
- Updated the package to work with `socket.io@4.x` on the server side and `socket.io-client@2.x` on the client side.

## 0.0.4+1

- Upgrade pusher_client_fixed to 0.0.2

## 0.0.5

- Clean up the code.

## 0.0.5+1

- Edit README.md

## 0.0.5+2

- Edit Pusher Channels

## 0.0.5+3

- Update Flutter Sdk version

## 0.0.5+4

- Add on private channel subscribed event

## 0.0.5+5

- Upgrade dependencies

## 0.0.5+6

- Fix onSubscribeSuccess event in pusher client

## 0.0.5+7

- Upgrade dependencies

## 0.0.5+8

- Upgrade dependencies

## 0.0.5+9

- Add auth headers with socket client options

## 0.0.5+10

- Edit socket.io connector connect function.
- Add other events handlers in connector.

## 0.0.6 - May 13, 2024

- Update readme.
- Upgrade flutter sdk and dependencies.
- Edit example.

## 0.0.6 - May 13, 2024

- Upgrade flutter sdk and dependencies.


## 0.0.7 - Aug 16, 2024

- Replace `pusher_client_fixed` package with `pusher_client_socket`.
- Support all platforms [Android, IOS, MacOs, Windows, Linux].

## 0.0.7+1 - Aug 18, 2024

- Upgrade `pusher_client_socket` to ^0.0.2.

## 0.0.8 - Aug 18, 2024

- Add `private-encrypted-channel` feature to socket.io channels.

    **Note:** you need use a custom broadcaster for this feature see [EncryptedRedisBroadcaster](https://gist.github.com/AbdoPrDZ/415fcaf6568cef762e2b3eeb019c16bd) gist.

- Fixed some issues that were occurring.
