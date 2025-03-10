import 'package:zporter_board/core/domain/usecase/usecase.dart';
import 'package:zporter_board/features/tactic/data/model/animation_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';
import 'package:zporter_board/features/tactic/domain/repository/tactic_repository.dart';

class GetAllAnimationUsecase extends UseCase<List<AnimationDataModel>, dynamic>{

  TacticRepository tacticRepository;

  GetAllAnimationUsecase({required this.tacticRepository});

  @override
  Future<List<AnimationDataModel>> call(param) async{
    return await tacticRepository.getAllAnimation();
  }

}