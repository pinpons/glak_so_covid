import 'package:flutter/material.dart';
import 'package:glaksoalcovid/bloc/AppBloc.dart';
import 'package:glaksoalcovid/components/src/FormPage.dart';
import 'package:glaksoalcovid/components/src/check.dart';
import 'package:glaksoalcovid/components/work.dart';
import 'package:glaksoalcovid/providers/db.dart';
export 'package:flutter/material.dart';
export 'package:glaksoalcovid/bloc/AppBloc.dart';
export 'package:glaksoalcovid/providers/db.dart';

class App extends StatelessWidget {
  final ThemeData theme;
  App({this.theme});
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: this.theme,
      routes: {
        "/": (context) => SafeArea(
                child: Scaffold(
              body: new FutureBuilder(
                future: new StorageProvider().isNewUser,
                builder: builder,
              ),
            )),
        "/form": (context) => new FormPage(),
        "/check": (context) => new CheckPage(),
        "/works": (context) => new WorkPageTabs(),
      },
      initialRoute: "/",
    );
  }

  Widget builder(BuildContext context, AsyncSnapshot<bool> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      debugPrint("@@@@@@@@@@@@@PUTO ERROR ${snapshot.data.runtimeType}");
      var appbloc = new AppBloc();
      print(appbloc.voyArenderizar);
      if (!snapshot.data ||
          appbloc.voyArenderizar == StatusRegisterHero.renderForm) {
        // render form is new user
        return new Container(child: new FormPage());
      } else if (appbloc.voyArenderizar == StatusRegisterHero.renderWork) {
        if (appbloc.hero.getPasswd) {
          // render checkout passwd
          return new Container(child: new CheckPage());
        } else {
          // render work area
          return new Container(child: new WorkPageTabs());
        }
      }
    }
    return new CircularProgressIndicator(); // TODO:marcar una pantalla de eres mi heroe
    //no lo dudes
  }
}
