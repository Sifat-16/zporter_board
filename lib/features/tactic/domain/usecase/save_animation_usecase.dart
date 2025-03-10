import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/tactic/data/model/animation_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';
import 'package:zporter_board/features/tactic/domain/repository/tactic_repository.dart';

class SaveAnimationUsecase extends UseCase<AnimationDataModel, AnimationDataModel>{

  TacticRepository tacticRepository;

  SaveAnimationUsecase({required this.tacticRepository});

  @override
  Future<AnimationDataModel> call(param) async{
    return await tacticRepository.saveAnimation(animationModel: param);
  }

}