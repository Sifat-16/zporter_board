import 'package:zporter_board/features/tactic/data/model/animation_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';

abstract class TacticRepository{
  Future<List<AnimationDataModel>> getAllAnimation();
  Future<AnimationDataModel> saveAnimation({required AnimationDataModel animationModel});
}