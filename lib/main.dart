import 'package:boomerang/classes/fcm.dart';
import 'package:boomerang/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:boomerang/classes/nav.dart';
import 'get-it.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initGetIt();

  FCM.instance().init();

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 16,
      color: Colors.black,
      height: 1.25,
      letterSpacing: 16 * 0.01,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: Nav.instance().navigatorKey,
      title: 'Boomerang la',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ru'),
      ],
      color: Colors.black,
      theme: ThemeData(
        primaryColor: Colors.purple,
        fontFamily: 'Default',
        textTheme: const TextTheme(
          bodySmall: style,
          bodyMedium: style,
          bodyLarge: style,
        ),
      ),
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: child!,
        );
      },
      home: const HomeScreen(),
    );
  }
}
