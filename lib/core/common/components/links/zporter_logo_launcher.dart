import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zporter_board/config/version/version_info.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';
import 'package:zporter_board/core/resource_manager/values_manager.dart';

class ZporterLogoLauncher extends StatelessWidget {
  const ZporterLogoLauncher({super.key});

  Future<void> _launchUrl(BuildContext context) async {
    String url = AppInfo.zporter_url;
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      try {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } catch (e) {
        // It's good practice to show feedback to the user if launching fails.
        BotToast.showText(
          align: Alignment.topCenter,
          text: 'Could not launch $url',
          contentColor: Colors.red,
          textStyle: const TextStyle(color: Colors.white),
        );
      }
    } else {
      BotToast.showText(
        align: Alignment.topCenter,
        text: 'Could not launch $url',
        contentColor: Colors.red,
        textStyle: const TextStyle(color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchUrl(context);
      },
      child: Image.asset(
        AssetsManager.logo,
        height: AppSize.s40,
        width: AppSize.s40,
      ),
    );
  }
}
