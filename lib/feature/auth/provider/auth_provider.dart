import 'dart:developer';

import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/configs/routes/routes.dart';
import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/auth/data/auth_local_db.dart';
import 'package:desktopme/feature/auth/domain/user_model.dart';
import 'package:desktopme/shared/services/sessionManger/session_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  LocalAuthDataSource _authDataSource = LocalAuthDataSource();
 

  int selectedTab = 0;
  void updateTab(int index) {
    selectedTab = index;
    notifyListeners();
  }
  bool isLoading=false;
 bool signInStatus = false;
  Future<void> login({required String email,required String password, required BuildContext context,}) async {
    try {
      signInStatus = true;
      notifyListeners();
      print(signInStatus.toString());
      final retrunUserResult = await _authDataSource.signInnUser(email,password);
      Future.delayed(Duration(seconds: 2), () {});
      if (retrunUserResult != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: AppColors.green,content: Text('✅ User SignIn successfully')),
        );
        await SessionController().saveUserPreference(retrunUserResult);
        await SessionController().getUserPreference();
        signInStatus = false;
        notifyListeners();
        if (kDebugMode) {
          print("${retrunUserResult.id} this is user id");
        }
        Navigator.pushReplacementNamed(context, AppNameRoutes.home);
        if (kDebugMode) {
          print(signInStatus.toString());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text('⚠️ Invalid User')),
        );
        signInStatus = false;
        notifyListeners();
      }
    } catch (e) {
      signInStatus = false;
      notifyListeners();
      debugPrint(signInStatus.toString());
       
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  bool signUpStatus = false;

  Future<void> userSignUp({
    required BuildContext context,
    required UserModel user,
  }) async {
    try {
      signUpStatus = true;
      notifyListeners();
      print(signUpStatus.toString());
      final userInsertResult = await _authDataSource.insertUser(user);
      Future.delayed(Duration(seconds: 2), () {});
      if (userInsertResult != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: AppColors.green,content: Text('✅ User registered successfully')),
        );
        await SessionController().saveUserPreference(userInsertResult.user);
        await SessionController().getUserPreference();
        signUpStatus = false;
        notifyListeners();
        if (kDebugMode) {
          print("${userInsertResult.user!.id} this is user id");
        }
        Navigator.pushReplacementNamed(context, AppNameRoutes.home);
        if (kDebugMode) {
          print(signUpStatus.toString());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text('⚠️ User already registered')),
        );
        signUpStatus = false;
        notifyListeners();
      }
    } catch (e) {
      signUpStatus = false;
      notifyListeners();
      debugPrint(signUpStatus.toString());
       
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  Future<void>  logout(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await SessionController().logout();
      SessionController().userDataModel = UserModel(email: '', password: '');
      SessionController().isLogin = false;ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: AppColors.green,content: Text('✅ User Logout successfully')),
        );
         Navigator.pushReplacementNamed(context, AppNameRoutes.mainUi);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Logout error: $e');
    }
  }
}
