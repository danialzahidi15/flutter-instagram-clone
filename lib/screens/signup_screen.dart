import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/resources/auth_method.dart';
import 'package:flutter_danthocode_instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:flutter_danthocode_instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:flutter_danthocode_instagram_clone/responsive/web_screen_layout.dart';
import 'package:flutter_danthocode_instagram_clone/screens/login_screen.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';
import 'package:flutter_danthocode_instagram_clone/utils/utils.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/loader.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _bioController = TextEditingController();
    final _usernameController = TextEditingController();
    Uint8List? _image;
    bool _isLoading = false;

    @override
    void dispose() {
      super.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _bioController.dispose();
      _usernameController.dispose();
    }

    selectImage() async {
      Uint8List image = await pickImage(ImageSource.gallery);
      setState(() {
        _image = image;
      });
    }

    void signupUser() async {
      setState(() {
        _isLoading = true;
      });

      String res = await AuthMethod().signUpUser(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        file: _image!,
      );

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;
      if (res != 'Success') {
        showSnackbar(res, context);
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ResponsiveLayoutScreen(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout(),
            ),
          ),
        );
      }
    }

    final navigator = Navigator.of(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(flex: 1, child: Container()),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                height: 48,
                color: InstagramColor.primaryColor,
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            'https://static.vecteezy.com/system/resources/thumbnails/009/292/244/small/default-avatar-icon-of-social-media-user-vector.jpg',
                          ),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 75,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Textfield
              TextFieldInput(
                controller: _usernameController,
                hintText: 'Enter your username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                controller: _emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                controller: _passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPassword: true,
              ),
              const SizedBox(height: 10),
              TextFieldInput(
                controller: _bioController,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
              ),

              const SizedBox(height: 10),
              GestureDetector(
                onTap: signupUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: const BoxDecoration(
                    color: InstagramColor.blueColor,
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: _isLoading
                      ? const Loader()
                      : const Text(
                          'Sign up',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(flex: 1, child: Container()),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: const Text("You have an account? "),
                    ),
                    InkWell(
                      onTap: () {
                        navigator.push(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: const Text(
                          'Login.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: InstagramColor.blueColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
