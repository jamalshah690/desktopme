import 'package:equatable/equatable.dart';

abstract class BaseAuthBloc extends Equatable {
  @override
  List<Object?> get props => [];
}

class TabEvent extends BaseAuthBloc {
  TabEvent({required this.selectedTab});
  int selectedTab;

  @override
  List<Object?> get props => [selectedTab];

  
}
 
class EmailChangeEvent extends BaseAuthBloc{
  EmailChangeEvent({required this.email});
  String email;
    @override
  List<Object?> get props => [email];

}
class PasswordChangeEvent extends BaseAuthBloc{
  PasswordChangeEvent({required this.password});
  String password;
    @override
  List<Object?> get props => [password];

}


class LoginSubmitButtonEvent extends BaseAuthBloc{

}
class SignUpSubmitButtonEvent extends BaseAuthBloc{
  
}

class LogOutEvent extends BaseAuthBloc{}