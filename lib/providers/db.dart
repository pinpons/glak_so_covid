import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:glaksoalcovid/bloc/AppBloc.dart';
import 'package:glaksoalcovid/components/App.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class StorageProvider {
  static bool dev = false;
  static Database _database;
  int userNewIndentificador = 7;
  static int version = 2;
  static StorageProvider instance = new StorageProvider._();

  factory StorageProvider() => instance;

  StorageProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _open;
    return database;
  }

  Future<Database> get _open async {
    debugPrint("ACTION: Abriendo la base de datos .:.:·:");
    Directory appRootPath = await getApplicationDocumentsDirectory();
    final String pathDb = join(appRootPath.path, 'veniio.db');

    return await openDatabase(pathDb, version: version,
        onCreate: (Database db, int version) async {
      await db.execute(
          '''CREATE TABLE heroe(id_meta INTEGER DEFAULT $userNewIndentificador ,name TEXT,uuid_movil TEXT,
        verificado integer DEFAULT 0,password TEXT,get_passwd integer DEFAULT 0,
        foto TEXT,group_name TEXT, carnet INTEGER,new INTEGER DEFAULT 1)''');

      await db.execute(
          'CREATE TABLE estadisticas(count_persons INTEGER,date_work TEXT)');
      await db.execute(
          '''CREATE TABLE metainfo(id INTEGER PRIMARY KEY ,group_heroe_name TEXT,ubicacion_name TEXT,
x TEXT,y TEXT,on_time_start TEXT,on_time_end TEXT)''');
      await db.execute(
          '''CREATE TABLE persons(id TEXT ,foto_uno TEXT,foto_dos TEXT,extra TEXT,
        id_carnet INTEGER,name TEXT,domicilio TEXT,en TEXT,on_time TEXT)''');
    });
  }
  // # Model hero
  // ```sql 
  // CREATE TABLE heroe(id_meta INTEGER DEFAULT $userNewIndentificador ,name TEXT,uuid_movil TEXT,
  // verificado integer DEFAULT 0,password TEXT,get_passwd integer DEFAULT 0,
  // foto TEXT,group_name TEXT,new INTEGER DEFAULT 1)
  // ```

  // if return false is a new user devide, but create user
  Future<bool> get isNewUser async {
    debugPrint("isNewUser() -> call");
    Database db = await database;
    List<Map<String, dynamic>> res =
        await db.query("heroe", where: "id_meta = ?", columns: [
      "name",
      "uuid_movil",
      "verificado",
      "get_passwd",
      "password",
      "carnet",
      "foto",
      "group_name"
    ], whereArgs: [
      userNewIndentificador
    ]);
    debugPrint("Resultados: $res");
    if (res.isEmpty) {
      Map infoDevice = await simpleMovilInfo;
      debugPrint("Es nuevo usuario");
      await db.insert("heroe", {
        "id_meta": userNewIndentificador,
        "uuid_movil": infoDevice["id"],
        "new": 0
      });
      return false;
    }
    debugPrint("No es nuevo usuario");
    AppBloc appBloc = new AppBloc();
    appBloc.hero = new HeroModel(name: res[0]["name"]);
    appBloc.hero.getPasswd = int2bool(res[0]["get_passwd"]);
    appBloc.hero.heroModelNew = false;
    appBloc.hero.verificado = int2bool(res[0]["verificado"]);
    //TODO: un poco más seguro
    if (appBloc.hero.getPasswd == false && res[0]["password"] != null) {
      appBloc.hero.auth = true;
    } else {
      appBloc.hero.auth = (res[0]["password"] != null) ? true : false;
    }

    appBloc.hero.foto = res[0]["foto"];
    /* render Work or Render Form*/
    String paswd = res[0]["password"];
    StatusRegisterHero status;
    if (paswd == null) {
      if (appBloc.hero.name == null) {
        status = StatusRegisterHero.renderForm;
      }
    } else if (paswd != null && appBloc.hero.name != null) {
      status = StatusRegisterHero.renderWork;
    }
    appBloc.voyArenderizar = status;
    /*end render Work or Render Form*/
    return true;
  }

  /// # insert images in table persons
  Future<int> insertgpersons(Map<String,String> data) async {
    int res = 0;
    Database db = await database;
    try {
      await db.insert("persons", data);
      // estadisticas(count_persons INTEGER,date_work TEXT)
      await db.insert("estadisticas", <String,dynamic>{"count_persons": 0,"date_work": getDate()});
    } catch (e) {
      // DATE:some@ERROR:meta_description:error_message;
      await db.insert("estadisticas", <String,dynamic>{"count_persons": 1,
      "date_work": "DATE:${getDate()}@ERROR:error al insertar pesona:$e"
      });
      print("ERROR INSERT : $e");
    }

    return res;

  }

  /// # list persons save
  // TODO: completame
  Future<List<Map<String,dynamic>>> getPersonas() async {
    Database db = await database;
    return await db.rawQuery("SELECT id FROM persons");
  }

  Future<Map<String, String>> get simpleMovilInfo async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.toString();
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        IosDeviceInfo data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      debugPrint('Failed to get platform version');
    }

    return {"name": deviceName, "version": deviceVersion, "id": identifier};
  }
  
  Future<int> getSum() async {
    Database db = await database;
    // estadisticas(count_persons INTEGER,date_work TEXT)
    String date = getDate();
    String sql = "SELECT count(count_persons) as res FROM estadisticas where count_persons = 0 and date_work = \'$date\'";
    var res = await db.rawQuery(sql);
    return res[0]['res'];
  }
}
