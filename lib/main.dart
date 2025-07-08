import 'package:desktopme/core/configs/routes/name_route.dart';
import 'package:desktopme/core/configs/routes/routes.dart';
import 'package:desktopme/feature/auth/bloc/auth_bloc.dart';
import 'package:desktopme/feature/todo/bloc/todo_bloc.dart';  
import 'package:desktopme/shared/services/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  sqfliteFfiInit(); // Required for SQLite FFI on desktop
  databaseFactory = databaseFactoryFfi;
  WindowOptions windowOptions = const WindowOptions(
    size: Size(1000, 700),
    center: true,
    backgroundColor: Color.fromRGBO(0, 0, 0, 0),
    windowButtonVisibility: true,
  );
  await LoggerService.init();
  LoggerService.logger.i("App started"); // Initialize logger before anything
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setMinimumSize(const Size(600, 800));
    await windowManager.setMaximumSize(const Size(1600, 1200));
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (BuildContext context) => AuthBloc()),
           BlocProvider<TodoBloc>(create: (BuildContext context) => TodoBloc()),
      ],
      child: MaterialApp(
          title: 'Desktop App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          initialRoute: AppNameRoutes.splashPage,
          onGenerateRoute: AppRoutes.generateRoute,
        ),
    );
  }
}
