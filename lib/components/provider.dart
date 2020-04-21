import 'package:glaksoalcovid/bloc/Login.dart';
import 'package:glaksoalcovid/components/App.dart';

//TODO: convertirlo la "raiz del arbol" para obtener los blocs
class Provider extends InheritedWidget {
  final FormBloc formBloc = new FormBloc();
  AppBloc app = new AppBloc();
  static Provider _instancia;
  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._(
        key: key,
        child: child,
      );
    }
    return _instancia;
  }
  Provider._({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: Crear una logica mas "compleja"
    return true;
  }

  static FormBloc ofForm(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Provider>().formBloc;

  static HeroModel ofHeroModel(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Provider>().app.hero;
  static AppBloc ofAppBloc(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Provider>().app;
}
