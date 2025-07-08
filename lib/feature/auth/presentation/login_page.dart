import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/auth/bloc/auth_bloc.dart';
import 'package:desktopme/feature/auth/bloc/bloc_event.dart';
import 'package:desktopme/feature/auth/bloc/bloc_state.dart'; 
import 'package:desktopme/shared/components/customfield_component.dart';
import 'package:desktopme/shared/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailC = TextEditingController();

  final passwordC = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          CustomFieldComponents(
            hint: 'enter a email',
            controller: emailC,
            onTapOutside: (p0) {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            onChanged: (val) {
              BlocProvider.of<AuthBloc>(
                context,
              ).add(EmailChangeEvent(email: val));
            },
            validator: (v) {
              if (v!.isEmpty) {
                return 'feild Must not be Empty';
              }
              return null;
            },
          ),
          SizedBox(height: 12),
          Text(
            'Password',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 8),
          CustomFieldComponents(
            onChanged: (val) {
              BlocProvider.of<AuthBloc>(
                context,
              ).add(PasswordChangeEvent(password: val));
            },
            onTapOutside: (p0) {
              FocusManager.instance.primaryFocus!.unfocus();
            },
            hint: 'enter a password',
            validator: (v) {
              if (v!.isEmpty) {
                return 'feild Must not be Empty';
              }
              return null;
            },
            controller: passwordC,
            obscureText: true,
          ),
          SizedBox(height: 30),

          Center(
            child: BlocBuilder<AuthBloc, AuthSate>(
              builder: (BuildContext context, state) {
                return PrimaryButton(
                  onTap: state.apiStatus == StatusApp.Loading
                      ? () {
                          print('object');
                        }
                      : () async {
                          if (formKey.currentState!.validate()) {
                            // await Provider.of<AuthProvider>(
                            //   context,
                            //   listen: false,
                            // ).login(
                            //   context: context,
                            //   email: emailC.text.trim().toString(),
                            //   password: passwordC.text.trim().toString(),
                            // );

                            BlocProvider.of<AuthBloc>(
                              context,
                            ).add(LoginSubmitButtonEvent());
                          } else {}
                        },
                  childWidget: state.apiStatus == StatusApp.Loading
                      ? Center(
                          child: CircularProgressIndicator.adaptive(
                            backgroundColor: AppColors.white,
                          ),
                        )
                      : Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.white,
                          ),
                        ),
                  elevation: 0,
                  gradient: const LinearGradient(
                    colors: [AppColors.purple, AppColors.lightPurple],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  height: 52,
                  width: 355,
                  borderRadius: 100,
                  bgColor: Colors.transparent,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
