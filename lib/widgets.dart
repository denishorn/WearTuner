import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyRing extends StatelessWidget {
  final double percent;
  final Color color;
  final double radius;
  final double width;
  final bool showBackground;

  MyRing({
    required this.percent,
    required this.color,
    required this.radius,
    required this.width,
    required this.showBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
   Ring(
            percent: percent,
            color: RingColorScheme(
              ringColor: color,
              gradient: false,
            ),
            radius: radius,
            width: width,
            curve: Curves.easeInOutCubic,
            showBackground: showBackground,
          ),
        
Transform(
  alignment: Alignment.center,
  transform: Matrix4.rotationY(math.pi),

          child: Ring(
            percent: percent,
            color: RingColorScheme(
              ringColor: color,
              gradient: false,
            ),
            radius: radius,
            width: width,
            curve: Curves.easeInOutCubic,
            showBackground: showBackground,
          ),
        
)


      ],

    );
  }
}