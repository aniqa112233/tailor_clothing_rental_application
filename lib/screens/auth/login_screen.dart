// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/primary_button.dart';
// import '../../utils/app_theme.dart';
// import '../../main.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailC = TextEditingController();
//   final _passwordC = TextEditingController();
//   bool _loading = false;
//   String? _error;

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CustomTextField(label: 'Email', controller: _emailC, keyboardType: TextInputType.emailAddress),
//             const SizedBox(height: 12),
//             CustomTextField(label: 'Password', controller: _passwordC, obscure: true),
//             const SizedBox(height: 12),
//             if (_error != null)
//               Text(_error!, style: const TextStyle(color: Colors.red)),
//             const SizedBox(height: 12),
//             PrimaryButton(
//               label: 'Login',
//               loading: _loading,
//               onPressed: () async {
//                 setState(() {
//                   _loading = true;
//                   _error = null;
//                 });
//                 final ok = await auth.login(email: _emailC.text.trim(), password: _passwordC.text);
//                 setState(() => _loading = false);
//                 if (ok) {
//                   Navigator.pushReplacementNamed(context, Routes.dashboard);
//                 } else {
//                   setState(() => _error = 'Invalid credentials!');
//                 }
//               },
//             ),
//             const SizedBox(height: 12),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don't have an account? "),
//                 GestureDetector(
//                   onTap: () => Navigator.pushNamed(context, Routes.signup),
//                   child: Text('Sign up', style: TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold)),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/primary_button.dart';
// import '../../utils/app_theme.dart';
// import '../../main.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailC = TextEditingController();
//   final _passwordC = TextEditingController();
//   bool _loading = false;
//   String? _error;

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CustomTextField(
//               label: 'Email',
//               controller: _emailC,
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 12),
//             CustomTextField(
//               label: 'Password',
//               controller: _passwordC,
//               obscure: true,
//             ),
//             const SizedBox(height: 12),
//             if (_error != null)
//               Text(
//                 _error!,
//                 style: const TextStyle(color: Colors.red),
//               ),
//             const SizedBox(height: 12),
//             PrimaryButton(
//               label: 'Login',
//               loading: _loading,
//               onPressed: () async {
//                 setState(() {
//                   _loading = true;
//                   _error = null;
//                 });
//                 final ok = await auth.login(
//                   email: _emailC.text.trim(),
//                   password: _passwordC.text,
//                 );
//                 setState(() => _loading = false);
//                 if (ok) {
//                   Navigator.pushReplacementNamed(context, Routes.dashboard);
//                 } else {
//                   setState(() => _error = 'Invalid credentials!');
//                 }
//               },
//             ),
//             const SizedBox(height: 20),

//             // -------------------------------
//             // GOOGLE LOGIN BUTTON
//             // -------------------------------
//             const Text('Or login with:'),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.login, color: Colors.white),
//               label: const Text('Continue with Google',
//                   style: TextStyle(color: Colors.white)),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: () async {
//                 await auth.signInWithGoogle();
//                 if (auth.isLoggedIn) {
//                   Navigator.pushReplacementNamed(context, Routes.dashboard);
//                 }
//               },
//             ),
//             const SizedBox(height: 12),

//             // -------------------------------
//             // SIGNUP NAVIGATION
//             // -------------------------------
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don't have an account? "),
//                 GestureDetector(
//                   onTap: () => Navigator.pushNamed(context, Routes.signup),
//                   child: Text(
//                     'Sign up',
//                     style: TextStyle(
//                       color: AppTheme.primary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';
// import '../../widgets/custom_text_field.dart';
// import '../../widgets/primary_button.dart';
// import '../../utils/app_theme.dart';
// import '../../main.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final _emailC = TextEditingController();
//   final _passwordC = TextEditingController();
//   bool _loading = false;
//   String? _error;

//   @override
//   Widget build(BuildContext context) {
//     final auth = Provider.of<AuthProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Login')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             CustomTextField(
//               label: 'Email',
//               controller: _emailC,
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 12),
//             CustomTextField(
//               label: 'Password',
//               controller: _passwordC,
//               obscure: true,
//             ),
//             const SizedBox(height: 12),
//             if (_error != null)
//               Text(_error!, style: const TextStyle(color: Colors.red)),
//             const SizedBox(height: 12),

//             // Email Login
//             PrimaryButton(
//               label: 'Login',
//               loading: _loading,
//               onPressed: () async {
//                 setState(() {
//                   _loading = true;
//                   _error = null;
//                 });
//                 final ok = await auth.login(
//                   email: _emailC.text.trim(),
//                   password: _passwordC.text,
//                 );
//                 setState(() => _loading = false);
//                 if (ok && mounted) {
//                   Navigator.pushReplacementNamed(context, Routes.dashboard);
//                 } else {
//                   setState(() => _error = 'Invalid credentials!');
//                 }
//               },
//             ),
//             const SizedBox(height: 20),

//             // Google Login Button
//             const Text('Or login with:'),
//             const SizedBox(height: 10),
//             ElevatedButton.icon(
//               icon: const Icon(Icons.login, color: Colors.white),
//               label: const Text(
//                 'Continue with Google',
//                 style: TextStyle(color: Colors.white),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.redAccent,
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: () async {
//                 final user = await auth.signInWithGoogle(context);
//                 if (user != null && mounted) {
//                   Navigator.pushReplacementNamed(context, Routes.dashboard);
//                 }
//               },
//             ),
//             const SizedBox(height: 12),

//             // Signup Navigation
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don't have an account? "),
//                 GestureDetector(
//                   onTap: () => Navigator.pushNamed(context, Routes.signup),
//                   child: Text(
//                     'Sign up',
//                     style: TextStyle(
//                       color: AppTheme.primary,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }wapusssssssssssssssss
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/primary_button.dart';
import '../../utils/app_theme.dart';
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
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
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

            // Email Login Button
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
                );
                setState(() => _loading = false);
                if (ok && mounted) {
                  Navigator.pushReplacementNamed(context, Routes.dashboard);
                } else {
                  setState(() => _error = 'Invalid credentials!');
                }
              },
            ),
            const SizedBox(height: 20),

            // Google Login Button
            const Text('Or login with:'),
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
                // just call the function (it handles navigation internally)
                await auth.signInWithGoogle(context);
              },
            ),
            const SizedBox(height: 12),

            // Signup Navigation
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
    );
  }
}

