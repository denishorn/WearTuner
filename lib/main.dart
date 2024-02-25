import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:activity_ring/activity_ring.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:provider/provider.dart';
import 'package:time_text/time_text.dart';
import 'package:wear/wear.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

import 'widgets.dart';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Color.fromARGB(255, 33, 189, 2),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// class MyAppState extends ChangeNotifier {}

// class MyHomePage extends StatefulWidget {
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   FlutterAudioCapture _audioRecorder = FlutterAudioCapture();
//   final pitchDetectorDart = PitchDetector(_sampleRate, _bufferSize);
//   final pitchUp = PitchHandler(InstrumentType.guitar);
//   var turns = 0.0;
//   Map<String, String> pitch = {
//     'note': '',
//     'status': '',
//     'frequency': '',
//     'expectedFrequency': ''
//   };
//   var status = "Click on start";

//   @override
//   void initState() {
//     super.initState();
//     _startCapture();
//   }

//   Future<void> _startCapture() async {
//     await _audioRecorder.start(
//       listener,
//       onError,
//       sampleRate: _sampleRate.toInt(),
//       bufferSize: _bufferSize,
//       androidAudioSource: ANDROID_AUDIOSRC_MIC,
//       waitForFirstDataOnAndroid: false,
//       firstDataTimeout: Duration(seconds: 0),
//     );
//     setState(() {
//       pitch['note'] = "";
//       pitch['status'] = "Play something";
//     });
//   }

//   void listener(dynamic obj) {
//     var buffer = Float64List.fromList(obj.cast<double>());
//     final List<double> audioSample = buffer.toList();
//     final result = pitchDetectorDart.getPitch(audioSample);
//     if (result.pitched) {
//       final handledPitchResult = pitchUp.handlePitch(result.pitch);
//       setState(() {
//         pitch['frequency'] = result.pitch.toString();
//         pitch['expectedFrequency'] = 330.toString();
//         turns = pow(-1, 330 - result.pitch > 0.0 ? 1 : 0) * min(0.35, (330 - result.pitch).abs() / 43);
//       });
//     }
//   }

//   void onError(Object e) {
//     print(e);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ringRadius = 0.47 * MediaQuery.of(context).size.width;
//     return MaterialApp(
//       home: Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           // child: WatchShape(
//           //   builder: (BuildContext context, WearShape shape, Widget? child) {
//           //     return Column(
//           //       mainAxisAlignment: MainAxisAlignment.center,
//           //       children: <Widget>[
//           //         Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
//           //         child!,
//           //       ],
//           //     );
//           //   },
//              child: buildContent(context, ringRadius),
//           // ),
//         ),
//       ),
//     );
//   }

//   Widget buildContent(BuildContext context, double ringRadius) {
//     return Stack(
//       children: [
//         buildRings(ringRadius, turns, context),
//         buildTopText(context, ringRadius),
//         buildCenterText(pitch['frequency'] ?? ''),
//         buildBottomText(ringRadius, pitch['expectedFrequency'] ?? ''),
//       ],
//     );
//   }
// }
