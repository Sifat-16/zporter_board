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

## Development Plan

### MVP Task Breakdown (1 Week)

#### **Day 1: Project Setup (8 Hours)**
- **Project Initialization**:
    - Set up Flutter project with Clean Architecture (MVVM).
    - Configure Firebase (Firestore, Authentication).
    - Set up MongoDB for advanced data storage.
- **Authentication**:
    - Implement Google Sign-In using Firebase Authentication.
- **UI Development**:
    - Create mock UI for Scoreboard functionality (home/away team scores, edit functionality).
- **Progress**:
    - Completed project setup, Firebase and MongoDB configuration, Google Sign-In, and Scoreboard mock UI.



