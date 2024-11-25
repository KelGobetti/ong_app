import 'package:flutter/material.dart';
import 'package:ong_app/controllers/bottom_app_bar_controller.dart';
import 'package:ong_app/controllers/filter_city_controller.dart';
import 'package:ong_app/controllers/ong_category_controller.dart';
import 'package:ong_app/controllers/ong_controller.dart';
import 'package:ong_app/controllers/user_controller.dart';
import 'package:ong_app/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
import 'controllers/filter_ong_category_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controllers/ong_approval_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => BottomAppBarController(),),
      ChangeNotifierProvider(create: (context) => OngController(),),
      ChangeNotifierProvider(create: (context) => FilterOngCategoryController(),),
      ChangeNotifierProvider(create: (context) => FilterCityController(),),
      ChangeNotifierProvider(create: (context) => UserController(),),
      ChangeNotifierProvider(create: (context) => OngCategoryController(),),
      ChangeNotifierProvider(create: (context) => OngApprovalController(),),
    ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ong app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
        )
      ),
      home: const WelcomeScreen(),
    );
  }
}





















