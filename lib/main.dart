import 'package:flutter/material.dart';
import 'package:frontend/presentation/pages/login_screen.dart';
import 'package:frontend/presentation/pages/signup_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/router/app_router.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
       routerConfig:  appRouter,
       debugShowCheckedModeBanner: false,
      theme: ThemeData(
         
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      
        useMaterial3: true,
      ),
   
    );
  }
}

