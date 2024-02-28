import 'dart:typed_data';

import 'package:flutter/material.dart';
//import 'package:flutter_audio_capture/flutter_audio_capture.dart';
//import 'package:pitch_detector_dart/pitch_detector.dart';
//import 'package:pitchupdart/instrument_type.dart';
//import 'package:pitchupdart/pitch_handler.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:flutter/foundation.dart';



import 'homepage.dart';
import 'theme/theme.dart';
void main() {
  // LicenseRegistry.addLicense(() async* {
  //   final license = await rootBundle.loadString('google_fonts/OFL.txt');
  //   yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  // });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic){
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: lightDynamic,
        useMaterial3: true,
        textTheme: GoogleFonts.publicSansTextTheme(),
        //textTheme: lightTypographyTheme,
        ),
        darkTheme:ThemeData(
          colorScheme: darkDynamic,
        brightness: Brightness.dark,
        useMaterial3: true,
        textTheme: GoogleFonts.publicSansTextTheme(ThemeData(brightness: Brightness.dark).textTheme),
        //textTheme: darkTypographyTheme,
        ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
    });
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final _audioRecorder = FlutterAudioCapture();
//   final pitchDetectorDart = PitchDetector(44100, 2000);
//   final pitchupDart = PitchHandler(InstrumentType.guitar);
//   var note = "";
//   var status = "Click on start";

//   Future<void> _startCapture() async {
//     await _audioRecorder.start(listener, onError,
//         sampleRate: 44100, bufferSize: 3000);
//     setState(() {
//       note = "";
//       status = "Play something";
//     });
//   }

//   Future<void> _stopCapture() async {
//     await _audioRecorder.stop();
//     setState(() {
//       note = "";
//       status = "Click on start";
//     });
//   }

//   void listener(dynamic obj) {
//     //Gets the audio sample
//     var buffer = Float64List.fromList(obj.cast<double>());
//     final List<double> audioSample = buffer.toList();

//     //Uses pitch_detector_dart library to detect a pitch from the audio sample
//     final result = pitchDetectorDart.getPitch(audioSample);

//     //If there is a pitch - evaluate it
//     if (result.pitched) {
//       //Uses the pitchupDart library to check a given pitch for a Guitar
//       final handledPitchResult = pitchupDart.handlePitch(result.pitch);

//       //Updates the state with the result
//       setState(() {
//         note = result.pitch.toString();
//         //note = handledPitchResult.note;
//         status = handledPitchResult.tuningStatus.toString();
//         //turns = pow(-1, 330 - result.pitch > 0.0 ? 1 : 0) * min(0.35, (330 - result.pitch).abs() / 43);

//       });
//     }
//   }

//   void onError(Object e) {
//     print(e);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       body: Center(
//         child: Column(children: [
//           Center(
//               child: Text(
//             note,
//             style: const TextStyle(
//                 color: Colors.green, fontSize: 25.0, fontWeight: FontWeight.bold),
//           )),
//           const Spacer(),
//           Center(
//               child: Text(
//             status,
//             style: const TextStyle(
//                 color: Colors.green, fontSize: 14.0, fontWeight: FontWeight.bold),
//           )),
//           Expanded(
//               child: Row(
//             children: [
//               Expanded(
//                   child: Center(
//                       child: FloatingActionButton(
//                           onPressed: _startCapture, child: const Text("Start")))),
//               Expanded(
//                   child: Center(
//                       child: FloatingActionButton(
//                           onPressed: _stopCapture, child: const Text("Stop")))),
//             ],
//           ))
//         ]),
//       ),
//     );
//   }
// }
