// import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';
// import 'package:zporter_board/core/common/components/slidable/custom_slidable.dart';
// import 'package:zporter_board/core/resource_manager/color_manager.dart';
//
// class HighlightToolbarComponent extends StatefulWidget {
//   const HighlightToolbarComponent({super.key});
//
//   @override
//   State<HighlightToolbarComponent> createState() => _HighlightToolbarComponentState();
// }
//
// class _HighlightToolbarComponentState extends State<HighlightToolbarComponent> {
//   List<String> titles = [
//     "Away-Corner 1",
//     "Away-Corner 2",
//     "Away-Corner 3",
//     "Away-Corner 4",
//     "Away-Corner 5",
//     "Away-Corner 6",
//     "Away-Corner 7",
//     "Away-Corner 8",
//
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: titles.length,
//         itemBuilder: (context, index){
//
//         return SlidableOptionsWidget(
//           content: Container(
//             margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
//             decoration: BoxDecoration(
//               border: Border.all(color: ColorManager.grey),
//               borderRadius: BorderRadius.circular(2)
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Column(
//                   children: [
//                     Text("02:00", style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                       color: ColorManager.white
//                     ),),
//                     Text("02:20", style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                         color: ColorManager.white
//                     ),),
//                   ],
//                 ),
//
//                 Text("${titles[index]}", style: Theme.of(context).textTheme.labelMedium!.copyWith(
//                     color: ColorManager.white
//                 ),),
//
//                 IconButton(onPressed: (){}, icon: Icon(Icons.play_circle_outline, color: ColorManager.white,))
//
//
//
//               ],
//             ),
//           ),
//           onEdit: () {  },
//           onDelete: () {
//             setState(() {
//               titles.removeAt(index);
//             });
//           },
//
//
//         );
//
//     });
//   }
// }
