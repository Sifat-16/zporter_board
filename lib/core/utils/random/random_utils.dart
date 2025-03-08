import 'package:uuid/uuid.dart';

class RandomUtils{
  static String randomString(){
    return Uuid().v4();
  }
}