[//]: # (DON'T MODIFY: This file is generated from template at "./Building/Templates/README-template.md".)

[![Linux][gh-linux-badge]][gh-linux-actions]
[![macOS][gh-macos-badge]][gh-macos-actions]

# BlinkTool

A command-line tool for managing [Blink](https://blinkforhome.com) camera system.

[gh-linux-actions]: https://github.com/grigorye/BlinkTool/actions?query=workflow%3ALinux
[gh-macos-actions]: https://github.com/grigorye/BlinkTool/actions?query=workflow%3AmacOS
[gh-linux-badge]: https://github.com/grigorye/BlinkTool/workflows/Linux/badge.svg
[gh-macos-badge]: https://github.com/grigorye/BlinkTool/workflows/macOS/badge.svg

[//]: # (Usage.md)

## Usage
```
OVERVIEW: Tool to manage Blink cameras

USAGE: blink-tool <subcommand>

OPTIONS:
  -h, --help              Show help information.

SUBCOMMANDS:
  login                   Login into account
  verify-pin              Verify PIN
  home-screen             Show home screen info
  get-camera-thumbnail    Download Camera Thumbnail
  get-video-events        Get video events
  get-video-events-media  Get media for video events
  get-video               Get video
  toggle-camera           Toggle camera
  remove-obsolete-media   Remove media that is no longer available remotely.

  See 'blink-tool help <subcommand>' for detailed help.
```

## Commands
### login

```
OVERVIEW: Login into account

USAGE: blink-tool login --email <email> [--password <password>] [--reauth <reauth>] [--json <json>]

OPTIONS:
  --email <email>         E-mail
  --password <password>   Password
  --reauth <reauth>       Reauthenticate (default: true)
  --json <json>           Enable JSON Output
  -h, --help              Show help information.
```
### verify-pin

```
OVERVIEW: Verify PIN

USAGE: blink-tool verify-pin --pin <pin> --email <email> [--password <password>] [--reauth <reauth>] [--json <json>]

OPTIONS:
  --pin <pin>             Pin
  --email <email>         E-mail
  --password <password>   Password
  --reauth <reauth>       Reauthenticate (default: true)
  --json <json>           Enable JSON Output
  -h, --help              Show help information.
```
### home-screen

```
OVERVIEW: Show home screen info

USAGE: blink-tool home-screen --email <email> [--password <password>] [--reauth <reauth>] [--json <json>]

OPTIONS:
  --email <email>         E-mail
  --password <password>   Password
  --reauth <reauth>       Reauthenticate (default: true)
  --json <json>           Enable JSON Output
  -h, --help              Show help information.
```
### get-camera-thumbnail

```
OVERVIEW: Download Camera Thumbnail

USAGE: blink-tool get-camera-thumbnail --network-id <network-id> --camera-id <camera-id> --email <email> [--password <password>] [--reauth <reauth>] [--json <json>]

OPTIONS:
  --network-id <network-id>
                          Network ID
  --camera-id <camera-id> Camera ID
  --email <email>         E-mail
  --password <password>   Password
  --reauth <reauth>       Reauthenticate (default: true)
  --json <json>           Enable JSON Output
  -h, --help              Show help information.
```
### get-video-events

```
OVERVIEW: Get video events

USAGE: blink-tool get-video-events [--page <page>] [--since <since>] --email <email> [--password <password>] [--reauth <reauth>] [--json <json>]

OPTIONS:
  --page <page>           Page
  --since <since>         Since date
  --email <email>         E-mail
  --password <password>   Password
  --reauth <reauth>       Reauthenticate (default: true)
  --json <json>           Enable JSON Output
  -h, --help              Show help information.
```
### get-video-events-media

```
OVERVIEW: Get media for video events

USAGE: blink-tool get-video-events-media [--page <page>] [--max-downloads <max-downloads>] [--since <since>] [--destination <destination>] --email <email> [--password <password>] [--reauth <reauth>] [--json <json>]

OPTIONS:
  --page <page>           Page
  --max-downloads <max-downloads>
                          Maximum number of simultaneous downloads
  --since <since>         Since date
  --destination <destination>
                          Root
  --email <email>         E-mail
  --password <password>   Password
  --reauth <reauth>       Reauthenticate (default: true)
  --json <json>           Enable JSON Output
  -h, --help              Show help information.
```
### get-video

```
OVERVIEW: Get video

USAGE: blink-tool get-video --media <media> --email <email> [--password <password>] [--reauth <reauth>] [--json <json>]

OPTIONS:
  --media <media>         Media Path
  --email <email>         E-mail
  --password <password>   Password
  --reauth <reauth>       Reauthenticate (default: true)
  --json <json>           Enable JSON Output
  -h, --help              Show help information.
```
### toggle-camera

```
OVERVIEW: Toggle camera

USAGE: blink-tool toggle-camera --network-id <network-id> --camera-id <camera-id> --on --off --email <email> [--password <password>] [--reauth <reauth>] [--json <json>]

OPTIONS:
  --network-id <network-id>
                          Network ID
  --camera-id <camera-id> Camera ID
  --on/--off              On/Off
  --email <email>         E-mail
  --password <password>   Password
  --reauth <reauth>       Reauthenticate (default: true)
  --json <json>           Enable JSON Output
  -h, --help              Show help information.
```
### remove-obsolete-media

```
OVERVIEW: Remove media that is no longer available remotely.

USAGE: blink-tool remove-obsolete-media [--destination <destination>] --email <email> [--password <password>] [--reauth <reauth>] [--json <json>]

OPTIONS:
  --destination <destination>
                          Root
  --email <email>         E-mail
  --password <password>   Password
  --reauth <reauth>       Reauthenticate (default: true)
  --json <json>           Enable JSON Output
  -h, --help              Show help information.
```
