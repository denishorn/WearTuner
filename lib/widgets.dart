import 'package:flutter/material.dart';
import 'tuner.dart'; 
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:flutter/foundation.dart';



class ControlsAndTunerWidget extends StatelessWidget {
  final VoidCallback onStartPressed;
  final VoidCallback onStopPressed;
  //final BoxConstraints constraints;

  const ControlsAndTunerWidget({
    Key? key,
    required this.onStartPressed,
    required this.onStopPressed,
    //required this.constraints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Container(
    //constraints: BoxConstraints(maxWidth: constraints.maxWidth),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // const SizedBox(width: 16),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: onStartPressed,
            child: const Text("Start"),
          ),
        ),
        // const SizedBox(width: 16),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: onStopPressed,
            child: const Text("Stop"),
          ),
        ),
        // const SizedBox(width: 16),
      ],
    ),
  );
  }

}

class TextDisplayWidget extends StatelessWidget {
  final String note;
  final String status;

  const TextDisplayWidget({
    Key? key,
    required this.note,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(note),
        Text(status),
      ],
    
    );
  }
}

//___________

class AutoTuneSwitchWidget extends StatefulWidget {
  final bool isAutoTune;
  final ValueChanged<bool> onChanged;

  const AutoTuneSwitchWidget({
    Key? key,
    required this.isAutoTune,
    required this.onChanged,
  }) : super(key: key);

  @override
  _AutoTuneSwitchWidgetState createState() => _AutoTuneSwitchWidgetState();
}

class _AutoTuneSwitchWidgetState extends State<AutoTuneSwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        'Auto Select Note',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        'The app will automatically select the note for you',
        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.85)),
      ),
      value: widget.isAutoTune,
      isThreeLine: true,
      onChanged: widget.onChanged,
    );
  }
}
//------------
class PlayNoteButton extends StatefulWidget {
  final VoidCallback onStartPressed;
  final VoidCallback onStopPressed;
  final Note noteToPlay;
  final bool isAutoTune;

  const PlayNoteButton({
    Key? key,
    required this.noteToPlay,
    required this.isAutoTune,
    required this.onStartPressed,
    required this.onStopPressed,
  }) : super(key: key);

  @override
  _PlayNoteButtonState createState() => _PlayNoteButtonState();
}

class _PlayNoteButtonState extends State<PlayNoteButton> {
  final _flutterMidi = FlutterMidi();

  int noteNameToMidiNumber(String noteName) {
    // Map of note names to their semitone offsets from C
    const Map<String, int> noteOffsets = {
      'C': 0, 'Db': 1, 'D': 2, 'Eb': 3, 'E': 4, 'F': 5,
      'Gb': 6, 'G': 7, 'Ab': 8, 'A': 9, 'Bb': 10, 'B': 11,
    };

    // Extract the note letter (and accidental if present) and octave
    RegExp regExp = RegExp(r"([A-G][b]?)(\d)");
    var matches = regExp.firstMatch(noteName);
    if (matches != null && matches.groupCount == 2) {
      String note = matches.group(1)!; // Note letter and accidental
      int octave = int.parse(matches.group(2)!); // Octave

      // Calculate the MIDI note number
      int midiNumber = (octave + 1) * 12 + noteOffsets[note]!;
      return midiNumber;
    } else {
      throw FormatException("Invalid note format", noteName);
    }
  }
  @override
  void initState() {
    _flutterMidi.prepare(sf2: null);
    super.initState();
    load();
  }

  void load() async {
  print('Loading Soundfont...');    
    _flutterMidi.unmute();
    ByteData _byte = await rootBundle.load('assets/Guitar.SF2');
    //assets/sf2/SmallTimGM6mb.sf2
    //assets/sf2/Piano.SF2
    await _flutterMidi.prepare(sf2: _byte, name: 'Guitar.SF2');
      print('Soundfont Loaded');

  }
void _play(int midi) async {
  
  print('Playing MIDI note...');
  widget.onStopPressed();
  _flutterMidi.playMidiNote(midi: midi);

  // Wait for 1 second
  await Future.delayed(Duration(milliseconds: 700));

  // Stop the note
  _flutterMidi.stopMidiNote(midi: midi);
  widget.onStartPressed();
  print('Stopped MIDI note.');
}

