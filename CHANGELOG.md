# Changelog

All notable changes to WakeSenpai will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-01-XX

### Added
- ✨ **Core Alarm Functionality**
  - Create, edit, delete, and toggle alarms
  - Support for one-time and daily recurring alarms
  - Local notifications for alarm alerts
  - Time picker with intuitive UI

- 🎮 **Interactive Challenge Games**
  - Sliding puzzle challenge (3x3 grid)
  - Gesture-based shake challenge using accelerometer
  - Challenge completion tracking

- 💾 **Data Persistence**
  - Hive database for local storage
  - Encrypted storage for sensitive data
  - User statistics and progress tracking
  - Alarm history and settings

- 🎨 **Modern UI/UX**
  - Material Design 3 implementation
  - Responsive design for all screen sizes
  - Smooth animations and transitions
  - Intuitive navigation flow

- 🔧 **Developer Experience**
  - MVVM architecture pattern
  - Provider state management
  - Comprehensive error handling
  - Unit and widget tests

- 🚀 **CI/CD Pipeline**
  - Automated testing on pull requests
  - Multi-platform builds (Android, iOS, Web)
  - Code quality checks and formatting
  - Security scanning with Trivy
  - Automated releases with GitHub Actions

### Technical Details
- **Flutter Version**: 3.22.2
- **Dart Version**: >=3.0.0 <4.0.0
- **Target Platforms**: Android, iOS, Web
- **Architecture**: MVVM with Provider
- **Database**: Hive (local NoSQL)
- **Notifications**: flutter_local_notifications

### Dependencies
- `provider: ^6.0.5` - State management
- `hive: ^2.2.3` - Local database
- `hive_flutter: ^1.1.0` - Flutter integration for Hive
- `flutter_secure_storage: ^9.0.0` - Secure storage
- `flutter_local_notifications: ^17.2.2` - Local notifications
- `just_audio: ^0.9.36` - Audio playback
- `sensors_plus: ^4.0.2` - Sensor access

### Build Requirements
- Flutter SDK 3.22.2 or later
- Android SDK 21+ (Android 5.0+)
- iOS 11.0+ (for iOS builds)
- Java 17 (for Android builds)

### Known Issues
- iOS background alarm functionality requires additional permissions
- Web version has limited sensor access
- Some Android devices may require battery optimization settings

### Security
- All user data stored locally with encryption
- No external data transmission
- Secure storage for sensitive information
- Regular dependency updates via Dependabot

---

## Development Notes

### Project Structure
```
lib/
├── models/          # Data models with Hive annotations
├── viewmodels/      # Business logic (Provider-based)
├── views/           # UI screens and widgets
├── services/        # Backend services (DB, Notifications)
└── main.dart        # App entry point

assets/
├── audio/           # Sound files for alarms
├── images/          # UI illustrations and icons
└── tflite/          # ML models (future feature)
```

### Contributing
See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.

### License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.