import 'package:flutter/material.dart';

import '../constants.dart';

class BottomNavBarPainter extends CustomPainter {

  @override
  void paint(Canvas canvas, Size size) {

    Path path = Path();
    path.moveTo(size.width*0.5000000,size.height*0.3877546);
    path.cubicTo(size.width*0.5517762,size.height*0.3877546,size.width*0.5937500,size.height*0.2164352,size.width*0.5937500,size.height*0.005101786);
    path.cubicTo(size.width*0.5937500,size.height*0.004890490,size.width*0.5937500,size.height*0.004679240,size.width*0.5937500,size.height*0.004468020);
    path.cubicTo(size.width*0.7339512,size.height*0.03967648,size.width*0.8997300,size.height*0.1094281,size.width,size.height*0.2346939);
    path.lineTo(size.width,size.height*0.9949337);
    path.lineTo(0,size.height*0.9949337);
    path.lineTo(0,size.height*0.2346939);
    path.cubicTo(size.width*0.1002698,size.height*0.1094281,size.width*0.2660488,size.height*0.03967648,size.width*0.4062500,size.height*0.004468026);
    path.lineTo(size.width*0.4062500,size.height*0.005101786);
    path.cubicTo(size.width*0.4062500,size.height*0.2164352,size.width*0.4482238,size.height*0.3877546,size.width*0.5000000,size.height*0.3877546);
    path.close();


    Paint paintFill = Paint()..style=PaintingStyle.fill;

    paintFill.color = kPrimaryColor.withOpacity(1.0);
    canvas.drawPath(path,paintFill);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}