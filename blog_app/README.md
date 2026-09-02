# 📝 Blog App Frontend

A modern and premium **Blog Application frontend** built with **Flutter** and **GetX**.

The application provides a clean mobile UI for browsing, searching, creating, editing, and deleting blog posts. It connects to a Laravel REST API backend.

---

## 📱 Project Overview

**Blog App** is a mobile application designed to manage and read blog posts through a modern and responsive Flutter interface.

### Main Features

* 🏠 Home page with blog posts
* 🔍 Search posts
* 📖 View post details
* ➕ Create a new post
* ✏️ Edit posts
* 🗑️ Delete posts
* 🖼️ Upload and crop images
* 🔄 Pull to refresh
* ⏳ Loading shimmer effects
* ⚠️ Error and empty states
* 🔔 Push notifications
* 🔐 Firebase integration
* 📱 Responsive mobile UI
* 🌐 Laravel REST API integration
* 💾 Local storage
* 🌙 Modern UI components and animations

---

## 🛠️ Technologies

### Frontend

| Technology | Version |
| ---------- | ------- |
| Flutter    | 3.41.7  |
| Dart       | 3.11.5  |
| GetX       | ^4.7.3  |
| Dio        | ^5.11.0 |

### Packages

* `get` - State management and dependency injection
* `dio` - HTTP client and API communication
* `connectivity_plus` - Internet connectivity checking
* `get_storage` - Local storage
* `shared_preferences` - Persistent preferences
* `image_picker` - Image selection
* `image_cropper` - Image cropping
* `flutter_svg` - SVG support
* `cached_network_image` - Network image caching
* `shimmer` - Loading placeholders
* `flutter_animate` - UI animations
* `intl` - Date and number formatting
* `url_launcher` - Open external URLs
* `share_plus` - Share blog posts
* `flutter_local_notifications` - Local notifications
* `timezone` - Notification scheduling
* `permission_handler` - Runtime permissions
* `firebase_core` - Firebase initialization
* `firebase_messaging` - Push notifications
* `flutter_launcher_icons` - App icon generation

---

## 📂 Project Structure

```text
lib/
├── app/
│   ├── bindings/
│   │   ├── app_bindings.dart
│   │   └── initial_binding.dart
│   │
│   ├── config/
│   │   ├── app_config.dart
│   │   └── api_endpoints.dart
│   │
│   ├── constants/
│   │   └── app_colors.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   ├── providers/
│   │   └── repositories/
│   │
│   ├── routes/
│   │   ├── app_pages.dart
│   │   └── app_routes.dart
│   │
│   └── widgets/
│       ├── empty_state.dart
│       ├── error_state.dart
│       ├── loading_shimmer.dart
│       ├── post_card.dart
│       ├── post_image_section.dart
│       └── search_widget.dart
│
├── features/
│   ├── home/
│   │   ├── bindings/
│   │   ├── controllers/
│   │   ├── views/
│   │   └── widgets/
│   │
│   ├── post/
│   │   ├── bindings/
│   │   ├── controllers/
│   │   ├── views/
│   │   └── widgets/
│   │
│   └── ...
│
├── firebase_options.dart
└── main.dart
```

> The exact folders may change as the project develops.

---

## 🎨 UI/UX Design

The application follows a modern mobile-first design approach.

### Design Principles

* Clean layout
* Simple navigation
* Consistent spacing
* Rounded cards
* High-quality images
* Clear typography
* Smooth animations
* Loading states
* Empty states
* Error handling
* Responsive layouts

### Main Screens

```text
Splash Screen
      │
      ▼
Home Screen
      │
      ├── Search
      │
      ├── Post Details
      │       │
      │       ├── Edit Post
      │       └── Delete Post
      │
      └── Create Post
```

---

## 🌐 Backend API

The Flutter application communicates with a **Laravel REST API**.

Example:

```text
Flutter App
     │
     │ HTTP / JSON
     ▼
Laravel REST API
     │
     ▼
Database
```

Example API configuration:

```dart
class AppConfig {
  static const String baseUrl =
      'http://127.0.0.1:8000/api';
}
```

For an Android emulator, you may need:

```text
http://10.0.2.2:8000
```

instead of:

```text
http://127.0.0.1:8000
```

For a physical Android device, use the computer's local network IP address.

---

## 🚀 Getting Started

### 1. Clone the project

```bash
git clone <your-repository-url>
```

Enter the project:

```bash
cd blog_app
```

---

### 2. Check Flutter

```bash
flutter --version
```

Recommended environment:

```text
Flutter 3.41.7
Dart 3.11.5
```

---

### 3. Install dependencies

```bash
flutter pub get
```

---

### 4. Configure the API

Open:

```text
lib/app/config/app_config.dart
```

Set your Laravel backend URL.

For example:

```dart
static const String baseUrl =
    'http://10.0.2.2:8000/api';
```

---

### 5. Start Laravel Backend

Open another terminal:

