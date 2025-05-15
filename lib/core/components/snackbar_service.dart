import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

/// A static service to display styled `SnackBar`s across the app
/// using the `awesome_snackbar_content` package.
///
/// This service provides a consistent way to show different types
/// of feedback messages (error, success, warning, info) in the UI.
class SnackbarService {
  /// Displays a custom [SnackBar] with styled content using [AwesomeSnackbarContent].
  ///
  /// - [context]: The [BuildContext] used to display the `SnackBar`.
  /// - [title]: The title of the message (e.g., "Success", "Error").
  /// - [message]: The body content of the message.
  /// - [contentType]: The visual type of message: `success`, `failure`, `warning`, or `help`.
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

    // Dismisses any current SnackBar and shows a new one
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  /// Displays an error [SnackBar] with red styling and failure icon.
  ///
  /// - [context]: Context in which to display the `SnackBar`.
  /// - [message]: The error message content.
  static void showError(BuildContext context, String message) {
    show(
      context,
      title: 'Error',
      message: message,
      contentType: ContentType.failure,
    );
  }

  /// Displays a success [SnackBar] with green styling and success icon.
  ///
  /// - [context]: Context in which to display the `SnackBar`.
  /// - [message]: The success message content.
  static void showSuccess(BuildContext context, String message) {
    show(
      context,
      title: 'Success',
      message: message,
      contentType: ContentType.success,
    );
  }

  /// Displays a warning [SnackBar] with yellow styling and warning icon.
  ///
  /// - [context]: Context in which to display the `SnackBar`.
  /// - [message]: The warning message content.
  static void showWarning(BuildContext context, String message) {
    show(
      context,
      title: 'Warning',
      message: message,
      contentType: ContentType.warning,
    );
  }

  /// Displays an informational [SnackBar] with blue styling and help icon.
  ///
  /// - [context]: Context in which to display the `SnackBar`.
  /// - [message]: The info message content.
  static void showInfo(BuildContext context, String message) {
    show(
      context,
      title: 'Info',
      message: message,
      contentType: ContentType.help,
    );
  }
}
