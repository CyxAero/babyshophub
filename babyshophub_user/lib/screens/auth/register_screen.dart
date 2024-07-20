import 'package:BabyShopHub/models/user_model.dart';
import 'package:BabyShopHub/providers/user_provider.dart';
import 'package:BabyShopHub/screens/dashboard/main_app.dart';
import 'package:BabyShopHub/services/auth_service.dart';
import 'package:BabyShopHub/theme/theme_extension.dart';
import 'package:BabyShopHub/widgets/basic_appbar.dart';
import 'package:BabyShopHub/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

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
  bool _isGoogleLoading = false;

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

  // MARK: Register method
  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);

        UserModel? user = await authService.registerWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
          _usernameController.text,
          false, // isAdmin
        );

        if (user != null) {
          await userProvider.refreshUser(); // Ensure UserProvider is updated
          if (!context.mounted) return;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainApp()),
          );
          CustomSnackBar.showCustomSnackbar(
            context,
            'User registered successfully.',
            false,
          );
        } else {
          throw Exception('Failed to register user');
        }
      } catch (e) {
        CustomSnackBar.showCustomSnackbar(
          context,
          'Failed to register user. Please try again.',
          true,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const BasicAppBar(height: 80),
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
            decoration: InputDecoration(
              labelText: "Username",
              hintText: "JSmith",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
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
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "johnsmith@gmail.com",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
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
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
              ),
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
                      _register(context);
                    }
                  : null,
              child: _isLoading
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: SizedBox(
                        height: 32,
                        width: 32,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.white1,
                          ),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "Register",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.black2,
                            ),
                      ),
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
                  _isGoogleLoading = true;
                });
                try {
                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  final userProvider =
                      Provider.of<UserProvider>(context, listen: false);

                  UserModel? user = await authService.signInWithGoogle();

                  if (user != null) {
                    await userProvider
                        .refreshUser(); // Ensure UserProvider is updated
                    if (!context.mounted) return;
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainApp()),
                    );
                    CustomSnackBar.showCustomSnackbar(
                      context,
                      'Logged in with Google successfully.',
                      false,
                    );
                  } else {
                    throw Exception('Failed to log in with Google');
                  }
                } catch (e) {
                  CustomSnackBar.showCustomSnackbar(
                    context,
                    'Failed to log in with Google. Please try again.',
                    true,
                  );
                } finally {
                  setState(() {
                    _isGoogleLoading = false;
                  });
                }
              },
        icon: _isGoogleLoading
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.white1,
                    ),
                  ),
                ),
              )
            : const Icon(UniconsLine.google, size: 32),
        label: const Text(""),
      ),
    );
  }
}
