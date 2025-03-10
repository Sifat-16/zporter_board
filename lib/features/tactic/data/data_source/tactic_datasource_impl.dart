import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/config/database/remote/mongodb.dart';
import 'package:zporter_board/core/constant/mongo_constant.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/tactic/data/data_source/tactic_datasource.dart';
import 'package:zporter_board/features/tactic/data/model/animation_data_model.dart';
import 'package:zporter_board/features/tactic/data/model/animation_model.dart';

class TacticDatasourceImpl implements TacticDatasource{
  MongoDB mongoDB;
  TacticDatasourceImpl({required this.mongoDB});

  @override
  Future<List<AnimationDataModel>> getAllAnimation() async{
    try{
      DbCollection? animationCollection = mongoDB.db?.collection(MongoConstant.MATCH_ANIMATION);
      final matches = await animationCollection!.find().toList();
      List<AnimationDataModel> animations = [];

      for(var m in matches){
        try{
          animations.add(AnimationDataModel.fromJson(m));
        }catch(e){
          debug(data: "Error while extracting $e");
        }
      }

      return animations;
    }catch(e){
      throw Exception(e);
    }
  }

  @override
  Future<AnimationDataModel> saveAnimation({required AnimationDataModel animationModel}) async {
    try {
      DbCollection? animationCollection = mongoDB.db?.collection(MongoConstant.MATCH_ANIMATION);

      if (animationCollection == null) {
        throw Exception("MongoDB collection is not initialized.");
      }

      // Check if the animation already exists
      var existingAnimation = await animationCollection.findOne(where.eq('_id', animationModel.id));

      if (existingAnimation != null) {
        // Update existing animation
        await animationCollection.update(
          where.eq('_id', animationModel.id),
          {
            r'$set': animationModel.toJson(), // Only update fields, keeping `_id` unchanged
          },
        );
      } else {
        // Insert new animation
        await animationCollection.insert(animationModel.toJson());
      }

      // Retrieve the updated animation and return it
      var updatedAnimation = await animationCollection.findOne(where.eq('_id', animationModel.id));

      if (updatedAnimation != null) {
        return AnimationDataModel.fromJson(updatedAnimation);
      } else {
        throw Exception("Failed to retrieve the saved animation.");
      }
    } catch (e) {
      throw Exception("Error in saveAnimation: $e");
    }
  }



}