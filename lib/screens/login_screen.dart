import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/resources/auth_method.dart';
import 'package:flutter_danthocode_instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:flutter_danthocode_instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:flutter_danthocode_instagram_clone/responsive/web_screen_layout.dart';
import 'package:flutter_danthocode_instagram_clone/screens/signup_screen.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';
import 'package:flutter_danthocode_instagram_clone/utils/global_variables.dart';
import 'package:flutter_danthocode_instagram_clone/utils/utils.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/loader.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    final TextEditingController _passwordController = TextEditingController();
    bool _isLaoding = false;

    @override
    void dispose() {
      super.dispose();
      _emailController.dispose();
      _passwordController.dispose();
    }

    void loginUser() async {
      final navigator = Navigator.of(context);
      setState(() {
        _isLaoding = true;
      });

      String res = await AuthMethod().loginUser(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (!mounted) return;
      if (res == 'Success') {
        navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayoutScreen(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
          ),
        );
      } else {
        showSnackbar(res, context);
      }

      setState(() {
        _isLaoding = false;
      });
    }

    final navigator = Navigator.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                height: 64,
                color: InstagramColor.primaryColor,
              ),
              const SizedBox(height: 64),
              TextFieldInput(
                controller: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFieldInput(
                controller: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPassword: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: InstagramColor.blueColor,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                ),
                child: _isLaoding ? const Loader() : const Text('Login'),
              ),
              const SizedBox(height: 12),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account? "),
                  ),
                  InkWell(
                    onTap: () {
                      navigator.push(
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Sign Up.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: InstagramColor.blueColor,
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
