import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:activity_ring/activity_ring.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:provider/provider.dart';
import 'package:pitchupdart/instrument_type.dart';
import 'package:pitchupdart/pitch_handler.dart';

const double _sampleRate = 44100;
const int _bufferSize = 1500;

class Recorder {
  final FlutterAudioCapture _audioRecorder = FlutterAudioCapture();
  final pitchDetectorDart = PitchDetector(_sampleRate, _bufferSize);
  final PitchHandler pitchUp = PitchHandler(InstrumentType.guitar);
  final Map<String, String> pitch = {'note':'', 'status':'', 'frequency':'', 'expectedFrequency':''};
  double turns = 0.0;
  String status = "Click on start";
  StreamSubscription<dynamic>? _captureSubscription;

  Future<void> startCapture() async {
    await _audioRecorder.start(
      _listener,
      _onError,
      sampleRate: _sampleRate.toInt(),
      bufferSize: _bufferSize,
      androidAudioSource: ANDROID_AUDIOSRC_MIC,
      waitForFirstDataOnAndroid: false,
      firstDataTimeout: Duration(seconds: 0),
    );

    status = "Play something";
  }

  void _listener(dynamic obj) {
    final buffer = Float64List.fromList(obj.cast<double>());
    final List<double> audioSample = buffer.toList();
    final result = pitchDetectorDart.getPitch(audioSample);

    if (result.pitched) {
      final handledPitchResult = pitchUp.handlePitch(result.pitch);

      pitch['frequency'] = result.pitch.toString();
      pitch['expectedFrequency'] = 330.toString();
      turns = pow(-1, 330 - result.pitch > 0.0 ? 1 : 0) * min(0.35, (330 - result.pitch).abs() / 43);
    }
  }

  void _onError(Object e) {
    print(e);
  }

  void stopCapture() {
    _audioRecorder.stop();
  }
}
