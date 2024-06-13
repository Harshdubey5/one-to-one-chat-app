import 'package:chat/auth/auth_services.dart';
import 'package:chat/widgets/button.dart';
import 'package:chat/widgets/textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();

  // tap to go to login page
  final void Function()? onTap;

  RegisterPage({
    super.key,
    required,
    required this.onTap,
  });

  void register(BuildContext context) {
    // get auth service
    final _auth = AuthService();

    // password match (create a user)
    if (_pwController.text == _confirmPwController.text) {
      try {
        _auth.signUpWithEmailPassword(
          _emailController.text,
          _pwController.text,
        );
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }
    // password don't match (tell user to fix)

    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Password doesn\'t match'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.message,
              size: 60,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 50),
            Text(
              'Let\'s create an account for you',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 25),

            // email

            MyTextField(
              obscureText: false,
              hintText: 'Email',
              controller: _emailController,
            ),
            const SizedBox(height: 10),

            // password

            MyTextField(
              obscureText: true,
              hintText: 'Password',
              controller: _pwController,
            ),
            const SizedBox(height: 10),

            // confirm password

            MyTextField(
              obscureText: true,
              hintText: 'Confirm Password',
              controller: _confirmPwController,
            ),
            const SizedBox(height: 25),

            // login button

            MyButton(
              text: 'Register',
              onTap: () => register(context),
            ),
            const SizedBox(height: 25),

            // register button

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already an user? ',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login now',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
