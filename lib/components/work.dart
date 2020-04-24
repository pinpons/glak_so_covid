import 'dart:async';
import 'dart:typed_data';

import 'package:glaksoalcovid/components/App.dart';
import 'package:glaksoalcovid/components/src/estadisticas.dart';
import 'package:glaksoalcovid/components/src/trans_image_page.dart';
import 'package:glaksoalcovid/components/src/trans_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';

enum renderworkstatus {
  addHeader,
  addfirstimage,
  addsecondimage,
  addsendbutton,
  savedata,
  rerender
}

class WorkPageTabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new WorkPage();
}

//TODO:añadir manejo si es auth o no lo es
class WorkPage extends State<WorkPageTabs> {
  AppBloc appBloc = new AppBloc();
  final GlobalKey<ScaffoldState> _keyScaffold = new GlobalKey<ScaffoldState>();
  List<Widget> pages = new List(3);
  int index = 1;
  @override
  void initState() {
    super.initState();
    //WorkBloc()
    //  .createmsg;
    //TODO: crear paginas para el: Transcricion de las imagenes las estadisticas
    pages = [
      // Text("translate"),
      TransImageViewEditElement(),
      TakePhotos(keyScaffold: _keyScaffold),
      Estadisticas()
    ];
  }

  @override
  void dispose() {
    super.dispose();
    // WorkBloc()..dispose()..closemsg..closewidget;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _keyScaffold,
      appBar: new AppBar(
        title: const Text("Lak'so al coronavairus"),
      ),
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) {
            setState(() {
              index = i;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.border_color), title: Text("Interpretar")),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_searching), title: Text("Engine")),
            BottomNavigationBarItem(
                icon: Icon(Icons.timeline), title: Text("Estadisticas"))
          ]),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
                accountName: Text(appBloc.hero.name),
                accountEmail: Text(appBloc.hero.groupName != null
                    ? appBloc.hero.name
                    : "No definido")),
            SwitchListTile(
                secondary: Icon(Icons.settings_applications),
                title: Text("Modo control"),
                subtitle:
                    Text("Este modo es ideal para lugares como las trancas"),
                value: appBloc.modeControl,
                onChanged: (value) {
                  WorkBloc bloc = new WorkBloc();
                  setState(() {
                    if (value == false) {
                      appBloc.modeCircus = true;
                      bloc.mode = true;
                      appBloc.pref.setBool("modeCircus", true);
                      appBloc.modeControl = value;
                    } else if (value == true && appBloc.modeCircus == true) {
                      appBloc.modeCircus = false;
                      bloc.mode = false;
                      appBloc.pref.setBool("modeCircus", false);
                      appBloc.modeControl = value;
                    }
                    appBloc.pref.setBool("modeControl", value);
                  });
                }),
            SwitchListTile(
                secondary: Icon(Icons.settings_applications),
                title: Text("Modo circo"),
                subtitle: Text(
                    "Este modo es muy bueno para casos como los mercados,se supone que la salida hay otro control para llevar una marca de tiempo de entrada y salida de las personas"),
                value: appBloc.modeCircus,
                onChanged: (value) {
                  WorkBloc bloc = new WorkBloc();
                  setState(() {
                    if (value == false) {
                      appBloc.modeControl = true;
                      //bloc.mode = true;
                      appBloc.pref.setBool("modeControl", true);
                      appBloc.modeCircus = value;
                    } else if (value == true && appBloc.modeControl == true) {
                      appBloc.modeControl = false;
                      //bloc.mode = false;
                      appBloc.pref.setBool("modeControl", false);
                      appBloc.modeCircus = value;
                    }
                    appBloc.pref.setBool("modeCircus", value);
                  });
                }),
            new SwitchListTile(
                secondary: Icon(Icons.directions_run),
                subtitle: Text(
                    "Si el interruptor esta activado entonces la persona esta de entrada si no es asi esta de salida"),
                title: Text("¿La persona esta de salida o entrada del circo?"),
                value: new WorkBloc().mode ?? false,
                onChanged: (appBloc.modeCircus)
                    ? (value) {
                        setState(() {
                          new WorkBloc().mode = value;
                        });
                      }
                    : null)
          ],
        ),
      ),
    );
  }
}

