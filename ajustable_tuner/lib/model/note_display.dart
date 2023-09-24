import 'note_symbol.dart';

class NoteDisplay {
  final NoteSymbol noteSymbol;
  final double originalNote;
  final int harmonic;
  final double factor;

  NoteDisplay(this.noteSymbol, this.originalNote, this.harmonic, this.factor);
}
