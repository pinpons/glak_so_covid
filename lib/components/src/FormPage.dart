import 'package:glaksoalcovid/bloc/Login.dart';
import 'package:glaksoalcovid/components/App.dart';
import 'package:glaksoalcovid/components/work.dart';
import 'package:progress_dialog/progress_dialog.dart';

import '../provider.dart';

ProgressDialog pr;

class FormPage extends StatelessWidget {
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
                Text('Registrando Heroe 🔥', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _inputName(bloc),
                SizedBox(height: 30.0),
                _inputCarnet(bloc),
                SizedBox(height: 30.0),
                _inputPasswd(bloc),
                SizedBox(height: 30.0),
                CheckBoxTile(
                    icon: Icon(Icons.settings_applications),
                    text:
                        "¿Quieres que te pida la contraseña cada vez que abras al app?",
                    handler: (value) {
                      Provider.ofHeroModel(context).getPasswd =
                          value ? true : false;
                      //print("@@@@@@@@ HNDLE ${Provider.ofHeroModel(context).getPasswd.runtimeType}");
                      return Provider.ofHeroModel(context).getPasswd;
                    }),
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

  Widget _inputName(FormBloc bloc) {
    return StreamBuilder(
      stream: bloc.createsname().nameStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
                  hintText: 'El Puto Amo',
                  labelText: 'Nombre del heroe',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: bloc.addName),
        );
      },
    );
  }

  Widget _inputCarnet(FormBloc bloc) {
    return StreamBuilder(
      stream: bloc.createsNumcarnet().numCarnetStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                icon: Icon(Icons.assignment_ind, color: Colors.deepPurple),
                hintText: '12345678',
                labelText: 'Número de carnet',
                counterText: null,
                errorText: snapshot.error),
            onChanged: bloc.addCarnet,
          ),
        );
      },
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
                // counterText: snapshot.data,
                errorText: snapshot.error),
            onChanged: bloc.addPassword,
          ),
        );
      },
    );
  }

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
            onPressed:
                snapshot.data == "ready" ? onPress(bloc, context) : null);
      },
    );
  }

  Function onPress(FormBloc bloc, BuildContext context) {
    return () {
      Map data = <String, dynamic>{
        "name": bloc.nameValue,
        "password": bloc.passwdValue,
        "carnet": bloc.carnetValue,
        "get_passwd": bool2int(Provider.ofHeroModel(context).getPasswd)
      };
      bloc.auth = true;
      new AppBloc().hero.name = bloc.nameValue;
      bloc
        ..passwordClose
        ..numCarnetClose
        ..nameClose;
      pr.show();
      new StorageProvider().database.then((database) {
        // CREATE TABLE heroe(id_meta INTEGER DEFAULT $userNewIndentificador ,name TEXT,uuid_movil TEXT,
        // verificado integer DEFAULT 0,password TEXT,get_passwd integer DEFAULT 0,
        // foto TEXT,group_name TEXT,new INTEGER DEFAULT 1)
        pr.hide().whenComplete(() async {
          await database.update("heroe", data,
              where: "id_meta = ?",
              whereArgs: [StorageProvider().userNewIndentificador]);
          //Navigator.pushReplacementNamed(context, "/works");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => WorkPageTabs()),
            (Route<dynamic> route) => false,
          );
          return 0;
        });
      });
      //pr.hide().whenComplete(()async
      //{
      //  await new StorageProvider().database;
      //  return 0;
      //});
    };
  }
}

class CheckBoxTile extends StatefulWidget {
  final Icon icon;
  final String text;
  final Function(bool) handler;
  CheckBoxTile({this.icon, this.text, this.handler, Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
      _CheckBoxTile(text: this.text, icon: this.icon, handler: this.handler);
}

class _CheckBoxTile extends State<CheckBoxTile> {
  final Icon icon;
  final String text;
  final Function(bool) handler;
  bool check = false;
  _CheckBoxTile({this.icon, this.text, this.handler});

  @override
  Widget build(BuildContext context) {
    Provider.ofHeroModel(context).getPasswd = check;
    return CheckboxListTile(
      title: Text(this.text),
      value: check,
      onChanged: (bool value) {
        // print("@@@@@@@@ INTO ${handler(value).runtimeType}");
        setState(() {
          check = handler(value);
          //Provider.ofHeroModel(context).getPasswd = value ? true : false;
        });
      },
      secondary: this.icon,
    );
  }
}
