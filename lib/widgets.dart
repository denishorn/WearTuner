import 'package:flutter/material.dart';
import 'tuner.dart'; 
import 'package:sound_generator/sound_generator.dart';
import 'package:sound_generator/waveTypes.dart';


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
  
   final double frequency;

  const PlayNoteButton({
    Key? key,
    // required this.onStartPressed,
    // required this.onStopPressed,
    required this.frequency,
  }) : super(key: key);

  @override
  _PlayNoteButtonState createState() => _PlayNoteButtonState();
}

class _PlayNoteButtonState extends State<PlayNoteButton> {
  @override
  void initState() {
    super.initState();
    // Initialize your sound generator here.
    SoundGenerator.init(44100);
    SoundGenerator.setWaveType(waveTypes.SINUSOIDAL);
    // Add any other initialization code here.
  }

  @override
  Widget build(BuildContext context) {
    return /*Container(
      child:*/ Padding(
        padding: EdgeInsets.all(16.0),
        child: FloatingActionButton(
          onPressed: () {
              SoundGenerator.stop();
              SoundGenerator.setFrequency(widget.frequency);
              SoundGenerator.setVolume(0.5);
              SoundGenerator.play();
          },
          child: const Text("Start"),
        ),
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
        nextIndex,
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
      childCount: null, // Infinite scroll
    ),
    onSelectedItemChanged: (index) {
      setState(() {
        int ind = index % widget.guitar.tuning.length;
        widget.onChangedNote(widget.guitar.tuning[ind]);
      });
    },
  ),
),
        ],
      ),
    );
  }
}
