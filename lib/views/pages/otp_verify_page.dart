import 'package:flutter/material.dart';
import 'package:form_helpers/form_helpers.dart';
import 'package:subabase_auth/controller/supabase_auth.dart';
import 'package:subabase_auth/views/pages/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OtpVerifyPage extends StatefulWidget {
  const OtpVerifyPage({
    super.key,
    required this.email,
  });
  final String email;

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  late final TextEditingController _otpController;
  final SupabaseAuth _auth = SupabaseAuthImplementation();

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _otpController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomInputFormField(
              controller: _otpController,
              hintText: 'Enter Your OTP',
            ),
          ),
          const SizedBox(height: 200),
          CustomButton(
            buttonLabel: 'Verify OTP',
            onPressed: () async {
              await _auth.verifyOtp(
                _otpController.text,
                widget.email,
                OtpType.email,
              );
              debugPrint(_auth.fetchUserData().toString());
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const HomePage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
