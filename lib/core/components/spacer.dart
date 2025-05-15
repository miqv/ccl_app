import 'package:ccl_app/core/dimens.dart';
import 'package:flutter/widgets.dart';

/// A utility class that provides consistent spacing widgets
/// using predefined sizes from [Dimen].
///
/// This helps maintain consistent spacing between UI components
/// across the entire app.
///
/// ### Example usage:
/// ```dart
/// Column(
///   children: [
///     Text('Name'),
///     Spacing.small,
///     TextField(),
///     Spacing.medium,
///     ElevatedButton(onPressed: () {}, child: Text('Save')),
///   ],
/// );
/// ```
///
/// All spacing constants are defined as [SizedBox] widgets,
/// making layout construction easier and cleaner.
abstract class Spacing {
  /// Very small spacing (`4.0` px).
  static const SizedBox micro = SizedBox(
    height: Dimen.micro,
    width: Dimen.micro,
  );

  /// Tiny spacing (`6.0` px).
  static const SizedBox tiny = SizedBox(
    height: Dimen.tiny,
    width: Dimen.tiny,
  );

  /// Extra small spacing (`8.0` px).
  static const SizedBox xSmall = SizedBox(
    height: Dimen.xSmall,
    width: Dimen.xSmall,
  );

  /// Small spacing (`12.0` px).
  static const SizedBox small = SizedBox(
    height: Dimen.small,
    width: Dimen.small,
  );

  /// Regular spacing (`16.0` px). Ideal for general use.
  static const SizedBox regular = SizedBox(
    height: Dimen.regular,
    width: Dimen.regular,
  );

  /// Medium spacing (`24.0` px).
  static const SizedBox medium = SizedBox(
    height: Dimen.medium,
    width: Dimen.medium,
  );

  /// Large spacing (`32.0` px).
  static const SizedBox large = SizedBox(
    height: Dimen.large,
    width: Dimen.large,
  );

  /// Extra large spacing (`44.0` px). Great for visual breaks or section spacing.
  static const SizedBox xLarge = SizedBox(
    height: Dimen.xLarge,
    width: Dimen.xLarge,
  );
}
