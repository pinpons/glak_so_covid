import 'package:glaksoalcovid/components/App.dart';

class TranscriptionItem extends StatelessWidget {
  String fill;
  int indentificador;
  String ago;
  TranscriptionItem({this.fill, this.indentificador, this.ago});
  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: levelFillPerson(),
      title: Text("Identificador unico $indentificador"),
      subtitle: Text("Registrado $ago"),
      onTap: () {
        //Navigator.push();
      },
    );
  }

  Widget levelFillPerson() {
    if (fill == "complete") {
      return new Icon(
        Icons.local_gas_station,
        color: Colors.green[300],
      );
    } else if (fill == "medium") {
      return new Icon(Icons.local_gas_station, color: Colors.orange[300]);
    } else if (fill == "low") {
      return Icon(Icons.local_gas_station, color: Colors.yellow[200]);
    } else
      return new Icon(Icons.local_gas_station, color: Colors.red[300]);
  }
}
