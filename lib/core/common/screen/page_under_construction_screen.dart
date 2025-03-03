import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zporter_board/core/resource_manager/assets_manager.dart';


class PageUnderConstructionScreen extends StatelessWidget {
  final String? error;
  const PageUnderConstructionScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    // Log the error or handle it gracefully
    if (kDebugMode) {
      print("GoRouter Error: $error");
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Center(
            child: Lottie.asset(AssetsManager.pageUnderConstruction),
          ),
        ),
      ),
    );
  }
}