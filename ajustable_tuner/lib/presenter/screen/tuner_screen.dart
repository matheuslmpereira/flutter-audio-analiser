import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../audio_processing/note_measure.dart';
import '../../bridges/audio_data_provider.dart';
import '../../bridges/native_method_caller.dart';
import '../../core/colors.dart';
import '../../model/audio_data.dart';
import '../../model/note_display.dart';
import '../../model/note_symbol.dart';
import '../widget/note_widget.dart';
import '../widget/ruler_widget.dart';
import '../widget/volume_bar_widget.dart';

class TunerScreenWidget extends StatefulWidget {
  const TunerScreenWidget({super.key});

  @override
  _TunerScreenWidgetState createState() => _TunerScreenWidgetState();
}

class _TunerScreenWidgetState extends State<TunerScreenWidget> {
  NoteDisplay currentNoteDisplay = NoteDisplay(NoteSymbol.c, NoteMeasure().getNoteFrequency(NoteSymbol.c, 2), 2, 0);
  double volume = 0;
  bool isRecording = false;
  bool hasPermission = false;
  late StreamSubscription<AudioData> _audioDataSubscription;

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
    _audioDataSubscription = AudioDataProvider().audioStream.listen((audioData) {
      setState(() {
        volume = audioData.intensity;
        if (audioData.frequency != -1) {
          currentNoteDisplay = NoteMeasure().closestNote(audioData.frequency);
        }
      });
    });
  }

  Future<void> _requestMicrophonePermission() async {
    PermissionStatus status = await Permission.microphone.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      PermissionStatus newStatus = await Permission.microphone.request();

      setState(() {
        hasPermission = newStatus.isGranted;
      });
    } else {
      setState(() {
        hasPermission = true;
      });
    }
  }

  _toggleRecorder() async {
    if (isRecording) {
      await NativeMethodCaller().pauseCounter();
    } else {
      await NativeMethodCaller().startCounter();
    }
    setState(() {
      isRecording = !isRecording;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Experience Tuner')),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NoteWidget(noteDisplay: currentNoteDisplay!),
                  VerticalRuler(factor: currentNoteDisplay!.factor),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: VolumeBarWidget(volume: volume),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleRecorder,
        backgroundColor: componentBackground,
        child: Icon(isRecording ? Icons.pause : Icons.play_arrow),
      ),
    );
  }

  @override
  void dispose() {
    _audioDataSubscription.cancel();
    super.dispose();
  }
}
