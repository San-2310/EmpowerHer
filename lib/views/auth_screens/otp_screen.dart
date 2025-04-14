import 'package:empower_her/models/user_model.dart';
import 'package:empower_her/views/auth_screens/auth_screens.dart';
import 'package:empower_her/views/main_layout_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/auth_services.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final bool isNewUser;
  final EmpowerHerUser? userData;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
    this.isNewUser = false,
    this.userData,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isLoading = false;
  final AuthService _authService = AuthService();
  // final EmpowerHerUser userData = new ;

  void verifyOtp() async {
    setState(() => isLoading = true);

    try {
      final credential = await _authService.signInWithOTP(
        widget.verificationId,
        otpController.text.trim(),
      );

      final uid = credential.user?.uid;
      if (uid != null) {
        if (widget.isNewUser && widget.userData != null) {
          final newUser = widget.userData!.copyWith(id: uid);
          await _authService.createUserInFirestore(newUser);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MainLayoutScreen(),
            ),
          );
        } else {
          final userProfile = await _authService.fetchCurrentUserProfile();
          if (userProfile != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainLayoutScreen(),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SignupScreen(),
              ),
            );
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP verification failed: ${e.message}')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDEE2F8),
        title: const Text('Verify OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Enter the 6-digit code sent to your phone",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC0C5F0),
                foregroundColor: Colors.black,
              ),
              onPressed: isLoading ? null : verifyOtp,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
