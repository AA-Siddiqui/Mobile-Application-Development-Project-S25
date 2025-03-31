import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/service/supabase_service.dart';
import 'package:project/utils/email_validator.dart';
import 'package:project/utils/toast.dart';
import 'dart:core';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          width: MediaQuery.sizeOf(context).width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 36),
                child: Text(
                  "UMS",
                  style: TextStyle(
                    fontSize: 36,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Builder(builder: (context) {
                return SupaForgetAuth(
                  onSignInComplete: (_) {},
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class SupaForgetAuth extends StatefulWidget {
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
  const SupaForgetAuth({
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
  State<SupaForgetAuth> createState() => _SupaEmailAuthState();
}

class _SupaEmailAuthState extends State<SupaForgetAuth> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Focus node for email field
  final FocusNode _emailFocusNode = FocusNode();

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
              textInputAction: TextInputAction.done,
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
              onFieldSubmitted: (_) {
                _passwordRecovery();
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _passwordRecovery,
              child: Text("Send password reset email"),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Get.off(Get.currentRoute);
              },
              child: Text("Back to sign in"),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _passwordRecovery() async {
    try {
      if (!_formKey.currentState!.validate()) {
        // Focus on email field if validation fails
        _emailFocusNode.requestFocus();
        return;
      }

      final email = _emailController.text.trim();
      SupabaseService.user.resetPassword(email);
      widget.onPasswordResetEmailSent?.call();
      Toast.info(
        "Email Sent!",
        "Password reset email has been sent",
      );
      Future.delayed(Durations.extralong4, () {
        Get.off(Get.currentRoute);
      });
    } on AuthException catch (error) {
      widget.onError?.call(error);
    } catch (error) {
      widget.onError?.call(error);
    } finally {}
  }
}
