import 'package:flutter/cupertino.dart';

abstract class FieldDraggableItem{
  String id;
  Offset? offset;
  // Abstract copyWith method
  FieldDraggableItem copyWith({
    String? id,
    Offset? offset,
  });
  FieldDraggableItem({this.offset, required this.id});

}