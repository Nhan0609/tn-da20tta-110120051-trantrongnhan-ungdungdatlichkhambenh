import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:koruko_app/utils/router/router.dart';
import 'package:loader_overlay/loader_overlay.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBwb0-3mLRDhh1InmP1CcECCv7jOsRNl9s',
      appId: "1:894916554858:web:8324d8b93fd3511083da13",
      messagingSenderId: "894916554858",
      projectId: "okuro-c7cb8",
      storageBucket: "okuro-c7cb8.appspot.com",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
