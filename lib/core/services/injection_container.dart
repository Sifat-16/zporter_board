import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:zporter_board/config/database/remote/mongodb.dart';
import 'package:zporter_board/core/resource_manager/route_manager.dart';
import 'package:zporter_board/features/auth/data/data_source/auth_data_source.dart';
import 'package:zporter_board/features/auth/data/data_source/auth_data_source_impl.dart';
import 'package:zporter_board/features/auth/data/repository/auth_repository_impl.dart';
import 'package:zporter_board/features/auth/domain/repository/auth_repository.dart';
import 'package:zporter_board/features/auth/domain/usecase/auth_status_usecase.dart';
import 'package:zporter_board/features/auth/domain/usecase/sign_in_with_google_usecase.dart';
import 'package:zporter_board/features/auth/presentation/view_model/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final routeGenerator = RouteGenerator();

  sl.registerLazySingleton(()=>routeGenerator);
  sl.registerLazySingleton(()=>routeGenerator.router);
  sl.registerLazySingleton(()=>routeGenerator.rootNavigatorKey);

  sl.registerLazySingleton<Logger>(()=>Logger());


  sl.registerLazySingletonAsync<MongoDB>(() async {
    final mongoDB = MongoDB();
    await mongoDB.connect();
    return mongoDB;
  });

  await sl.isReady<MongoDB>();


  // auth
  sl.registerLazySingleton<AuthDataSource>(()=>AuthDataSourceImpl(mongoDB: sl.get()));
  sl.registerLazySingleton<AuthRepository>(()=>AuthRepositoryImpl(authDataSource: sl.get()));
  sl.registerLazySingleton<SignInWithGoogleUseCase>(()=>SignInWithGoogleUseCase(authRepository: sl.get()));
  sl.registerLazySingleton<AuthStatusUsecase>(()=>AuthStatusUsecase(authRepository: sl.get()));
  sl.registerLazySingleton<AuthBloc>(()=>AuthBloc(signInWithGoogleUseCase: sl.get(), authStatusUsecase: sl.get()));




}