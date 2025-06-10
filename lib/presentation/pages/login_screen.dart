import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/application/providers/user_provider.dart';
import 'package:frontend/presentation/%20viewmodels/UserStateNotifier.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback onSignUpClick;

  const LoginScreen({
    super.key,
    required this.onSignUpClick,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  String? _emailError;
  String? _passwordError;

  void _validateAndLogin() {
    setState(() {
      _emailError = null;
      _passwordError = null;

      final email = _emailController.text.trim();
      final password = _passwordController.text;

      if (email.isEmpty) {
        _emailError = 'Email cannot be empty';
      } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
        _emailError = 'Invalid email format';
      }

      if (password.isEmpty) {
        _passwordError = 'Password cannot be empty';
      } else if (password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
      }

      if (_emailError == null && _passwordError == null) {
        _login(email, password);
      }
    });
  }

  Future<void> _login(String email, String password) async {
    final userNotifier = ref.read(userNotifierProvider.notifier);

    await userNotifier.login(email, password,ref);
    final authStatus = ref.read(userNotifierProvider);

    if (mounted) {
      if (authStatus == AuthStatus.authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );

        context.go('/home');
      } else if (authStatus == AuthStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userNotifierProvider) == AuthStatus.loading;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/research_paper.png',
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /* IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: widget.onBackClick,
                  ),*/
                  const SizedBox(height: 8),
                  const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF36454F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Email
                  const Text('Email',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF36454F))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'johndoe@example.com',
                      filled: true,
                      fillColor: const Color(0xFFD3D3D3),
                      errorText: _emailError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Password
                  const Text('Password',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF36454F))),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      filled: true,
                      fillColor: const Color(0xFFD3D3D3),
                      errorText: _passwordError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _validateAndLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5D5CBB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          isLoading ? 'Logging in...' : 'Login',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Divider(
                      color: Colors.grey[400],
                      thickness: 1,
                      indent: 40,
                      endIndent: 40),
                  const SizedBox(height: 8),

                  Center(
                    child: GestureDetector(
                      onTap: widget.onSignUpClick,
                      child: RichText(
                        text: const TextSpan(
                          text: 'No account? ',
                          style: TextStyle(fontSize: 14, color: Colors.black87),
                          children: [
                            TextSpan(
                              text: 'Sign up',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF5D5CBB)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
