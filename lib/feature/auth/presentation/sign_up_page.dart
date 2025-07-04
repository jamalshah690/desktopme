import 'dart:developer';

import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/auth/domain/user_model.dart';
import 'package:desktopme/feature/auth/provider/auth_provider.dart';
import 'package:desktopme/shared/components/customfield_component.dart';
import 'package:desktopme/shared/components/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
            hint: 'enter a password',
            controller: passwordC,
            obscureText: true,
            validator: (v) {
              if (v!.isEmpty) {
                return 'feild Must not be Empty';
              }
              return null;
            },
          ),
          SizedBox(height: 30),

          Center(
            child: Consumer<AuthProvider>(
              builder: (builder, c, cd) {
                return PrimaryButton(
                  onTap: c.isLoading
                      ? () {
                        print('object');
                      }
                      : () async {
                        
    if (formKey.currentState!.validate()) {
      
        await Provider.of<AuthProvider>(context, listen: false).userSignUp(

        context: context,
         email: emailC.text.trim().toString(),
        password: passwordC.text.trim().toString(),  
      );
    }
 
                        },
                  childWidget: Consumer<AuthProvider>(
                    builder: (builder, val, child) {
                      return val.signUpStatus==true?
                           Center(child: CircularProgressIndicator.adaptive(backgroundColor: AppColors.white,))
                          : Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.white,
                              ),
                            );
                    },
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
