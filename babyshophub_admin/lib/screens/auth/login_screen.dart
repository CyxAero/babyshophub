import 'package:babyshophub_admin/models/user_model.dart';
import 'package:babyshophub_admin/screens/dashboard/main_app.dart';
import 'package:babyshophub_admin/services/auth_service.dart';
import 'package:babyshophub_admin/widgets/basic_appbar.dart';
import 'package:babyshophub_admin/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  late FocusNode _emailFocusNode;

  bool _isLoading = false;
  bool _isGoogleLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _emailFocusNode = FocusNode();

    // TODO: Streamline the form validation process

    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        _validateEmail();
      }
    });
  }

  void _validateEmail() {
    setState(() {
      // Trigger email validation
      _formKey.currentState?.validate();
    });
  }

  Future<void> _signIn(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      UserModel? user = await AuthService().signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (!context.mounted) return;

      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainApp(
              user: user,
            ),
          ),
        );
        // Navigator.of(context).pushReplacement(
        //   MaterialPageRoute(
        //     builder: (context) => MainApp(
        //       user: user,
        //     ),
        //   ),
        // );

        CustomSnackBar.showCustomSnackbar(
          context,
          'User logged in with Email and Password.',
          false,
        );
      } else {
        CustomSnackBar.showCustomSnackbar(
          context,
          'Failed to log in user. Please try again.',
          true,
        );
      }
    }
  }

  @override
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const BasicAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            // padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
            child: Column(
              children: [
                _buildTitleSection(context),
                const SizedBox(height: 32),
                _buildLogInForm(context),
                const SizedBox(height: 24),
                _buildDividerWithText(),
                const SizedBox(height: 24),
                _buildGoogleLogInButton(context),
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
          "Log In",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        Text(
          "Fill your information below or log in with your Google account",
          style: Theme.of(context).textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

// MARK: LOGIN FORM
  Widget _buildLogInForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 8),
              ),
              onPressed: _isLoading
                  ? null
                  : () async {
                      _signIn(context);
                    },
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      "Log in",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
            ),
          )
        ],
      ),
    );
  }

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
            'Or log in with',
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

  Widget _buildGoogleLogInButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onPressed: _isGoogleLoading
            ? null
            : () async {
                setState(() {
                  _isGoogleLoading = true;
                });

                UserModel? user = await AuthService().signInWithGoogle();

                setState(() {
                  _isGoogleLoading = false;
                });

                if (!context.mounted) return;

                if (user != null) {
                  CustomSnackBar.showCustomSnackbar(
                    context,
                    'User logged in with Google Sign-In.',
                    false,
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainApp(
                        user: user,
                      ),
                    ),
                  );
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //   builder: (context) => MainApp(
                  //     user: user,
                  //   ),
                  // ));
                } else {
                  CustomSnackBar.showCustomSnackbar(
                    context,
                    'Failed to sign in with Google. Please try again.',
                    true,
                  );
                }
              },
        icon: _isGoogleLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const PhosphorIcon(
                PhosphorIconsBold.googleLogo,
                size: 32,
              ),
        label: _isGoogleLoading
            ? const SizedBox.shrink()
            : Text(
                "",
                style: Theme.of(context).textTheme.titleLarge,
              ),
      ),
    );
  }
}
