# 🧪 Rick & Morty Explorer - Flutter Application

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%2300B4AB.svg?style=for-the-badge&logo=dart&logoColor=white)
![BLoC/Cubit](https://img.shields.io/badge/Bloc%2FCubit-8A2BE2?style=for-the-badge)
![Clean Architecture](https://img.shields.io/badge/Clean%20Architecture-00599E?style=for-the-badge)

A modern, high-performance Flutter application built for the **EASY WORLD DIGITAL MARKETING** Flutter Internship selection task. The app integrates with the [Rick & Morty REST API](https://rickandmortyapi.com/documentation) to explore characters, perform real-time debounced searches, apply advanced multi-criteria filters, view detailed character profiles, and **export character datasets directly to Excel (.xlsx)** files with native sharing.

---

## 🌟 Key Features

- **🛸 Fetch & Infinite Scroll Pagination**: Automatically loads character lists with smooth infinite scroll pagination (`loadNextPage`).
- **🔍 Real-Time Search**: Search characters by name with a 500ms debounce timer to optimize network calls.
- **🎛️ Advanced Multi-Filter**: Filter characters by:
  - **Status**: Alive, Dead, Unknown
  - **Gender**: Female, Male, Genderless, Unknown
  - **Species**: Human, Alien, Humanoid, Robot, etc.
- **📊 Excel (.xlsx) Data Export**: One-tap export of character lists into structured, auto-formatted `.xlsx` spreadsheets complete with native share/save dialogs (`share_plus`).
- **🎨 Modern Portal UI/UX**:
  - Dark Mode & Light Mode switcher.
  - Rick & Morty Portal Green (`#00B5CC`) & Cyber Neon (`#97CE4C`) accents.
  - Hero image animations between list and detail view.
  - Glowing status badges (Green for Alive, Red for Dead, Gray for Unknown).
- **🛡️ Robust State Handling**:
  - **Loading State**: Shimmer skeleton loading effect (`shimmer`).
  - **Empty State**: Custom vector artwork for zero results with "Reset All Filters" action.
  - **Error State**: Friendly malfunction error screen with "Try Again" retry action.

---

## 🏗️ Architecture & Project Structure

The project strictly follows **Clean Architecture** combined with **Feature-First / Layered Structure** for clean separation of concerns and maintainability.

```
lib/
├── core/
│   ├── network/
│   │   └── api_client.dart            # Dio HTTP Client wrapper with error mapping
│   ├── theme/
│   │   ├── app_colors.dart            # Brand & theme color palette
│   │   └── app_theme.dart             # Dark and Light ThemeData
│   └── utils/
│       └── excel_exporter.dart        # Helper to generate & share Excel (.xlsx) files
├── features/
│   └── character/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── character_remote_data_source.dart
│       │   ├── models/
│       │   │   ├── character_model.dart
│       │   │   └── character_response_model.dart
│       │   └── repositories/
│       │       └── character_repository_impl.dart
│       ├── domain/
│       │   ├── entities/
│       │   │   └── character_entity.dart
│       │   └── repositories/
│       │       └── character_repository.dart
│       └── presentation/
│           ├── cubit/
│           │   ├── character_cubit.dart
│           │   └── character_state.dart
│           ├── screens/
│           │   ├── character_list_screen.dart
│           │   └── character_detail_screen.dart
│           └── widgets/
│               ├── character_card.dart
│               ├── filter_bottom_sheet.dart
│               ├── shimmer_loading.dart
│               ├── empty_state_widget.dart
│               └── error_state_widget.dart
└── main.dart                           # Entrypoint & Dependency Injection
```

---

## 🛠️ State Management: Cubit (Flutter Bloc)

We chose **Cubit** (`flutter_bloc`) due to its lightweight nature, predictable state management, and seamless integration with Clean Architecture:
- `CharacterState` holds the state for character lists, current page index, total count, active filter queries, and Excel export status.
- `CharacterCubit` encapsulates business logic for fetching, paginating, searching, filtering, and exporting.

---

## 📦 Packages & Dependencies Used

| Package | Purpose |
| :--- | :--- |
| `flutter_bloc` | State management (Cubit) |
| `equatable` | Value equality comparison |
| `dio` | HTTP networking & API integration |
| `excel` | Creating & formatting Excel (.xlsx) spreadsheets |
| `share_plus` | Triggering native device share dialogs for exported files |
| `path_provider` | Locating temporary directory paths |
| `cached_network_image` | Image caching and memory optimization |
| `shimmer` | Skeleton loading effects |
| `google_fonts` | Typography |

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (v3.19.0 or higher)
- Dart SDK (v3.3.0 or higher)

### Installation

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-username/flutter_rick_and_morty.git
   cd flutter_rick_and_morty
   ```

2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the Application**:
   ```bash
   flutter run
   ```

4. **Run Unit Tests**:
   ```bash
   flutter test
   ```

---

## 📸 Screenshots & Video Demo

> [!NOTE]
> - **Screenshots**: Place screenshots inside a `screenshots/` directory or embed links here.
> - **Video Demo**: [Link to Application Video Demo](https://youtube.com/...)

---

## 📄 Submission Information

- **Task**: EASY WORLD ESTABLISHMENT Digital Marketing - Flutter Internship Task
- **Deadline**: Wednesday, 29/07/2026 – 6:00 PM
- **Form Submission**: [Google Forms Submission Link](https://forms.gle/HCpbTp7ps8Gs5jE86)
- **Contact**: info@1ez.app | WhatsApp: +201019285422
