# 💬 Chat App

A real-time cross-platform chat application built with Flutter. Each device gets a persistent identity and exchanges messages over a WebSocket connection in real time.

---

## What This App Does

- Generates a unique device identity on first launch and persists it locally
- Opens a WebSocket connection to a chat server
- Sends and receives real-time JSON messages
- Displays chat bubbles with sender name, timestamp, and alignment based on ownership

---

## ✨ Features

- Real-time messaging over WebSocket
- Persistent device identity across app restarts (no login required)
- Platform-aware device naming — Android brand/model, iOS name, Web Browser
- Optimistic UI — messages appear instantly before server round-trip
- Sender-aware chat bubbles — own messages styled differently from others
- HH:mm timestamps on every message
- BLoC state management for predictable UI updates
- Clean Architecture — data, domain, and presentation layers separated
- Dependency injection via GetIt
- Cross-platform — Android, iOS, and Web from a single codebase

---

## 🏗️ Architecture

```
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

### Data Flow

```
ChatPage → SendMessageEvent → ChatBloc → SocketManager → WebSocket Server
                                                ↓
ChatBloc ← incoming JSON stream ← SocketManager
```

---

## 🛠️ Tech Stack

| Package | Role |
|---------|------|
| `flutter` | UI framework |
| `flutter_bloc` | BLoC state management |
| `web_socket_channel` | WebSocket transport layer |
| `get_it` | Dependency injection |
| `shared_preferences` | Persist device identity locally |
| `device_info_plus` | Read platform/device metadata |
| `equatable` | Value equality for entities and BLoC states |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (Dart `^3.8.1`)
- A WebSocket chat backend running locally or remotely

### Install dependencies

```bash
flutter pub get
```

### Configure server URL

Update the WebSocket endpoints in `lib/main.dart`:

```dart
// Web
ws://localhost:3000

// Mobile
ws://192.168.1.7:3000
```

### Run

```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

### Verify

```bash
flutter analyze
flutter test
```

---
## License
MIT License

## 👤 Author

**Rony Dawoud** — Flutter Developer

[![LinkedIn](https://img.shields.io/badge/LinkedIn-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/rony-dawoud)
