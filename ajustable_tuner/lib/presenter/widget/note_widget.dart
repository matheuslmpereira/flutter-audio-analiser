import 'package:adjustable_tuner/model/note_display.dart';
import 'package:flutter/material.dart';

import '../../core/colors.dart';

class NoteWidget extends StatelessWidget {
  final NoteDisplay noteDisplay;

  const NoteWidget({Key? key, required this.noteDisplay}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: noteDisplay.noteSymbol.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            noteDisplay.noteSymbol.noteSymbol,
            style: TextStyle(
              fontSize: 80,
              color: primarySwatch,
            ),
          ),
          Positioned(
            bottom: 15,
            right: 10,
            child: Text(
              noteDisplay.harmonic.toString(),
              style: TextStyle(
                fontSize: 40,
                color: primarySwatch,
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 10,
            child: Text(
              noteDisplay.originalNote.toStringAsFixed(2),
              style: TextStyle(
                fontSize: 15,
                color: primarySwatch,
              ),
            ),
          ),
          if (noteDisplay.noteSymbol.sharp)
            Positioned(
              top: 15,
              right: 10,
              child: Text(
                "#",
                style: TextStyle(
                  fontSize: 40,
                  color: primarySwatch,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
