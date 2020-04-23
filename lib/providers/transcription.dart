import 'dart:async';

import 'package:glaksoalcovid/components/App.dart';

// # encarado de manejar que se renderiza
class TranscriptionProvider {
  int _lastId;
  bool _cagando;
  StreamController<List<Map<String, dynamic>>> _elementsStream;

  static final TranscriptionProvider _instance = new TranscriptionProvider._();

  factory TranscriptionProvider() => _instance;
  TranscriptionProvider._();

  TranscriptionProvider get createStreamElements {
    _elementsStream = new StreamController.broadcast();
    return this;
  }

  Stream<List<Map<String, dynamic>>> get stream => _elementsStream.stream;

  void addElements(List<Map<String, dynamic>> newElements) {
    return _elementsStream.sink.add(newElements);
  }

  Future<bool> getElements() async {
    if (_cagando) {
      return false;
    } else {
      _cagando = true;
      List<Map<String, dynamic>> resultados =
          await StorageProvider().getMetaPersonas(_lastId);
      if (resultados.isNotEmpty) {
        _lastId = resultados.last["person_id"] ?? null;
        addElements(resultados);
        _cagando = false;
        return true;
      }
    }
  }
}
