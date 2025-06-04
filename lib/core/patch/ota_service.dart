import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:zporter_board/core/common/components/button/custom_button.dart';
import 'package:zporter_board/core/common/components/z_loader.dart';
import 'package:zporter_tactical_board/app/manager/color_manager.dart';

class OTAService {
  static final updater = ShorebirdUpdater();

  static CancelFunc? _currentStickyToastCancelFunc;

  static void showUpdatingStickySnackbar() {
    // If a sticky toast is already shown, you might want to cancel it first
    // or rely on `onlyOne: true` in `showCustomNotification`.
    // For this example, let's explicitly cancel any previous one.
    _currentStickyToastCancelFunc?.call();

    // Show a custom notification using BotToast
    _currentStickyToastCancelFunc = BotToast.showCustomNotification(
      // The duration: null means it won't auto-dismiss.
      // It will only be dismissed when the CancelFunc is called.
      duration: null,
      // enableSlideClose: false prevents dismissing by sliding.
      enableSlideOff: false,
      // onlyOne: true ensures that only one toast of this type (identified by groupKey or internal mechanisms) is shown.
      onlyOne: true,
      // crossPage: true allows the toast to persist across page navigations.
      crossPage: true,
      // align: Alignment.bottomCenter places the toast at the bottom, similar to a Snackbar.
      // You can adjust this as needed (e.g., Alignment.topCenter).
      align: Alignment.bottomCenter,
      // The toastBuilder provides a CancelFunc that can be used to dismiss this specific toast.
      toastBuilder: (cancelFunc) {
        // This is the widget that will be displayed as the toast.
        return Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: Colors.black,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize:
                  MainAxisSize.min, // Important for Card to wrap content
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: ZLoader(logoAssetPath: "assets/image/logo.png"),
                    ),
                    Text(
                      'Your app will be updated with the latest improvements and fixes.',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.yellowAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: Colors.yellowAccent.withOpacity(0.5)))),
                  onPressed: () {
                    // Call the cancelFunc provided by toastBuilder to dismiss this specific toast.
                    cancelFunc();
                    // Clear our reference if needed
                    if (_currentStickyToastCancelFunc == cancelFunc) {
                      _currentStickyToastCancelFunc = null;
                    }
                  },
                  child: const Text('DISMISS'),
                ),
              ],
            ),
          ),
        );
      },
      // You can customize animations if needed
      // animationDuration: Duration(milliseconds: 200),
      // animationReverseDuration: Duration(milliseconds: 200),
    );
  }

  static void showRestartStickySnackbar() {
    // If a sticky toast is already shown, you might want to cancel it first
    // or rely on `onlyOne: true` in `showCustomNotification`.
    // For this example, let's explicitly cancel any previous one.
    _currentStickyToastCancelFunc?.call();

    // Show a custom notification using BotToast
    _currentStickyToastCancelFunc = BotToast.showCustomNotification(
      // The duration: null means it won't auto-dismiss.
      // It will only be dismissed when the CancelFunc is called.
      duration: null,
      // enableSlideClose: false prevents dismissing by sliding.
      enableSlideOff: false,
      // onlyOne: true ensures that only one toast of this type (identified by groupKey or internal mechanisms) is shown.
      onlyOne: true,
      // crossPage: true allows the toast to persist across page navigations.
      crossPage: true,
      // align: Alignment.bottomCenter places the toast at the bottom, similar to a Snackbar.
      // You can adjust this as needed (e.g., Alignment.topCenter).
      align: Alignment.bottomCenter,
      // The toastBuilder provides a CancelFunc that can be used to dismiss this specific toast.
      toastBuilder: (cancelFunc) {
        // This is the widget that will be displayed as the toast.
        return Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: Colors.black,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize:
                  MainAxisSize.min, // Important for Card to wrap content
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: CustomButton(
                        fillColor: ColorManager.green,
                        borderRadius: 4,
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                        child: Text(
                          "Restart",
                          style: TextStyle(
                              color: ColorManager.white,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          try {
                            Restart.restartApp(
                              notificationTitle: 'Restarting App',
                              notificationBody:
                                  'Please tap here to open the app again.',
                            );
                          } catch (e) {}
                        },
                      ),
                    ),
                    Text(
                      'Your update is ready. Please tap on restart button',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.yellowAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: Colors.yellowAccent.withOpacity(0.5)))),
                  onPressed: () {
                    // Call the cancelFunc provided by toastBuilder to dismiss this specific toast.
                    cancelFunc();
                    // Clear our reference if needed
                    if (_currentStickyToastCancelFunc == cancelFunc) {
                      _currentStickyToastCancelFunc = null;
                    }
                  },
                  child: const Text('DISMISS'),
                ),
              ],
            ),
          ),
        );
      },
      // You can customize animations if needed
      // animationDuration: Duration(milliseconds: 200),
      // animationReverseDuration: Duration(milliseconds: 200),
    );
  }

  static Future<void> checkForUpdates() async {
    // Check whether a new update is available.
    final status = await updater.checkForUpdate();

    if (status == UpdateStatus.outdated) {
      try {
        // Perform the update
        showUpdatingStickySnackbar();
        updater.update().then((t) {
          showRestartStickySnackbar();
        });
      } on UpdateException catch (error) {
        // Handle any errors that occur while updating.
      }
    }
  }
}
