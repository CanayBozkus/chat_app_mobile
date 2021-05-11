import 'package:chatapp/route_generator.dart';
import 'package:chatapp/screens/main_screen.dart';
import 'package:chatapp/services/database.dart';
import 'package:chatapp/utilities/constants.dart';
import 'package:chatapp/services/sharedPreference.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:chatapp/utilities/general_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await getPreference();
  await databaseManager.initializeDatabase();

  await Permission.contacts.request();
  runApp(MyApp(pref: pref,));
}

class MyApp extends StatelessWidget {
  final SharedPreferences pref;
  MyApp({this.pref});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GeneralProvider>(create: (_) => GeneralProvider()),
      ],
      child: MaterialApp(
        onGenerateRoute: RouteGenerator.generateRoute,
        initialRoute: pref.containsKey('jwt-token') ? 'MainScreen' : 'LoginScreen',
      ),
    );
  }
}
