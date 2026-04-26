# Chat Application (Flutter)

A real-time cross-platform chat client built with Flutter that identifies each device, persists that identity locally, and exchanges JSON messages over a WebSocket server.

## What this app actually does

This app starts by generating (or reusing) a local device identity and then opens a WebSocket connection to a configured server:

- **Device identity bootstrap**
  - Reads `deviceId` and `deviceName` from `SharedPreferences`.
  - If missing, creates a new `device_<timestamp>` ID and derives a platform-aware device name (Android brand/model, iOS name/machine, macOS/Windows computer name, or `Web Browser`).
- **WebSocket session setup**
  - Connects to `ws://localhost:3000` on web.
  - Connects to `ws://192.168.1.7:3000` on non-web platforms.
- **Real-time chat flow**
  - Sending a message immediately updates UI state and pushes JSON to the socket.
  - Incoming socket payloads are JSON-decoded and appended to the chat timeline.
  - Messages include `id`, `senderId`, `senderName`, `content`, and ISO timestamp.
- **Conversation rendering**
  - Displays reverse-ordered chat bubbles (latest near input area).
  - Styles own messages differently from others.
  - Shows sender name only for messages from other devices.
  - Shows HH:mm timestamps on each bubble.

## Features verified in this codebase

- Dark-themed single-screen chat UI (`ChatPage`) with text input + send action.
- Message bubbles with sender-aware alignment and color treatment.
- BLoC-based in-memory message state (`ChatBloc` + events/state).
- WebSocket manager with broadcast message stream and UTF-8 byte decoding support.
- Dependency injection via `GetIt` (`SocketManager`, data source, repository, use cases, and `ChatBloc` factory params).
- Conditional platform imports to avoid `dart:io` usage on web.
- Multi-platform project scaffolding for Android, iOS, macOS, and web.

## Architecture

The project uses a **feature-first clean-ish layering** for chat (`presentation` / `domain` / `data`) with some direct wiring from presentation to core socket infrastructure.

```text
lib/
├── core/
│   ├── di/
│   │   └── injection_container.dart
│   └── network/
│       └── socket_manager.dart
├── features/
│   └── chat/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── chat_socket_datasource_impl.dart
│       │   ├── models/
│       │   │   └── message_model.dart
│       │   └── repositories/
│       │       └── chat_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── message.dart
│       │   ├── repositories/
│       │   │   └── chat_repository.dart
│       │   └── usecases/
│       │       ├── receive_message_usecase.dart
│       │       └── send_message_usecase.dart
│       └── presentation/
│           ├── blocs/
│           │   ├── chat_bloc.dart
│           │   ├── chat_event.dart
│           │   └── chat_state.dart
│           ├── pages/
│           │   └── chat_page.dart
│           └── widgets/
│               └── message_bubble.dart
├── main.dart
└── src/
    ├── platform_io.dart
    └── platform_stub.dart
```

### Runtime data flow

1. `main.dart` gets/creates local device info and initializes DI + socket connection.
2. `ChatPage` dispatches `SendMessageEvent` to `ChatBloc`.
3. `ChatBloc` updates local state and sends serialized message through `SocketManager`.
4. `SocketManager` emits incoming raw JSON strings.
5. `ChatBloc` listens to the stream, deserializes, and emits updated message list.

## Tech stack

| Package | Role in this project |
|---|---|
| `flutter` | UI framework and runtime for all targets. |
| `cupertino_icons` | iOS-style icon font dependency (template-level, available for use). |
| `equatable` | Included dependency; currently not used by chat entities/events/state. |
| `get_it` | Service locator for app-level dependency injection and parameterized `ChatBloc` factory. |
| `flutter_bloc` | Event/state management and widget binding (`BlocProvider`, `BlocBuilder`). |
| `socket_io_client` | Included dependency; currently not used (the app uses raw WebSocket channel instead). |
| `web_socket_channel` | Actual transport layer used to connect/send/receive over WebSocket. |
| `intl` | Included dependency; currently not used (timestamps are manually formatted). |
| `uuid` | Included dependency; currently not used (message IDs use timestamp string). |
| `shared_preferences` | Persists `deviceId` and `deviceName` locally between launches. |
| `device_info_plus` | Reads platform/device metadata for first-run `deviceName`. |
| `flutter_test` (dev) | Widget test framework (`test/widget_test.dart`). |
| `flutter_lints` (dev) | Lint rules via `analysis_options.yaml`. |

## How to run locally

### Prerequisites

- Flutter SDK installed (compatible with Dart `^3.8.1` in `pubspec.yaml`).
- A WebSocket chat backend running and reachable.

### 1) Install dependencies

```bash
flutter pub get
```

### 2) Configure server endpoint

The app currently hardcodes endpoints in `lib/main.dart`:

- Web: `ws://localhost:3000`
- Mobile/Desktop: `ws://192.168.1.7:3000`

If your server runs elsewhere, update those constants before launching.

### 3) Run

```bash
# Web
flutter run -d chrome

# Android (example)
flutter run -d android

# iOS (example)
flutter run -d ios

# macOS (example)
flutter run -d macos
```

### 4) Optional checks

```bash
flutter analyze
flutter test
```

## Notable technical decisions in this code

1. **Device identity is persisted once and reused**
   - This enables sender attribution across app restarts without auth.

2. **Optimistic local message append on send**
   - UI updates immediately in `ChatBloc` before network round-trip.

3. **Socket connection established at app startup in DI init**
   - `SocketManager.connect(url)` is called during `init()`, not lazily per screen.

4. **`ChatBloc` directly depends on `SocketManager`**
   - Although repository/use case layers exist and are registered, current presentation flow bypasses them for message handling.

5. **Manual timestamp formatting (`HH:mm`) in widget layer**
   - Keeps formatting simple, but leaves `intl` unused.

6. **Web-safe platform detection via conditional imports**
   - Prevents `dart:io` references on web builds by using `platform_stub.dart` fallback.
