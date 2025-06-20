import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/routes/routes.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/app_text_field.dart';
import '../../../../../generated/l10n.dart';
import '../logic/forgot_password_cubit.dart';
import '../logic/forgot_password_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if passwords match
    final cubit = context.read<ForgotPasswordCubit>();
    if (cubit.newPasswordController.text.trim() !=
        cubit.confirmPasswordController.text.trim()) {
      context.showErrorSnackBar(S.of(context).Passwords_do_not_match);
      return;
    }

    cubit.resetPassword();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ForgotPasswordCubit>();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          S.of(context).Reset_Password,
          style: theme.appBarTheme.titleTextStyle,
        ),
        iconTheme: theme.appBarTheme.iconTheme,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordSuccess) {
                context.showSuccessSnackBar(
                  state.response.message.isNotEmpty
                      ? state.response.message
                      : S.of(context).Password_reset_successful,
                );

                // Navigate back to login screen
                Navigator.pushReplacementNamed(context, Routes.travelerLogin);
              } else if (state is ForgotPasswordError) {
                context.showErrorSnackBar(state.errorMessage);
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Icon/Image
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock_reset,
                        size: 80,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Title
                    Text(
                      S.of(context).Reset_Password,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      S.of(context).Enter_email_and_new_password,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface.withOpacity(0.6),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Email Field
                    AppTextField(
                      controller: cubit.emailController,
                      hintText: S.of(context).Email,
                      prefixIcon: const Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.validateEmail,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),

                    // New Password Field
                    AppTextField(
                      controller: cubit.newPasswordController,
                      hintText: S.of(context).New_Password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      isPassword: true,
                      passwordVisible: !cubit.obscureNewPassword,
                      keyboardType: TextInputType.visiblePassword,
                      validator: Validators.validatePassword,
                      textInputAction: TextInputAction.next,
                      onTogglePasswordVisibility: () {
                        cubit.toggleNewPasswordVisibility();
                      },
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    AppTextField(
                      controller: cubit.confirmPasswordController,
                      hintText: S.of(context).Confirm_New_Password,
                      prefixIcon: const Icon(Icons.lock_outline),
                      isPassword: true,
                      passwordVisible: !cubit.obscureConfirmPassword,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).Please_confirm_password;
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onTogglePasswordVisibility: () {
                        cubit.toggleConfirmPasswordVisibility();
                      },
                      onFieldSubmitted: (_) => _resetPassword(),
                    ),
                    const SizedBox(height: 30),

                    // Reset Password Button
                    AppButton(
                      text: S.of(context).Reset_Your_Password,
                      isLoading: state is ForgotPasswordLoading,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _resetPassword();
                      },
                    ),
                    const SizedBox(height: 20),

                    // Back to Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).Remember_password,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              Routes.travelerLogin,
                            );
                          },
                          child: Text(
                            S.of(context).Log_In,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
