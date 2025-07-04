import 'dart:convert';
import 'dart:developer';
 
import 'package:desktopme/feature/auth/domain/user_model.dart';
import 'package:desktopme/shared/services/logger_service.dart';
import 'package:desktopme/shared/services/storage/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

 
class SessionController {
  static final _session = SessionController._internal();
  LocalStorage storage = LocalStorage();
    UserModel userDataModel = UserModel(email: '',password: '');
  bool? isLogin;
  
  SessionController._internal() {
    isLogin = false; 
  }
  factory SessionController() {
    return _session;
  }

  Future<void> saveUserPreference(dynamic userData) async {
    await storage.setData(key: 'userData', value: jsonEncode(userData));
    await storage.setData(key: 'isLogin', value: jsonEncode(true)); 
  }

  Future<void> getUserPreference() async {
    try {
      final onValue = await storage.getData(key: 'userData');
      if (onValue != null && onValue.isNotEmpty) {
        SessionController().userDataModel = UserModel.fromJson(
          jsonDecode(onValue),
        );
        log(
          "${SessionController().userDataModel.id} id token ",
        );
      }
      final myLogin = (await storage.getData(key: 'isLogin'))?.toString(); 
      SessionController().isLogin = myLogin == 'true'; 
    } catch (e) {
      print("Error: $e"); 
LoggerService.logger.e("Failed to get data");

    }
  }
   
   
  
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData'); 
    await prefs.remove('isLogin'); 
  }
}