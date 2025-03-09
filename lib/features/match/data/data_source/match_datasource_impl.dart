import 'package:mongo_dart/mongo_dart.dart';
import 'package:zporter_board/config/database/remote/mongodb.dart';
import 'package:zporter_board/core/constant/mongo_constant.dart';
import 'package:zporter_board/core/utils/log/debugger.dart';
import 'package:zporter_board/features/match/data/data_source/match_datasource.dart';
import 'package:zporter_board/features/match/data/model/football_match.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_score_request.dart';
import 'package:zporter_board/features/match/domain/requests/update_match_time_request.dart';

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

  @override
  Future<FootballMatch> updateMatchScore(UpdateMatchScoreRequest updateMatchScoreRequest) async{
    try{
      DbCollection? matchCollection = mongoDB.db?.collection(MongoConstant.MATCH_COLLECTION);
      final ObjectId objectId = updateMatchScoreRequest.matchId;
      await matchCollection?.updateOne(
        where.id(objectId),
        modify.set('matchScore', updateMatchScoreRequest.newScore.toJson()),
      );
      debug(data: "Match score updated");
      return getMatchById(objectId);
    }catch(e){
      throw Exception(e);
    }
  }


  Future<FootballMatch> getMatchById(ObjectId matchId)async{
    try{
      DbCollection? matchCollection = mongoDB.db?.collection(MongoConstant.MATCH_COLLECTION);

      // Ensure that matchId is an ObjectId. If it's a string, convert it.


      // Fetch the updated match object from the database
      final matchDocument = await matchCollection?.findOne(where.id(matchId));


      // If a match document is found, return it as a FootballMatch object
      if (matchDocument != null) {
        return FootballMatch.fromJson(matchDocument);  // Convert the MongoDB document to FootballMatch object
      }else{
        throw Exception("Match id not found");
      }
    }catch(e){
      throw Exception(e);
    }

  }

  @override
  Future<FootballMatch> updateMatchTime(UpdateMatchTimeRequest updateMatchTimeRequest) async{
    try{
      DbCollection? matchCollection = mongoDB.db?.collection(MongoConstant.MATCH_COLLECTION);
      final ObjectId objectId = updateMatchTimeRequest.matchId;

      // Convert the list of MatchTime objects to a list of JSON maps
      List<Map<String, dynamic>> matchTimeJsonList = updateMatchTimeRequest.footballMatch.matchTime.map((matchTime) {
        return matchTime.toJson();  // Convert each MatchTime object to JSON
      }).toList();

      // Update the matchTime field in the MongoDB document
      await matchCollection?.updateOne(
        where.id(objectId),
        modify.set('matchTime', matchTimeJsonList),  // Set the updated list
      );
      debug(data: "Match time updated");
      return getMatchById(objectId);
    } catch(e){
    throw Exception(e);
    }
  }

}