# Zporter Board: Football Score & Tactics Board

## Overview
**Zporter Board** is a comprehensive tool designed for football professionals (coaches, team managers, referees, and contest organizers) to manage and present match data effectively. The app supports **score tracking**, **time management**, **substitutions**, and **tactical presentations**, all accessible from a tablet device. The initial version is free, with a roadmap for future premium features like **Zporter account integration**, **advanced analytics**, and **cross-platform compatibility**.

---

## Features

### MVP Features (Week 1)
The **Minimum Viable Product (MVP)** focuses on delivering core functionality that provides immediate value to users.

- **Scoreboard Management**:
  - Edit and display match scores (0-0 to 99-99).
  - Simple UI for home and away team scores.
- **Time Management**:
  - Start, pause, and stop a match clock.
  - Display total elapsed time and current period.
  - Set period duration (1-99 minutes) with countdown functionality.
- **Substitutions Management**:
  - Manage player substitutions (00-99).
  - Prepare up to 10 substitutions in advance.
- **Tactical Board**:
  - Draw basic shapes (lines, circles, arrows) for tactics.
  - Add text labels to diagrams.
  - Save, share, and delete up to 10 tactical diagrams.
- **Sharing Capabilities**:
  - Share board content (score, time, tactics) to larger screens using iOS/Android share features.
- **Onboarding**:
  - Display a short Zporter logo animation on startup.
  - Show a website URL and QR code (`onelink.to/zporter`) for app promotion.

### Advanced Features (Roadmap)
Once the MVP is complete, the app will expand with advanced features to make it more powerful and integrated with the Zporter ecosystem.

- **User Authentication**:
  - Log in using Zporter account (same auth as Zporter App).
  - Access premium features based on subscription.
- **Advanced Tactical Board**:
  - Add images, videos, and animations to tactics.
  - Save unlimited tactics to Zporter Library.
- **Team and Player Integration**:
  - Pull team and player data from Zporter account.
  - Pre-load opponent team data for quick setup.
- **Live and Video Analytics**:
  - Watch live matches or upload videos.
  - Tag players, note events, and create highlights.
  - Add tactical diagrams and notes to video highlights.
- **Referee and Analytics Sync**:
  - Sync with Zporter’s referee and analytics apps.
  - Display advanced match data (e.g., possession, shots on goal).
- **Cross-Platform Compatibility**:
  - Smartphone and laptop versions.
  - Web application for broader accessibility.

---

## Technical Stack

### MVP Stack
- **Frontend**: Flutter (iOS/Android tablet compatibility).
- **Backend**: Firebase (Firestore for data storage, no login required for MVP).
- **Database**: MongoDB (for advanced data storage).
- **Authentication**: Google Sign-In (Firebase Authentication).
- **Architecture**: Clean Architecture (MVVM).
- **Sharing**: Native iOS/Android sharing features.

### Advanced Features Stack
- **Frontend**: Flutter (expand to smartphones, laptops, and web).
- **Backend**: Firebase (Authentication, Cloud Functions for advanced logic).
- **Database**: Firestore or MongoDB (for larger datasets like video analytics).
- **Integrations**: Zporter API for account sync, referee app, and analytics.

---

## Object Model Design

### Key Entities

The following entities have been designed to represent the core features of the app, such as match details, teams, players, and tactical diagrams.

---

### 1. **User**

The `User` object stores information about the users of the app (coaches, referees, and team managers). It is essential for managing access and actions in the system.

#### Attributes
- `uid`: Unique identifier for the user.
- `email`: User's email address.
- `displayName`: User's display name.
- `photoURL`: Profile photo URL.

#### Pseudocode
```dart
class User {
  String uid;
  String email;
  String displayName;
  String photoURL;
}
```

```dart
class FootballMatch {
  final md.ObjectId id;
  final String name;
   List<MatchTime> matchTime; // List of match time periods
  final String status;
  final Team homeTeam;
  final Team awayTeam;
  final MatchScore matchScore;
  final MatchSubstitutions substitutions;
  final String venue;
}
```
```dart
class Team {
  final ObjectId id;
  final String name;
  final List<Player> players;
}
```

```dart
class Player {
  final ObjectId id;
  final String name;
  final String position;
  final int jerseyNumber;
}
```
```dart
class MatchTime {
   String id;         // Unique ID for this match time
   DateTime startTime;  // Start time of this period
   DateTime? endTime;   // End time (nullable if ongoing)
   String? nextId;    // Points to the next match time segment
}
```

```dart
class MatchScore {
  int homeScore;
  int awayScore;
}
```

```dart
class Substitution {
  final ObjectId teamId;
  final ObjectId playerOutId;
  final ObjectId playerInId;
  final int minute;
}
```

Tactical Board object design needs more SOLID approach for drag & drop behaviour


```dart
abstract class FieldDraggableItem {
  ObjectId id;
  Offset? offset;
  double rotation;
}
```


```dart
enum PlayerType { HOME, OTHER, AWAY }

class PlayerModel extends FieldDraggableItem with EquatableMixin {
  String role;
  int index;
  String? imagePath;
  PlayerType playerType;

  PlayerModel({
    required super.id,
    required this.role,
    super.offset,
    required this.index,
    this.imagePath,
    super.rotation = 0.0,
    required this.playerType,
  });
}
```

```dart
enum FormType { LINE, OTHER }

class FormDataModel extends FieldDraggableItem with EquatableMixin {
  String name;
  String? imagePath;
  FormType formType;

  FormDataModel({
    required super.id,
    required this.name,
    super.offset,
    this.imagePath,
    super.rotation = 0.0,
    this.formType = FormType.OTHER,
  });
}
```

```dart
class EquipmentDataModel extends FieldDraggableItem with EquatableMixin {
  String name;
  String? imagePath;

  EquipmentDataModel({
    required super.id,
    required this.name,
    super.offset,
    this.imagePath,
    super.rotation = 0.0,
  });
}
```

```dart
class ArrowHead extends FieldDraggableItem with EquatableMixin {
  FieldDraggableItem parent;
  Offset? parentPoint;

  ArrowHead({
    required this.parent,
    this.parentPoint,
    required super.id,
    required super.offset,
    required super.rotation,
  });
}
```


```dart
class AnimationModel {
  ObjectId id;
  List<FieldDraggableItem> items;
  int index;
}
```

```dart
class AnimationDataModel {
  ObjectId id;
  List<AnimationModel> items;
}
```







