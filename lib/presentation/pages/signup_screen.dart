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
  bool _isLoading = false;

  final List<String> _roleOptions = ['user', 'admin', 'guest'];

  String? _nameError;
  String? _emailError;
  String? _passwordError;
  String? _countryError;
  String? _roleError;

  void _validateAndSubmit() {
    setState(() {
      _nameError = null;
      _emailError = null;
      _passwordError = null;
      _countryError = null;
      _roleError = null;

      final name = _nameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final country = _countryController.text.trim();

      if (name.isEmpty) _nameError = 'Name cannot be empty';
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

      if (country.isEmpty) _countryError = 'Country cannot be empty';
      if (_selectedRole == null) _roleError = 'Please select a role';

      if (_nameError == null &&
          _emailError == null &&
          _passwordError == null &&
          _countryError == null &&
          _roleError == null) {
        _submit();
      }
    });
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // TODO: Replace with actual signup logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sign up successful!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              onPressed: widget.onBackClick,
              icon: const Icon(Icons.arrow_back),
            ),
            const Center(
              child: Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF36454F),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTextField("Your full name", _nameController, errorText: _nameError),
            _buildTextField("Email", _emailController,
                errorText: _emailError, keyboardType: TextInputType.emailAddress),
            _buildTextField("Password", _passwordController,
                isPassword: true,
                passwordVisible: _passwordVisible,
                onToggleVisibility: () => setState(() {
                      _passwordVisible = !_passwordVisible;
                    }),
                errorText: _passwordError),
            _buildDropdown(),
            if (_roleError != null)
              Padding(
                padding: const EdgeInsets.only(left: 12, bottom: 10),
                child: Text(
                  _roleError!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            _buildTextField("Country", _countryController, errorText: _countryError),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5D5CBB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  _isLoading ? 'Signing up...' : 'Continue',
                  style: const TextStyle(
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
            Center(
              child: GestureDetector(
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
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isPassword = false,
    bool passwordVisible = false,
    VoidCallback? onToggleVisibility,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
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
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: "Enter $label",
            filled: true,
            fillColor: const Color(0xFFD3D3D3),
            errorText: errorText,
            suffixIcon: isPassword
                ? IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Role",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff36454f),
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
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
