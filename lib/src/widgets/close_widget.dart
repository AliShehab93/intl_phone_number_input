import 'package:flutter/material.dart';

class CloseWithStroke1 extends CustomPainter {
  final double? value;
  final Color? color;
  CloseWithStroke1({this.value, this.color});
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color!
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;

    //! drawing the lines in canvas
    canvas.drawLine(_firstLineStart(), _firstLineEnd(), paint);
    //! third line
    canvas.drawLine(_thirdLineStart(), _thirdLineEnd(), paint);
  }

  //! First line
  _firstLineStart() => Offset(0, 0);
  _firstLineEnd() => Offset(this.value!, this.value!);

  //! second line
  _thirdLineStart() => Offset(0, this.value!);
  _thirdLineEnd() => Offset(this.value!, 0);

  @override
  bool shouldRepaint(CloseWithStroke1 oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CloseWithStroke1 oldDelegate) => false;
}
