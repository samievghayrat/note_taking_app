import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_firebase/main.dart';
import 'package:new_firebase/utils.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResentEmail = false;
  Timer? timer;

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();

      setState(() {
        canResentEmail = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResentEmail = true;
      });
    } catch (error) {
      Utils.showSnackBar(error.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A verification email has been sent to you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.green),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color.fromARGB(255, 11, 73, 13)),
                  onPressed: canResentEmail ? sendVerificationEmail : null,
                  icon: const Icon(Icons.email_outlined),
                  label: const Text(
                    'Resent Email',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),
        );
}