  //String _value = 'assets/Guitar.SF2';


  @override
  Widget build(BuildContext context) {
    return /* Padding(
        padding: EdgeInsets.all(16.0),
        child: */FilledButton.icon(
          style: ButtonStyle ( shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32),),),),
          onPressed: () {
            if(widget.isAutoTune){ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Turn auto select mode off first!'),
            duration: Duration(milliseconds: 3000),
            dismissDirection: DismissDirection.horizontal,
            // behavior: SnackBarBehavior.floating,
            // showCloseIcon: true,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(6.0),),
            
          ),
        );} else {
          int midiNote = noteNameToMidiNumber(widget.noteToPlay.name);
          _play(midiNote);
          }
            
          },
          label: const Text("Play Note"),
          icon: Icon(Icons.play_arrow),

      //),
    );
  }
  
}

//------------ 

class TuningWheelContainerWidget extends StatefulWidget {
  final bool isAutoTune;
  final ValueChanged<Note> onChangedNote;
  final ValueChanged<bool> onChanged;
  final Guitar guitar;

  const TuningWheelContainerWidget({
    Key? key,
    required this.isAutoTune,
    required this.onChangedNote,
    required this.onChanged,
    required this.guitar,
  }) : super(key: key);

  @override
  _TuningWheelContainerWidgetState createState() => _TuningWheelContainerWidgetState();
}

class _TuningWheelContainerWidgetState extends State<TuningWheelContainerWidget> {
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  bool _isAnimating = false;
@override
  void initState() {
    super.initState();
WidgetsBinding.instance.addPostFrameCallback((_) {
    setState(() {
      final initialNote = widget.guitar.tuning[0];
      widget.onChangedNote(initialNote);
    });
  }); 
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    return Container( 
      height: 150,
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            opacity: widget.isAutoTune ? 0.0 : 0.33,
            duration: Duration(milliseconds: 150),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          GestureDetector(
  onTapDown: (details) {
    // You can perform actions here when the tap down event occurs.
  },
  onTapCancel: () {
    // This block is executed when the tap is cancelled.
    setState(() {
      if (widget.isAutoTune) {
        widget.onChanged(false);
      }
    });
  },
  onTapUp: (details) {
    // This block is executed when the tap is released.
    if (!_isAnimating) {
      int nextIndex = widget.isAutoTune ? _controller.selectedItem : _controller.selectedItem + 1;
      setState(() {
        _isAnimating = true;
        if (widget.isAutoTune) {
          widget.onChanged(false);
        }
      });
      _controller.animateToItem(
        (nextIndex >= widget.guitar.tuning.length) ? 0 : nextIndex,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      ).then((_) {
        setState(() {
          _isAnimating = false;
        });
      });
    }
  },
  child: ListWheelScrollView.useDelegate(
    controller: _controller,
    itemExtent: 50,
    overAndUnderCenterOpacity: 0.5,
    physics: (_isAnimating || widget.isAutoTune) ? NeverScrollableScrollPhysics() : FixedExtentScrollPhysics(),
    diameterRatio: 3,
    childDelegate: ListWheelChildBuilderDelegate(
      builder: (BuildContext context, int index) {
        int loopedIndex = index % widget.guitar.tuning.length;
        if (loopedIndex < 0) {
          loopedIndex += widget.guitar.tuning.length;
        }
        return Center(
          child: Text(
            widget.guitar.tuning[loopedIndex].toString(),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        );
      },
      childCount: widget.guitar.tuning.length, 
    ),
    onSelectedItemChanged: (index) {
      setState(() {
        int ind = index % widget.guitar.tuning.length;
        widget.onChangedNote(widget.guitar.tuning[index]);
      });
    },
  ),
),
        ],
      ),
    );
  }
}
