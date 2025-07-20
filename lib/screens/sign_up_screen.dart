/// 🗳️ Sign Up Screen - User Registration with DID Generation
/// 
/// This screen handles user registration and automatic DID (Decentralized Identifier) generation.
/// It provides a streamlined sign-up process that creates a new user account and generates
/// a unique DID using IOTA Identity technology.
/// 
/// Features:
/// - Form validation for all input fields
/// - Automatic DID generation via backend API
/// - Success screen with DID display
/// - Navigation to dashboard after registration
/// - Responsive design for mobile and desktop

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// Sign-up screen widget that handles user registration
/// 
/// This widget manages the complete registration flow:
/// 1. User fills out registration form
/// 2. Form validation ensures data integrity
/// 3. Backend API call generates DID
/// 4. Success screen displays generated DID
/// 5. Navigation to dashboard
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

/// State class for the sign-up screen
/// 
/// Manages form state, validation, API calls, and UI updates
class _SignUpScreenState extends State<SignUpScreen> {
  // Form validation key for form validation
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers for form input fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  
  // UI state variables
  bool _isLoading = false; // Loading state for API calls
  bool _obscurePassword = true; // Password visibility toggle
  bool _obscureConfirmPassword = true; // Confirm password visibility toggle

  @override
  void initState() {
    super.initState();
  }

  /// Handles the sign-up process
  /// 
  /// This method:
  /// 1. Validates the form data
  /// 2. Shows loading state
  /// 3. Calls backend API to generate DID
  /// 4. Displays success dialog with DID
  /// 5. Navigates to dashboard on completion
  /// 
  /// Throws exceptions for network errors or API failures
  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        // Create DID by calling the backend API
        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/did/create'),
          headers: {'Content-Type': 'application/json'},
        );
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final did = data['did'];
          
          setState(() => _isLoading = false);
          
          // Show DID to user in pop-up dialog
          _showDidDialog(did);
        } else {
          setState(() => _isLoading = false);
          _showErrorSnackBar('Failed to create account. Please try again.');
        }
      } catch (e) {
        setState(() => _isLoading = false);
        _showErrorSnackBar('Connection error: $e');
      }
    }
  }

  /// Displays the DID generation success dialog
  /// 
  /// Shows a dialog with the generated DID and instructions for the user
  /// 
  /// [did] - The generated Decentralized Identifier
  void _showDidDialog(String did) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('DID Generated', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your DID:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  did,
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                // Show success screen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => AccountSuccessScreen(did: did),
                  ),
                );
              },
              child: Text('Continue', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  /// Shows error message in a SnackBar
  /// 
  /// [message] - The error message to display
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    // Clean up text controllers to prevent memory leaks
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header icon and title
              Icon(Icons.person_add, size: 60, color: Colors.teal),
              SizedBox(height: 24),
              Text('Create a new account',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
                  textAlign: TextAlign.center),
              SizedBox(height: 32),
              
              // Full Name input field
              _buildTextField(
                controller: nameController,
                label: 'Full Name',
                icon: Icons.person,
                validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              
              // Email input field
              _buildTextField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter your email';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Enter a valid email';
                  return null;
                },
              ),
              
              // Phone Number input field
              _buildTextField(
                controller: phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Enter your phone number' : null,
              ),
              
              // Address input field
              _buildTextField(
                controller: addressController,
                label: 'Address',
                icon: Icons.home,
                validator: (value) => value == null || value.isEmpty ? 'Enter your address' : null,
              ),
              
              // Password input field
              _buildPasswordField(
                controller: passwordController,
                label: 'Password',
                obscureText: _obscurePassword,
                onToggleVisibility: () => setState(() => _obscurePassword = !_obscurePassword),
                validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              
              // Confirm Password input field
              _buildPasswordField(
                controller: confirmPasswordController,
                label: 'Confirm Password',
                obscureText: _obscureConfirmPassword,
                onToggleVisibility: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Confirm your password';
                  if (value != passwordController.text) return 'Passwords do not match';
                  return null;
                },
              ),
              
              SizedBox(height: 32),
              
              // Sign Up button
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                child: _isLoading
                    ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                    : Text('Sign Up', style: TextStyle(fontSize: 18)),
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a standard text input field with validation
  /// 
  /// [controller] - Text editing controller
  /// [label] - Field label text
  /// [icon] - Prefix icon
  /// [keyboardType] - Keyboard type for input
  /// [validator] - Form validation function
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            prefixIcon: Icon(icon, color: Colors.purple),
          ),
          keyboardType: keyboardType,
          validator: validator,
        ),
        SizedBox(height: 20),
      ],
    );
  }

  /// Builds a password input field with visibility toggle
  /// 
  /// [controller] - Text editing controller
  /// [label] - Field label text
  /// [obscureText] - Whether to obscure the text
  /// [onToggleVisibility] - Callback for visibility toggle
  /// [validator] - Form validation function
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggleVisibility,
    String? Function(String?)? validator,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.lock, color: Colors.purple),
            suffixIcon: IconButton(
              icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.purple),
              onPressed: onToggleVisibility,
            ),
          ),
          obscureText: obscureText,
          validator: validator,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

/// Account Success Screen - Displays registration success and DID
/// 
/// This screen is shown after successful registration and DID generation.
/// It displays the generated DID in a user-friendly format and provides
/// navigation to the dashboard.
/// 
/// Features:
/// - Compact, mobile-optimized design
/// - DID display with copy functionality
/// - Navigation to dashboard
/// - Success confirmation
class AccountSuccessScreen extends StatelessWidget {
  /// The generated Decentralized Identifier
  final String did;

  const AccountSuccessScreen({required this.did});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Congratulations'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 280,
            maxHeight: 350,
          ),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Success icon
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              SizedBox(height: 8),
              
              // Success message
              Text(
                'Account Created Successfully!',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              
              // DID display
              Text(
                'Your DID:',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 3),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(3),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  did,
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 7,
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
              SizedBox(height: 12),
              
              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the dashboard screen
                    Navigator.of(context).pushReplacementNamed('/dashboard');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    elevation: 1,
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 