// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get_it/get_it.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sembast/sembast.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:zporter_board/config/database/local/sembastdb.dart';
// import 'package:zporter_board/core/resource_manager/route_manager.dart';
// import 'package:zporter_board/core/services/notification_service.dart';
// import 'package:zporter_board/core/services/user_id_service.dart';
// import 'package:zporter_board/features/auth/data/data_source/auth_data_source.dart';
// import 'package:zporter_board/features/auth/data/data_source/auth_data_source_impl.dart';
// import 'package:zporter_board/features/auth/data/repository/auth_repository_impl.dart';
// import 'package:zporter_board/features/auth/domain/repository/auth_repository.dart';
// import 'package:zporter_board/features/auth/domain/usecase/auth_status_usecase.dart';
// import 'package:zporter_board/features/auth/domain/usecase/guest_login_usecase.dart';
// import 'package:zporter_board/features/auth/domain/usecase/sign_in_with_google_usecase.dart';
// import 'package:zporter_board/features/auth/domain/usecase/sign_out_usecase.dart';
// import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
// import 'package:zporter_board/features/board/presentation/view_model/board_bloc.dart';
// import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
// import 'package:zporter_board/features/match/data/data_source/match_datasource_impl.dart';
// import 'package:zporter_board/features/match/data/data_source/match_datasource_local_impl.dart';
// import 'package:zporter_board/features/match/data/repository/match_repository_impl.dart';
// import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
// import 'package:zporter_board/features/match/domain/usecases/clear_match_db_usecase.dart';
// import 'package:zporter_board/features/match/domain/usecases/create_new_match_usecase.dart';
// import 'package:zporter_board/features/match/domain/usecases/create_period_usecase.dart';
// import 'package:zporter_board/features/match/domain/usecases/delete_match_usecase.dart';
// import 'package:zporter_board/features/match/domain/usecases/fetch_and_sync_match_usecase.dart';
// import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
// import 'package:zporter_board/features/match/domain/usecases/update_match_period_usecase.dart';
// import 'package:zporter_board/features/match/domain/usecases/update_match_score_usecase.dart';
// import 'package:zporter_board/features/match/domain/usecases/update_match_time_usecase.dart';
// import 'package:zporter_board/features/match/domain/usecases/update_sub_usecase.dart';
// import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
// import 'package:zporter_board/features/notification/data/data_source/notification_local_data_source.dart';
// import 'package:zporter_board/features/notification/data/data_source/notification_local_data_source_impl.dart';
// import 'package:zporter_board/features/notification/domain/repository/notification_repository.dart';
// import 'package:zporter_board/features/notification/domain/repository/notification_repository_impl.dart';
// import 'package:zporter_board/features/notification/domain/usecases/delete_all_notifications_usecase.dart';
// import 'package:zporter_board/features/notification/domain/usecases/delete_notification_usecase.dart';
// import 'package:zporter_board/features/notification/domain/usecases/get_notification_settings_usecase.dart';
// import 'package:zporter_board/features/notification/domain/usecases/get_notifications_usecase.dart';
// import 'package:zporter_board/features/notification/domain/usecases/mark_notification_as_read_usecase.dart';
// import 'package:zporter_board/features/notification/domain/usecases/update_notification_settings_usecase.dart';
// import 'package:zporter_board/features/notification/presentation/view_model/notification_bloc.dart';
// import 'package:zporter_board/features/notification/presentation/view_model/notification_settings_bloc.dart';
// import 'package:zporter_board/features/notification/presentation/view_model/unread_count_bloc.dart';
//
// final sl = GetIt.instance;
//
// Future<void> init() async {
//   sl.registerSingletonAsync<SharedPreferences>(() async {
//     final prefs = await SharedPreferences.getInstance();
//     print("SharedPreferences Initialized");
//     return prefs;
//   });
//
//   // Register Sembast Database asynchronously
//   sl.registerSingletonAsync<Database>(() async {
//     final sembastDb = SembastDb();
//     final db = await sembastDb.database;
//     print("Sembast Database Initialized");
//     return db;
//   });
//
//   await sl.isReady<SharedPreferences>();
//   await sl.isReady<Database>();
//
//   sl.registerLazySingleton<UserIdService>(
//     () => UserIdService(
//       firebaseAuth: FirebaseAuth.instance,
//       prefs: sl<SharedPreferences>(),
//     ),
//   );
//   final routeGenerator = RouteGenerator();
//
//   sl.registerLazySingleton(() => routeGenerator);
//   sl.registerLazySingleton(() => routeGenerator.router);
//   sl.registerLazySingleton(() => routeGenerator.rootNavigatorKey);
//
//   // sl.registerLazySingleton<Logger>(()=>Logger());
//
//   // sl.registerLazySingletonAsync<MongoDB>(() async {
//   //   final mongoDB = MongoDB();
//   //   await mongoDB.connect();
//   //   return mongoDB;
//   // });
//   //
//   // await sl.isReady<MongoDB>();
//
//   // board
//   sl.registerLazySingleton<BoardBloc>(() => BoardBloc());
//
//   // auth
//   sl.registerLazySingleton<AuthDataSource>(
//     () => AuthDataSourceImpl(
//       firebaseAuth: FirebaseAuth.instance,
//       firestore: FirebaseFirestore.instance,
//       googleSignIn: GoogleSignIn(),
//       userIdService: sl.get(),
//     ),
//   );
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(authDataSource: sl.get()),
//   );
//   sl.registerLazySingleton<SignInWithGoogleUseCase>(
//     () => SignInWithGoogleUseCase(authRepository: sl.get()),
//   );
//   sl.registerLazySingleton<AuthStatusUsecase>(
//     () => AuthStatusUsecase(authRepository: sl.get()),
//   );
//
//   sl.registerLazySingleton<SignOutUseCase>(
//     () => SignOutUseCase(authRepository: sl.get()),
//   );
//
//   sl.registerLazySingleton<GuestLoginUseCase>(
//     () => GuestLoginUseCase(authRepository: sl.get()),
//   );
//
//   sl.registerLazySingleton<AuthBloc>(
//     () => AuthBloc(
//       signInWithGoogleUseCase: sl.get(),
//       authStatusUsecase: sl.get(),
//       signOutUseCase: sl.get(),
//       fetchAndSyncLocalMatchesUseCase: sl.get(),
//       guestLoginUseCase: sl.get(),
//       matchBloc: sl.get(),
//     ),
//   );
//
//   // match
//   sl.registerLazySingleton<MatchDataSource>(
//     () => MatchDataSourceImpl(
//       firestore: FirebaseFirestore.instance,
//       firebaseAuth: FirebaseAuth.instance,
//       userIdService: sl.get(),
//     ),
//     instanceName: 'remote',
//   );
//
//   sl.registerLazySingleton<MatchDataSource>(
//     () => MatchDatasourceLocalImpl(
//       database: sl<Database>(),
//       userIdService: sl<UserIdService>(),
//     ),
//     instanceName: 'local',
//   );
//   sl.registerLazySingleton<MatchRepository>(
//     () => MatchRepositoryImpl(
//       remoteDataSource: sl<MatchDataSource>(instanceName: 'remote'),
//       userIdService: sl<UserIdService>(),
//       localDataSource: sl<MatchDataSource>(instanceName: 'local'),
//     ),
//   );
//   sl.registerLazySingleton<FetchMatchUsecase>(
//     () => FetchMatchUsecase(matchRepository: sl.get()),
//   );
//   sl.registerLazySingleton<UpdateMatchScoreUsecase>(
//     () => UpdateMatchScoreUsecase(matchRepository: sl.get()),
//   );
//   sl.registerLazySingleton<UpdateMatchTimeUsecase>(
//     () => UpdateMatchTimeUsecase(matchRepository: sl.get()),
//   );
//
//   sl.registerLazySingleton<CreateNewMatchUseCase>(
//     () => CreateNewMatchUseCase(matchRepository: sl.get()),
//   );
//
//   sl.registerLazySingleton<DeleteMatchUseCase>(
//     () => DeleteMatchUseCase(matchRepository: sl.get()),
//   );
//   sl.registerLazySingleton<UpdateSubUseCase>(
//     () => UpdateSubUseCase(matchRepository: sl.get()),
//   );
//   sl.registerLazySingleton<FetchAndSyncLocalMatchesUseCase>(
//     () => FetchAndSyncLocalMatchesUseCase(
//       remoteMatchDataSource: sl<MatchDataSource>(instanceName: 'remote'),
//       localMatchDataSource: sl<MatchDataSource>(instanceName: 'local'),
//       userIdService: sl<UserIdService>(),
//       clearMatchDbUseCase: sl<ClearMatchDbUseCase>(),
//     ),
//   );
//
//   sl.registerLazySingleton<ClearMatchDbUseCase>(
//     () => ClearMatchDbUseCase(matchRepository: sl.get()),
//   );
//
//   sl.registerLazySingleton<CreatePeriodUseCase>(
//     () => CreatePeriodUseCase(matchRepository: sl.get()),
//   );
//
//   sl.registerLazySingleton<UpdateMatchPeriodUseCase>(
//     () => UpdateMatchPeriodUseCase(matchRepository: sl.get()),
//   );
//
//   sl.registerLazySingleton<MatchBloc>(
//     () => MatchBloc(
//       fetchMatchUsecase: sl.get(),
//       updateMatchScoreUsecase: sl.get(),
//       updateMatchTimeUsecase: sl.get(),
//       createNewMatchUseCase: sl.get(),
//       deleteMatchUseCase: sl.get(),
//       clearMatchDbUseCase: sl.get(),
//       updateSubUseCase: sl.get(),
//       createPeriodUseCase: sl.get(),
//       updateMatchPeriodUseCase: sl.get(),
//     ),
//   );
//
//   //============================================================================
//   // NOTIFICATION FEATURE
//   //============================================================================
//
//   //! Features - Notification
//   //
//   // BLoC
//   sl.registerLazySingleton(
//     () => NotificationBloc(
//       getNotifications: sl(),
//       markNotificationAsRead: sl(),
//       deleteNotification: sl(),
//       deleteAllNotifications: sl(),
//     ),
//   );
//
//   sl.registerLazySingleton(
//     () => NotificationSettingsBloc(
//       getNotificationSettings: sl(),
//       updateNotificationSettings: sl(),
//     ),
//   );
//
//   // Register UnreadCountBloc as a singleton so it's globally available
//   sl.registerLazySingleton(
//     () => UnreadCountBloc(
//       notificationRepository: sl(),
//     ),
//   );
//
//   // Use cases
//   sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
//   sl.registerLazySingleton(() => MarkNotificationAsReadUseCase(sl()));
//   sl.registerLazySingleton(() => DeleteNotificationUseCase(sl()));
//   sl.registerLazySingleton(() => DeleteAllNotificationsUseCase(sl()));
//   sl.registerLazySingleton(() => GetNotificationSettingsUseCase(sl()));
//   sl.registerLazySingleton(() => UpdateNotificationSettingsUseCase(sl()));
//
//   // Repository
//   sl.registerLazySingleton<NotificationRepository>(
//     () => NotificationRepositoryImpl(
//       localDataSource: sl(),
//       notificationService: sl(),
//       sharedPreferences: sl(),
//     ),
//   );
//
//   // Data sources
//   sl.registerLazySingleton<NotificationLocalDataSource>(
//     () => NotificationLocalDataSourceImpl(sl()),
//   );
//
//   //! Core - Notification
//   sl.registerLazySingleton(
//     () => NotificationService(
//       sl(),
//       sl(),
//     ),
//   );
//
//   //! External - Notification
//   sl.registerLazySingleton(() => FirebaseMessaging.instance);
//   sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
// }

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
  // EXTERNAL & CORE SERVICES
  //============================================================================
  sl.registerSingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  sl.registerSingletonAsync<Database>(() async {
    final sembastDb = SembastDb();
    return await sembastDb.database;
  });

  await sl.isReady<SharedPreferences>();
  await sl.isReady<Database>();

  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn());
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton(() => FlutterLocalNotificationsPlugin());
  // sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => NotificationService(sl(), sl()));

  final routeGenerator = RouteGenerator();

  sl.registerLazySingleton(() => routeGenerator);
  sl.registerLazySingleton(() => routeGenerator.router);
  sl.registerLazySingleton(() => routeGenerator.rootNavigatorKey);

  //============================================================================
  // AUTH FEATURE (REFACTORED)
  //============================================================================
  sl.registerLazySingleton(() => AuthBloc(
        firebaseAuth: sl(),
        googleSignIn: sl(),
        firestore: sl(),
        prefs: sl(),
        notificationService: sl(),
      ));

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
  // NOTIFICATION FEATURE
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
