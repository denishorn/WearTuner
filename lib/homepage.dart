import 'dart:async';
//import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
//import 'package:activity_ring/activity_ring.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
//import 'package:provider/provider.dart';
//import 'package:time_text/time_text.dart';
//import 'package:wear/wear.dart';
//import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';
////import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

import 'widgets.dart'; 
import 'tuner.dart'; 
//import 'main.dart'; 
// ! need to find optimal values
//const double _sampleRate = 22050;
//const int _bufferSize = 1000;
//Timer? _frequencyMatchTimer;


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  //final pitchupDart = PitchHandler(InstrumentType.guitar);
  final Guitar guitar = const Guitar();
  var note = "";
  var status = "Click on start";

  Future<void> _startCapture() async {
    await _audioRecorder.start(listener, onError,
        sampleRate: 44100, bufferSize: 3000);
    setState(() {
      note = "";
      status = "Play something";
    });
  }

  Future<void> _stopCapture() async {
    await _audioRecorder.stop();
    setState(() {
      note = "";
      status = "Click on start";
    });
  }

  void listener(dynamic obj) {
    //Gets the audio sample
    var buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();

    //Uses pitch_detector_dart library to detect a pitch from the audio sample
    final result = pitchDetectorDart.getPitch(audioSample);

    //If there is a pitch - evaluate it
    if (result.pitched) {
      //Uses the pitchupDart library to check a given pitch for a Guitar
      //final handledPitchResult = pitchupDart.handlePitch(result.pitch);
//
      ////Updates the state with the result
      //setState(() {
      //  note = result.pitch.toString();
      //  //note = handledPitchResult.note;
      //  status = handledPitchResult.tuningStatus.toString();
      //  //turns = pow(-1, 330 - result.pitch > 0.0 ? 1 : 0) * min(0.35, (330 - result.pitch).abs() / 43);
//
      //});
      final frequency = result.pitch;

  // Assuming 'guitar' is an instance of the Guitar class
  Note closestNote = guitar.findClosestNote(frequency);

  // Updates the state with the result
  setState(() {
    note = result.pitch.toStringAsFixed(1); // Now 'note' will hold the string representation of the closest note
    status = "Closest note: ${closestNote.toString()} , ${closestNote.frequency.toString()}"; // Updates status to show the closest note

    // The following line is commented out as it seems to be part of the original logic for tuning status or visual feedback
    // turns = pow(-1, 330 - frequency > 0.0 ? 1 : 0) * min(0.35, (330 - frequency).abs() / 43);
  });
    }
  }

  void onError(Object e) {
    print(e);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SafeArea(
      //child: Center(
        child: Flex(
          direction: Axis.vertical,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              //height: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              height: 300, // This makes the container take up 1/4 of the screen height
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.33), // Use the theme's secondary color
                borderRadius: BorderRadius.circular(15), // Adjust the radius to get the desired curvature
              ),
              child: Center(child: TextDisplayWidget(note: note, status: status),),
            ),
            //Spacer(),
            ControlsAndTunerWidget(
              onStartPressed: _startCapture,
              onStopPressed: _stopCapture,
              constraints: BoxConstraints(
              maxWidth: 500, // Example constraint
    //minWidth: 100,
    //maxHeight: MediaQuery.of(context).size.height - MediaQuery.of(context).size.width, // Example constraint
              ),
            ),
            //Spacer(flex: 10),
            TunerWidget(
              constraints: BoxConstraints(
              maxWidth: 500, // Example constraint
            ),
            ),
        ]),
      //),
      ),
    );
  }
}