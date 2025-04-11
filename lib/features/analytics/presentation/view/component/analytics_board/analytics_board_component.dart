//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:video_player/video_player.dart';
//
// import 'package:zporter_board/core/common/components/button/custom_button.dart';
// import 'package:zporter_board/core/common/components/video/custom_video_controller.dart';
// import 'package:zporter_board/core/common/components/video/custom_video_player.dart';
//
// import 'package:zporter_board/core/resource_manager/color_manager.dart';
// import 'package:zporter_board/core/resource_manager/values_manager.dart';
//
// import 'package:zporter_board/features/tactic/presentation/view/common/tactic_pagination_component.dart';
//
// import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_bloc.dart';
// import 'package:zporter_board/features/tactic/presentation/view_model/animation/animation_event.dart';
//
//
//
//
// class AnalyticsBoardComponent extends StatefulWidget {
//   const AnalyticsBoardComponent({super.key});
//
//   @override
//   State<AnalyticsBoardComponent> createState() => _AnalyticsBoardComponentState();
// }
//
// class _AnalyticsBoardComponentState extends State<AnalyticsBoardComponent> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
//
//   VideoPlayerController? playerController;
//
//
//   @override
//   void dispose() {
//     super.dispose();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return Container(
//       padding: EdgeInsets.symmetric(vertical: 50),
//       child: SingleChildScrollView(
//         child: Column(
//           spacing: 30,
//           children: [
//
//             _buildVideoClipper(),
//             _buildFieldToolbar(),
//
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildVideoClipper(){
//     return CustomVideoPlayer(videoUrl: "https://pic.pikbest.com/19/87/90/26n888piCiYk.mp4", onVideoInitialized: (controller){
//
//       WidgetsBinding.instance.addPostFrameCallback((t){
//         setState(() {
//           playerController = controller;
//         });
//       });
//
//
//     },);
//   }
//
//   Widget _buildFieldToolbar(){
//     return Container(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Flexible(
//             flex:1,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(onPressed: (){}, icon: Icon(Icons.fullscreen_rounded, color: ColorManager.white,)),
//                 IconButton(onPressed: (){
//
//                 }, icon: Icon(Icons.rotate_left, color: ColorManager.white,)),
//                 IconButton(onPressed: (){
//
//                 }, icon: Icon(Icons.threed_rotation, color: ColorManager.white,)),
//                 IconButton(onPressed: (){}, icon: Icon(Icons.share, color: ColorManager.white,)),
//
//               ],
//             ),
//           ),
//
//           SizedBox(
//             width: AppSize.s32,
//           ),
//
//
//
//           Flexible(
//             flex: 1,
//             child: playerController==null?Center(child: CircularProgressIndicator(),): CustomVideoController(controller: playerController!)
//
//           ),
//
//
//
//           Flexible(
//             flex: 1,
//             child: CustomButton(
//
//               fillColor: ColorManager.blue,
//
//               onTap: (){
//
//               },
//               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//               borderRadius: 3,
//               child: Text("Save new clip", style: Theme.of(context).textTheme.labelLarge!.copyWith(
//                   color: ColorManager.white,
//                   fontWeight: FontWeight.bold
//               ),),
//             ),
//           ),
//
//         ],
//       ),
//     );
//   }
//
//   @override
//   // TODO: implement wantKeepAlive
//   bool get wantKeepAlive => true;
//
// }
//
