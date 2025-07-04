import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future<bool> setData({required String key, required String value}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  Future<String?> getData({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<bool> deleteData({required String key}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}