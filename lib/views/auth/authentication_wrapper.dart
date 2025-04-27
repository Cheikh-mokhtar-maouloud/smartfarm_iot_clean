import 'package:flutter/material.dart';
import 'package:smartfarm_iot1/controllers/auth_controller.dart';
import 'package:smartfarm_iot1/views/auth/login_screen.dart';
import 'package:smartfarm_iot1/views/main_screen.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Vous pouvez utiliser StreamBuilder ici si vous utilisez Firebase Auth
    return StreamBuilder(
      stream: AuthController().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MainScreen();
        }
        return const LoginScreen();
      },
    );
  }
}