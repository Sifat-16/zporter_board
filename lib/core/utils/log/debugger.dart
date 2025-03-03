import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:zporter_board/core/services/injection_container.dart';

void debug({required dynamic data}){
  if(kDebugMode){
    Logger logger = sl.get<Logger>();
    logger.log(Level.info, data);
  }else{

  }
}