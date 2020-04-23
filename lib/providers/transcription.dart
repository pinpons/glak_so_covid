import 'dart:async';

import 'package:glaksoalcovid/components/App.dart';

// # encarado de manejar que se renderiza
class TranscriptionProvider {
StreamController<List<Map<String,dynamic>>> _elementsStream;
  
  static final TranscriptionProvider _instance = new TranscriptionProvider._();

  factory TranscriptionProvider() => _instance;
  TranscriptionProvider._();

  TranscriptionProvider get createStreamMsg {
  _elementsStream = new StreamController.broadcast(); return this;
  }

  Stream<List<Map<String,dynamic>>> get streamMsg => _elementsStream.stream;

  Function addElements(){
    return _elementsStream.sink.add;
  }

  Future<List<Map<String,dynamic>>> getElements(int a) async {

    var db = await new StorageProvider().getPersonas();

    
  }  
  
}