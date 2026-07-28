// lib/core/services/sync_status_service.dart

import 'dart:async';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:zporter_tactical_board/zporter_tactical_board.dart' as tactical;
import 'package:zporter_board/core/common/components/sync/sync_status_snackbar.dart';

/// Service that listens to sync queue status and displays sync notifications
class SyncStatusService {
  tactical.SyncQueueManager? _syncQueueManager;
  StreamSubscription<tactical.SyncQueueStatus>? _statusSubscription;
  CancelFunc? _currentNotification;

  // Track last status to avoid duplicate notifications
  bool _lastIsSyncing = false;
  int _lastPendingCount = 0;
  String? _lastError;

  // Debounce timer for showing success message
  Timer? _successDebounce;

  /// Initialize the service and start listening to sync status
  void initialize() {
    // Get SyncQueueManager from tactical board's GetIt instance
    try {
      _syncQueueManager = tactical.sl.get<tactical.SyncQueueManager>();
      _statusSubscription =
          _syncQueueManager!.statusStream.listen(_handleStatusChange);
    } catch (e) {
      print('[SyncStatusService] Failed to initialize: $e');
      // Service will remain inactive if SyncQueueManager is not available
    }
  }

  /// Handle sync status changes
  void _handleStatusChange(tactical.SyncQueueStatus status) {
    // Print detailed sync status for debugging
    print('[SyncStatus] isSyncing: ${status.isSyncing}, '
        'pending: ${status.pendingCount}, '
        'processing: ${status.processingCount}, '
        'completed: ${status.completedCount}, '
        'failed: ${status.failedCount}');

    // Skip if no changes detected
    if (status.isSyncing == _lastIsSyncing &&
        status.pendingCount == _lastPendingCount &&
        status.lastError == _lastError) {
      return;
    }

    // Cancel any pending success debounce
    _successDebounce?.cancel();
    _successDebounce = null;

    // Handle different states
    if (status.isSyncing && status.pendingCount > 0) {
      print(
          '[SyncStatus] 🔄 Syncing ${status.pendingCount + status.processingCount} changes...');
      // Sync happens silently — no toast notification shown to the user
    } else if (!status.isSyncing &&
        _lastIsSyncing &&
        status.pendingCount == 0) {
      // Just finished syncing successfully — silent, no toast
      _dismissNotification();
    } else if (status.lastError != null && status.lastError != _lastError) {
      // New error occurred — show failure notification (user needs to know)
      _showFailureNotification(status);
    } else if (!status.isSyncing && status.pendingCount == 0) {
      // Idle state - dismiss any notification
      _dismissNotification();
    }

    // Update last state
    _lastIsSyncing = status.isSyncing;
    _lastPendingCount = status.pendingCount;
    _lastError = status.lastError;
  }

  /// Show syncing notification with progress
  void _showSyncingNotification(tactical.SyncQueueStatus status) {
    _dismissNotification();

    final totalCount = status.pendingCount + status.processingCount;
    final completedCount = status.completedCount;
    final totalOperations = totalCount + completedCount;

    // Calculate progress based on completed vs total
    final progress =
        totalOperations > 0 ? (completedCount / totalOperations) : null;

    print('[SyncStatus] Progress: $completedCount/$totalOperations completed');

    _currentNotification = BotToast.showCustomNotification(
      duration: null, // Keep visible until dismissed
      animationDuration: const Duration(milliseconds: 200),
      animationReverseDuration: const Duration(milliseconds: 200),
      align: Alignment.topCenter, // FIX 4A: Position above tab menu per boss request
      toastBuilder: (cancel) => SyncingSnackbar(
        pendingCount: totalCount,
        progress: progress,
      ),
    );
  }

  /// Show success notification (debounced to avoid flashing)
  void _debouncedShowSuccess() {
    _successDebounce = Timer(const Duration(milliseconds: 300), () {
      print('[SyncStatus] ✅ Sync completed successfully!');
      _dismissNotification();

      _currentNotification = BotToast.showCustomNotification(
        duration: const Duration(seconds: 2),
        animationDuration: const Duration(milliseconds: 200),
        animationReverseDuration: const Duration(milliseconds: 200),
        align: Alignment.topCenter, // FIX 4A: Position above tab menu per boss request
        toastBuilder: (cancel) => const SuccessSnackbar(),
        onClose: () => _currentNotification = null,
      );
    });
  }

  /// Show failure notification with retry option
  void _showFailureNotification(tactical.SyncQueueStatus status) {
    _dismissNotification();

    final errorMessage = _formatError(status.lastError ?? 'Unknown error');
    print('[SyncStatus] ❌ Sync failed: ${status.lastError}');

    _currentNotification = BotToast.showCustomNotification(
      duration: const Duration(seconds: 5),
      animationDuration: const Duration(milliseconds: 200),
      animationReverseDuration: const Duration(milliseconds: 200),
      align: Alignment.topCenter, // FIX 4A: Position above tab menu per boss request
      toastBuilder: (cancel) => FailureSnackbar(
        error: errorMessage,
        onRetry: () {
          print('[SyncStatus] 🔄 User requested retry');
          cancel();
          _currentNotification = null;
          // Trigger retry by calling sync orchestrator
          // Note: This assumes sync orchestrator will retry automatically
        },
      ),
      onClose: () => _currentNotification = null,
    );
  }

  /// Dismiss current notification if any
  void _dismissNotification() {
    _currentNotification?.call();
    _currentNotification = null;
  }

  /// Format error message for display
  String _formatError(String error) {
    if (error.toLowerCase().contains('network')) {
      return 'No network connection';
    } else if (error.toLowerCase().contains('timeout')) {
      return 'Connection timeout';
    } else if (error.toLowerCase().contains('permission')) {
      return 'Permission denied';
    } else {
      return 'Sync error';
    }
  }

  /// Dispose resources
  void dispose() {
    _successDebounce?.cancel();
    _statusSubscription?.cancel();
    _dismissNotification();
  }
}
