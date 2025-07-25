import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zporter_tactical_board/data/admin/model/version_config_model.dart';

// A simple data class to hold the app's current context
class AppContext {
  final String userId;
  final String appVersion;
  final String platform; // 'android' or 'ios'
  final String? countryCode; // e.g., 'US', 'DE'

  AppContext({
    required this.userId,
    required this.appVersion,
    required this.platform,
    this.countryCode,
  });
}

class VersionCheckService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _collectionPath = 'app_config';
  static const String _documentPath = 'version_info';

  /// The main public method to be called on app startup.
  Future<void> performVersionCheck(BuildContext context,
      {required String userId}) async {
    // 1. Fetch the remote configuration
    final config = await _getRemoteConfig();
    if (config == null || !config.isForceUpdateEnabled) {
      return; // System is disabled or failed to fetch, so we do nothing.
    }

    // 2. Gather the app's current context
    final appContext = await _getAppContext(userId);

    // 3. Process rules to find the required version
    final requiredVersion = _getRequiredVersion(config, appContext);
    if (requiredVersion == null) return;

    // 4. Compare versions and show dialog if needed
    final isUpdateNeeded =
        _isVersionOutdated(appContext.appVersion, requiredVersion);

    if (isUpdateNeeded && context.mounted) {
      final updateRule = _getMatchingRule(config, appContext);
      final storeUrl = appContext.platform == 'android'
          ? config.androidStoreUrl
          : config.iosStoreUrl;

      _showUpdateDialog(
        context: context,
        title: config.updateTitle,
        message: config.updateMessage,
        storeUrl: storeUrl,
        isHardUpdate: updateRule?.updateType == 'hard',
      );
    }
  }

  // --- Private Helper Methods ---

  Future<VersionConfig?> _getRemoteConfig() async {
    try {
      final doc =
          await _db.collection(_collectionPath).doc(_documentPath).get();
      if (doc.exists) {
        return VersionConfig.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint("VersionCheckService: Failed to fetch remote config: $e");
      return null;
    }
  }

  Future<AppContext> _getAppContext(String userId) async {
    final packageInfo = await PackageInfo.fromPlatform();

    String? countryCode;
    try {
      final currentLocale = await Devicelocale.currentLocale; // e.g., "en-US"
      if (currentLocale != null && currentLocale.contains('-')) {
        countryCode = currentLocale.split('-').last;
      }
    } catch (e) {
      debugPrint("VersionCheckService: Could not get device country code: $e");
    }

    return AppContext(
      userId: userId,
      appVersion: packageInfo.version,
      platform: Platform.isAndroid ? 'android' : 'ios',
      countryCode: countryCode?.toUpperCase(),
    );
  }

  String? _getRequiredVersion(VersionConfig config, AppContext appContext) {
    final matchingRule = _getMatchingRule(config, appContext);

    if (matchingRule != null) {
      return appContext.platform == 'android'
          ? matchingRule.minAndroidVersion
          : matchingRule.minIosVersion;
    }
    // If no rule matches, return the default version
    return appContext.platform == 'android'
        ? config.defaultMinAndroidVersion
        : config.defaultMinIosVersion;
  }

  UpdateRule? _getMatchingRule(VersionConfig config, AppContext appContext) {
    for (final rule in config.rules) {
      if (_isRuleMatch(rule, appContext)) {
        return rule;
      }
    }
    return null;
  }

  bool _isRuleMatch(UpdateRule rule, AppContext appContext) {
    // Check Platform
    if (rule.targetPlatforms.isNotEmpty &&
        !rule.targetPlatforms.contains(appContext.platform)) {
      return false;
    }
    // Check Country
    if (rule.targetCountries.isNotEmpty &&
        (appContext.countryCode == null ||
            !rule.targetCountries.contains(appContext.countryCode))) {
      return false;
    }
    // Check App Version
    if (rule.targetAppVersions.isNotEmpty &&
        !rule.targetAppVersions.contains(appContext.appVersion)) {
      return false;
    }
    // Check User ID
    if (rule.targetUserIds.isNotEmpty &&
        !rule.targetUserIds.contains(appContext.userId)) {
      return false;
    }
    // Check Rollout Percentage
    final userHash =
        sha1.convert(utf8.encode(appContext.userId)).bytes.last % 100;
    if (userHash >= rule.rolloutPercentage) {
      return false;
    }

    // If all checks pass, the rule is a match
    return true;
  }

  bool _isVersionOutdated(String currentVersion, String minVersion) {
    try {
      final currentParts = currentVersion.split('.').map(int.parse).toList();
      final minParts = minVersion.split('.').map(int.parse).toList();

      for (int i = 0; i < minParts.length; i++) {
        final current = (i < currentParts.length) ? currentParts[i] : 0;
        if (current < minParts[i]) return true;
        if (current > minParts[i]) return false;
      }
      return false; // Versions are identical
    } catch (e) {
      debugPrint(
          "VersionCheckService: Error comparing versions '$currentVersion' and '$minVersion': $e");
      return false; // Fail safe
    }
  }

  void _showUpdateDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String storeUrl,
    required bool isHardUpdate,
  }) {
    showDialog(
      context: context,
      barrierDismissible:
          !isHardUpdate, // Dialog is dismissible only for "soft" updates
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async =>
              !isHardUpdate, // Prevent back button for "hard" updates
          child: AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              if (!isHardUpdate) // Show a "Later" button only for "soft" updates
                TextButton(
                  child: const Text('Later'),
                  onPressed: () => Navigator.of(dialogContext).pop(),
                ),
              TextButton(
                child: const Text('Update Now'),
                onPressed: () async {
                  if (storeUrl.isEmpty) return;
                  final uri = Uri.parse(storeUrl);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
