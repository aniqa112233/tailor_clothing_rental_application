
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/app_theme.dart';
import '../../utils/profile_helper.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passwordC = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ======= Pink Top Design =======
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
                  const Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        'Login',
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
              padding: const EdgeInsets.all(16.0),
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
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 12),

                  PrimaryButton(
                    label: 'Login',
                    loading: _loading,
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                        _error = null;
                      });

                      final ok = await auth.login(
                        email: _emailC.text.trim(),
                        password: _passwordC.text,
                        context: context,
                      );

                      setState(() => _loading = false);

                      if (!ok && mounted) {
                        setState(() => _error = 'Invalid credentials!');
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Or login with:'),
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
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, Routes.signup),
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
