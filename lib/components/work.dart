import 'dart:async';
import 'dart:io';

import 'package:glaksoalcovid/components/App.dart';
import 'package:glaksoalcovid/components/provider.dart';
import 'package:image_picker/image_picker.dart';

enum renderworkstatus {
  addHeader,
  addfirstimage,
  addsecondimage,
  addsendbutton,
  savedata,
  rerender
}
class WorkBloc {
  StreamController<renderworkstatus> _streamsg;
  StreamController<Widget> _streamwidget;
  int header,button,img1,img2 = 0;
  List<Widget> listrender = <Widget>[Container()];
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

class WorkPageTabs extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new WorkPage();
}

//TODO:añadir manejo si es auth o no lo es
class WorkPage extends State<WorkPageTabs> {
  // List<File> images = new List(2);
  List<Widget> pages = new List(3);
  int count = 1;
  int index = 1;
  @override
  void initState() {
    super.initState();
    WorkBloc()..createwidget.._createmsg;

    pages  = [
      Text("translate"),
      _buildImagerender(),
      Text("statics")
    ];
    debugPrint("INSER MESESAASA");
    
  }
  @override
  void dispose(){
    super.dispose();
    WorkBloc()..dispose()..closemsg..closewidget;
  }

 Widget  _buildImagerender(){
    return StreamBuilder(
      stream: WorkBloc().streammsg,
      builder: (BuildContext context, AsyncSnapshot<renderworkstatus> snapshot){
        if (snapshot.data == renderworkstatus.addHeader ) {
          debugPrint("łłłłłłłłłłłłłłłłłłł ${WorkBloc().listrender.length.runtimeType}");
          WorkBloc bloc = WorkBloc();
          bloc.listrender.add(new Container(
            child:_showGroupName()
          ));

          return widgetStream();
          
        }
        else if(snapshot.data == renderworkstatus.addfirstimage) {
          return widgetStream();
        }
        //else if(){
        //}else if() {
        //}
        WorkBloc()._streamsg.sink.add(renderworkstatus.addHeader );
        return Center(child: new CircularProgressIndicator());
      }// stream controler
    );
  }

  Widget widgetStream() {
    return ListView.builder(
            itemCount: WorkBloc().listrender.length,
            itemBuilder: (ctx, i){
              return Column(
                children: <Widget>[
                  WorkBloc().listrender[i],
                  Divider()
                ],
              );
            },
          );
  }

  Widget _showGroupName() {
      var bloc = AppBloc();
      if(bloc.hero.groupName == null){
        Future.delayed(Duration(seconds: 1)).then((value){
          Scaffold.of(context).showSnackBar(
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
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Si cambiaste de grupo , cambialo en las configuraciones"),
          action: SnackBarAction(onPressed: (){
            Scaffold.of(context).hideCurrentSnackBar();
          }
          , label: "Ok" ),
        )
      );
      });
      return Center(child: Text("Bienvenido miembro de ${bloc.hero.groupName}, nos alegra tenerte de nuevo!"));
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text("Lak'so al coronavairus"),
      ),
      body: pages[index],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () async {
          var bloc = new WorkBloc();
          var img = await ImagePicker.pickImage(source: ImageSource.camera);
            debugPrint("IMAGE FIEL");
            //bloc.streammsg.sink
            bloc.listrender.add(Image.file(img));
        },
      ),
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
}

// class EngineView extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return new _EngineView();
//   }
  
// }

// class _EngineView extends State<EngineView> {
//   //Widget uno = _container(Colors.red);
//   //Widget dos = _container(Colors.blue);
//   List<Widget> list;
//   bool use;
//   int elCount = 1;

//   @override
//   void initState() {
//     AppBloc appBloc = new AppBloc();
//     // TODO: implement initState
//     super.initState();
//     list = <Widget>[
//             _showGroupName(appBloc, context),
//                 // uno,
//                 // dos,
//             _takePhoto(appBloc)
//           ];
//   }
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return  _builder();
//   }

//   Widget _builder() {
    
//     return Builder(
//           builder:(context) => Container(
//         child: new ListView.builder(
//           itemCount: list.length,
//           itemBuilder:(BuildContext context, int i){
//               return list[i];
//           },
//         ),
//       ),
//     );
//   }

//   Widget _renderImages() {

//   }
//   static Widget _container(Color color) {
//     return new Container(
//       decoration: BoxDecoration(color: color,
      
//       ),
//       height: 150.0,
//       width: double.infinity,
//     );
//   }

//   Widget _takePhoto(AppBloc bloc) {
//     return Center(
//       child: new IconButton(icon: Icon(Icons.photo_camera),
//        onPressed: () async{
//          debugPrint("UNOOOOOOOOOOOO");
//         File image = await ImagePicker.pickImage(
//           source: ImageSource.camera
//         );
//         debugPrint("DOSSSSSSSSSSSSSS");
//         setState(() {
//           if(elCount == 1){
//             list.add(Image.file(image));
//             elCount = elCount + 1;
//           }else if(elCount == 2){
//             list.add(Image.file(image));
//           }
//         });
//         debugPrint("TRESSSSSSSSSSSSS");
//        }// on press
//        )
//     );
//   }
//   //TODO: add actions complete a las totadas
//   Widget _showGroupName(AppBloc bloc, BuildContext context) {

//       if(bloc.hero.groupName == null){
//         Future.delayed(Duration(seconds: 1)).then((value){
//           Scaffold.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Conocer el nombre de tu equipo nos ayuda muchisimo"),
//           action: SnackBarAction(onPressed: (){
//             //AlertDialog(
//             //  actions: <Widget>[],
//             //);
//           }
//           , label: "Añadir" ),
//         )
//       );
//         });
//           return Center(child: Text("No nos dijiste como se llama tu grupo heroes",
//           style: TextStyle(
//             color: Colors.red
//           ),
//           ));
          
//       }
//       Future.delayed(Duration(milliseconds: 500)).then((value){
//       Scaffold.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Si cambiaste de grupo , cambialo en las configuraciones"),
//           action: SnackBarAction(onPressed: (){
//             Scaffold.of(context).hideCurrentSnackBar();
//           }
//           , label: "Ok" ),
//         )
//       );
//       });
//       return Center(child: Text("Bienvenido miembro de ${bloc.hero.groupName}, nos alegra tenerte de nuevo!"));
//   }
// }