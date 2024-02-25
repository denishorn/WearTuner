import 'package:activity_ring/activity_ring.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:time_text/time_text.dart';

// TODO create own ring / rectangular widged and show one based on watch form
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


Widget buildRings(double ringRadius, double turns, BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.width,
    child: Stack(
      children: [
        Align(
          child: MyRing(
            percent: 35,
            color: Color.fromARGB(255, 65, 65, 65),
            radius: ringRadius,
            width: ringRadius * 0.09,
            showBackground: false,
          ),
        ),
        Align(
          child: MyRing(
            percent: 100 * 8 / 12 * 0.15,
            color: Color.fromARGB(255, 26, 156, 0),
            radius: ringRadius,
            width: ringRadius * 0.09,
            showBackground: false,
          ),
        ),
        Align(
          child: AnimatedRotation(
            duration: Duration(milliseconds: 300),
            turns: turns,
            child: Ring(
              percent: 0.1,
              curve: Curves.easeInOutCirc,
              color: RingColorScheme(
                ringColor: Color.fromARGB(255, 198, 198, 198),
                gradient: false,
              ),
              radius: ringRadius,
              width: ringRadius * 0.11,
              showBackground: false,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildTopText(BuildContext context, double ringRadius) {
  return Container(
    alignment: Alignment.topCenter,
    margin: EdgeInsets.only(top: ringRadius * 0.11),
    child: TimeText(
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  );
}

Widget buildCenterText(String frequency) {
  return Container(
    alignment: Alignment.center,
    child: Text(
      frequency,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget buildBottomText(double ringRadius, String expectedFrequency) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.only(top: ringRadius * 0.3),
    child: Text(
      expectedFrequency,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.0,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

