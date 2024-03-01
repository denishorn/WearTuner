import 'package:flutter/material.dart';
import 'tuner.dart'; // Make sure to import the TunerWidget correctly

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

class TuningWheel extends StatefulWidget {
  final Guitar guitar;
  final Function(int) onNoteSelected;

  const TuningWheel({Key? key, required this.guitar, required this.onNoteSelected}) : super(key: key);

  @override
  _TuningWheelState createState() => _TuningWheelState();
}


class _TuningWheelState extends State<TuningWheel> {
  final FixedExtentScrollController _controller = FixedExtentScrollController();
  //bool _isAnimating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //if (!_isAnimating) { // Checking if not already animating
          int nextIndex = _controller.selectedItem + 1;
          // if (nextIndex >= widget.guitar.tuning.length) {
          //   nextIndex = 0;
          // }

          // setState(() {
          //   _isAnimating = true; // Setting flag to true as animation starts
          // });

          _controller.animateToItem(
            nextIndex,
            duration: Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );},/*.then((_) {
            setState(() {
              _isAnimating = false; // Reset flag when animation completes
            });
          });
        }
      },*/
      child: ListWheelScrollView.useDelegate(
        controller: _controller,
        itemExtent: 50,
        overAndUnderCenterOpacity: 0.5,
        physics: /*_isAnimating ? NeverScrollableScrollPhysics() :*/ FixedExtentScrollPhysics(), 
        diameterRatio: 3,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (BuildContext context, int index) {
            //if (index < 0 || index >= widget.guitar.tuning.length) return null;
            int loopedIndex = index % widget.guitar.tuning.length;
            if (loopedIndex < 0) {
              loopedIndex += widget.guitar.tuning.length;
            }
            return Center(child:Text(widget.guitar.tuning[loopedIndex].toString()),
                //tileColor:Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.33),
            );
          },
          // childCount: widget.guitar.tuning.length,
          childCount: null
        ),
        onSelectedItemChanged: widget.onNoteSelected,
      ),
    );
  }
}


// class AutoTuneSwitch extends StatelessWidget {
//   final bool isAutoTune;
//   final ValueChanged<bool> onChanged;

//   const AutoTuneSwitch({Key? key, required this.isAutoTune, required this.onChanged}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SwitchListTile(
//       title: Text(
//         'Automatic mode',
//         style: Theme.of(context).textTheme.titleMedium,
//       ),
//       subtitle: Text(
//         'Switch to automatically detect your string',
//         style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
//       ),
//       value: isAutoTune,
//       isThreeLine: true,
//       onChanged: onChanged,
//     );
//   }
// }

class TunerWidget extends StatefulWidget {
  //final BoxConstraints constraints;
  final bool isAutoTune;
  final ValueChanged<bool> onChanged;

  TunerWidget({Key? key, required this.isAutoTune, required this.onChanged}) : super(key: key);

  @override
  _TunerWidgetState createState() => _TunerWidgetState();
}

class _TunerWidgetState extends State<TunerWidget> {
  final Guitar guitar = const Guitar();
  Note? selectedNote;
  //bool isAutoTune = true; // true for auto, false for manual

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      children: [
        // ControlsAndTunerWidget(
        //       onStartPressed: _startCapture,
        //       onStopPressed: _stopCapture,
        //     ),
        Container(
          height: 150,
          padding: EdgeInsets.all(16.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                //padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.33),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              TuningWheel(
                guitar: guitar,
                onNoteSelected: (index) {
                  // Handle note selection
                },
              ),
            ],
          ),
        ),
        SwitchListTile(
      title: Text(
        'Automatic mode',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        'Switch to automatically detect your string',
        style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
      value: widget.isAutoTune,
      isThreeLine: true,
      onChanged: widget.onChanged,
    ),
      ],
    );
  }
}
