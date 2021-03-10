import 'package:flutter/material.dart';

class VerticalText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 10),
      child: RotatedBox(
          quarterTurns: -1,
          child: Text(
            'EKTA',
            style: TextStyle(
                color: Colors.white,
                fontSize: 70,
                letterSpacing: 5.0,
                fontWeight: FontWeight.w900,
                shadows: <Shadow>[
                  Shadow(
                    offset: Offset(4.0, 4.0),
                    blurRadius: 2.0,
                    color: Colors.white30, //lightBlueAccent
                  ),]
            ),
          )),
    );;
  }
}



