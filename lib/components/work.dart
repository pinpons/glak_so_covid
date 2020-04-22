import 'dart:async';
import 'dart:io';

import 'package:glaksoalcovid/components/App.dart';
import 'package:image_picker/image_picker.dart';

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
      Text("translate"),
      TakePhotos(keyScaffold: _keyScaffold),
      Text("statics")
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
                icon: Icon(Icons.border_color),
                title: Text("Interpretar")),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_searching),
                title: Text("Engine")),
            BottomNavigationBarItem(
                icon: Icon(Icons.timeline), title: Text("Estadisticas"))
          ]),
    );
  }

}

class TakePhotos extends StatelessWidget {
  GlobalKey<ScaffoldState> keyScaffold;
  WorkBloc blocw = new WorkBloc();
  TakePhotos({this.keyScaffold});
  @override
  Widget build(BuildContext context) {
    return new Column(children: [
      _showGroupName(),
      new Expanded(child: streamImages()),
      // FIXME:decomenta y ocurre el error
      sendButton(),
      button()
    ]);
  }
  Widget sendButton() {
    return StreamBuilder(
      stream: blocw._streamsg.stream,
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        if(snapshot.hasData) {
          if(blocw.img1 != 0 && blocw.img2 != 0) {
            //TODO:añdir funcionalidad
            return createButton((){

            });
          }
          
          return createButton(null);

        }else {
          return createButton(null);
        }
      }
    );
  }
  Widget createButton(Function fn) {
    return RaisedButton.icon(
      icon: Icon(Icons.save),
      label: Text("Guardar"),
      onPressed: fn,
    );
  }
  Widget streamImages() {
    return new StreamBuilder(
      stream: blocw.streammsg,
      builder: (ctx, AsyncSnapshot snapshot) {
        if (snapshot.data == renderworkstatus.addfirstimage) {
          return ListView.builder(
              itemCount: blocw.listrender.length,
              itemBuilder: (ctx, i) => blocw.listrender[i]);
        } else if (blocw.listrender != null) {
          return ListView.builder(
              itemCount: blocw.listrender.length,
              itemBuilder: (ctx, i) => blocw.listrender[i]);
        }
        return Text("Necesito una imagen frontal y trasera del carnet");
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
          blocw.listrender.add(FutureBuilder(
            builder: (ctx, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return new Center(child: Image.memory(snapshot.data));
              } else {
                return new Center(child: new CircularProgressIndicator());
              }
            },
            future: img.readAsBytes(),
          ));
        } catch (e) {
          debugPrint("&&&&&&&&&&&&&&&&&& $e");
        }
        blocw._streamsg.sink.add(renderworkstatus.addfirstimage);
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

class WorkBloc {
  StreamController<renderworkstatus> _streamsg = StreamController<renderworkstatus>.broadcast();
  int img1, img2 = 0;
  List<Widget> listrender = new List<Widget>();
  File image1;
  File image2;
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
    image1 = null;
    image2 = null;
    img1 = 0; 
    img2 =0;
  }
 // Stream<Widget> get streamwidget => _streamwidget.stream;
  //WorkBloc get createwidget {
  //  _streamwidget = new StreamController<Widget>.broadcast();
  //  return this;
  //}
}
