import 'package:desktopme/core/enums/view_state.dart';
import 'package:equatable/equatable.dart';

class AuthSate extends Equatable {
  AuthSate({this.selectedTab = 0, this.email = '', this.password = '',this.apiStatus=StatusApp.initializing , this.isLoginSide=false });
  final int selectedTab;
  final String email;
  final String password; 
final StatusApp apiStatus;
final bool isLoginSide;
  AuthSate copyWith({int? selectedTab, String? email, String? password, StatusApp? apiStatus,bool? isLoginSide}) {
    return AuthSate(
      selectedTab: selectedTab ?? this.selectedTab,
      email: email ?? this.email,
      password: password ?? this.password,
      apiStatus:  apiStatus?? this.apiStatus,
       isLoginSide: isLoginSide??this.isLoginSide
    );
  }

  @override
  List<Object?> get props => [selectedTab, email, password,apiStatus,isLoginSide];
}
