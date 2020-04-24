import 'dart:async';

import 'package:glaksoalcovid/components/App.dart';

// # encarado de manejar que se renderiza
class TranscriptionProvider {
  int _lastId;
  bool _cagando;
  StreamController<List<Map<String, dynamic>>> _elementsStream;
  // test
  List<Map<String,dynamic>> _elements;

  // static final TranscriptionProvider _instance = new TranscriptionProvider._();

  // factory TranscriptionProvider() => _instance;
   TranscriptionProvider() {
    _elements = new List();
     this._cagando = false;
   }
  // TranscriptionProvider._();

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
      print("CALL: cargando ...");
      return false;
    } else {
      print("CALL: work ..");
      _cagando = true;
      List<Map<String, dynamic>> resultados =
          await StorageProvider().getMetaPersonas(_lastId);
      if (resultados.isNotEmpty) {
        _lastId = resultados.last["rowid"] ?? null;
        print("LASTUID;: $_lastId");
        //test
        _elements.addAll(resultados);
        addElements(_elements);
        _cagando = false;
        return true;
      }
    }
  }
}
