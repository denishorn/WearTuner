import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitchupdart/pitch_handler.dart';
//import 'package:vibration/vibration.dart';

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
  late Note currentSelectorNote;
  String targetNote = "";
  String note = "";
  String status = "Click on start";

  @override
  void initState() {
    super.initState();
    currentSelectorNote = guitar.tuning[0];
  }

  

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

  //Note closestNote = guitar.findClosestNote(frequency);
  if(!isAutoTune){
    targetNote = currentSelectorNote.name;
  }else{
    targetNote = guitar.findClosestNote(frequency).name;
  }

  setState(() {
    note = result.pitch.toStringAsFixed(1); 
    status = "Closest note: ${isAutoTune.toString()}, ${targetNote}"; // Updates status to show the closest note
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
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.33),
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextDisplayWidget(note: note, status: status), // Assuming TextDisplayWidget is defined elsewhere
            ),
          ),
          Flex(
            direction: Axis.vertical,
            children: [
              Container(
                width : MediaQuery.of(context).size.width,
                height : 82,
                padding: EdgeInsets.all(16.0),
                child:PlayNoteButton(
                  noteToPlay: currentSelectorNote,
                  isAutoTune: isAutoTune,
                  onStartPressed: _startCapture, // Assuming _startCapture is defined elsewhere
                  onStopPressed: _stopCapture, // Assuming _stopCapture is defined elsewhere
              )),
              
              TuningWheelContainerWidget(
                isAutoTune: isAutoTune,
                onChangedNote: (Note changedNote) {
                  setState(() {
                    if (!isAutoTune){
                      currentSelectorNote = changedNote;
                    }
                  });
                },
                onChanged: (bool value) {
                  setState(() {
                    isAutoTune = value;
                  });
                },
                guitar: guitar, // Assuming guitar is defined and passed correctly
              ),
              AutoTuneSwitchWidget(
                isAutoTune: isAutoTune,
                onChanged: (bool value) {
                  setState(() {
                    isAutoTune = value;
                  });
                },
              ),
              ControlsAndTunerWidget(
                onStartPressed: _startCapture, // Assuming _startCapture is defined elsewhere
                onStopPressed: _stopCapture, // Assuming _stopCapture is defined elsewhere
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

}