```bash
cd your-laravel-project
```

Run:

```bash
php artisan serve
```

The backend should be available at:

```text
http://127.0.0.1:8000
```

---

### 6. Run Flutter

Check connected devices:

```bash
flutter devices
```

Run the application:

```bash
flutter run
```

Or select a specific device:

```bash
flutter run -d <device-id>
```

---

## 🖼️ App Icon

The project uses `flutter_launcher_icons`.

Configuration:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/app_icon.png"
  adaptive_icon_background: "#FFFFFF"
  adaptive_icon_foreground: "assets/icon/app_icon_foreground.png"
```

Generate the icons:

```bash
dart run flutter_launcher_icons
```

---

## 🔥 Firebase

Firebase is used for push notification functionality.

Packages:

```yaml
firebase_core: ^4.14.0
firebase_messaging: ^16.6.0
```

Firebase configuration files should be added according to the target platform.

For Android:

```text
android/app/google-services.json
```

For iOS:

```text
ios/Runner/GoogleService-Info.plist
```

Do not commit sensitive Firebase configuration or credentials if your project setup requires them to remain private.

---

## 🔔 Notifications

The application supports:

* Firebase Cloud Messaging
* Local notifications
* Scheduled notifications
* Notification permissions
* Timezone-aware scheduling

Main packages:

```text
firebase_messaging
flutter_local_notifications
timezone
permission_handler
```

---

## 🖼️ Image Upload

The application supports selecting images from the device.

Flow:

```text
Select Image
     │
     ▼
Image Picker
     │
     ▼
Image Cropper
     │
     ▼
Preview
     │
     ▼
Upload to Laravel API
```

---

## 🔄 State Management

The application uses **GetX**.

GetX is used for:

* Controllers
* Reactive state
* Dependency injection
* Navigation
* API state management

Example:

```dart
final posts = <PostModel>[].obs;

final isLoading = false.obs;
```

UI can react to state changes using:

```dart
Obx(() {
  return ListView.builder(
    itemCount: controller.posts.length,
    itemBuilder: (context, index) {
      return PostCard(
        post: controller.posts[index],
      );
    },
  );
});
```

---

## 🌐 API Communication

The application uses **Dio** for HTTP requests.

Example:

```dart
final response = await dio.get(
  '/posts',
);
```

Common API operations:

```text
GET     /posts
GET     /posts/{id}
POST    /posts
PUT     /posts/{id}
DELETE  /posts/{id}
```

---

## 🧪 Testing

Run Flutter analyzer:

```bash
flutter analyze
```

Run tests:

```bash
flutter test
```

Check outdated packages:

```bash
flutter pub outdated
```

---

## 🧹 Clean Project

If you encounter build problems:

```bash
flutter clean
```

Then:

```bash
flutter pub get
```

Then:

```bash
flutter run
```

---

## 📦 Build APK

Build a release APK:

```bash
flutter build apk --release
```

The APK will be generated under:

```text
build/app/outputs/flutter-apk/app-release.apk
```

For split APKs:

```bash
flutter build apk --split-per-abi
```

---

## 🌍 Build Web

If web support is enabled:

```bash
flutter build web
```

---

## 🏗️ Development Workflow

Recommended workflow:

```text
1. Start Laravel API
        ↓
2. Check API with Postman
        ↓
3. Start Flutter
        ↓
4. Implement Model
        ↓
5. Implement Provider
        ↓
6. Implement Repository
        ↓
7. Implement Controller
        ↓
8. Build UI
        ↓
9. Test API integration
        ↓
10. Test Android device
```

---

## 🐛 Troubleshooting

### Flutter dependencies error

```bash
flutter clean
flutter pub get
```

### Check Flutter installation

```bash
flutter doctor
```

### Check connected devices

```bash
flutter devices
```

### Android emulator cannot connect to Laravel

Do not use:

```text
127.0.0.1
```

Use:

```text
10.0.2.2
```

for the Android emulator.

### App icon is not updated

Run:

```bash
dart run flutter_launcher_icons
```

Then:

```bash
flutter clean
flutter pub get
flutter run
```

---

## 🔐 Environment Configuration

Do not hard-code production secrets in the Flutter source code.

For different environments, consider separating:

```text
Development
Staging
Production
```

Example:

```text
API Development
http://10.0.2.2:8000/api

API Production
https://your-domain.com/api
```

---

## 📌 Project Status

**Status:** 🚧 In Development

Current focus:

* Blog post management
* API integration
* Modern UI/UX
* Image upload
* Search
* Notifications
* Firebase integration

---

## 👨‍💻 Developer

**Chhorn Pithak**

Junior App Developer | Full Stack Developer | UI/UX Designer

GitHub:

```text
https://github.com/Thak1347
```

---

## 📄 License

This project is created for educational and assignment purposes.

---

## ⭐ Acknowledgment

Built with:

```text
Flutter ❤️
Dart
GetX
Dio
Laravel
Firebase
```
