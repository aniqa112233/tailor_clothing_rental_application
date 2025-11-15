
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/app_theme.dart';
import '../../utils/profile_helper.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ======= Pink Top Design with Back Arrow =======
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: TopWaveClipper(),
                    child: Container(
                      height: 200,
                      color: const Color(0xFFFFA4A4),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pushNamed(context, Routes.login),
                    ),
                  ),
                  const Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ======= Main Form =======
            Padding(
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

                      await ensureUserProfileExists();

                      if (mounted) {
                        Navigator.pushReplacementNamed(context, Routes.profileSetup);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Or sign up with:'),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/google icon.png',
                      height: 24,
                      width: 24,
                    ),
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
                      await ensureUserProfileExists();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======= Wavy Top Clipper =======
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 60);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
