import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zporter_board/core/resource_manager/color_manager.dart';

class ImagePicker extends StatefulWidget {
  final String label;
  final ValueChanged<String> onChanged;

  const ImagePicker({
    Key? key,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  _ImagePickerState createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  late TextEditingController _controller;
  String _currentValue = "-";

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _currentValue.toString());
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _controller,


        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
            color: ColorManager.white
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          suffix: picker(),
          label: Text(
            widget.label,
            style:  Theme.of(context).textTheme.labelLarge!.copyWith(
                color: ColorManager.grey,
                fontWeight: FontWeight.bold
            ),
          ),

          //contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          hintText: 'Enter a number',
        ),
        onChanged: (value) {

          setState(() {
            _currentValue = value;
          });
          widget.onChanged(value);
                },
      ),
    );
  }

  Widget picker(){
    return GestureDetector(
      onTap: (){},
      child: const Icon(Icons.camera_alt_outlined, color: ColorManager.grey,),

    );
  }
}
