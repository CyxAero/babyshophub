import 'package:BabyShopHub/models/user_model.dart';
import 'package:BabyShopHub/screens/dashboard/main_app.dart';
import 'package:BabyShopHub/services/auth_service.dart';
import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:BabyShopHub/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  late FocusNode _emailFocusNode;
  late FocusNode _passwordFocusNode;

  bool _passwordsMatch = true;
  bool _isFormValid = false;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    // TODO: Streamline the form validation process

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _validateEmail();
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        _validatePassword();
      }
    });

    _confirmPasswordController.addListener(_validateForm);
  }

  void _checkPasswordsMatch() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
    });
  }

  void _validateEmail() {
    setState(() {
      // Trigger email validation
      _formKey.currentState?.validate();
    });
  }

  void _validatePassword() {
    setState(() {
      // Trigger password validation
      _formKey.currentState?.validate();
    });
  }

  void _validateForm() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _confirmPasswordController.text;
      _isFormValid = _formKey.currentState?.validate() ?? false;
    });
  }

  @override
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppBar(height: 120),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              children: [
                _buildTitleSection(context),
                const SizedBox(height: 32),
                _buildSignUpForm(context),
                const SizedBox(height: 24),
                _buildDividerWithText(),
                const SizedBox(height: 24),
                _buildGoogleSignUpButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Create Account",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          "Fill your information below or register with your Google account",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

// MARK: SIGN UP FORM
  Widget _buildSignUpForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextFormField(
            controller: _usernameController,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              labelText: "Username",
              hintText: "JSmith",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: "Email",
              hintText: "johnsmith@gmail.com",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _confirmPasswordController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: "Confirm Password",
              border: const OutlineInputBorder(),
              errorText: !_passwordsMatch ? 'Passwords do not match' : null,
            ),
            obscureText: true,
            onChanged: (_) => _checkPasswordsMatch(),
            validator: (value) {
              _checkPasswordsMatch();
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (!_passwordsMatch) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onPressed: _isFormValid && _passwordsMatch
                  ? () async {
                      if (_formKey.currentState!.validate()) {
                        UserModel? user =
                            await AuthService().registerWithEmailAndPassword(
                          _emailController.text,
                          _passwordController.text,
                          _usernameController.text,
                          true,
                        );

                        setState(() {
                          _isLoading = false;
                        });

                        if (!context.mounted) return;

                        if (user != null) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainApp(
                                user: user,
                              ),
                            ),
                            (route) => false,
                          );

                          CustomSnackBar.showCustomSnackbar(
                            context,
                            'User registered with Email and Password.',
                            false,
                          );
                        } else {
                          CustomSnackBar.showCustomSnackbar(
                            context,
                            'Failed to register user. Please try again.',
                            true,
                          );
                        }
                      }
                    }
                  : null,
              child: Text(
                "Register",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          )
        ],
      ),
    );
  }

// MARK: DIVIDER WITH TEXT
  Widget _buildDividerWithText() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Or sign up with',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            thickness: 1.0,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

// MARK: GOOGLE SIGN UP BUTTON
  Widget _buildGoogleSignUpButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onPressed: _isLoading
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });

                UserModel? user = await AuthService().signInWithGoogle();

                setState(() {
                  _isLoading = false;
                });

                if (!context.mounted) return;

                if (user != null) {
                  CustomSnackBar.showCustomSnackbar(
                    context,
                    'User registered with Google Sign-In.',
                    false,
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainApp(
                        user: user,
                      ),
                    ),
                    (route) => false,
                  );
                } else {
                  CustomSnackBar.showCustomSnackbar(
                    context,
                    'Failed to sign in with Google. Please try again.',
                    true,
                  );
                }
              },
        icon: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const PhosphorIcon(PhosphorIconsBold.googleLogo),
        label: _isLoading
            ? const SizedBox.shrink()
            : Text(
                "",
                style: Theme.of(context).textTheme.titleLarge,
              ),
      ),
    );
  }
}
