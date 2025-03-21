import 'package:flutter/material.dart';
import 'package:project/pages/forget_password_page.dart';
import 'package:project/utils/email_validator.dart';
import 'package:project/utils/show_snack_bar.dart';
import 'dart:core';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupaEmailAuth extends StatefulWidget {
  /// The URL to redirect the user to when clicking on the link on the
  /// confirmation link after signing up.
  final String? redirectTo;

  /// The URL to redirect the user to when clicking on the link on the
  /// password recovery link.
  ///
  /// If unspecified, the [redirectTo] value will be used.
  final String? resetPasswordRedirectTo;

  /// Validator function for the password field
  ///
  /// If null, a default validator will be used that checks if
  /// the password is at least 6 characters long.
  final String? Function(String?)? passwordValidator;

  /// Callback for the user to complete a sign in.
  final void Function(AuthResponse response) onSignInComplete;

  /// Callback for sending the password reset email
  final void Function()? onPasswordResetEmailSent;

  /// Callback for when the auth action threw an exception
  ///
  /// If set to `null`, a snack bar with error color will show up.
  final void Function(Object error)? onError;

  /// Callback for toggling between sign-in/ sign-up and password recovery
  final void Function(bool isRecoveringPassword)? onToggleRecoverPassword;

  /// Icons or custom prefix widgets for email UI
  final Widget? prefixIconEmail;
  final Widget? prefixIconPassword;

  /// {@macro supa_email_auth}
  const SupaEmailAuth({
    super.key,
    this.redirectTo,
    this.resetPasswordRedirectTo,
    this.passwordValidator,
    required this.onSignInComplete,
    this.onPasswordResetEmailSent,
    this.onError,
    this.onToggleRecoverPassword,
    this.prefixIconEmail = const Icon(Icons.email),
    this.prefixIconPassword = const Icon(Icons.lock),
  });

  @override
  State<SupaEmailAuth> createState() => _SupaEmailAuthState();
}

class _SupaEmailAuthState extends State<SupaEmailAuth> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  /// The user has pressed forgot password button
  // bool _isRecoveringPassword = false;

  /// Focus node for email field
  final FocusNode _emailFocusNode = FocusNode();

  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autofocus: true,
              focusNode: _emailFocusNode,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    !EmailValidator.validate(_emailController.text)) {
                  return "Please enter a valid email address";
                }
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: widget.prefixIconEmail,
                label: Text("Enter your email"),
              ),
              controller: _emailController,
              onFieldSubmitted: (_) {},
            ),
            SizedBox(height: 16),
            TextFormField(
              autofillHints: [AutofillHints.password],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              textInputAction: TextInputAction.done,
              validator: widget.passwordValidator ??
                  (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return "Please enter a password that is at least 6 characters long";
                    }
                    return null;
                  },
              decoration: InputDecoration(
                prefixIcon: widget.prefixIconPassword,
                label: Text("Enter your password"),
              ),
              obscureText: true,
              controller: _passwordController,
              onFieldSubmitted: (_) {
                _signInSignUp();
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _signInSignUp,
              child: (_isLoading)
                  ? SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.onPrimary,
                        strokeWidth: 1.5,
                      ),
                    )
                  : Text("Sign In"),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ForgetPasswordPage(),
                ),
              ),
              child: Text("Forgot your password?"),
            ),
          ],
        ),
      ),
    );
  }

  void _signInSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      widget.onSignInComplete.call(response);
    } on AuthException catch (error) {
      if (widget.onError == null && mounted) {
        context.showErrorSnackBar(error.message);
      } else {
        widget.onError?.call(error);
      }
      _emailFocusNode.requestFocus();
    } catch (error) {
      if (widget.onError == null && mounted) {
        context.showErrorSnackBar("An unexpected error occurred: $error");
      } else {
        widget.onError?.call(error);
      }
      _emailFocusNode.requestFocus();
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
