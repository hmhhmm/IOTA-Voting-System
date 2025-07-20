import 'dart:ui';
import 'package:flutter/material.dart';
import '../api_service.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController didController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Optionally check backend health on sign in
    final api = ApiService();
    api.health().catchError((e) {
      // Show a snackbar or log error if backend is unreachable
      print('Backend health check failed: $e');
    });
  }

  @override
  void dispose() {
    didController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Match dashboard: Colors.purple gradient
    return Scaffold(
      body: Stack(
        children: [
          // Dashboard-matching purple gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF9C27B0),
                  Color(0xFF9C27B0).withOpacity(0.7),
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // Main content
          Column(
            children: [
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 16,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(28),
                            child: Icon(
                              Icons.how_to_vote_rounded,
                              size: 54,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 28),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Gov',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.yellow[700],
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Vote',
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Citizen Feedback Platform',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.92),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 60),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 24,
                                  offset: Offset(0, 8),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.white.withOpacity(0.22),
                                width: 1.2,
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          'Enter your DID (Decentralized ID):',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.95),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                        SizedBox(height: 14),
                                        TextFormField(
                                          controller: didController,
                                          style: TextStyle(color: Colors.white, fontSize: 16),
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: Colors.white.withOpacity(0.13),
                                            prefixIcon: Icon(Icons.fingerprint, color: Colors.white),
                                            hintText: 'did:123',
                                            hintStyle: TextStyle(color: Colors.white70),
                                            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(16),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) {
                                              return 'Please enter your DID';
                                            }
                                            return null;
                                          },
                                        ),
                                        SizedBox(height: 24),
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            if (_formKey.currentState!.validate()) {
                                              Navigator.pushReplacementNamed(context, '/dashboard');
                                            }
                                          },
                                          icon: Icon(Icons.login, color: Colors.white),
                                          label: Text(
                                            'Sign In',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF7F53AC),
                                            foregroundColor: Colors.white,
                                            elevation: 6,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            padding: EdgeInsets.symmetric(vertical: 16),
                                          ),
                                        ),
                                        SizedBox(height: 18),
                                        // Make Sign Up a prominent OutlinedButton
                                        TextButton.icon(
                                          onPressed: () {
                                            Navigator.of(context).pushNamed('/signup');
                                          },
                                          icon: Icon(Icons.person_add, color: Colors.white),
                                          label: Text(
                                            "Don't have an account? Sign Up",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_user, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'Your identity is verified using IOTA Identity technology',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.93),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 