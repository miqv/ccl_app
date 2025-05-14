import 'package:ccl_app/core/components/snackbar_service.dart';
import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/app/register/bloc/register_cubit.dart';
import 'package:ccl_app/core/components/spacer.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/core/utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Pantalla de registro de usuario, inyecta el [RegisterCubit] usando getIt.
@RoutePage()
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>()..start(),
      child: const _RegisterScreen(),
    );
  }
}

/// Stateful widget que construye el formulario de registro.
class _RegisterScreen extends StatefulWidget {
  const _RegisterScreen();

  @override
  State<_RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<_RegisterScreen> {
  // Controladores para los campos de texto
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  // Estados de la UI
  bool _isPasswordVisible = false;
  bool _isValidatedFields = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.register.title.tr())),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterFailed) {
              SnackbarService.showError(
                context,
                state.message ==
                        LocaleKeys.register.failedMessageExistingEmail.tr()
                    ? state.message!
                    : LocaleKeys.register.failedMessage.tr(),
              );
            } else if (state is RegisterSucceeded) {
              SnackbarService.showSuccess(
                context,
                LocaleKeys.register.succeededMessage.tr(),
              );
            } else if (state is RegisterPassword) {
              setState(() => _isPasswordVisible = state.isPasswordVisible);
            } else if (state is RegisterValidatedFields) {
              setState(() => _isValidatedFields = true);
            }
          },
          builder: (context, state) {
            final cubit = context.read<RegisterCubit>();

            return SingleChildScrollView(
              child: Column(
                children: [
                  Spacing.medium,
                  _buildTextField(
                    controller: _firstNameController,
                    label: LocaleKeys.register.labelTextFirstName.tr(),
                    keyboardType: TextInputType.name,
                    onChanged: cubit.setFirstName,
                    showError:
                        _isValidatedFields && _firstNameController.text.isEmpty,
                  ),
                  Spacing.regular,
                  _buildTextField(
                    controller: _lastNameController,
                    label: LocaleKeys.register.labelTextLastName.tr(),
                    keyboardType: TextInputType.name,
                    onChanged: cubit.setLastName,
                    showError:
                        _isValidatedFields && _lastNameController.text.isEmpty,
                  ),
                  Spacing.regular,
                  _buildTextField(
                    controller: _emailController,
                    label: LocaleKeys.register.labelTextEmail.tr(),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: cubit.setEmail,
                    showError:
                        _isValidatedFields && _emailController.text.isEmpty,
                    customError: _isValidatedFields &&
                            !_emailController.text.isValidEmail()
                        ? LocaleKeys.register.emailFieldError.tr()
                        : null,
                  ),
                  Spacing.regular,
                  _buildPasswordField(cubit),
                  Spacing.large,
                  _buildLoginButton(cubit),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Crea un campo de texto con estilo uniforme y validación de errores.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required Function(String) onChanged,
    bool showError = false,
    String? customError,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        errorText:
            (showError ? LocaleKeys.register.requiredField.tr() : null) ??
                customError,
      ),
      onChanged: onChanged,
    );
  }

  /// Crea un campo de contraseña con botón de visibilidad.
  Widget _buildPasswordField(RegisterCubit cubit) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: LocaleKeys.register.labelTextPassword.tr(),
        border: const OutlineInputBorder(),
        errorText: _isValidatedFields && _passwordController.text.isEmpty
            ? LocaleKeys.register.requiredField.tr()
            : null,
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: cubit.togglePasswordVisibility,
        ),
      ),
      onChanged: cubit.setPassword,
    );
  }

  /// Botón de acción para crear usuario.
  Widget _buildLoginButton(RegisterCubit cubit) {
    return ElevatedButton(
      onPressed: cubit.register,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        textStyle: const TextStyle(fontSize: 16),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(LocaleKeys.register.registerButton.tr()),
    );
  }
}
