import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zporter_board/config/database/local/sembastdb.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/core/services/user_id_service.dart';
import 'package:zporter_board/features/auth/data/data_source/auth_data_source.dart';
import 'package:zporter_board/features/auth/data/data_source/auth_data_source_impl.dart';
import 'package:zporter_board/features/auth/data/repository/auth_repository_impl.dart';
import 'package:zporter_board/features/auth/domain/repository/auth_repository.dart';
import 'package:zporter_board/features/auth/domain/usecase/auth_status_usecase.dart';
import 'package:zporter_board/features/auth/domain/usecase/guest_login_usecase.dart';
import 'package:zporter_board/features/auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:zporter_board/features/auth/domain/usecase/sign_out_usecase.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';
import 'package:zporter_board/features/board/presentation/view_model/board_bloc.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource_impl.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource_local_impl.dart';
import 'package:zporter_board/features/match/data/repository/match_repository_impl.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/match/domain/usecases/clear_match_db_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/create_new_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/delete_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_and_sync_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_score_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_time_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_sub_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerSingletonAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    print("SharedPreferences Initialized");
    return prefs;
  });

  // Register Sembast Database asynchronously
  sl.registerSingletonAsync<Database>(() async {
    final sembastDb = SembastDb();
    final db = await sembastDb.database;
    print("Sembast Database Initialized");
    return db;
  });

  await sl.isReady<SharedPreferences>();
  await sl.isReady<Database>();

  sl.registerLazySingleton<UserIdService>(
    () => UserIdService(
      firebaseAuth: FirebaseAuth.instance,
      prefs: sl<SharedPreferences>(),
    ),
  );
  final routeGenerator = RouteGenerator();

  sl.registerLazySingleton(() => routeGenerator);
  sl.registerLazySingleton(() => routeGenerator.router);
  sl.registerLazySingleton(() => routeGenerator.rootNavigatorKey);

  // sl.registerLazySingleton<Logger>(()=>Logger());

  // sl.registerLazySingletonAsync<MongoDB>(() async {
  //   final mongoDB = MongoDB();
  //   await mongoDB.connect();
  //   return mongoDB;
  // });
  //
  // await sl.isReady<MongoDB>();

  // board
  sl.registerLazySingleton<BoardBloc>(() => BoardBloc());

  // auth
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthDataSourceImpl(
      firebaseAuth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      googleSignIn: GoogleSignIn(),
      userIdService: sl.get(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(authDataSource: sl.get()),
  );
  sl.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(authRepository: sl.get()),
  );
  sl.registerLazySingleton<AuthStatusUsecase>(
    () => AuthStatusUsecase(authRepository: sl.get()),
  );

  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(authRepository: sl.get()),
  );

  sl.registerLazySingleton<GuestLoginUseCase>(
    () => GuestLoginUseCase(authRepository: sl.get()),
  );

  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      signInWithGoogleUseCase: sl.get(),
      authStatusUsecase: sl.get(),
      signOutUseCase: sl.get(),
      fetchAndSyncLocalMatchesUseCase: sl.get(),
      guestLoginUseCase: sl.get(),
      matchBloc: sl.get(),
    ),
  );

  // match
  sl.registerLazySingleton<MatchDataSource>(
    () => MatchDataSourceImpl(
      firestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance,
    ),
    instanceName: 'remote',
  );

  sl.registerLazySingleton<MatchDataSource>(
    () => MatchDatasourceLocalImpl(
      database: sl<Database>(),
      userIdService: sl<UserIdService>(),
    ),
    instanceName: 'local',
  );
  sl.registerLazySingleton<MatchRepository>(
    () => MatchRepositoryImpl(
      remoteDataSource: sl<MatchDataSource>(instanceName: 'remote'),
      localDataSource: sl<MatchDataSource>(instanceName: 'local'),
      userIdService: sl<UserIdService>(),
    ),
  );
  sl.registerLazySingleton<FetchMatchUsecase>(
    () => FetchMatchUsecase(matchRepository: sl.get()),
  );
  sl.registerLazySingleton<UpdateMatchScoreUsecase>(
    () => UpdateMatchScoreUsecase(matchRepository: sl.get()),
  );
  sl.registerLazySingleton<UpdateMatchTimeUsecase>(
    () => UpdateMatchTimeUsecase(matchRepository: sl.get()),
  );

  sl.registerLazySingleton<CreateNewMatchUseCase>(
    () => CreateNewMatchUseCase(matchRepository: sl.get()),
  );

  sl.registerLazySingleton<DeleteMatchUseCase>(
    () => DeleteMatchUseCase(matchRepository: sl.get()),
  );
  sl.registerLazySingleton<UpdateSubUseCase>(
    () => UpdateSubUseCase(matchRepository: sl.get()),
  );
  sl.registerLazySingleton<FetchAndSyncLocalMatchesUseCase>(
    () => FetchAndSyncLocalMatchesUseCase(
      remoteMatchDataSource: sl<MatchDataSource>(instanceName: 'remote'),
      localMatchDataSource: sl<MatchDataSource>(instanceName: 'local'),
      userIdService: sl<UserIdService>(),
      clearMatchDbUseCase: sl<ClearMatchDbUseCase>(),
    ),
  );

  sl.registerLazySingleton<ClearMatchDbUseCase>(
    () => ClearMatchDbUseCase(matchRepository: sl.get()),
  );

  sl.registerLazySingleton<MatchBloc>(
    () => MatchBloc(
      fetchMatchUsecase: sl.get(),
      updateMatchScoreUsecase: sl.get(),
      updateMatchTimeUsecase: sl.get(),
      createNewMatchUseCase: sl.get(),
      deleteMatchUseCase: sl.get(),
      clearMatchDbUseCase: sl.get(),
      updateSubUseCase: sl.get(),
    ),
  );
}
