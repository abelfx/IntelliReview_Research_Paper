import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onBackClick;
  final VoidCallback onLoginClick;

  const SignUpScreen({
    Key? key,
    required this.onBackClick,
    required this.onLoginClick,
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _countryController = TextEditingController();
  String? _selectedRole;
  bool _passwordVisible = false;

  final List<String> _roleOptions = ['user', 'admin', 'guest'];

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _countryController.text.isEmpty ||
        _selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    print("Signup submitted");
    // Here you would call your signup logic
    // You can also navigate conditionally based on role like in your Compose code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  onPressed: widget.onBackClick,
                  icon: const Icon(Icons.arrow_back),
                ),
                const Spacer(),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff36454f),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
            const SizedBox(height: 16),
            _buildLabeledField("Your full name", _nameController),
            _buildLabeledField("Email", _emailController),
            _buildLabeledField(
              "Password",
              _passwordController,
              isPassword: true,
              passwordVisible: _passwordVisible,
              onToggleVisibility: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              },
            ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Role",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff36454f),
                ),
              ),
            ),
            const SizedBox(height: 7),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              items: _roleOptions
                  .map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                _selectedRole = value;
              }),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFEDEDED),
                hintText: "Select role",
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLabeledField("Country", _countryController),
            const SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 48,
              child: ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D5CBB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: widget.onLoginClick,
              child: RichText(
                text: const TextSpan(
                  text: 'Have an account? ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff36454f),
                  ),
                  children: [
                    TextSpan(
                      text: 'Log in',
                      style: TextStyle(
                        color: Color(0xFF5D5CBB),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLabeledField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool passwordVisible = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff36454f),
          ),
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          obscureText: isPassword && !passwordVisible,
          decoration: InputDecoration(
            hintText: "Enter $label",
            filled: true,
            fillColor: const Color(0xFFD3D3D3),
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
