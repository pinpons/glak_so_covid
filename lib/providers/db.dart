import 'dart:io' show Platform;
import 'dart:io' show Directory;
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:glaksoalcovid/bloc/AppBloc.dart';
import 'package:glaksoalcovid/components/App.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

//typedef F = Future<List<Map<String,dynamic>>>;// Function<T>(T);

class StorageProvider {
  static bool dev = false;
  static Database _database;
  int userNewIndentificador = 7;
  static int version = 5;
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
      //TODO: changue model.sql
      await db.execute(
          '''CREATE TABLE persons(foto_uno TEXT,foto_dos TEXT,extra TEXT,
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
    AppBloc appBloc = new AppBloc();
    debugPrint("isNewUser() -> call");
    appBloc.pref = await SharedPreferences.getInstance();
    appBloc.modeCircus = (appBloc.pref.getBool("modeCircus") ?? false);
    appBloc.modeControl = (appBloc.pref.getBool("modeControl") ?? true);
    debugPrint("Mode circus: ${appBloc.modeCircus}");
    debugPrint("Mode modeControl: ${appBloc.modeControl}");
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
  Future<int> insertgpersons(Map<String, String> data, bool input) async {
    int res = 0;

    Database db = await database;
    try {
      AppBloc appBloc = AppBloc();
      if (appBloc.modeCircus) {
        data["on_time"] = "${data['on_time']}@${(input) ? 'input' : 'output'}";
      } else {
        data["on_time"] = "${data['on_time']}@beishu";
      }
      //debugPrint("FOTO uno: ${data['foto_uno']}");
      //debugPrint("FOTO uno: ${data['foto_dos']}");
      debugPrint("CALL () -> INSERTANDO");
      // await db.insert("persons", data);
      String sql = """INSERT INTO persons(foto_uno,on_time)VALUES("${data['foto_uno']}",\'${data['on_time']}\')""";
      print("SQL RAW: $sql");
      //print("insert RAW:$sql");
      await db.rawInsert(sql);
      //print(await db.query("persons"));
      // estadisticas(count_persons INTEGER,date_work TEXT)
      await db.insert("estadisticas",
          <String, dynamic>{"count_persons": 0, "date_work": getDate()});
    } catch (e) {
      // DATE:some@ERROR:meta_description:error_message;
      await db.insert("estadisticas", <String, dynamic>{
        "count_persons": 1,
        "date_work": "DATE:${getDate()}@ERROR:error al insertar pesona:$e"
      });
      print("ERROR INSERT : $e");
    }

    return res;
  }

  /// # Obtener la lista de personas guardadas
  /// retorna un mapa
  // TODO: completame
  Future<List<Map<String, dynamic>>> getMetaPersonas(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> resultados;
    if (id != null) {
      resultados = await db.rawQuery(
          "SELECT rowid,extra,on_time FROM persons where rowid > $id limit 10");
      return resultados;
      // return await db.query("persons");
    } else {
      var res= await db.rawQuery(
          "SELECT rowid,extra,on_time FROM persons limit 10");
      print(res);
      return res;
      //return await db.rawQuery(
      //    "SELECT rowid,extra,on_time FROM persons limit 10");
    }
  }

// complete
  Future<Map<String, dynamic>> getPerson(int id) async {
    Database db = await database;
//    CREATE TABLE persons(person_id INTEGER PRIMARY KEY,foto_uno TEXT,foto_dos TEXT,extra TEXT,
//id_carnet INTEGER,name TEXT,domicilio TEXT,en TEXT,on_time TEXT)
    //var li = await db.query("persons", where: "rowid = ?", whereArgs: [id]);
    //print("DEBIF: $li");
    //await db.rawQuery("update persons set foto_uno = '''dasdmasbdqwjhbdqwjkbdwjkqbñdjkqwbjdkqwbdqwlbdkqwdbqwlbdqwdbqwldbqwdlbqwlbdqwldblqwdblqw ''' where rowid = $id");
    var sql = "SELECT rowid,on_time,foto_uno,foto_dos FROM persons where rowid = $id";
    List<Map<String, dynamic>> resultados =
        await db.rawQuery(sql);
        print("GET PERSON:call()->");
    return resultados[0];
  }

  Future<bool> deletePerson(int id) async {
    Database db = await database;
    int onRowActionEffect =
        await db.delete("persons", where: "rowid = ?", whereArgs: [id]);
    return onRowActionEffect == 1 ? true : false;
  }

  Future<bool> updatePerson(Map<String, dynamic> data, int target_id) async {
    Database db = await database;
    //TODO:
    int onRowActionEffect = await db.update("persons", data,
        where: "person_id = ?", whereArgs: [target_id]);
    return onRowActionEffect == 1 ? true : false;
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
    String sql =
        "SELECT count(count_persons) as res FROM estadisticas where count_persons = 0 and date_work = \'$date\'";
    var res = await db.rawQuery(sql);
    return res[0]['res'];
  }
}
