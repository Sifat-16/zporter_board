import 'package:zporter_board/features/tactic/data/data_source/tactic_datasource.dart';
import 'package:zporter_board/features/tactic/data/model/animation_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';
import 'package:zporter_board/features/tactic/domain/repository/tactic_repository.dart';

class TacticRepositoryImpl implements TacticRepository{

  TacticDatasource tacticDatasource;
  TacticRepositoryImpl({required this.tacticDatasource});
  @override
  Future<List<AnimationDataModel>> getAllAnimation() async{
    return await tacticDatasource.getAllAnimation();
  }

  @override
  Future<AnimationDataModel> saveAnimation({required AnimationDataModel animationModel}) async{
    return await tacticDatasource.saveAnimation(animationModel: animationModel);
  }
  
}