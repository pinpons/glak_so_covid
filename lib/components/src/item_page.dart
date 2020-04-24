

import 'package:glaksoalcovid/bloc/Login.dart';
import 'package:glaksoalcovid/components/App.dart';

class ItemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ItemPageSatate();
  }
  
}

class ItemPageSatate extends State<ItemPage> {
  @override
  Widget build(BuildContext context) {
    int person_id = ModalRoute.of(context).settings.arguments;
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Aprovechando el tiempo libre")
      ),
      body: FutureBuilder(
        future: new StorageProvider().getPerson(person_id),
        builder: (BuildContext ctx, AsyncSnapshot<Map<String,dynamic>> snapshot) {
            if(snapshot.hasData)
            {
              return new ItemView(data: snapshot.data);
            }else{
              return Center(
                child: Column(
                  children: <Widget>[
                    Text("Obteniendo datos del elemento $person_id"),
                    LinearProgressIndicator()
                  ],
                ),
              );
            }
        },
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  Map<String,dynamic> data;
  FormBloc bloc;
  ItemView({@required this.data});
  @override
  Widget build(BuildContext context) {
    // TODO: hacerlo mas bonito
    bloc = new FormBloc();
    debugPrint("FOTO UNO: ${data['foto']}");
    debugPrint("FOTO dos: ${data['fotos']}");
    return new Container(
      child: new Container(
        child: Column(
          children: <Widget>[
            //_createImage(data["foto_uno"]),
            //_createImage(data["foto_dos"]),
            _createInputName(),
            _createInputCarnet(),
            _createInputDomicilio(),
            _createInputEn()
          ]
        )
      ),
    );
  }

  Widget _createInputName() {
    return StreamBuilder(
        stream: bloc.createsname().nameStream,
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                //icon:,
                //hintText: ,
                //labelText: ,
                //counterText ,
                //errorText: ,
              ),
              onChanged: (String value) {

              },
            ),
          );
        },
      );
  }
  
  Widget _createImage(String base64) {
    return new Image.memory(base64ImageToBytes(base64));
  }

  Widget _createInputEn() {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder(
        stream: bloc.createsEn().enStream,
        builder: (BuildContext ctx, AsyncSnapshot snapshot){
          return TextField(
            
            keyboardType: TextInputType.text,
            onChanged: (String value) {
              
            },
            decoration: InputDecoration(
              
              //errorText: ,
              //hintText: ,
              //counterText: ,
              //icon: ,
              //labelText: 
            ),
          );
        },
      ),
    );
  }
  Widget _createInputDomicilio() {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder(
        stream: bloc.createsDomicilo().domicilioStream,
        builder: (BuildContext ctx, AsyncSnapshot snapshot){
          return TextField(
            keyboardType: TextInputType.text,
            onChanged: (String value) {
              
            },
            decoration: InputDecoration(
              //errorText: ,
              //hintText: ,
              //counterText: ,
              //icon: ,
              //labelText: 
            ),
          );
        },
      ),
    );
  }
  Widget _createInputCarnet() {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: StreamBuilder(
        stream: bloc.createsNumcarnet().numCarnetStream,
        builder: (BuildContext ctx, AsyncSnapshot snapshot){
          return TextField(
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              
            },
            decoration: InputDecoration(
              //errorText: ,
              //hintText: ,
              //counterText: ,
              //icon: ,
              //labelText: 
            ),
          );
        },
      ),
    );
  }
}