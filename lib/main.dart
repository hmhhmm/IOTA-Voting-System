
/// 🗳️ IOTA Voting Platform - Main Application Entry Point
/// 
/// This file serves as the main entry point for the Flutter application.
/// It configures the app theme, routing, and wraps the application in a device frame
/// for demonstration purposes.
/// 
/// Key Features:
/// - Material Design 3 theming with purple color scheme
/// - Named route navigation system
/// - Device frame wrapper for mobile simulation
/// - Cross-platform support (iOS, Android, Web)

import 'package:flutter/material.dart';
import 'package:device_frame/device_frame.dart';
import 'screens/sign_in_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/sign_up_screen.dart';

/// Main function that initializes and runs the Flutter application
void main() {
  runApp(const VirtualPhoneApp());
}

/// Main application widget that configures the overall app structure
/// 
/// This widget sets up:
/// - Material Design theme with purple color scheme
/// - Device frame for mobile simulation
/// - Named route navigation system
/// - Cross-platform compatibility
class VirtualPhoneApp extends StatelessWidget {
  const VirtualPhoneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: _buildAppTheme(), // Apply custom theme
      home: _buildDeviceFrame(), // Wrap in device frame
    );
  }

  /// Builds the Material Design theme for the application
  /// 
  /// Returns a ThemeData object with:
  /// - Purple primary color scheme
  /// - Custom button and text button themes
  /// - Light grey background color
  /// - Consistent app bar styling
  ThemeData _buildAppTheme() {
    return ThemeData(
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
    );
  }

  /// Builds the device frame wrapper for mobile simulation
  /// 
  /// This creates a phone-like frame around the app for demonstration purposes.
  /// The inner MaterialApp contains the actual application logic with routing.
  Widget _buildDeviceFrame() {
    return Container(
      color: Colors.grey[200], // Background color for device frame
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: DeviceFrame(
            device: Devices.ios.iPhone15ProMax, // iPhone 15 Pro Max frame
            isFrameVisible: true, // Show the device frame
            orientation: Orientation.portrait, // Portrait orientation
            screen: _buildInnerApp(), // The actual app content
          ),
        ),
      ),
    );
  }

  /// Builds the inner MaterialApp with routing configuration
  /// 
  /// This contains the actual application logic with:
  /// - Named route definitions
  /// - Screen mappings
  /// - Navigation configuration
  MaterialApp _buildInnerApp() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildAppTheme(), // Apply same theme to inner app
      initialRoute: '/', // Start with sign-in screen
      routes: _buildRouteMap(), // Define named routes
    );
  }

  /// Defines the named route mapping for the application
  /// 
  /// Routes:
  /// - '/' -> SignInScreen (authentication)
  /// - '/dashboard' -> DashboardScreen (main app)
  /// - '/feedback' -> FeedbackScreen (policy feedback)
  /// - '/signup' -> RegisterPage (user registration)
  Map<String, WidgetBuilder> _buildRouteMap() {
    return {
      '/': (context) => SignInScreen(),
      '/dashboard': (context) => DashboardScreen(),
      '/feedback': (context) => FeedbackScreen(),
      '/signup': (context) => RegisterPage(),
    };
  }
} 