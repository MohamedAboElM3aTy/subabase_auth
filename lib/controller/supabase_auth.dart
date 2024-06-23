import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

abstract class SupabaseAuth {
  Future<User?> signUp(String email, String password, String userName);

  Future<User?> signIn(String email, String password);

  Future<void> signOut();

  Map<String, dynamic> fetchUserData();

  User? getCurrentUser();

  Future<User?> verifyOtp(String token, String email, OtpType type);
}

class SupabaseAuthImplementation implements SupabaseAuth {
  @override
  Future<User?> signUp(
    String email,
    String password,
    String userName,
  ) async {
    try {
      final userAuth = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': userName,
        },
      );
      return userAuth.user;
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  @override
  Future<User?> signIn(String email, String password) async {
    final userAuth = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return userAuth.user;
  }

  @override
  Future<void> signOut() async => await supabase.auth.signOut();

  @override
  Map<String, dynamic> fetchUserData() => supabase.auth.currentUser!.toJson();

  @override
  Future<User?> verifyOtp(
    String token,
    String email,
    OtpType type,
  ) async {
    try {
      final result =
          await supabase.auth.verifyOTP(type: type, email: email, token: token);
      return result.user;
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  @override
  User? getCurrentUser() => supabase.auth.currentUser;
}
