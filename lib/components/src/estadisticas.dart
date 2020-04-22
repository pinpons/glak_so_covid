

import 'package:glaksoalcovid/components/App.dart';

//TODO: complete more pretty
class Estadisticas extends StatelessWidget{
  AppBloc bloc = new AppBloc();
  @override
  Widget build(BuildContext context) {
    return Column(
      children:<Widget>[
        Row(children: <Widget>[Text("Aqui deberia ir la foto"),Text(bloc.hero.name)],),
        getEstadisticas()
      ]
    );

  }
    Widget getEstadisticas() {
      return FutureBuilder(
        future: new StorageProvider().getSum(),
        builder: (BuildContext ctx,AsyncSnapshot<int> snapshot){
          if(snapshot.hasData){
            int res = snapshot.data;
            return  Text("Hiciste $res");
          }
          return Center(child: new CircularProgressIndicator(),);

        },

      );
    }
}