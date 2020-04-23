import 'dart:async';

enum transcriptionprovider {
  isLoad,
  damemas
}
// # encarado de manejar que se renderiza
class TranscriptionProvider {
StreamController _msgStream;
  static final TranscriptionProvider _instance = new TranscriptionProvider._();

  factory TranscriptionProvider() => _instance;
  TranscriptionProvider._();

  TranscriptionProvider get createStreamMsg {
  _msgStream = new StreamController.broadcast(); return this;
  }

  Stream<transcriptionprovider> get streamMsg => _msgStream.stream;
    
  
}