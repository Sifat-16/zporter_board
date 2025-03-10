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
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource_impl.dart';
import 'package:zporter_board/features/match/data/repository/match_repository_impl.dart';
import 'package:zporter_board/features/match/domain/repository/match_repository.dart';
import 'package:zporter_board/features/match/domain/usecases/fetch_match_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_score_usecase.dart';
import 'package:zporter_board/features/match/domain/usecases/update_match_time_usecase.dart';
import 'package:zporter_board/features/match/presentation/view_model/match_bloc.dart';
import 'package:zporter_board/features/tactic/data/data_source/tactic_datasource.dart';
import 'package:zporter_board/features/tactic/data/data_source/tactic_datasource_impl.dart';
import 'package:zporter_board/features/tactic/data/repository/tactic_repository_impl.dart';
import 'package:zporter_board/features/tactic/domain/repository/tactic_repository.dart';
import 'package:zporter_board/features/tactic/domain/usecase/get_all_animation_usecase.dart';
import 'package:zporter_board/features/tactic/domain/usecase/save_animation_usecase.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/equipment/equipment_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/form/form_bloc.dart';
import 'package:zporter_board/features/tactic/presentation/view_model/player/player_bloc.dart';

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


  // match
  sl.registerLazySingleton<MatchDataSource>(()=>MatchDataSourceImpl(mongoDB: sl.get()));
  sl.registerLazySingleton<MatchRepository>(()=>MatchRepositoryImpl(matchDataSource: sl.get()));
  sl.registerLazySingleton<FetchMatchUsecase>(()=>FetchMatchUsecase(matchRepository: sl.get()));
  sl.registerLazySingleton<UpdateMatchScoreUsecase>(()=>UpdateMatchScoreUsecase(matchRepository: sl.get()));
  sl.registerLazySingleton<UpdateMatchTimeUsecase>(()=>UpdateMatchTimeUsecase(matchRepository: sl.get()));
  sl.registerLazySingleton<MatchBloc>(()=>MatchBloc(fetchMatchUsecase: sl.get(), updateMatchScoreUsecase: sl.get(), updateMatchTimeUsecase: sl.get()));


  // tactic
  sl.registerLazySingleton<TacticDatasource>(()=>TacticDatasourceImpl(mongoDB: sl.get()));
  sl.registerLazySingleton<TacticRepository>(()=>TacticRepositoryImpl(tacticDatasource: sl.get()));
  sl.registerLazySingleton<GetAllAnimationUsecase>(()=>GetAllAnimationUsecase(tacticRepository: sl.get()));
  sl.registerLazySingleton<SaveAnimationUsecase>(()=>SaveAnimationUsecase(tacticRepository: sl.get()));


  //player
  sl.registerLazySingleton<PlayerBloc>(()=>PlayerBloc());

  //equipment
  sl.registerLazySingleton<EquipmentBloc>(()=>EquipmentBloc());

  //form
  sl.registerLazySingleton<FormBloc>(()=>FormBloc());

  //animation
  sl.registerLazySingleton<AnimationBloc>(()=>AnimationBloc(
    getAllAnimationUsecase: sl.get(),
    saveAnimationUsecase: sl.get()
  ));

}