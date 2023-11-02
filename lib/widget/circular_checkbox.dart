import 'package:flutter/material.dart';
import 'package:notescribe/utils/color.dart';

class ResizableCircularCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final double size;

  ResizableCircularCheckbox({required this.value, required this.onChanged, required this.size});

  @override
  _ResizableCircularCheckboxState createState() => _ResizableCircularCheckboxState();
}

class _ResizableCircularCheckboxState extends State<ResizableCircularCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: primaryColor,
            width: 2.0,
          ),
          color: widget.value ? primaryColor : null
        ),
        child: Center(
          child: widget.value
              ? Icon(
                  Icons.check,
                  size: widget.size * 0.7, 
                  color: Colors.white,
                )
              : null,
        ),
      ),
    );
  }
}