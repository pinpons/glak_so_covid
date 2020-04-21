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
  // List<File> images = new List(2);
  final GlobalKey<ScaffoldState> _keyScaffold = new GlobalKey<ScaffoldState>();
  List<Widget> pages = new List(3);
  int index = 1;
  @override
  void initState() {
    super.initState();
    WorkBloc()..createwidget..createmsg;;

    pages  = [
      Text("translate"),
      TakePhotos(keyScaffold: _keyScaffold),
      Text("statics")
    ];
  }
  @override
  void dispose(){
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
        onTap: (i){
          setState(() {
            index = i;
          });
        },
        items:[
          BottomNavigationBarItem(icon: Icon(Icons.border_color),title: Text("Interpretar imagenes")),
          BottomNavigationBarItem(icon: Icon(Icons.location_searching),title:Text("Engine People search")),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), title: Text("Tus estadisticas"))
        ]
      ),
    );
  }
//  Widget  _buildImagerender(){
//     return StreamBuilder(
//       key: UniqueKey(),
//       stream: WorkBloc().streammsg,
//       builder: (BuildContext context, AsyncSnapshot<renderworkstatus> snapshot){
//           WorkBloc bloc = WorkBloc();
//         if (snapshot.data == renderworkstatus.addHeader ) {
//           debugPrint("łłłłłłłłłłłłłłłłłłł ${WorkBloc().listrender.length.runtimeType}");
//           bloc.listrender.add(new Container(
//             child:_showGroupName()
//           ));

//           return ListView(children: bloc.listrender);
          
//         }
//         else if(snapshot.data == renderworkstatus.addfirstimage) {
//           print("ĸĸĸĸĸĸĸĸĸĸĸĸĸßææææææææææææææææææßw2sw");
//           return ListView(children: bloc.listrender);
//         }
//         //else if(){
//         //}else if() {
//         //}
//         WorkBloc()._streamsg.sink.add(renderworkstatus.addHeader );
//         return Center(child: new CircularProgressIndicator());
//       }// stream controler
//     );
//   }
}

class TakePhotos extends StatelessWidget {
  GlobalKey<ScaffoldState> keyScaffold;
  WorkBloc blocw = new WorkBloc();
  TakePhotos({this.keyScaffold});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      children: [
      //_showGroupName(),
      new Expanded(child:streamImages()),
      button()
      ]

    );
  }
  Widget streamImages(){
    return new StreamBuilder(
      stream: WorkBloc().createmsg.streammsg,
      builder: (ctx, AsyncSnapshot snapshot){
        if(snapshot.data == renderworkstatus.addfirstimage){
            return ListView.builder(itemCount: blocw.listrender.length,itemBuilder:(ctx,i) => blocw.listrender[i] ) ; 
        }else if(blocw.listrender != null ){
          return ListView.builder(itemCount: blocw.listrender.length,itemBuilder:(ctx,i) => blocw.listrender[i] ) ; 
        }
        return Text("Necesito una imagen frontal y trasera del carnet");
      },
    );
  }

  Widget button(){
    return FloatingActionButton(

      child: Icon(Icons.add_a_photo),
      onPressed: (){
        try {
        blocw.listrender.add(new Text("etwrtlwemflñwem  elñwfwef"));
          
        } catch (e) {
          debugPrint("&&&&&&&&&&&&&&&&&& $e");
        }
        blocw._streamsg.sink.add( renderworkstatus.addfirstimage );
      },
    );
  }
  Widget _showGroupName() {
      var bloc = AppBloc();
      if(bloc.hero.groupName == null){
        Future.delayed(Duration(seconds: 1)).then((value){
          keyScaffold.currentState.showSnackBar(
        SnackBar(
          content: Text("Conocer el nombre de tu equipo nos ayuda muchisimo"),
          action: SnackBarAction(onPressed: (){
            //TODO
            //AlertDialog(
            //  actions: <Widget>[],
            //);
          }
          , label: "Añadir" ),
        )
        );
        });
          return Center(child: Text("No nos dijiste como se llama tu grupo heroes",
          style: TextStyle(
            color: Colors.red
          ),
          ));
          
      }
      Future.delayed(Duration(milliseconds: 500)).then((value){
      keyScaffold.currentState.showSnackBar(
        SnackBar(
          content: Text("Si cambiaste de grupo , cambialo en las configuraciones"),
          action: SnackBarAction(onPressed: (){
            keyScaffold.currentState.hideCurrentSnackBar();
          }
          , label: "Ok" ),
        )
      );
      });
      return Center(child: Text("Bienvenido miembro de ${bloc.hero.groupName}, nos alegra tenerte de nuevo!"));
  }
}

class WorkBloc {
  StreamController<renderworkstatus> _streamsg;
  StreamController<Widget> _streamwidget;
  int header,button,img1,img2 = 0;
  List<Widget> listrender = new List<Widget>();
  WorkBloc get _createmsg {
    _streamsg = new StreamController<renderworkstatus>.broadcast();
    return this;
  }
  Stream<renderworkstatus> get streammsg => _streamsg.stream;
  Stream<Widget> get streamwidget => _streamwidget.stream;
  
  WorkBloc get createwidget {
    _streamwidget = new StreamController<Widget>.broadcast();
    return this;
  }
  WorkBloc get createmsg {
    _streamsg = new StreamController();
    return this;
  }
  get closemsg => _streamsg.close();
  get closewidget => _streamsg.close();

  static WorkBloc _bloc = new WorkBloc._();
  Widget image1;
  Widget image2;
  factory WorkBloc() => _bloc;
  WorkBloc._();
  dispose(){
    image1 = null;
    image2 = null;
  }
}