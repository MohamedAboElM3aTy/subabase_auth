import 'dart:async';

import 'package:flutter/material.dart';
import 'package:form_helpers/form_helpers.dart';
import 'package:subabase_auth/controller/supabase_auth.dart';
import 'package:subabase_auth/models/user_model.dart';
import 'package:subabase_auth/views/pages/home_page.dart';
import 'package:subabase_auth/views/pages/otp_verify_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _nameController,
      _emailController,
      _passwordController;
  late final StreamSubscription<AuthState> _authStateSubscription;
  final SupabaseAuth _auth = SupabaseAuthImplementation();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _formKey = GlobalKey<FormState>();
    _authStateSubscription = supabase.auth.onAuthStateChange.listen(
      (event) {
        final session = event.session;
        if (session != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supabase Auth'),
      ),
      body: GenericForm(
        formKey: _formKey,
        firstNameController: _nameController,
        emailController: _emailController,
        passwordController: _passwordController,
        onSignupPressed: () async {
          if (_formKey.currentState!.validate()) {
            await _auth.signUp(
              AppUser(
                email: _emailController.text,
                password: _passwordController.text,
                name: _nameController.text,
              ),
            );
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OtpVerifyPage(
                  email: _emailController.text,
                ),
              ),
            );
          }
        },
        onLoginPressed: () async {
          if (_formKey.currentState!.validate()) {
            await _auth.signIn(
              AppUser(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
            _formKey.currentState!.reset();
            debugPrint(_auth.logUserData().toString());
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const HomePage(),
              ),
            );
          }
        },
      ),
    );
  }
}
