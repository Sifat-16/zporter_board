import 'package:bot_toast/bot_toast.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zporter_board/core/theme/app_theme.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';

import 'core/services/injection_container.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
        BlocProvider<MatchBloc>(create: (context) => sl<MatchBloc>()),
      ],
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) {
          return MaterialApp.router(
            routerConfig: sl<GoRouter>(),
            locale: DevicePreview.locale(context),
            builder: (context, child) {
              final botToastBuilder = BotToastInit();
              child = botToastBuilder(context, child);
              child = DevicePreview.appBuilder(context, child);
              return child;
            },
            debugShowCheckedModeBanner: false,
            title: 'Zporter Board',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.lightTheme,
            themeMode: ThemeMode.system,
          );
        },
      ),
    );
  }
}
