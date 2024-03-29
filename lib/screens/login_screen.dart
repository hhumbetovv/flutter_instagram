import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../layouts/mobile_screen_layout.dart';
import '../layouts/responsive_layout_screen.dart';
import '../layouts/web_screen_layout.dart';
import '../resources/auth_methods.dart';
import '../utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() => _isLoading = true);
    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() => _isLoading = false);
    if (res == 'success' && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            webScreenLayout: WebScreenLayout(),
            mobileScreenLayout: MobileScreenLayout(),
          ),
        ),
      );
    } else if (res != 'success' && mounted) {
      showSnackBar(res, context);
    }
  }

  void navigateToSignup() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SignupScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            constraints: const BoxConstraints(maxWidth: 480),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                //! Logo
                SvgPicture.asset(
                  'assets/logo.svg',
                  height: 64,
                ),
                const SizedBox(height: 64),
                //! Textfield email
                TextFieldInput(
                  hintText: 'Enter your email',
                  textInputType: TextInputType.emailAddress,
                  textEditingController: _emailController,
                ),
                const SizedBox(height: 24),
                //! Textfield password
                TextFieldInput(
                  hintText: 'Enter your password',
                  textInputType: TextInputType.text,
                  textEditingController: _passwordController,
                  isPass: true,
                ),
                const SizedBox(height: 24),
                //! Button login
                _isLoading
                    ? const Center(
                        child: SizedBox(
                          height: 39,
                          width: 39,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : InkWell(
                        onTap: loginUser,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: ShapeDecoration(
                            color: blueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text('Log  in'),
                        ),
                      ),
                const SizedBox(height: 12),
                //! Transitioning to sign up
                const Spacer(flex: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text('Don\'t have an account? '),
                    ),
                    GestureDetector(
                      onTap: navigateToSignup,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
