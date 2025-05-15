import 'package:ccl_app/core/components/snackbar_service.dart';
import 'package:ccl_app/core/dimens.dart';
import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ccl_app/app/login/bloc/login_cubit.dart';
import 'package:ccl_app/core/components/spacer.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/core/routes/routes.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Main login screen that uses [LoginCubit] to manage its state.
///
/// This widget is annotated with [RoutePage] to support auto routing.
/// It provides the [LoginCubit] to the widget tree using [BlocProvider],
/// initializing it with the `start()` method.
@RoutePage()
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LoginCubit>()..start(),
      child: const _LoginScreen(),
    );
  }
}

/// Internal stateful widget that represents the content of the login screen.
///
/// Handles UI interactions such as form inputs and triggers login actions
/// through the [LoginCubit].
class _LoginScreen extends StatefulWidget {
  const _LoginScreen({Key? key}) : super(key: key);

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.login.title.tr())),
      body: Padding(
        padding: EdgeInsets.all(Dimen.regular),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginInit) {
              FlutterNativeSplash.remove();
              return;
            }

            if (state is LoginFailed) {
              SnackbarService.showError(
                context,
                LocaleKeys.login.failedMessage.tr(),
              );
            }

            if (state is LoginSucceeded) {
              SnackbarService.showSuccess(
                context,
                LocaleKeys.login.succeededMessage.tr(),
              );
              context.router.navigate(const NavigationScreenRoute());
            }

            if (state is LoginPassword) {
              setState(() {
                isPasswordVisible = state.isPasswordVisible;
              });
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Spacing.regular,
                  _buildEmailField(),
                  Spacing.regular,
                  _buildPasswordField(cubit),
                  Spacing.regular,
                  _buildLoginButton(cubit),
                  Spacing.regular,
                  _buildRegisterText(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the email input field for user authentication.
  ///
  /// Uses [TextFormField] and supports localization.
  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: LocaleKeys.login.labelTextEmail.tr(),
        hintText: LocaleKeys.login.hintTextEmail.tr(),
        border: const OutlineInputBorder(),
      ),
    );
  }

  /// Builds the password input field with visibility toggle.
  ///
  /// Uses [TextField] with [LoginCubit.togglePasswordVisibility] to control
  /// the visibility of the password field.
  Widget _buildPasswordField(LoginCubit cubit) {
    return TextField(
      controller: passwordController,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: LocaleKeys.login.labelTextPassword.tr(),
        hintText: LocaleKeys.login.hintTextPassword.tr(),
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: cubit.togglePasswordVisibility,
        ),
      ),
    );
  }

  /// Builds the login button that initiates the login process.
  ///
  /// Invokes [LoginCubit.login] with the values from the input fields.
  Widget _buildLoginButton(LoginCubit cubit) {
    return ElevatedButton(
      onPressed: () {
        cubit.login(emailController.text, passwordController.text);
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        textStyle: const TextStyle(fontSize: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(LocaleKeys.login.loginButton.tr()),
    );
  }

  /// Builds the registration redirect row at the bottom of the screen.
  ///
  /// Provides a prompt and a button to navigate to the registration screen.
  Widget _buildRegisterText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(LocaleKeys.login.questionRegister.tr()),
        TextButton(
          onPressed: () {
            context.router.navigate(const RegisterScreenRoute());
          },
          child: Text(LocaleKeys.login.registerButton.tr()),
        ),
      ],
    );
  }
}
