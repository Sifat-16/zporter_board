# Force Update Setup Guide

## Overview
This guide explains how to configure and use the Force Update system in Zporter Board.

---

## ✅ Fixed Issues (December 17, 2025)

### 1. WillPopScope Deprecation ✅
- **Issue**: Using deprecated `WillPopScope` widget (deprecated in Flutter 3.12+)
- **Fix**: Replaced with `PopScope` widget for Flutter 3.32.1 compatibility
- **Impact**: Back button handling now works correctly on hard updates

### 2. Android Compile SDK Version ✅
- **Issue**: Project compiled against SDK 35, but `devicelocale` plugin requires SDK 36
- **Fix**: Updated `compileSdk = 36` in `android/app/build.gradle.kts`
- **Impact**: Country-based targeting now works properly; build warnings resolved

### 3. Null Safety Warning ✅
- **Issue**: Incorrect null-coalescing operator usage
- **Fix**: Changed logic to `updateRule?.updateType != 'soft'` (defaults to hard update)
- **Impact**: Cleaner code, no warnings, correct default behavior

---

## 🔧 Firebase Configuration

### Required Firestore Document

Create a document at the following path in Firebase Firestore:

```
Collection: app_config
Document: version_info
```

### Document Structure

```json
{
  "isForceUpdateEnabled": true,
  "defaultMinAndroidVersion": "1.0.5",
  "defaultMinIosVersion": "1.0.5",
  "androidStoreUrl": "https://play.google.com/store/apps/details?id=com.zporter.zporter_board",
  "iosStoreUrl": "https://apps.apple.com/app/zporter-board/idXXXXXXXXX",
  "updateTitle": "Update Required",
  "updateMessage": "A new version of Zporter Board is available. Please update to continue using the app.",
  "rules": []
}
```

### Field Descriptions

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `isForceUpdateEnabled` | Boolean | Yes | Master switch to enable/disable the force update system |
| `defaultMinAndroidVersion` | String | Yes | Minimum Android app version required (fallback when no rules match) |
| `defaultMinIosVersion` | String | Yes | Minimum iOS app version required (fallback when no rules match) |
| `androidStoreUrl` | String | Yes | Google Play Store URL for the app |
| `iosStoreUrl` | String | Yes | Apple App Store URL for the app |
| `updateTitle` | String | Yes | Title text for the update dialog |
| `updateMessage` | String | Yes | Message text for the update dialog |
| `rules` | Array | Yes | Array of update rules (can be empty) |

---

## 📋 Advanced Rules

For more granular control, you can add rules to target specific users, countries, or versions.

### Rule Structure

```json
{
  "rules": [
    {
      "targetPlatforms": ["android"],
      "targetCountries": ["US", "CA"],
      "targetAppVersions": ["1.0.4"],
      "targetUserIds": [],
      "rolloutPercentage": 100,
      "updateType": "hard",
      "minAndroidVersion": "1.0.5",
      "minIosVersion": "1.0.5"
    }
  ]
}
```

### Rule Fields

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `targetPlatforms` | Array[String] | Platforms to target. Empty = all platforms | `["android", "ios"]` |
| `targetCountries` | Array[String] | Countries to target (ISO 2-letter codes). Empty = all countries | `["US", "UK", "DE"]` |
| `targetAppVersions` | Array[String] | Specific app versions to target. Empty = all versions | `["1.0.4", "1.0.3"]` |
| `targetUserIds` | Array[String] | Specific user IDs to target (for testing). Empty = all users | `["user123", "user456"]` |
| `rolloutPercentage` | Number | Percentage of users to show update (0-100) | `50` for 50% rollout |
| `updateType` | String | Type of update: `"hard"` (required) or `"soft"` (optional) | `"hard"` |
| `minAndroidVersion` | String | Minimum Android version for this rule | `"1.0.5"` |
| `minIosVersion` | String | Minimum iOS version for this rule | `"1.0.5"` |

### Rule Matching Logic

Rules are evaluated in order. The **first matching rule** is used. If no rules match, the default min version is used.

