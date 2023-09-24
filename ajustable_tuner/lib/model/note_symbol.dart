import 'package:flutter/material.dart';
import '../core/colors.dart';

enum NoteSymbol implements Comparable<NoteSymbol> {
  c(noteSymbol: "C", color: neonC, sharp: false),
  cSharp(noteSymbol: "C", color: neonCSharp, sharp: true),
  d(noteSymbol: "D", color: neonD, sharp: false),
  dSharp(noteSymbol: "D", color: neonDSharp, sharp: true),
  e(noteSymbol: "E", color: neonE, sharp: false),
  f(noteSymbol: "F", color: neonF, sharp: false),
  fSharp(noteSymbol: "F", color: neonFSharp, sharp: true),
  g(noteSymbol: "G", color: neonG, sharp: false),
  gSharp(noteSymbol: "G", color: neonGSharp, sharp: true),
  a(noteSymbol: "A", color: neonA, sharp: false),
  aSharp(noteSymbol: "A", color: neonASharp, sharp: true),
  b(noteSymbol: "B", color: neonB, sharp: false);

  final String noteSymbol;
  final Color color;
  final bool sharp;

  const NoteSymbol({
    required this.noteSymbol,
    required this.color,
    required this.sharp
  });

  @override
  int compareTo(NoteSymbol other) {
    return index.compareTo(other.index);
  }

  static NoteSymbol fromInteger(int index) {
    return NoteSymbol.values[index % 12];
  }
}
