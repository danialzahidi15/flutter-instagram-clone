import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_danthocode_instagram_clone/providers/user_model_provider.dart';
import 'package:flutter_danthocode_instagram_clone/responsive/mobile_screen_layout.dart';
import 'package:flutter_danthocode_instagram_clone/responsive/responsive_layout_screen.dart';
import 'package:flutter_danthocode_instagram_clone/responsive/web_screen_layout.dart';
import 'package:flutter_danthocode_instagram_clone/screens/login_screen.dart';
import 'package:flutter_danthocode_instagram_clone/screens/signup_screen.dart';
import 'package:flutter_danthocode_instagram_clone/utils/colors.dart';
import 'package:flutter_danthocode_instagram_clone/widgets/loader.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: 'lib/.env');
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FLUTTER_APP_API_KEY']!,
        appId: dotenv.env['FLUTTER_APP_APP_ID']!,
        messagingSenderId: dotenv.env['FLUTTER_APP_WEB_MESSAGE_SENDER_ID']!,
        projectId: dotenv.env['FLUTTER_APP_PROJECT_ID']!,
        storageBucket: dotenv.env['FLUTTER_APP_STORAGE_BUCKET'],
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserModelProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'danthocode Instagram Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: InstagramColor.mobileBackgroundColor,
        ),
        // home: const SignUpScreen(),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayoutScreen(
                  webScreenLayout: WebScreenLayout(),
                  mobileScreenLayout: MobileScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
