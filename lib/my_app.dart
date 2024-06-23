import 'package:flutter/material.dart';
import 'package:subabase_auth/views/pages/auth_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Supabase Auth',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurpleAccent,
        ),
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const AuthPage(),
    );
  }
}
