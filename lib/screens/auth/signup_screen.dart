
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/app_theme.dart';
import '../../main.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  String _role = 'customer';
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
              label: 'Email',
              controller: _emailC,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Password',
              controller: _passwordC,
              obscure: true,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'customer', child: Text('Customer')),
                DropdownMenuItem(value: 'tailor', child: Text('Tailor')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (v) => setState(() => _role = v!),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 16),

            // Email Signup
            PrimaryButton(
              label: 'Create Account',
              loading: _loading,
              onPressed: () async {
                setState(() => _loading = true);
                await auth.signup(
                  email: _emailC.text.trim(),
                  password: _passwordC.text,
                  role: _role,
                );
                setState(() => _loading = false);
                if (mounted) {
                  Navigator.pushReplacementNamed(context, Routes.profileSetup);
                }
              },
            ),
            const SizedBox(height: 20),

            // Google Signup
            const Text('Or sign up with:'),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text(
                'Continue with Google',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                await auth.signInWithGoogle(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

