import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zporter_board/config/database/local/sembastdb.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/core/services/navigation_service.dart';
import 'package:zporter_board/core/services/notification_service.dart';
import 'package:zporter_board/core/services/sync_status_service.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_bloc.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource_impl.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource_local_impl.dart';
import 'package:zporter_board/features/match/data/repository/match_repository_impl.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/match/domain/usecases/clear_match_db_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/create_new_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/create_period_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/delete_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_and_sync_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_period_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_score_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_time_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_sub_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/notification/data/data_source/notification_local_data_source.dart';
import 'package:zporter_board/features/notification/data/data_source/notification_local_data_source_impl.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';
import 'package:zporter_board/features/notification/domain/repository/notification_repository_impl.dart';
import 'package:zporter_board/features/notification/domain/usecases/delete_all_notifications_usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/delete_notification_usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/get_notification_settings_usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
import 'package:zporter_board/features/notification/domain/usecases/update_notification_settings_usecase.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/notification_settings_bloc.dart';
import 'package:zporter_board/features/notification/presentation/view_model/unread_count_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //============================================================================
  // EXTERNAL & CORE SERVICES (LOCAL-FIRST: Fast local-only initialization)
  //============================================================================

  // Initialize local services synchronously - these are fast and don't block
  // We await these because BLoCs need them immediately and they're quick (< 100ms)
  print('[zporter_board] Initializing local services...');

  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  print('[zporter_board] SharedPreferences ready');

  final sembastDb = SembastDb();
  final db = await sembastDb.database;
  sl.registerLazySingleton<Database>(() => db);
  print('[zporter_board] Sembast Database ready');

  // Local services are ready - app can now create BLoCs safely
  // Firebase services will connect in background (non-blocking)

  // Firebase services (will be available after background initialization completes)
  // Register placeholder - these will throw if accessed before Firebase is ready
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // NotificationService with error handling for async dependencies
  sl.registerLazySingleton(() {
    try {
      return NotificationService(sl(), sl());
    } catch (e) {
      print('[zporter_board] NotificationService registration deferred: $e');
      rethrow;
    }
  });

  final routeGenerator = RouteGenerator();

  sl.registerLazySingleton(() => routeGenerator);
  sl.registerLazySingleton(() => routeGenerator.router);
  sl.registerLazySingleton(() => routeGenerator.rootNavigatorKey);

  // Register SyncStatusService for offline sync notifications
  sl.registerLazySingleton(() => SyncStatusService());

  //============================================================================
  // AUTH FEATURE (REFACTORED)
  //============================================================================
  // AuthBloc registration - will only be created when first accessed
  // By that time, Firebase should be initialized (or will initialize on-demand)
  sl.registerLazySingleton(() {
    try {
      return AuthBloc(
        firebaseAuth: sl(),
        googleSignIn: sl(),
        firestore: sl(),
        prefs: sl(),
        notificationService: sl(),
      );
    } catch (e) {
      print('[zporter_board] AuthBloc registration deferred: $e');
      rethrow;
    }
  });

  //============================================================================
  // MATCH FEATURE
  //============================================================================
  sl.registerLazySingleton(() => BoardBloc());
  sl.registerLazySingleton(() => MatchBloc(
      fetchMatchUsecase: sl(),
      updateMatchScoreUsecase: sl(),
      updateMatchTimeUsecase: sl(),
      createNewMatchUseCase: sl(),
      deleteMatchUseCase: sl(),
      clearMatchDbUseCase: sl(),
      updateSubUseCase: sl(),
      createPeriodUseCase: sl(),
      updateMatchPeriodUseCase: sl()));

  sl.registerLazySingleton<MatchDataSource>(
      () => MatchDataSourceImpl(
          firestore: sl(), firebaseAuth: sl(), authBloc: sl()), // MODIFIED
      instanceName: 'remote');

  sl.registerLazySingleton<MatchDataSource>(
      () =>
          MatchDatasourceLocalImpl(database: sl(), authBloc: sl()), // MODIFIED
      instanceName: 'local');

  sl.registerLazySingleton<MatchRepository>(() => MatchRepositoryImpl(
      remoteDataSource: sl(instanceName: 'remote'),
      localDataSource: sl(instanceName: 'local'),
      authBloc: sl())); // MODIFIED

  sl.registerLazySingleton(() => FetchMatchUsecase(matchRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateMatchScoreUsecase(matchRepository: sl()));
  sl.registerLazySingleton(() => UpdateMatchTimeUsecase(matchRepository: sl()));
  sl.registerLazySingleton(() => CreateNewMatchUseCase(matchRepository: sl()));
  sl.registerLazySingleton(() => DeleteMatchUseCase(matchRepository: sl()));
  sl.registerLazySingleton(() => UpdateSubUseCase(matchRepository: sl()));
  sl.registerLazySingleton(() => ClearMatchDbUseCase(matchRepository: sl()));
  sl.registerLazySingleton(() => CreatePeriodUseCase(matchRepository: sl()));
  sl.registerLazySingleton(
      () => UpdateMatchPeriodUseCase(matchRepository: sl()));
  sl.registerLazySingleton(() => FetchAndSyncLocalMatchesUseCase(
      remoteMatchDataSource: sl(instanceName: 'remote'),
      localMatchDataSource: sl(instanceName: 'local'),
      authBloc: sl(), // MODIFIED
      clearMatchDbUseCase: sl()));

  //============================================================================
  // NOTIFICATION FEATURE - Safe initialization with async dependencies
  //============================================================================
  sl.registerLazySingleton(() => NotificationBloc(
      getNotifications: sl(),
      markNotificationAsRead: sl(),
      deleteNotification: sl(),
      deleteAllNotifications: sl()));
  sl.registerLazySingleton(() => NotificationSettingsBloc(
      getNotificationSettings: sl(), updateNotificationSettings: sl()));
  sl.registerLazySingleton(() => UnreadCountBloc(notificationRepository: sl()));
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationAsReadUseCase(sl()));
  sl.registerLazySingleton(() => DeleteNotificationUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAllNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => GetNotificationSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateNotificationSettingsUseCase(sl()));
  sl.registerLazySingleton<NotificationRepository>(() =>
      NotificationRepositoryImpl(
          localDataSource: sl(),
          notificationService: sl(),
          sharedPreferences: sl()));
  sl.registerLazySingleton<NotificationLocalDataSource>(
      () => NotificationLocalDataSourceImpl(sl()));
}
