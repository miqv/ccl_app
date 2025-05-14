import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

/// Servicio estático para mostrar `SnackBar`s personalizados utilizando
/// el paquete `awesome_snackbar_content`.
///
/// Este servicio permite mostrar diferentes tipos de mensajes visuales
/// (error, éxito, advertencia, información) de forma uniforme en toda la aplicación.
class SnackbarService {
  /// Muestra un `SnackBar` personalizado con contenido dinámico.
  ///
  /// [context] es el `BuildContext` donde se mostrará el `SnackBar`.
  /// [title] es el título del mensaje.
  /// [message] es el contenido o descripción del mensaje.
  /// [contentType] define el tipo de mensaje (`success`, `failure`, `warning`, `help`).
  static void show(
    BuildContext context, {
    required String title,
    required String message,
    required ContentType contentType,
  }) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: title,
        message: message,
        contentType: contentType,
      ),
    );

    // Limpia cualquier SnackBar previo y muestra uno nuevo.
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  /// Muestra un `SnackBar` de tipo **error** con el mensaje proporcionado.
  static void showError(BuildContext context, String message) {
    show(
      context,
      title: 'Error',
      message: message,
      contentType: ContentType.failure,
    );
  }

  /// Muestra un `SnackBar` de tipo **éxito** con el mensaje proporcionado.
  static void showSuccess(BuildContext context, String message) {
    show(
      context,
      title: 'Éxito',
      message: message,
      contentType: ContentType.success,
    );
  }

  /// Muestra un `SnackBar` de tipo **advertencia** con el mensaje proporcionado.
  static void showWarning(BuildContext context, String message) {
    show(
      context,
      title: 'Advertencia',
      message: message,
      contentType: ContentType.warning,
    );
  }

  /// Muestra un `SnackBar` de tipo **información** con el mensaje proporcionado.
  static void showInfo(BuildContext context, String message) {
    show(
      context,
      title: 'Información',
      message: message,
      contentType: ContentType.help,
    );
  }
}
