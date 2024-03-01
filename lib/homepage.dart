import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/pitch_handler.dart';
import 'package:vibration/vibration.dart';
//import 'package:wakelock_plus/wakelock_plus.dart';

import 'widgets.dart'; 
import 'tuner.dart'; 



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(44100, 2000);
  final Guitar guitar = const Guitar();
  bool isAutoTune = false;
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
    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      final frequency = result.pitch;

  Note closestNote = guitar.findClosestNote(frequency);

  setState(() {
    note = result.pitch.toStringAsFixed(1); // Now 'note' will hold the string representation of the closest note
    status = "Closest note: ${closestNote.toString()} , ${closestNote.frequency.toString()}"; // Updates status to show the closest note
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
        child: Flex(
          direction: Axis.vertical,
          children: [
            Padding(padding: EdgeInsets.all(8.0), child:Container(
              height: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.33), 
                borderRadius: BorderRadius.circular(15), 
              ),
              child: TextDisplayWidget(note: note, status: status),
            ),
            ),
            Flex(
              direction: Axis.vertical,
              children:[
            ControlsAndTunerWidget(
              onStartPressed: _startCapture,
              onStopPressed: _stopCapture,
            ),
            TunerWidget(
              isAutoTune: isAutoTune,
              onChanged: (bool value) {
                setState(() {
                  isAutoTune = value;
                });
              },
            ),
            ]),
        ]),
      ),
    );
  }
}