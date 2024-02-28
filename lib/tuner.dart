import 'dart:async';
import 'dart:math';
//import 'dart:typed_data';
import 'package:flutter/material.dart';
//import 'package:flutter_audio_capture/flutter_audio_capture.dart';
//import 'package:pitch_detector_dart/pitch_detector.dart';
//import 'package:provider/provider.dart';
//import 'package:time_text/time_text.dart';
//import 'package:wear/wear.dart';
//import 'package:pitchupdart/instrument_type.dart';
//import 'package:pitchupdart/pitch_handler.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:vibration/vibration.dart';
//import 'widgets.dart';
//import 'main.dart';
//import 'package:flutter/cupertino.dart';


class Instrument {
  final List<Note> tuning;

  const Instrument(this.tuning);

  Note findClosestNote(double frequency) {
    Note closestNote = tuning.first;
    double minDiff = double.infinity;

    for (Note note in tuning) {
      double diff = (frequency - note.frequency).abs();
      if (diff < minDiff) {
        minDiff = diff;
        closestNote = note;
      }
    }

    return closestNote;
  }
}

class Guitar extends Instrument {
  const Guitar() : super(const [Note.E2, Note.A2, Note.D3, Note.G3, Note.B3, Note.E4]);
}

class Ukulele extends Instrument {
  const Ukulele() : super(const [Note.A3, Note.E4, Note.C4, Note.G4]);
}

class BassGuitar extends Instrument {
  const BassGuitar() : super(const [Note.E1, Note.A1, Note.D2, Note.G2]);
}

enum Note {
  C1(32.70),
  D1(36.71),
  E1(41.20),
  F1(43.65),
  G1(49.00),
  A1(55.00),
  B1(61.74),
  C2(65.41),
  D2(73.42),
  E2(82.41),
  F2(87.31),
  G2(98.00),
  A2(110.00),
  B2(123.47),
  C3(130.81),
  D3(146.83),
  E3(164.81),
  F3(174.61),
  G3(196.00),
  A3(220.00),
  B3(246.94),
  C4(261.63),
  D4(293.66),
  E4(329.63),
  F4(349.23),
  G4(392.00),
  A4(440.00),
  B4(493.88),
  C5(523.25);

  final double frequency;

  const Note(this.frequency);
}


