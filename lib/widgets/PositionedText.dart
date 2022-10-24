import 'package:flutter/material.dart';


class PositionedText extends StatelessWidget {
  const PositionedText({
    Key? key,
    required this.text,
    required this.left,
    required this.top,
    required this.fontSize,
    required this.color
  }) : super(key: key);


  final String text;
  final double top;
  final double left;
  final double fontSize;
  final Color color;



  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child:
      Center(child: Text(text, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700, color: color),)),
    );
  }
}