import 'package:desktopme/core/configs/colors/app_colors.dart';
import 'package:desktopme/core/configs/routes/routes.dart';
import 'package:desktopme/shared/services/sessionManger/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
 SessionController().getUserPreference();
    Future.delayed(const Duration(seconds: 3), ()  {
       SessionController().isLogin == true
          ? Navigator.pushReplacementNamed(context, AppNameRoutes.home)
          : Navigator.pushReplacementNamed(context, AppNameRoutes.mainUi);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SpinKitSquareCircle(color: AppColors.lightPurple, size: 66.0),
          Center(
            child: Text(
              'Goritmi',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
