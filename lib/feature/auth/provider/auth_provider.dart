import 'dart:developer';

import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/configs/routes/routes.dart';
import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/auth/data/auth_local_db.dart';
import 'package:desktopme/feature/auth/domain/user_model.dart';
import 'package:desktopme/shared/services/logger_service.dart';
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

  bool isLoading = false;
  bool signInStatus = false;
  Future<void> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      signInStatus = true;
      notifyListeners();
      print(signInStatus.toString());
      final retrunUserResult = await _authDataSource.signInnUser(
        email,
        password,
      );
      Future.delayed(Duration(seconds: 2), () {});
      if (retrunUserResult == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text('⚠️ Invalid User'),
          ),
        );
        LoggerService.logger.e("Invalid User");
        signInStatus = false;
        notifyListeners();
      } else {ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.green,
            content: Text('✅ User SignIn successfully'),
          ),
        );
        LoggerService.logger.e("User SignIn successfully");
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
        
      }
    } catch (e) {
      signInStatus = false;
      notifyListeners();
      debugPrint(signInStatus.toString());

      LoggerService.logger.e("login catch error $e");
    }
  }

  bool signUpStatus = false;

  Future<void> userSignUp({
    required BuildContext context,
    required String email,
    required String password
  }) async {
    try {
      signUpStatus = true;
      notifyListeners();
      print(signUpStatus.toString());
      final userInsertResult = await _authDataSource.insertUser(email: email, password: password);
      Future.delayed(Duration(seconds: 2), () {});
      if (userInsertResult) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.green,
            content: Text('✅ User registered successfully'),
          ),
        );
        LoggerService.logger.e("User registered successfully");

        signUpStatus = false;selectedTab=0;
        notifyListeners();
 
        if (kDebugMode) {
          print(signUpStatus.toString());
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.error,
            content: Text('⚠️ User already registered'),
          ),
        );
        LoggerService.logger.e("User already registered");
        signUpStatus = false;
        notifyListeners();
      }
    } catch (e) {
      signUpStatus = false;
      notifyListeners();
      debugPrint(signUpStatus.toString());

      LoggerService.logger.e("signup error $e");
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      await SessionController().logout();
      SessionController().userDataModel = UserModel(email: '', password: '');
      SessionController().isLogin = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.green,
          content: Text('✅ User Logout successfully'),
        ),
      );
      Navigator.pushReplacementNamed(context, AppNameRoutes.mainUi);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
      debugPrint('Logout error: $e');
      LoggerService.logger.e("logout error $e");
    }
  }
}
