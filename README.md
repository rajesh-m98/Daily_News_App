# 📰 Daily News App

A professional Flutter news application featuring country-based news, category filtering, location-aware local news, and multi-language support using GNews API.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## ✨ Features

- **🌍 Country-based News**: Get top headlines from India and other countries
- **🏷️ Category Filtering**: Browse news by categories (Business, Sports, Technology, Health, Entertainment, Science)
- **📍 Local News**: City-based news using IP geolocation
- **🌐 Multi-language Support**: On-device translation using Google ML Kit (English, Hindi, Tamil, Telugu, Bengali, Marathi)
- **🔍 Search**: Search for specific news topics
- **📱 Clean Material 3 UI**: Modern, responsive design
- **⚡ State Management**: Efficient state management using Provider
- **🏗️ Clean Architecture**: Separation of concerns with proper folder structure
- **🔄 Pagination**: Smooth infinite scrolling
- **💾 Offline Support**: Cache recent articles
- **🌙 Dark Mode**: Beautiful dark theme support

## 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| **UI** | Flutter (Material 3) |
| **State Management** | Provider |
| **API** | GNews API |
| **Translation** | Google ML Kit |
| **Location** | IP-based (ip-api.com) |
| **Storage** | SharedPreferences |
| **Web View** | webview_flutter |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- GNews API Key (Get it from [gnews.io](https://gnews.io))

### Installation

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Get your GNews API Key**
   - Visit [GNews.io](https://gnews.io)
   - Sign up for a free account
   - Copy your API key from the dashboard

3. **Add your API Key**
   - Open `lib/core/constants/api_constants.dart`
   - Replace `YOUR_API_KEY_HERE` with your actual GNews API key:
   ```dart
   static const String apiKey = 'your_actual_api_key_here';
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🔑 API Setup

**Free tier limits**: 100 requests/day

Example API endpoints used:
- Top Headlines: `https://gnews.io/api/v4/top-headlines?country=in&lang=en&apikey=YOUR_KEY`
- Search: `https://gnews.io/api/v4/search?q=keyword&country=in&lang=en&apikey=YOUR_KEY`

## 📱 Screens

1. **Splash Screen** - App branding and initialization
2. **Language Selection** - Choose preferred language (first launch)
3. **Home** - Top headlines from your country
4. **Categories** - Browse by category with tabs
5. **Local News** - City-based news using IP location
6. **Search** - Search for specific topics
7. **Article Detail** - Full article in WebView
8. **Settings** - Language, theme, and preferences

## 🌐 Supported Languages

- 🇬🇧 English
- 🇮🇳 Hindi (हिंदी)
- 🇮🇳 Tamil (தமிழ்)
- 🇮🇳 Telugu (తెలుగు)
- 🇮🇳 Bengali (বাংলা)
- 🇮🇳 Marathi (मराठी)

*Translation powered by Google ML Kit (offline after first download)*

## 🏗️ Architecture

This app follows **Clean Architecture** principles:

```
lib/
 ├── core/
 │   ├── constants/        # App constants, API config, theme
 │   ├── services/         # API, location, translation services
 │   └── utils/            # Utilities (date formatter, error handler)
 ├── data/
 │   ├── models/           # Data models (Article, Source)
 │   └── repositories/     # Data repositories
 ├── presentation/
 │   ├── screens/          # UI screens
 │   ├── widgets/          # Reusable widgets
 │   └── providers/        # State management
 └── main.dart
```

### Key Design Patterns

- **Repository Pattern**: Abstracts data sources
- **Provider Pattern**: State management
- **Singleton Pattern**: Service instances
- **Factory Pattern**: Model creation

## 📦 Dependencies

```yaml
dependencies:
  provider: ^6.1.1                    # State management
  http: ^1.1.0                        # HTTP requests
  shared_preferences: ^2.2.2          # Local storage
  webview_flutter: ^4.4.2             # WebView
  google_mlkit_translation: ^0.10.0   # Translation
  cached_network_image: ^3.3.0        # Image caching
  shimmer: ^3.0.0                     # Loading effects
  intl: ^0.18.1                       # Date formatting
```

## 🎨 Features Showcase

### Clean Architecture
- ✅ Separation of concerns
- ✅ Testable code
- ✅ Scalable structure

### Error Handling
- ✅ Network errors
- ✅ API rate limits
- ✅ Empty states
- ✅ Retry mechanisms

### Performance
- ✅ Image caching
- ✅ Lazy loading
- ✅ Pagination
- ✅ Efficient state management

### UX Enhancements
- ✅ Shimmer loading effects
- ✅ Pull to refresh
- ✅ Smooth animations
- ✅ Responsive design

## 📝 Resume-Ready Description

> Developed a Flutter News Application using GNews API featuring category-based, location-aware news with offline multilingual support using Google ML Kit. Implemented clean architecture, Provider state management, error handling, pagination, and responsive Material 3 UI.

## 🎯 Interview Talking Points

**Q: Did you use a backend?**
> "No, I used GNews API directly since it's a portfolio app. For production, I'd move API calls to a backend to secure the API key and add caching layers."

**Q: How do you show local news?**
> "I use IP-based geolocation to detect the user's city, then perform keyword-filtered searches using the GNews API."

**Q: How did you support multiple languages?**
> "I implemented on-device translation using Google ML Kit, which works offline after the first download and doesn't require constant internet connectivity."

**Q: How do you handle API rate limits?**
> "I implemented caching with SharedPreferences, show cached data when offline, and display user-friendly messages when limits are reached."

**Q: What state management did you use and why?**
> "I used Provider for its simplicity and efficiency. It's perfect for this app's scale and provides good separation between UI and business logic."

## 🔮 Future Enhancements

- [ ] Bookmarks/Favorites
- [ ] Push notifications for breaking news
- [ ] Share articles to social media
- [ ] Reading history
- [ ] Personalized feed based on reading habits
- [ ] Offline reading mode
- [ ] Multiple country selection
- [ ] News sources filter

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Author

Built as a portfolio project to demonstrate:
- Clean architecture implementation
- State management with Provider
- API integration
- Multi-language support
- Material 3 design
- Error handling
- Caching strategies

## 🙏 Acknowledgments

- [GNews API](https://gnews.io) for news data
- [Google ML Kit](https://developers.google.com/ml-kit) for translation
- [Flutter](https://flutter.dev) for the amazing framework

---

⭐ **Perfect for Portfolio & Interviews!**

This project demonstrates production-ready Flutter development with:
- ✅ Clean code architecture
- ✅ Professional UI/UX
- ✅ Real-world API integration
- ✅ State management
- ✅ Error handling
- ✅ Offline support
- ✅ Multi-language support