A rule matches if **ALL** of the following conditions are true:
1. Platform matches (or targetPlatforms is empty)
2. Country matches (or targetCountries is empty)
3. App version matches (or targetAppVersions is empty)
4. User ID matches (or targetUserIds is empty)
5. User hash is within rollout percentage

---

## 🎯 Common Use Cases

### 1. Simple Force Update (Everyone)

Force all users on all platforms to update to 1.0.6:

```json
{
  "isForceUpdateEnabled": true,
  "defaultMinAndroidVersion": "1.0.6",
  "defaultMinIosVersion": "1.0.6",
  "androidStoreUrl": "https://play.google.com/...",
  "iosStoreUrl": "https://apps.apple.com/...",
  "updateTitle": "Update Required",
  "updateMessage": "Please update to the latest version to continue.",
  "rules": []
}
```

### 2. Soft Update (Skippable)

Allow users to skip the update:

```json
{
  "isForceUpdateEnabled": true,
  "defaultMinAndroidVersion": "1.0.5",
  "defaultMinIosVersion": "1.0.5",
  "androidStoreUrl": "https://play.google.com/...",
  "iosStoreUrl": "https://apps.apple.com/...",
  "updateTitle": "Update Available",
  "updateMessage": "A new version is available with exciting features!",
  "rules": [
    {
      "targetPlatforms": [],
      "targetCountries": [],
      "targetAppVersions": [],
      "targetUserIds": [],
      "rolloutPercentage": 100,
      "updateType": "soft",
      "minAndroidVersion": "1.0.6",
      "minIosVersion": "1.0.6"
    }
  ]
}
```

### 3. Gradual Rollout (50% of Users)

Force update for 50% of users only:

```json
{
  "rules": [
    {
      "targetPlatforms": [],
      "targetCountries": [],
      "targetAppVersions": [],
      "targetUserIds": [],
      "rolloutPercentage": 50,
      "updateType": "hard",
      "minAndroidVersion": "1.0.6",
      "minIosVersion": "1.0.6"
    }
  ]
}
```

### 4. Country-Specific Update

Force update only for US and Canada users:

```json
{
  "rules": [
    {
      "targetPlatforms": [],
      "targetCountries": ["US", "CA"],
      "targetAppVersions": [],
      "targetUserIds": [],
      "rolloutPercentage": 100,
      "updateType": "hard",
      "minAndroidVersion": "1.0.6",
      "minIosVersion": "1.0.6"
    }
  ]
}
```

### 5. Beta Testing (Specific Users)

Test update dialog with specific users:

```json
{
  "rules": [
    {
      "targetPlatforms": [],
      "targetCountries": [],
      "targetAppVersions": [],
      "targetUserIds": ["test_user_1", "test_user_2"],
      "rolloutPercentage": 100,
      "updateType": "soft",
      "minAndroidVersion": "1.0.7",
      "minIosVersion": "1.0.7"
    }
  ]
}
```

### 6. Android-Only Critical Update

Force Android users to update due to a critical bug:

```json
{
  "rules": [
    {
      "targetPlatforms": ["android"],
      "targetCountries": [],
      "targetAppVersions": ["1.0.4", "1.0.5"],
      "targetUserIds": [],
      "rolloutPercentage": 100,
      "updateType": "hard",
      "minAndroidVersion": "1.0.6",
      "minIosVersion": "1.0.5"
    }
  ]
}
```

---

## 🚀 Deployment Checklist

### Before Enabling Force Update

- [ ] Create Firestore document at `app_config/version_info`
- [ ] Set `isForceUpdateEnabled: false` initially
- [ ] Configure store URLs for both platforms
- [ ] Set appropriate update title and message
- [ ] Test with specific user IDs first (using `targetUserIds`)

### Testing Phase

- [ ] Test with `targetUserIds` containing your test accounts
- [ ] Verify hard update blocks navigation
- [ ] Verify soft update allows dismissal
- [ ] Test store URL launches correctly
- [ ] Test on both Android and iOS
- [ ] Test version comparison logic

### Gradual Rollout

