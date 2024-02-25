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
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

import 'widgets.dart'; 
import 'main.dart'; 
// ! need to find optimal values
const double _sampleRate = 22050;
const int _bufferSize = 1000;
Timer? _frequencyMatchTimer;


class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterAudioCapture _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(_sampleRate, _bufferSize);
  final pitchUp = PitchHandler(InstrumentType.guitar);
  var turns = 0.0;
  Map<String, String> pitch = {
    'note': '',
    'status': '',
    'frequency': '',
    'expectedFrequency': ''
  };
  var status = "Click on start";

  @override
  void initState() {
    super.initState();
      requestMicrophonePermission().then((_) {
    _startCapture();
  });
  }

  Future<void> requestMicrophonePermission() async {
   var status = await Permission.microphone.status;
    if(status.isDenied){
     await Permission.microphone.request();
   } 
   if(status.isPermanentlyDenied){
     openAppSettings();
   } 
}

  Future<void> _startCapture() async {
    var status = await Permission.microphone.status;
  //if (status.isGranted) {
  
    await _audioRecorder.start(
      listener,
      onError,
      sampleRate: _sampleRate.toInt(),
      bufferSize: _bufferSize,
      androidAudioSource: ANDROID_AUDIOSRC_MIC,
      waitForFirstDataOnAndroid: false,
      firstDataTimeout: Duration(milliseconds: 0),
    );
    //}
    setState(() {
      pitch['note'] = "";
      pitch['status'] = "Play something";
    });
  }

  void listener(dynamic obj) {
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();
    final result = pitchDetectorDart.getPitch(audioSample);
    if (result.pitched) {
      final handledPitchResult = pitchUp.handlePitch(result.pitch);
      setState(() {
        pitch['frequency'] = result.pitch.toString();
        pitch['expectedFrequency'] = 330.toString();
        turns = pow(-1, 330 - result.pitch > 0.0 ? 1 : 0) * min(0.35, (330 - result.pitch).abs() / 43);
      });
      if ((result.pitch - 330).abs() < 2) {     
  Vibration.vibrate(duration: 1);
    }
    }
  }

  void onError(Object e) {
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    final ringRadius = 0.47 * MediaQuery.of(context).size.width;
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          // child: WatchShape(
          //   builder: (BuildContext context, WearShape shape, Widget? child) {
          //     return Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: <Widget>[
          //         Text('Shape: ${shape == WearShape.round ? 'round' : 'square'}'),
          //         child!,
          //       ],
          //     );
          //   },
             child: buildContent(context, ringRadius),
          // ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context, double ringRadius) {
    return Stack(
      children: [
        buildRings(ringRadius, turns, context),
        buildTopText(context, ringRadius),
        buildCenterText(pitch['frequency'] ?? ''),
        buildBottomText(ringRadius, pitch['expectedFrequency'] ?? ''),
      ],
    );
  }
}