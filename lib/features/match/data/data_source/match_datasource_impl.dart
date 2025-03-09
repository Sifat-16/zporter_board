import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/config/database/remote/mongodb.dart';
import 'package:zporter_board/core/constant/mongo_constant.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';

class MatchDataSourceImpl implements MatchDataSource{
  MongoDB mongoDB;
  MatchDataSourceImpl({required this.mongoDB});

  @override
  Future<List<FootballMatch>> getAllMatches() async{
    try{
      DbCollection? matchCollection = mongoDB.db?.collection(MongoConstant.MATCH_COLLECTION);
      final matches = await matchCollection!.find().toList();
      return matches.map((json) => FootballMatch.fromJson(json)).toList();
    }catch(e){
      throw Exception(e);
    }
  }

}