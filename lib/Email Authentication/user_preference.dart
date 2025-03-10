import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{

  static const USER_ID_KEY = "uid";

  void setUID(String uid) async{
    var pref = await SharedPreferences.getInstance();
    // pref.setInt(USER_ID_KEY, uid);
    pref.setString(USER_ID_KEY, uid);

  }

  Future<String> getUID() async{
    var pref = await SharedPreferences.getInstance();
    // int? uid = pref.getInt(USER_ID_KEY);
    String? uid=pref.getString(USER_ID_KEY);
    return uid ?? "";
  }

}