<div align="center">

# 📱 ColorMate — Mobile-App

**Flutter client for ColorMate — color vision testing, detection, correction, and more**

</div>

> 📦 This folder was renamed from `Front-End` to `Mobile-App`. If you're updating an existing local clone, make sure to update any IDE run configurations or scripts that reference the old folder name.

This is the Flutter application that end users install on their phones. It talks to the **`Back-End`** ASP.NET Core API for everything except the AI chatbot, which calls **Google's Gemini API** directly from the device.

---

## 📂 Folder Structure

```
Mobile-App/
├── lib/
│   ├── main.dart                  # App entry point — initializes Gemini, storage, Bloc observer, router
│   ├── core/                      # Shared infrastructure used across features
│   │   ├── routing/                # go_router configuration (app_router.dart)
│   │   ├── services/               # auth_session_manager, image_picker_service, storage_service
│   │   ├── storage/                 # Local persistence helpers
│   │   ├── theme/                   # App colors, text styles, theming
│   │   ├── utils/                   # constants.dart (env vars, colors), bloc observer, validators
│   │   ├── validation/              # Form/input validation helpers
│   │   ├── widget/                  # Shared/reusable widgets
│   │   └── model/                   # Shared data models
│   └── features/                  # One folder per feature — feature-first architecture
│       ├── authentication/          # Login, signup, email verification, Google/Facebook auth
│       ├── onboarding/              # Onboarding flow
│       ├── splash/                  # Splash screen
│       ├── home/                    # Home dashboard
│       ├── test/                    # Ishihara color blindness test
│       ├── object&color_detection/   # Camera-based object & color detection (clean-architecture style: data/domain/di/presentation)
│       ├── matching/                 # Outfit color-matching results UI
│       ├── fruits/                   # Fruit freshness scanning UI
│       ├── image_correction/         # Color blindness simulation & Daltonization correction (data/domain/di/presentation)
│       ├── chatbot/                  # Gemini-powered AI chat assistant
│       ├── games/                    # 5 educational mini-games (see below)
│       └── profile/                  # Profile view/edit, profile picture upload
├── assets/
│   ├── images/ (incl. ishihara_test/)
│   ├── icons/
│   └── fonts/                      # Poppins font family (Light → Bold, incl. italics)
├── android/                        # Android platform project
├── ios/                            # iOS platform project
├── web/                            # Web platform project (Flutter web target)
├── pubspec.yaml                    # Dependencies & asset declarations
└── analysis_options.yaml           # Dart/Flutter lint rules
```

### 🎮 Mini-Games (`lib/features/games/`)
- `color_collector_game/`
- `memory_match_game/`
- `color_the_picture_game/`
- `sequence_game/`
- `find_the_object_game/`

---

## 🛠️ Tech Stack

| Purpose | Package |
|---|---|
| State management | **flutter_bloc** (Cubit pattern) |
| Routing | **go_router** |
| Dependency injection | **get_it** |
| HTTP client | **dio** |
| AI chatbot | **flutter_gemini** (Google Gemini API) |
| Auth | **google_sign_in**, custom Facebook/email flows |
| Local storage | **shared_preferences** |
| Env config | **flutter_dotenv** |
| Responsive UI | **flutter_screenutil** |
| Localization | **easy_localization** |
| Image handling | **image_picker**, **image**, **gal** |
| Functional error handling | **dartz** |
| Permissions | **permission_handler** |
| App icon generation | **flutter_launcher_icons** |

Full dependency list with versions is in [`pubspec.yaml`](./pubspec.yaml).

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart SDK `>=3.7.0 <4.0.0`)
- Android Studio / Xcode for emulators or physical devices
- A Google Gemini API key (for the chatbot feature)

### 1. Install dependencies

```bash
cd Mobile-App
flutter pub get
```

### 2. Configure environment variables

Create a `.env` file in the `Mobile-App/` root (it's declared as an asset in `pubspec.yaml` and loaded in `main.dart`):

```env
GEMINI_API_KEY=your_gemini_api_key_here
```

> The app reads `GEMINI_API_KEY` first, then falls back to `GOOGLE_API_KEY`, then `API_KEY` (see `lib/core/utils/constants.dart`). Loading is optional — the app still runs without a `.env` file, but the chatbot won't work without a valid key.

### 3. Run the app

```bash
flutter run
```

Or target a specific platform:
```bash
flutter run -d chrome     # Web
flutter run -d android    # Android
flutter run -d ios        # iOS
```

---

## 🌐 Backend Connectivity

The app currently points to the **live deployed backend** at:

```
http://colormate.runasp.net
```

This base URL is referenced directly across ~12 files (API services, repositories, and a couple of UI widgets that build profile-picture URLs) rather than from a single shared config constant. If you need to point the app at a different backend (e.g. `http://localhost:5000` for local development against the `Back-End` project), you'll currently need to update each occurrence — search the codebase for `colormate.runasp.net` to find them all:

```bash
grep -rl "colormate.runasp.net" lib/
```

> 💡 **Suggested improvement:** centralize this into a single `ApiConstants.baseUrl` (or read it from `.env`) so the backend URL only needs to change in one place.

---

## 🧩 Architecture Notes

- **Feature-first structure**: each feature in `lib/features/` is self-contained. Simpler features (e.g. `fruits`, `matching`) only have a `presentation/` layer and call shared API services directly; more complex features (`object&color_detection`, `image_correction`) follow a fuller clean-architecture split with `data/`, `domain/`, `di/`, and `presentation/` layers.
- **State management** uses `flutter_bloc`'s **Cubit** variant throughout (`*_cubit.dart` + `*_state.dart` pairs).
- **Routing** is centralized in `lib/core/routing/app_router.dart` using `go_router`.
- **Chatbot** (`lib/features/chatbot/`) talks directly to Gemini via `flutter_gemini` / a custom `GeminiService` — it does **not** go through the `Back-End` or `AI-API`.
- **Dependency injection** uses `get_it` for service locator–style access to shared services.

---

## 🎨 Assets & Theming

- **Font:** Poppins (Light, Regular, Italic, Medium, Medium Italic, SemiBold, Bold) — declared in `pubspec.yaml`
- **App icon:** generated via `flutter_launcher_icons` from `assets/images/app_icon.png`
- **Ishihara test plates:** stored under `assets/images/ishihara_test/`

---

## 🧪 Testing

```bash
flutter test
```

Test files live under the `test/` directory at the project root.

---

## 📦 Building for Release

```bash
# Android
flutter build apk --release
# or
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

---

## ⚠️ Notes & Gotchas

- **No `.env.example`** is currently committed — make sure to document required keys somewhere visible (or add an example file) so new contributors know what to put in their own `.env`.
- **Hardcoded backend URL** — see "Backend Connectivity" above.
- **Google Sign-In** requires platform-specific configuration (OAuth client IDs for Android/iOS) outside of this repo's tracked files — refer to the [google_sign_in plugin docs](https://pub.dev/packages/google_sign_in) if setting this up fresh.

---

## 📝 License

Part of the ColorMate graduation project, Faculty of Computers and Artificial Intelligence, Fayoum University (2026).
