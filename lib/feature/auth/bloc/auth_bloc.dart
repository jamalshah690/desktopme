

import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/auth/bloc/bloc_event.dart';
import 'package:desktopme/feature/auth/bloc/bloc_state.dart';
import 'package:desktopme/feature/auth/data/auth_local_db.dart';
import 'package:desktopme/feature/auth/domain/user_model.dart';
import 'package:desktopme/shared/services/logger_service.dart';
import 'package:desktopme/shared/services/sessionManger/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<BaseAuthBloc,AuthSate >{
    LocalAuthDataSource _authDataSource = LocalAuthDataSource();

  AuthBloc( ):super(AuthSate(selectedTab: 0)){

    on<TabEvent>(_updateTab);
    on<EmailChangeEvent>(_inputEmailEvent);
    on<PasswordChangeEvent>(_inputPasswordEvent);
    on<LoginSubmitButtonEvent>(_login);
     on<SignUpSubmitButtonEvent>(_signUp);
      on<LogOutEvent>(_logout);     

  }

     _updateTab(TabEvent event, Emitter<AuthSate> emit  ) {
    emit(state.copyWith(selectedTab: event.selectedTab));
    print(' inside a bloc taab event');
    print(state.selectedTab.toString()+" "+event.selectedTab.toString());
     
  }
    

   _inputEmailEvent(EmailChangeEvent event, Emitter<AuthSate> emit){
    emit(state.copyWith(email: event.email));
    print(state.email+ " is typing");
   } 
    _inputPasswordEvent(PasswordChangeEvent event, Emitter<AuthSate> emit){
    emit(state.copyWith(password: event.password));
    print(state.password+ " is typing");
   } 

   _login(LoginSubmitButtonEvent event, Emitter<AuthSate> emit)async{

try { emit(state.copyWith(apiStatus: StatusApp.Loading,isLoginSide: true));
      final retrunUserResult = await _authDataSource.signInnUser(
        state.email,
        state.password,
        
      );
      Future.delayed(Duration(seconds: 2), () {});
      if (retrunUserResult == null) {
        
        LoggerService.logger.e("Invalid User");
       emit(state.copyWith(apiStatus: StatusApp.Error));
      } else {
        
       emit(state.copyWith(apiStatus: StatusApp.Completed));
        LoggerService.logger.e("User SignIn successfully");
        await SessionController().saveUserPreference(retrunUserResult);
        await SessionController().getUserPreference();
         
        
      }
    } catch (e) {
       
emit(state.copyWith(apiStatus: StatusApp.Error));
      LoggerService.logger.e("login catch error $e");
    }
   }

   _signUp(SignUpSubmitButtonEvent event, Emitter<AuthSate> emit)async{
try { emit(state.copyWith(apiStatus: StatusApp.Loading,isLoginSide: false));
      final retrunUserResult = await _authDataSource.insertUser(
       email:  state.email,
      password:   state.password,
      );
      
      if (retrunUserResult) {
        
        LoggerService.logger.i("User registered successfully");
       emit(state.copyWith(apiStatus: StatusApp.Completed));
       emit(state.copyWith(selectedTab: 0));
      } else {
        
       emit(state.copyWith(apiStatus: StatusApp.Error));
        LoggerService.logger.e("User already registered");
       
        
      }
    } catch (e) {
       
emit(state.copyWith(apiStatus: StatusApp.Error));
      LoggerService.logger.e("signUp catch error $e");
    }
   }
  _logout(LogOutEvent event, Emitter<AuthSate> emit)async{

  try {
       emit(state.copyWith(apiStatus: StatusApp.Loading));

      await SessionController().logout();
      SessionController().userDataModel = UserModel(email: '', password: '');
      SessionController().isLogin = false;
      
  emit(state.copyWith(apiStatus: StatusApp.Completed));
  
    } catch (e) {
      emit(state.copyWith(apiStatus: StatusApp.Error));
      debugPrint('Logout error: $e');
      LoggerService.logger.e("logout error $e");
    }
  }
}