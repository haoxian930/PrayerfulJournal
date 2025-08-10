# Prayerful Journey: Prompts, Requests & Reflections

A privacy-focused mobile companion for individuals seeking to deepen their prayer life by organizing requests, engaging with prompts, and documenting answered prayer stories.

## 🙏 Vision

To be the most intuitive, privacy-focused, and inspiring mobile companion for individuals seeking to deepen their prayer life by organizing requests, engaging with prompts, and uniquely documenting answered prayer stories to cultivate an active awareness of divine intervention and gratitude.

## ✨ Key Features

### Core Prayer Management
- Add and track prayer requests with categories (Personal, Family, Ministry, Global, Health, Work, Relationships, Spiritual)
- Update prayer status (Pending, In Progress, Answered)
- Beautiful, intuitive prayer request management

### Answered Prayer Stories (Unique Selling Point)
- Create detailed testimonies when prayers are answered
- Add narratives, reflections, and photos
- Tag "God's Fingerprints" (#Provision, #Healing, #Wisdom, etc.)
- Visual timeline of God's faithfulness

### Reflective Journaling
- Write general journal entries
- Link entries to specific prayers or answered stories
- Search and filter capabilities
- Tag system for organization

### Guided Prayer Prompts
- Daily customizable prayer prompts
- Various categories (Gratitude, Guidance, Intercession, etc.)
- Local notifications for prayer reminders

### Privacy-First Design
- 100% offline functionality
- No data collection or transmission
- Local database storage only
- Export capabilities for backup

## 🛠 Tech Stack

- **Framework**: Flutter 3.10+
- **Language**: Dart
- **Database**: SQLite (sqflite)
- **State Management**: Provider
- **UI**: Material Design 3 with custom theming
- **Notifications**: flutter_local_notifications
- **Image Handling**: image_picker, photo_view
- **Typography**: Google Fonts (Poppins)

## 📱 Platform Support

- **Primary**: Android (initial release)
- **Future**: iOS (planned for future release)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code with Flutter extension
- Android device or emulator (API level 21+)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/prayerful-journey.git
   cd prayerful-journey
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Generate launcher icons** (optional)
   ```bash
   flutter pub run flutter_launcher_icons:main
   ```

2. **Run tests**
   ```bash
   flutter test
   ```

3. **Build for release**
   ```bash
   flutter build apk --release
   ```

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── prayer_request.dart
│   ├── answered_prayer_story.dart
│   ├── journal_entry.dart
│   └── prayer_prompt.dart
├── providers/                # State management
│   ├── prayer_request_provider.dart
│   ├── answered_prayer_story_provider.dart
│   └── journal_entry_provider.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── prayer_requests_screen.dart
│   ├── answered_stories_screen.dart
│   ├── journal_screen.dart
│   └── settings_screen.dart
├── widgets/                  # Reusable UI components
│   ├── dashboard_overview.dart
│   ├── daily_prompt_card.dart
│   ├── quick_actions.dart
│   └── prayer_request_card.dart
├── services/                 # Business logic
│   ├── database_service.dart
│   └── notification_service.dart
└── utils/                    # Utilities
    └── app_theme.dart
```

## 🎨 Design System

### Color Palette
- **Primary**: Soft purple-blue (#6B73FF) - Spiritual, calming
- **Secondary**: Warm gold (#FFB74D) - Divine, hopeful
- **Success**: Green (#81C784) - Growth, answered prayers
- **Background**: Clean whites and soft grays

### Typography
- **Font Family**: Poppins (clean, modern, readable)
- **Hierarchy**: Clear distinction between headings, body text, and captions

### UI Principles
- **Minimalism**: Clean, distraction-free interface
- **Accessibility**: High contrast, readable fonts, intuitive navigation
- **Emotional Design**: Warm, encouraging, spiritually uplifting

## 🔧 Configuration

### Android Permissions
The app requires the following permissions:
- `INTERNET` - For future cloud sync (optional)
- `WRITE_EXTERNAL_STORAGE` - For photo attachments and exports
- `READ_EXTERNAL_STORAGE` - For photo attachments
- `CAMERA` - For taking photos for prayer stories
- `VIBRATE` - For notification feedback
- `RECEIVE_BOOT_COMPLETED` - For persistent notifications
- `WAKE_LOCK` - For notification reliability
- `USE_EXACT_ALARM` - For precise prayer reminders

### Database Schema
- **prayer_requests**: Core prayer data
- **answered_prayer_stories**: Testimony records
- **journal_entries**: Reflection entries
- **prayer_prompts**: Guided prayer content

## 🧪 Testing

Run the test suite:
```bash
flutter test
```

### Test Coverage
- Unit tests for models and providers
- Widget tests for UI components
- Integration tests for user flows

## 📊 Performance Goals

- **Load Time**: < 2 seconds for all screens
- **Database**: Handle 10,000+ records efficiently
- **Memory**: Optimized for devices with 2GB+ RAM
- **Battery**: Minimal background activity

## 🔒 Privacy & Security

- **Zero Data Collection**: No analytics, tracking, or data transmission
- **Local Storage Only**: All data stays on the user's device
- **Encrypted Exports**: Backup files can be password protected
- **No Network Calls**: Completely offline application

## 🚀 Roadmap

### Version 1.0 (Current)
- ✅ Core prayer request management
- ✅ Beautiful UI with Material Design 3
- ✅ Local database with SQLite
- ✅ Daily prayer prompts
- ⏳ Answered prayer stories (in development)
- ⏳ Journal entries (in development)
- ⏳ Local notifications (in development)

### Version 1.1 (Future)
- 📷 Photo attachments for stories
- 🔍 Advanced search and filtering
- 📊 Prayer statistics and insights
- 🎨 Custom themes and personalization

### Version 1.2 (Future)
- 📱 iOS version
- 📤 Enhanced export options
- 🔔 Smart notification timing
- 📱 Widget support

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Process
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Design Inspiration**: Modern spiritual and wellness apps
- **Icons**: Material Design Icons
- **Typography**: Google Fonts (Poppins)
- **Flutter Community**: For excellent packages and support

## 📞 Support

For support, feedback, or questions:
- 📧 Email: support@prayerfuljourney.app
- 🐛 Issues: [GitHub Issues](https://github.com/yourusername/prayerful-journey/issues)
- 📖 Documentation: [Wiki](https://github.com/yourusername/prayerful-journey/wiki)

---

**"Rejoice always, pray continually, give thanks in all circumstances; for this is God's will for you in Christ Jesus." - 1 Thessalonians 5:16-18**

*Built with ❤️ and 🙏 for the faith community*
