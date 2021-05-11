import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/main_screen.dart';
import 'package:chatapp/screens/contacts_screen.dart';
import 'package:chatapp/screens/profile_screen.dart';
import 'package:chatapp/screens/registration_screen.dart';
import 'package:chatapp/screens/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/route_generator.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case MainScreen.routeName: return MaterialPageRoute(builder: (_) => MainScreen());
      case ChatScreen.routeName: return MaterialPageRoute(builder: (_) => ChatScreen(chatRoom: args,));
      case LoginScreen.routeName: return MaterialPageRoute(builder: (_) => LoginScreen());
      case RegistrationScreen.routeName: return MaterialPageRoute(builder: (_) => RegistrationScreen());
      case ContactsScreen.routeName: return MaterialPageRoute(builder: (_) => ContactsScreen());
      case SearchScreen.routeName: return MaterialPageRoute(builder: (_) => SearchScreen());
      case ProfileScreen.routeName: return MaterialPageRoute(builder: (_) => ProfileScreen());
      default: return MaterialPageRoute(builder: (_) => Text('error'));
    }
  }
}