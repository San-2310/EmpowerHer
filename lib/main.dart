import 'package:empower_her/firebase_options.dart';
import 'package:empower_her/views/auth_screens/auth_screens.dart';
import 'package:empower_her/views/main_layout_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/translation_controller.dart';
import 'controllers/tts_controller.dart';
import 'providers/user_provider.dart';

// import 'providers/empowerher_user_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // await populateCourses();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => EmpowerHerUserProvider()),
        ChangeNotifierProvider(create: (_) => TranslationController()),
        ChangeNotifierProvider(create: (_) => TTSController()),
      ],
      child: Consumer<EmpowerHerUserProvider>(
        builder: (context, userProvider, _) {
          if (!userProvider.isDataLoaded) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp(
            title: 'EmpowerHer',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Poppins',
              primarySwatch: Colors.indigo,
            ),
            home: userProvider.isAuthenticated
                ? const MainLayoutScreen()
                : const LoginScreen(),
          );
        },
      ),
    );
  }
}
