import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/feature/auth/presentation/login_page.dart';
import 'package:desktopme/feature/auth/presentation/sign_up_page.dart';
import 'package:desktopme/feature/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
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
                  Consumer<AuthProvider>(
                    builder: (context, state, child) {
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
                  Consumer<AuthProvider>(
                    builder: (context, state, child) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    state.updateTab(0);
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: state.selectedTab == 0 ? 16 : 12,
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
                                    state.updateTab(1);
                                  },
                                  child: Text(
                                    'Sign Up',
                                    style: TextStyle(
                                      fontSize: state.selectedTab == 1 ? 16 : 12,
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
                       state.selectedTab==0?LoginPage():SignUpPage( ) ],
                      );
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
