import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _keyUserId = 'user_id';

  static Future<void> saveUserId(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_keyUserId, userId);
  }

  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }
}