- [ ] Start with `rolloutPercentage: 10` (10% of users)
- [ ] Monitor for issues (crash reports, support tickets)
- [ ] Increase to 25%, then 50%, then 100%
- [ ] Keep `targetUserIds: []` for production rollout

### Full Deployment

- [ ] Set `isForceUpdateEnabled: true`
- [ ] Set `rolloutPercentage: 100`
- [ ] Set appropriate `defaultMinAndroidVersion` and `defaultMinIosVersion`
- [ ] Monitor analytics and user feedback

---

## 🔍 Troubleshooting

### Force Update Not Showing

1. **Check Firestore document exists**:
   - Path: `app_config/version_info`
   - Verify all required fields are present

2. **Check `isForceUpdateEnabled` flag**:
   - Must be `true` to enable system

3. **Check app version comparison**:
   - Current version: Check `lib/config/version/version_info.dart`
   - Required version: Check Firestore `defaultMinAndroidVersion`/`defaultMinIosVersion`

4. **Check Firebase connection**:
   - Verify internet connectivity
   - Check Firebase console for errors
   - Verify Firestore rules allow read access

5. **Check rule matching**:
   - If using rules, verify they match your test conditions
   - Check `rolloutPercentage` (user may not be in rollout group)

### Dialog Doesn't Block Navigation (Hard Update)

- Verify `updateType: "hard"` in rule or no rule exists (defaults to hard)
- Check console for errors
- Verify `PopScope` widget is being used (not `WillPopScope`)

### Country Targeting Not Working

- Verify Android compile SDK is 36 or higher
- Check device locale settings
- Verify `devicelocale` plugin is installed

### Store URL Not Opening

- Verify URL format is correct
- Check URL permissions in manifest
- Test URL manually in browser

---

## 📊 Version Comparison

The system uses **semantic versioning** comparison:

- `1.0.5` < `1.0.6` ✅ Update required
- `1.0.6` < `1.1.0` ✅ Update required
- `2.0.0` < `1.9.9` ❌ Update not required (major version higher)
- `1.0.6` < `1.0.6` ❌ Update not required (same version)

---

## 🛠️ Manual Testing

### Test Hard Update

1. Set Firestore `defaultMinAndroidVersion` to a version higher than your current app
2. Launch app
3. Expected: Update dialog appears and cannot be dismissed
4. Expected: Cannot navigate past splash screen

### Test Soft Update

1. Create a rule with `updateType: "soft"`
2. Set min version higher than current
3. Launch app
4. Expected: Update dialog appears with "Later" button
5. Expected: Can dismiss dialog and continue to app

### Test Rollout Percentage

1. Create a rule with `rolloutPercentage: 50`
2. Test with multiple user IDs
3. Expected: ~50% of users see update dialog

---

## 📝 Code References

- **Service**: `lib/core/services/version_check_service.dart`
- **Integration**: `lib/features/splash/presentation/view/responsive/splash_screen_tablet.dart`
- **Version Info**: `lib/config/version/version_info.dart`
- **Android Config**: `android/app/build.gradle.kts`

---

## 🔗 Related Documentation

- [Firebase Firestore Setup](https://firebase.google.com/docs/firestore)
- [Semantic Versioning](https://semver.org/)
- [Flutter PopScope Widget](https://api.flutter.dev/flutter/widgets/PopScope-class.html)

---

## ⚡ Quick Start

**Minimum configuration to enable force update:**

```bash
# 1. Create Firestore document
# Path: app_config/version_info
# Content:
{
  "isForceUpdateEnabled": true,
  "defaultMinAndroidVersion": "1.0.6",
  "defaultMinIosVersion": "1.0.6",
  "androidStoreUrl": "YOUR_ANDROID_STORE_URL",
  "iosStoreUrl": "YOUR_IOS_STORE_URL",
  "updateTitle": "Update Required",
  "updateMessage": "Please update to continue.",
  "rules": []
}
```

That's it! The system will now force all users with version < 1.0.6 to update.

---

**Last Updated**: December 17, 2025
**Current App Version**: 1.0.5+24

