import 'package:flutter/material.dart';
import 'package:form_helpers/form_helpers.dart';
import 'package:subabase_auth/controller/supabase_auth.dart';
import 'package:subabase_auth/views/pages/auth_page.dart';
import 'package:subabase_auth/views/pages/supabase_storage_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SupabaseAuth _auth = SupabaseAuthImplementation();

  @override
  Widget build(BuildContext context) {
    final String name = _auth.getCurrentUser()?.userMetadata?['name'];
    final String email = _auth.getCurrentUser()?.userMetadata?['email'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const AuthPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome $name'),
            const SizedBox(height: 20),
            Text('Welcome $email'),
            const SizedBox(height: 50),
            CustomButton(
              buttonLabel: 'Try Supabase Storage',
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SupabaseStoragePage(userName: name),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