class TakePhotos extends StatelessWidget {
  ProgressDialog pr;
  AppBloc appBloc = new AppBloc();
  GlobalKey<ScaffoldState> keyScaffold;
  WorkBloc blocw = new WorkBloc();
  TakePhotos({this.keyScaffold});
  @override
  Widget build(BuildContext context) {
    // TODO: analizar si es necesario que sea dimisible estricto o no
    pr = new ProgressDialog(context, isDismissible: true);
    pr.style(message: "Guardando ,por favor espere 🔥 ");

    return new Column(children: [
      // TODO: agregar shared preferences,por que es muy molesto todos esos mensages
      //_showGroupName(),
      new Expanded(child: streamImages()),
      sendButton(),
      button()
    ]);
  }

  Widget sendButton() {
    return StreamBuilder(
        stream: blocw._streamsg.stream,
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          if (snapshot.hasData || (blocw.img1 == 1 && blocw.img2 == 1)) {
            if (blocw.img1 == 1 && blocw.img2 == 1) {
              //TODO:añdir funcionalidad
              return createButton(() async {
                // TODO:V1
                StorageProvider instance = new StorageProvider();
                await pr.show();
                // persons(id INTEGER PRIMARY KEY AUTOINCREMENT,foto_uno TEXT,foto_dos TEXT,
                // extra TEXT,
                // id_carnet INTEGER,name TEXT,domicilio TEXT,en TEXT,on_time TEXT)
                // FIXME: :)?
                // por favor quitame la preocupacion
                // Uuid uuid = new Uuid();
                //var data = <String,String>{
                //    "id": uuid.v4(),
                //    "foto_uno": bytesImageToBase64(blocw.image1),
                //    "foto_dos": bytesImageToBase64(blocw.image2),
                //    "on_time": DateTime.now().toString()
                //  };
                // test
                print("IMAGE ${blocw.image1}");
                var foto = bytesImageToBase64(blocw.image1);
                print("FO: $foto");
                await instance.insertgpersons(<String, String>{
                  "foto_uno": foto,
                  "foto_dos": bytesImageToBase64(blocw.image2),
                  "on_time": DateTime.now().toString()
                }, blocw.mode);
                blocw.dispose();
                await pr.hide();
              });
            }

            return createButton(null);
          } else {
            return createButton(null);
          }
        });
  }

  Widget createButton(Function fn) {
    return RaisedButton.icon(
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      onPressed: fn,
    );
  }

  //TODO: hacer mas bonito los mensajes de estados
  Widget streamImages() {
    return new StreamBuilder(
      stream: blocw.streammsg,
      builder: (ctx, AsyncSnapshot snapshot) {
        if (snapshot.data == renderworkstatus.addfirstimage) {
          return ListView.builder(
              itemCount: blocw.listrender.length,
              itemBuilder: (ctx, i) => blocw.listrender[i]);
        } else if (snapshot.data == renderworkstatus.addsecondimage) {
          return ListView.builder(
              itemCount: blocw.listrender.length,
              itemBuilder: (ctx, i) => blocw.listrender[i]);
        } else if (blocw.listrender[0] != null || blocw.listrender[1] != null) {
          return ListView.builder(
              itemCount: blocw.listrender.length,
              itemBuilder: (ctx, i) => blocw.listrender[i]);
        } else if (snapshot.data == renderworkstatus.savedata) {
          return Center(child: new Text("EXITO"));
        }
        return Center(
            child: Text("Necesito una imagen frontal y trasera del carnet"));
      },
    );
  }

  Widget button() {
    return FloatingActionButton(
      child: Icon(Icons.add_a_photo),
      onPressed: () async {
        try {
          //blocw.listrender.add(new Text("etwrtlwemflñwem  elñwfwef"));
          var img = await ImagePicker.pickImage(source: ImageSource.camera);

          debugPrint("00000000000000000000000000000");
          print("img1 = ${blocw.img1} img2 = ${blocw.img2}");
          print("lenght items: ${blocw.listrender.length}");
          print(blocw.img1 == 0 && blocw.img2 == 0);
          print(blocw.img1 == 1 && blocw.img2 == 0 || blocw.img2 == 1);
          // logic
          if (blocw.img1 == 0 && blocw.img2 == 0) {
            blocw.img1 = 1;
            debugPrint("1111111111111111111111111111111111111");
            // blocw.listrender.add(FutureBuilder(
            //   builder: (ctx, AsyncSnapshot snapshot) {
            //     if (snapshot.hasData) {
            //       blocw.image1 = snapshot.data;
            //       return new Center(child: Image.memory(snapshot.data));
            //     } else {
            //       return new Center(child: new CircularProgressIndicator());
            //     }
            //   },
            //   future: img.readAsBytes(),
            // ));
            blocw.listrender[0] = FutureBuilder(
              builder: (ctx, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  blocw.image1 = snapshot.data;
                  return new Center(child: Image.memory(snapshot.data));
                } else {
                  return new Center(child: new CircularProgressIndicator());
                }
              },
              future: img.readAsBytes(),
            );
            blocw._streamsg.sink.add(renderworkstatus.addfirstimage);
          } else if (blocw.img1 == 1 && blocw.img2 == 0 || blocw.img2 == 1) {
            blocw.img2 = 1;
            debugPrint("2222222222222222222222222222222222222");
            // blocw.listrender.insert(1,FutureBuilder(
            //   builder: (ctx, AsyncSnapshot snapshot) {
            //     if (snapshot.hasData) {
            //       blocw.image2 = snapshot.data;
            //       return new Center(child: Image.memory(snapshot.data));
            //     } else {
            //       return new Center(child: new CircularProgressIndicator());
            //     }
            //   },
            //   future: img.readAsBytes(),
            // ));
            blocw.listrender[1] = FutureBuilder(
              builder: (ctx, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  blocw.image2 = snapshot.data;
                  return new Center(child: Image.memory(snapshot.data));
                } else {
                  return new Center(child: new CircularProgressIndicator());
                }
              },
              future: img.readAsBytes(),
            );
            blocw._streamsg.sink.add(renderworkstatus.addsecondimage);
          }
        } catch (e) {
          debugPrint("Error al añadir los widget con las imagenes $e");
        }
      },
    );
  }

  /// # Retorna la cabecera
  ///
  /// indicando si pertenece a algun grupo o no
  Widget _showGroupName() {
    var bloc = AppBloc();
    if (bloc.hero.groupName == null) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        keyScaffold.currentState.showSnackBar(SnackBar(
          content: Text("Conocer el nombre de tu equipo nos ayuda muchisimo"),
          action: SnackBarAction(
              onPressed: () {
                //TODO: si quiero añadir el nombre de mi equipo
                //AlertDialog(
                //  actions: <Widget>[],
                //);
              },
              label: "Añadir"),
        ));
      });
      return Center(
          child: Text(
        "No nos dijiste como se llama tu grupo heroes",
        style: TextStyle(color: Colors.red),
      ));
    }
    Future.delayed(Duration(milliseconds: 500)).then((value) {
      keyScaffold.currentState.showSnackBar(SnackBar(
        content:
            Text("Si cambiaste de grupo , cambialo en las configuraciones"),
        action: SnackBarAction(
            onPressed: () {
              keyScaffold.currentState.hideCurrentSnackBar();
            },
            label: "Ok"),
      ));
    });
    return Center(
        child: Text(
            "Bienvenido miembro de ${bloc.hero.groupName}, nos alegra tenerte de nuevo!"));
  }
}

