import 'package:glaksoalcovid/components/App.dart';
import 'package:glaksoalcovid/components/provider.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  return runApp(Provider(child: new App(theme: new ThemeData())));
}
