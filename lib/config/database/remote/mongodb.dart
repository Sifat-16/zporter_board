// import 'package:mongo_dart/mongo_dart.dart' hide State;
// import 'package:zporter_board/core/env/env.dart';
// import 'package:zporter_board/core/utils/log/debugger.dart';
//
// class MongoDB{
//   Db? db;
//   Future<void> connect() async {
//     if (db != null && db!.isConnected) {
//       debug(data: 'Successful connecting to MongoDB: ');
//       return; // Already connected
//     }
//     try {
//       db = await Db.create(Env.MONGODB_CONNECT);
//       await db!.open();
//       debug(data: 'Successful connecting to MongoDB: ');
//     } catch (e) {
//       debug(data: 'Error connecting to MongoDB: $e');
//     }
//   }
//
// }
