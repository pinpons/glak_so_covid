import 'package:glaksoalcovid/bloc/Login.dart';
import 'package:glaksoalcovid/components/App.dart';
import 'package:glaksoalcovid/components/src/FormPage.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:sqflite/sqflite.dart';

import '../provider.dart';
import '../work.dart';

class CheckPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, isDismissible: false);
    //HeroModel heroe = Provider.ofHeroModel(context);
    pr.style(message: "Por favor espere ...");
    return new Stack(
      children: <Widget>[_crearFondo(context), _crearForm(context)],
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final fondoModaro = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(63, 63, 156, 1.0),
        Color.fromRGBO(90, 70, 178, 1.0)
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        fondoModaro,
        Positioned(top: 90.0, left: 30.0, child: circulo),
        Positioned(top: -40.0, right: -30.0, child: circulo),
        Positioned(bottom: -50.0, right: -10.0, child: circulo),
        Positioned(bottom: 120.0, right: 20.0, child: circulo),
        Positioned(bottom: -50.0, left: -20.0, child: circulo),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon(Icons.person_pin_circle, color: Colors.white, size: 100.0),
              SizedBox(height: 10.0, width: double.infinity),
              Text("lak'so al coronavairus",
                  style: TextStyle(color: Colors.white, fontSize: 25.0)),
            ], //TODO: dar espacio entrel el form
          ),
        )
      ],
    );
  }

  Widget _crearForm(BuildContext context) {
    final bloc = Provider.ofForm(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 180.0,
            ),
          ),

          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text('Hola de nuevo, Heroe 🔥',
                    style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _inputPasswd(bloc),
                SizedBox(height: 30.0),
                _crearBoton(bloc)
              ],
            ),
          ),

          //FlatButton(
          //  child: Text('¿Ya tienes cuenta? Login'),
          //  onPressed: ()=> Navigator.pushReplacementNamed(context, 'login'),
          //),
          SizedBox(height: 100.0)
        ],
      ),
    );
  }

  Widget _inputPasswd(FormBloc bloc) {
    return StreamBuilder(
      stream: bloc.createspasswd().passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              obscureText: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  icon: Icon(Icons.security, color: Colors.deepPurple),
                  hintText: 'lk12u3891uhn1 raras',
                  labelText: 'Contraseña',
                  //counterText: bloc.domicilioValue == "ready!12345678" ? "OK, presiona el boton":null,
                  errorText: snapshot.error),
              onChanged: (String val) async {
                if (val.length < 8) {
                  bloc.addPassword(val, "Contraseña Invalida");
                  bloc.domicilioAdd("23132131211 asd");
                } else {
                  bloc.addPassword(val);
                  Database db = await StorageProvider().database;
                  var res = await db.query("heroe",
                      where: "password = ?",
                      whereArgs: [val],
                      columns: ["id_meta"]);
                  if (res.isNotEmpty) {
                    bloc.auth = true;
                    print("LOGIN");
                    bloc.domicilioAdd("ready!12345678");
                  }
                }
              } // onChange ,
              ),
        );
      },
    );
  }
  //TODO: añadir un mensajito de ok passwd
  Widget _crearBoton(FormBloc bloc) {
    return StreamBuilder(
      stream: bloc.createsDomicilo().domicilioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text('Ingresar'),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0.0,
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed: snapshot.data == "ready!12345678"
                ? () {
                    bloc
                      ..nameClose
                      ..passwordClose;
                   //  Navigator.pushReplacementNamed(context, "/works");
                   Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WorkPageTabs()),
        (Route<dynamic> route) => false,
        );
                  }
                : null);
      },
    );
  }
}
