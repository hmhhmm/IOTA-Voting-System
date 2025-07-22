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
import 'package:file_picker/file_picker.dart';
import 'dart:async';
import 'package:gov_vote/api_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int _currentStep = 0;
  String? _selectedFileName;
  PlatformFile? _selectedFile;

  // Personal Info
  final _personalFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Identity Info
  final _identityFormKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();

  // Step 2: Personal Info
  String? _nationalityValue;
  String? _salaryRangeValue;
  final TextEditingController _occupationController = TextEditingController();

  // Add new controllers for NRIC and nationality text field:
  final TextEditingController _nricController = TextEditingController();
  final TextEditingController _nationalityTextController = TextEditingController();

  late BuildContext _rootContext;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _nationalityController.dispose();
    _occupationController.dispose();
    _nricController.dispose();
    super.dispose();
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.name.isNotEmpty) {
      setState(() {
        _selectedFileName = result.files.single.name;
        _selectedFile = result.files.single;
      });
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (_selectedFile != null) {
        setState(() => _currentStep++);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please upload your IC photo.')),
        );
      }
    } else if (_currentStep == 1) {
      if (_personalFormKey.currentState!.validate()) {
        setState(() => _currentStep++);
      }
    } else if (_currentStep == 2) {
      if (_identityFormKey.currentState!.validate()) {
        _submit();
      }
    }
  }

  void _prevStep() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  void _submit() async {
    // Collect all data and (optionally) send to backend
    final registrationData = {
      'ic_photo': _selectedFileName,
      'personal': {
        'name': _nameController.text,
        'email': _emailController.text + '@gmail.com',
        'phone': _phoneController.text,
        'nric': _nricController.text,
        'nationality': _nationalityValue,
      },
      'identity': {
        'address': _addressController.text,
        'salary_range': _salaryRangeValue,
        'occupation': _occupationController.text,
      },
    };
    // Show animated verification dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => VerificationProgressDialog(
        onComplete: () async {
          Navigator.of(context).pop(); // Close progress dialog
          // Call backend to create DID
          String did = '';
          try {
            did = await ApiService().createDid();
          } catch (e) {
            did = 'Error: Could not generate DID';
          }
          _showDidDialog(did); // Show DID dialog (real DID)
        },
      ),
    );
  }

  void _showDidDialog(String did) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 290), // Match verification dialog width
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
                  Icon(Icons.verified, color: Colors.purple, size: 40),
                  SizedBox(height: 10),
                  Text('DID Generated', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              SizedBox(height: 8),
                  Text('Your DID:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  SizedBox(height: 4),
              Container(
                    padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                child: SelectableText(
                  did,
                  style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
              ),
          ),
                  SizedBox(height: 14),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                      Navigator.of(_rootContext).pushNamedAndRemoveUntil('/dashboard', (route) => false);
              },
              child: Text('Continue', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
            ),
          ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _rootContext = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Voter Registration'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: Stepper(
        type: StepperType.horizontal,
        currentStep: _currentStep,
        onStepContinue: _nextStep,
        onStepCancel: _prevStep,
        controlsBuilder: (context, details) {
          // Step 0: Only Next, centered
          if (_currentStep == 0) return SizedBox.shrink();
          // Step 1: Previous and Next, centered
          if (_currentStep == 1) {
            return Column(
              children: [
                SizedBox(height: 32), // Add extra space above the buttons
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _prevStep,
                          child: Text('Previous', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 6,
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      SizedBox(
                        width: 170,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          child: Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          // Step 2: Previous and Submit, centered
          if (_currentStep == 2) {
            return Column(
              children: [
                SizedBox(height: 32),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 170,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _prevStep,
                          child: Text('Previous', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 6,
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      SizedBox(
                        width: 170,
                        height: 44,
                        child: ElevatedButton(
                          onPressed: _nextStep,
                          child: Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return SizedBox.shrink();
        },
        steps: [
          Step(
            title: Text('IC Photo', style: TextStyle(fontSize: 12)),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
                    constraints: BoxConstraints(minHeight: 220), // Make card longer
                    padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0), // More vertical padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.credit_card, size: 36, color: Colors.purple),
                            SizedBox(width: 12),
                            Text('Upload your government-issued ID', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Passport, Driver’s License, etc.', style: TextStyle(color: Colors.grey[700])),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            OutlinedButton(
                              onPressed: () async {
                                FilePickerResult? result = await FilePicker.platform.pickFiles();
                                if (result != null && result.files.single.name.isNotEmpty) {
                                  setState(() {
                                    _selectedFileName = result.files.single.name;
                                    _selectedFile = result.files.single;
                                  });
                                  // Simulate auto-upload
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('File "${result.files.single.name}" uploaded!'), duration: Duration(seconds: 1)),
                                  );
                                }
                              },
                              child: Text('Choose File'),
                            ),
                            SizedBox(width: 12),
                            if (_selectedFileName != null)
                              Row(
            children: [
                                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                                  SizedBox(width: 4),
                                  Text(_selectedFileName!, style: TextStyle(fontSize: 13, color: Colors.teal)),
                                ],
                              )
                            else
                              Text('No file selected', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 10),
              Container(
                          padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.purple, size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Why do we need this?\nYour ID is required to verify your eligibility and prevent fraud. All documents are securely processed.',
                                  style: TextStyle(fontSize: 12, color: Colors.purple[900]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 18),
                Center(
                  child: Text(
                    'Need help? Contact support@organization.org',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
                SizedBox(height: 18),
                Center(
                  child: SizedBox(
                    width: 260, // Increase width
                    height: 44, // Decrease height
                    child: ElevatedButton(
                      onPressed: (_selectedFile == null) ? null : _nextStep,
                      child: Text('Next', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Step 2: Personal Info
          Step(
            title: Text('Personal Info', style: TextStyle(fontSize: 12)),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Container(
                constraints: BoxConstraints(minHeight: 320),
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 32.0),
                child: Form(
                  key: _personalFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.purple, size: 28),
                          SizedBox(width: 10),
                          Text('Personal Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Please provide your personal details.', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                      SizedBox(height: 18),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Enter your name' : null,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          suffixText: '@email.com',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter your email username';
                          // Optionally, add more username validation here
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (v) => v == null || v.isEmpty ? 'Enter your phone number' : null,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _nricController,
                        decoration: InputDecoration(
                          labelText: 'NRIC Number',
                          prefixIcon: Icon(Icons.credit_card, color: Colors.black), // Black icon
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Enter your NRIC number' : null,
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _nationalityValue,
                        items: [
                          DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                          DropdownMenuItem(value: 'No', child: Text('No')),
                        ],
                        onChanged: (val) => setState(() => _nationalityValue = val),
                        decoration: InputDecoration(
                          labelText: 'Are you a national citizen?',
                          prefixIcon: Icon(Icons.flag, color: Colors.black), // Black icon
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null ? 'Select Yes or No' : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Step 3: Identity Info
          Step(
            title: Text('Identity Info', style: TextStyle(fontSize: 12)),
            isActive: _currentStep >= 2,
            state: StepState.indexed,
            content: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Form(
                  key: _identityFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.badge, color: Colors.purple, size: 28),
                          SizedBox(width: 10),
                          Text('Identity Information', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text('Provide additional identity details.', style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                      SizedBox(height: 18),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.home_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Enter your address' : null,
                      ),
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _salaryRangeValue,
                        items: [
                          DropdownMenuItem(value: '<4000', child: Text('< 4,000')),
                          DropdownMenuItem(value: '4000-8000', child: Text('4,000–8,000')),
                          DropdownMenuItem(value: '>8000', child: Text('> 8,000')),
                        ],
                        onChanged: (val) => setState(() => _salaryRangeValue = val),
                        decoration: InputDecoration(
                          labelText: 'Salary Range',
                          prefixIcon: Icon(Icons.attach_money, color: Colors.black),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null ? 'Select salary range' : null,
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _occupationController,
                        decoration: InputDecoration(
                          labelText: 'Occupation',
                          prefixIcon: Icon(Icons.work_outline),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Enter your occupation' : null,
                      ),
                      SizedBox(height: 20),
              Container(
                        padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                          color: Colors.teal.withOpacity(0.04),
                          border: Border(left: BorderSide(color: Colors.purple, width: 3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Verification Process', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple)),
                            SizedBox(height: 6),
                            Text('Your documents will be verified by a consortium of trusted authorities:'),
                            SizedBox(height: 6),
                            ...[
                              'Government Identity Authority',
                              'Electoral Commission',
                              'District Administration',
                              'Citizen Registry',
                              'Election Security Authority',
                            ].map((e) => Padding(
                              padding: const EdgeInsets.only(left: 8, bottom: 2),
                              child: Text('• $e', style: TextStyle(fontSize: 13)),
                            )),
                            SizedBox(height: 6),
                            Text('Each authority will verify your identity using secure Hardware Security Modules (HSM) and collectively sign your credential.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VerificationProgressDialog extends StatefulWidget {
  final VoidCallback onComplete;
  const VerificationProgressDialog({required this.onComplete});
  @override
  State<VerificationProgressDialog> createState() => _VerificationProgressDialogState();
}

class _VerificationProgressDialogState extends State<VerificationProgressDialog> {
  int _step = 0;
  late Timer _timer;

  final List<_VerificationStep> _steps = [
    _VerificationStep('Documents Received', 'Your documents have been securely uploaded'),
    _VerificationStep('Government Verification', 'Identity validated with government records'),
    _VerificationStep('Consortium Approval', '5 of 5 signatures received from consortium members'),
    _VerificationStep('Credential Issuance', 'Creating and signing your verifiable credential'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_step < _steps.length - 1) {
        setState(() => _step++);
      } else if (_step == _steps.length - 1) {
        // Wait a bit longer for the last step
        Future.delayed(Duration(seconds: 2), () {
          widget.onComplete();
        });
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 290), // Slightly wider, but still compact
        child: Material(
          type: MaterialType.transparency,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18), // Slightly more horizontal padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text('Identity Verification in Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text('Your identity documents are being verified by the consortium members.', softWrap: true),
                SizedBox(height: 18),
                ...List.generate(_steps.length, (i) {
                  final isDone = i < _step;
                  final isCurrent = i == _step;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            if (isDone)
                              Icon(Icons.check_circle, color: Colors.purple, size: 26)
                            else if (isCurrent)
                              SizedBox(
                                width: 26,
                                height: 26,
                                child: CircularProgressIndicator(strokeWidth: 3, color: Colors.purple),
                              )
                            else
                              Icon(Icons.radio_button_unchecked, color: Colors.purple[200], size: 26),
                          ],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _steps[i].title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                                  color: Colors.purple,
                                  fontSize: 15,
                                ),
                                softWrap: true,
                              ),
                              SizedBox(height: 2),
                              Text(
                                _steps[i].subtitle,
                                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 10),
                Text(
                  'This process typically takes 1–2 minutes in this demo. In a real system, it might take longer.',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  softWrap: true,
                ),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close', style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
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

class _VerificationStep {
  final String title;
  final String subtitle;
  _VerificationStep(this.title, this.subtitle);
} 