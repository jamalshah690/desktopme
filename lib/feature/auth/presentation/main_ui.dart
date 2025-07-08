import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/configs/routes/routes.dart';
import 'package:desktopme/core/enums/view_state.dart';
import 'package:desktopme/feature/auth/bloc/auth_bloc.dart';
import 'package:desktopme/feature/auth/bloc/bloc_event.dart';
import 'package:desktopme/feature/auth/bloc/bloc_state.dart';
import 'package:desktopme/feature/auth/presentation/login_page.dart';
import 'package:desktopme/feature/auth/presentation/sign_up_page.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class MainUi extends StatelessWidget {
  const MainUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.purple, AppColors.lightPurple],
        ),
      ),
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.transparent),
        backgroundColor: Colors.transparent,

        body: Padding(
          padding: EdgeInsets.only(top: 100, bottom: 100),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              width: 600,

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: AppColors.background,
              ),
              child: Column(
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 2),
                  BlocBuilder<AuthBloc, AuthSate>(
                    builder: (BuildContext context, state) {
                      return Text(
                        state.selectedTab == 0
                            ? 'Login to your account to explore about aur Desktop App'
                            : 'Sign Up to your account to explore about aur Desktop App',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 12),
                  BlocConsumer<AuthBloc, AuthSate>(
                    buildWhen: (previous, current) =>
                        current.email != previous.email ||
                        current.isLoginSide != previous.isLoginSide ||
                        current.password != previous.password ||
                        current.selectedTab != previous.selectedTab ||
                        previous.apiStatus != current.apiStatus &&
                            current.apiStatus != StatusApp.initializing,
                    builder: (context, state) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    BlocProvider.of<AuthBloc>(
                                      context,
                                    ).add(TabEvent(selectedTab: 0));
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: state.selectedTab == 0
                                          ? 16
                                          : 12,
                                      color: state.selectedTab == 0
                                          ? AppColors.KBlacks
                                          : AppColors.lightGrey,
                                      fontWeight: state.selectedTab == 1
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 60),
                              Flexible(
                                child: Container(
                                  width: 3,
                                  height: 40,

                                  alignment: Alignment.center,

                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.purple,
                                        AppColors.lightPurple,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 60),
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    BlocProvider.of<AuthBloc>(
                                      context,
                                    ).add(TabEvent(selectedTab: 1));
                                    print('object');
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: state.selectedTab == 1
                                          ? 16
                                          : 12,
                                      color: state.selectedTab == 1
                                          ? AppColors.KBlacks
                                          : AppColors.lightGrey,
                                      fontWeight: state.selectedTab == 1
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          state.selectedTab == 0 ? LoginPage() : SignUpPage(),
                        ],
                      );
                    },
                    listener: (BuildContext context, AuthSate state) {
                      if (state.apiStatus == StatusApp.Error) {
                        if (state.isLoginSide == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.error,
                              content: Text('⚠️ Invalid User'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.error,
                              content: Text('⚠️ User already registered'),
                            ),
                          );
                        } // 👇 Reset apiStatus to avoid re-trigger on tab switch
                        BlocProvider.of<AuthBloc>(context).emit(
                          state.copyWith(apiStatus: StatusApp.initializing),
                        );
                      } else if(state.apiStatus == StatusApp.Completed) {
                        if (state.isLoginSide == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.green,
                              content: Text('✅ User SignIn successfully'),
                            ),
                          );

                          Navigator.pushReplacementNamed(
                            context,
                            AppNameRoutes.home,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: AppColors.green,
                              content: Text('✅ User registered successfully'),
                            ),
                          );
                        } // 👇 Reset apiStatus to avoid re-trigger on tab switch
                        BlocProvider.of<AuthBloc>(context).emit(
                          state.copyWith(apiStatus: StatusApp.initializing),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
