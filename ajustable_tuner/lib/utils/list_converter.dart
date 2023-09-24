import 'dart:typed_data';

Int16List uInt8ListToInt16List(Uint8List data) {
  final byteData = ByteData.sublistView(data);
  final int16List = Int16List(data.length ~/ 2);

  for (int i = 0; i < data.length; i += 2) {
    int16List[i ~/ 2] = byteData.getInt16(i, Endian.little);
  }

  return int16List;
}
