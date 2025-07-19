import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';
import 'screens/sign_in_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/sign_up_screen.dart';

void main() {
  runApp(const VirtualPhoneApp());
}

class VirtualPhoneApp extends StatelessWidget {
  const VirtualPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
          secondary: Colors.deepPurpleAccent,
        ),
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.purple),
        ),
      ),
      home: Container(
        color: Colors.grey[200],
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: DeviceFrame(
              device: Devices.ios.iPhone15ProMax,
              isFrameVisible: true,
              orientation: Orientation.portrait,
              screen: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  primarySwatch: Colors.purple,
                  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple).copyWith(
                    secondary: Colors.deepPurpleAccent,
                  ),
                  scaffoldBackgroundColor: Colors.grey[50],
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(foregroundColor: Colors.purple),
                  ),
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => SignInScreen(),
                  '/dashboard': (context) => DashboardScreen(),
                  '/feedback': (context) => FeedbackScreen(),
                  '/signup': (context) => SignUpScreen(),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
} 