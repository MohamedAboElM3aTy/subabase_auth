import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  final String email;
  final String password;
  final String? name;

  const AppUser({
    required this.email,
    required this.password,
    this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}
