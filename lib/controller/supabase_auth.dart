import 'package:flutter/material.dart';
import 'package:subabase_auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

abstract class SupabaseAuth {
  Future<User?> signUp(AppUser user);

  Future<User?> signIn(AppUser user);

  Future<void> signOut();

  Map<String, dynamic> logUserData();

  User? getCurrentUser();

  Future<User?> verifyOtp(String token, String email, OtpType type);
}

class SupabaseAuthImplementation implements SupabaseAuth {
  @override
  Future<User?> signUp(AppUser user) async {
    try {
      final userAuth = await supabase.auth.signUp(
        email: user.email,
        password: user.password,
        data: {
          'name': user.name,
        },
      );
      return userAuth.user;
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  @override
  Future<User?> signIn(AppUser user) async {
    try {
      final userAuth = await supabase.auth.signInWithPassword(
        email: user.email,
        password: user.password,
      );
      return userAuth.user;
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  @override
  Future<void> signOut() async => await supabase.auth.signOut();

  @override
  Map<String, dynamic> logUserData() => supabase.auth.currentUser!.toJson();

  @override
  Future<User?> verifyOtp(
    String token,
    String email,
    OtpType type,
  ) async {
    try {
      final supabaseResponse = await supabase.auth.verifyOTP(
        type: type,
        email: email,
        token: token,
      );
      return supabaseResponse.user;
    } on Exception catch (error) {
      debugPrint(error.toString());
    }
    return null;
  }

  @override
  User? getCurrentUser() => supabase.auth.currentUser;
}
