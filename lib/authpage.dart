import 'package:flutter/material.dart';
import 'package:new_firebase/login.dart';
import 'package:new_firebase/signup.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginWidget(
          onClickedSignUp: toggle,
        )
      : SignUpWidget(
          onClickedSignUp: toggle,
        );

  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
