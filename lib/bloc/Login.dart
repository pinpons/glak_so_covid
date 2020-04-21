import 'dart:async';

import 'package:glaksoalcovid/components/App.dart';

//TODO: Hacer que el mixin sea un verdadero mixin
class FormBloc with Validator {
  // StreamController<String> _emailStream;
  StreamController<String> _paswdStream;
  StreamController<String> _nameStream;
  StreamController<int> _numCarnetStream;
  StreamController<String> _enStream;
  StreamController<String> _domicilioStream;

  String _paswdValue = "Fail";
  String _nameValue = "Juanita";
  int _numcarnetValue = 2312;
  String _enValue = "Tangamandapio";
  String _domicilioValue = "tangamandapio";

  bool _auth = false;

  static FormBloc _instance = new FormBloc._();
  factory FormBloc() => _instance;
  FormBloc._();
  set auth(bool value) => _auth = value;
  get auth => _auth;
  // inicializar streams
  FormBloc createspasswd() {
    _paswdStream = StreamController<String>.broadcast();
    return this;
  }

  FormBloc createsname() {
    _nameStream = new StreamController.broadcast();
    return this;
  }

  FormBloc createsNumcarnet() {
    _numCarnetStream = new StreamController.broadcast();
    return this;
  }

  FormBloc createsDomicilo() {
    _domicilioStream = new StreamController.broadcast();
    return this;
  }

  //close stremas
  get nameClose {
    _nameValue = null;
    _nameStream?.close();
  }

  get domicilioClose {
    _domicilioValue = null;
    _domicilioStream?.close();
  }

  get enClose {
    _enValue = null;
    _enStream?.close();
  }

  get numCarnetClose {
    _numcarnetValue = null;
    _numCarnetStream?.close();
  }

  get passwordClose {
    _paswdValue = null;
    _paswdStream?.close();
  }

  // getters streams
  Stream<String> get nameStream => _nameStream.stream;
  Stream<String> get domicilioStream => _domicilioStream.stream;
  Stream<String> get enStream => _enStream.stream;
  Stream<int> get numCarnetStream => _numCarnetStream.stream;
  Stream<String> get passwordStream => _paswdStream.stream;

  // last values
  String get nameValue => _nameValue;
  String get domicilioValue => _domicilioValue;
  String get enValue => _enValue;
  int get carnetValue => _numcarnetValue;
  String get passwdValue => _paswdValue;

  // adders?(Englosh live, jaja) handlers
  void addPassword(String pwd,
      [String msg = "La contraseña tiene que tener mas de 8 letras"]) {
    bool res = vpasswd(pwd);
    if (res) {
      _paswdStream.sink.add(pwd);
      _paswdValue = pwd;
      validate();
      //TODO: mensage de error , passwd
    } else {
      _paswdStream.sink.addError(msg);
      _domicilioStream.sink.add("op23jeio23ndo23n dfo23non23do23n");
    }
  }

  void domicilioAdd(String value) {
    _domicilioStream.sink.add(value);
  }

  void addName(String name) {
    if (name.length <= 37) {
      _nameStream.sink.add(name);
      _nameValue = name;
      validate();
    } else {
      _nameStream.sink.addError("Tu nombres debe ser menor a 37 letras");
      _domicilioStream.sink.add("op23jeio23ndo23n dfo23non23do23n");
    }
  }

  void addCarnet(String carnet) {
    if (carnet.length == 8) {
      try {
        _numcarnetValue = int.parse(carnet);
        _numCarnetStream.sink.add(int.parse(carnet));
      } catch (e) {
        debugPrint("$e");
      }
      validate();
    } else {
      _numCarnetStream.sink
          .addError("Los números de carnet solo deben tener 8 digitos");
      _domicilioStream.sink.add("op23jeio23ndo23n dfo23non23do23n");
    }
  }

  void validate() {
    if (_numcarnetValue <= 99999999 &&
        _paswdValue.length >= 8 &&
        (_nameValue.length >= 8 && _nameValue.length <= 37)) {
      _domicilioStream.sink.add("ready");
    } else
      _domicilioStream.sink.add("op23jeio23ndo23n dfo23non23do23n");
  }
}

class Validator {
  //final vpasswdTrasform = new StreamTransformer.fromHandlers(
  //  handleData: (passwd, sink){
  //    bool res = vpasswd(passwd);
  //    if(res){
  //        sink.add("")
  //    }
  //
  //  }
  //);
  bool vpasswd(String paswd) => (paswd.length >= 8) ? true : false;
}
