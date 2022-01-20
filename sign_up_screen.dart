import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './sign_in_screen.dart';
import './home_screen.dart';
import '../../services/auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  void _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      print('Empty');
      return;
    } else if (!email.contains('@')) {
      print('Invalid');
      return;
    } else if (password.length < 6) {
      print('Less than 6');
      return;
    } else if (confirmPassword != password) {
      print('Not equal');
      return;
    } else {
      print('Now Sign up');
      final AuthBase auth = Provider.of<AuthBase>(context, listen: false);

      try {
        await auth.createUserWithEmailAndPassword(email, password);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      } on Exception catch (e) {
        // TODO
        print(e);

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(
            16.0,
          ),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Spacer(),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Spacer(),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      gapPadding: 10,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      gapPadding: 10,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                      gapPadding: 10,
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                  onPressed: _signUp,
                  child: Text('Sign Up'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => SignInScreen(),
                    ),
                  ),
                  child: Text(
                    'Sign in here',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