///
/// Si el mode esta en true entonces la entrada del usuario es entrada al circo
/// si el false es salida del circo
class WorkBloc {
  StreamController<renderworkstatus> _streamsg =
      StreamController<renderworkstatus>.broadcast();
  int img1 = 0;
  int img2 = 0;
  List<Widget> listrender = new List<Widget>(2);
  Uint8List image1;
  Uint8List image2;
  bool mode = false;
  WorkBloc get _createmsg {
    _streamsg = new StreamController<renderworkstatus>.broadcast();
    return this;
  }

  get close => _streamsg.close();
  Stream<renderworkstatus> get streammsg => _streamsg.stream;
  get closemsg => _streamsg.close();
  //get closewidget => _streamsg.close();
  WorkBloc get createmsg {
    _streamsg = new StreamController();
    return this;
  }

  static WorkBloc _bloc = new WorkBloc._();
  factory WorkBloc() => _bloc;
  WorkBloc._();
  dispose() {
    mode = false;
    image1 = null;
    image2 = null;
    img1 = 0;
    img2 = 0;
    listrender[0] = null;
    listrender[1] = null;
    _streamsg.sink.add(renderworkstatus.savedata);
  }
  // Stream<Widget> get streamwidget => _streamwidget.stream;
  //WorkBloc get createwidget {
  //  _streamwidget = new StreamController<Widget>.broadcast();
  //  return this;
  //}
}
