import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences _pref;

Future<SharedPreferences> getPreference() async {
  if(_pref != null){
    return _pref;
  }
  SharedPreferences pref = await SharedPreferences.getInstance();
  _pref = pref;
  return _pref;
}