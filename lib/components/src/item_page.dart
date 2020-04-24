

import 'package:glaksoalcovid/components/App.dart';

class ItemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
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
      body: Text("Prueba: $person_id"),
    );
  }
  
}