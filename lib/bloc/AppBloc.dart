import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:glaksoalcovid/components/App.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppBloc {
  StatusRegisterHero voyArenderizar;
  SharedPreferences pref;
  bool modeCircus;
  bool modeControl;
  HeroModel hero = new HeroModel();
  // PersonModel person;
  static AppBloc app = new AppBloc._();
  factory AppBloc() => app;
  AppBloc._();

  //Future<void> loadPreferences () async {
  //  pref = await SharedPreferences.getInstance();
  //  modeCircus = (pref.getBool("modeCircus")??modeCircus);
  //  modeControl = (pref.getBool("modeControl") ?? modeControl);
  //}

}

enum StatusRegisterHero {
  passwordIsNull,
  renderForm,
  renderWork,
  isAuth,
  getPasswd
}

class HeroModel {
  String name;
  String uuidMovil;
  bool verificado;
  bool getPasswd = false;
  String foto;
  String groupName;
  int carnet;
  bool heroModelNew;
  bool auth;

  HeroModel({
    this.name,
    this.uuidMovil,
    this.verificado,
    this.getPasswd,
    this.foto,
    this.groupName,
    this.carnet,
    this.heroModelNew,
    this.auth,
  });

  HeroModel copyWith({
    String name,
    String uuidMovil,
    bool verificado,
    bool getPasswd,
    String foto,
    String groupName,
    int carnet,
    bool heroModelNew,
    bool auth,
  }) =>
      HeroModel(
        name: name ?? this.name,
        uuidMovil: uuidMovil ?? this.uuidMovil,
        verificado: verificado ?? this.verificado,
        getPasswd: getPasswd ?? this.getPasswd,
        foto: foto ?? this.foto,
        groupName: groupName ?? this.groupName,
        carnet: carnet ?? this.carnet,
        heroModelNew: heroModelNew ?? this.heroModelNew,
        auth: auth ?? this.auth,
      );

  factory HeroModel.fromRawJson(String str) =>
      HeroModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory HeroModel.fromJson(Map<String, dynamic> json) => HeroModel(
        name: json["name"],
        uuidMovil: json["uuid_movil"],
        verificado: json["verificado"],
        getPasswd: json["get_passwd"],
        foto: json["foto"],
        groupName: json["group_name"],
        carnet: json["carnet"],
        heroModelNew: json["new"],
        auth: json["auth"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "uuid_movil": uuidMovil,
        "verificado": verificado,
        "get_passwd": getPasswd,
        "foto": foto,
        "group_name": groupName,
        "carnet": carnet,
        "new": heroModelNew,
        "auth": auth,
      };
}

/*
{
  "name":"ca",
  "uuid_movil":"237412389",
  "verificado":false,
  "get_passwd":true,
  "foto":"jdkl2jd",
  "group_name":"adqw",
  "new":false,
  "auth":false
}
*/

class PersonModel {
  int id;
  String fotoUno;
  String fotoDos;
  int idCarnet;
  String namePerson;
  String domicilio;
  String en;
  int timestamp;

  PersonModel({
    this.id,
    this.fotoUno,
    this.fotoDos,
    this.idCarnet,
    this.namePerson,
    this.domicilio,
    this.en,
    this.timestamp,
  });

  PersonModel copyWith({
    int id,
    String fotoUno,
    String fotoDos,
    int idCarnet,
    String namePerson,
    String domicilio,
    String en,
    int timestamp,
  }) =>
      PersonModel(
        id: id ?? this.id,
        fotoUno: fotoUno ?? this.fotoUno,
        fotoDos: fotoDos ?? this.fotoDos,
        idCarnet: idCarnet ?? this.idCarnet,
        namePerson: namePerson ?? this.namePerson,
        domicilio: domicilio ?? this.domicilio,
        en: en ?? this.en,
        timestamp: timestamp ?? this.timestamp,
      );

  factory PersonModel.fromRawJson(String str) =>
      PersonModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PersonModel.fromJson(Map<String, dynamic> json) => PersonModel(
        id: json["id"],
        fotoUno: json["foto_uno"],
        fotoDos: json["foto_dos"],
        idCarnet: json["id_carnet"],
        namePerson: json["name_person"],
        domicilio: json["domicilio"],
        en: json["en"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "foto_uno": fotoUno,
        "foto_dos": fotoDos,
        "id_carnet": idCarnet,
        "name_person": namePerson,
        "domicilio": domicilio,
        "en": en,
        "timestamp": timestamp,
      };
}
/*

{
 "id":123,
 "foto_uno":"1e12",
 "foto_dos":"qwdqw",
 "id_carnet":112312,
 "name_person":"dwedwedwe dwe",
 "domicilio":  "dqdqwdqw",
 "en":"12e12",
 "timestamp":12312312
}
*/

bool int2bool(int number) => !(((number < 0) ? number * -1 : number) < 1);
int bool2int(bool value) => value ? 1 : 0;
void navigateToOtherPageNotBackUser(BuildContext context, Widget toPage) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => toPage),
    (Route<dynamic> route) => false,
  );
}

String bytesImageToBase64(Uint8List bytes) => base64.encode(bytes);
Uint8List base64ImageToBytes(String base64string) =>
    base64.decode(base64string);
String getDate() {
  DateTime hoy = DateTime.now();
  int dia, mes, ano;
  dia = hoy.day;
  mes = hoy.month;
  ano = hoy.year;
  return "$dia/$mes/$ano";
}

Future<int> get isConnected async {
  int returns;
  try {
    List<InternetAddress> result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      returns = 1;
    }
  } on SocketException catch (_) {
    returns = 0;
  } on Exception catch (_) {
    returns = -1;
  }
  return returns;
}
