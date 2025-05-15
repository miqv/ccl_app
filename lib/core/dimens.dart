/// Abstract class that centralizes dimension constants used across the UI.
///
/// This class defines standard values for margins, paddings, spacing between
/// elements, and other layout dimensions. Centralizing these values promotes
/// consistency, scalability, and easier maintenance throughout the application.
///
/// All properties are declared as `const` to ensure performance and prevent
/// unintended modification.
abstract class Dimen {
  /// Standard border width: `1.0`
  static const double border = 1.0;

  /// Extra micro spacing: `2.5`
  ///
  /// Useful for very fine-tuned adjustments between tightly packed elements.
  static const double xMicro = 2.5;

  /// Micro spacing: `4.0`
  ///
  /// Recommended for minimal spacing between closely related widgets.
  static const double micro = 4.0;

  /// Very small spacing (tiny): `6.0`
  static const double tiny = 6.0;

  /// Extra small spacing (xSmall): `8.0`
  static const double xSmall = 8.0;

  /// Small standard spacing: `12.0`
  static const double small = 12.0;

  /// Regular/default spacing: `16.0`
  static const double regular = 16.0;

  /// Intermediate medium spacing (xMedium): `20.0`
  ///
  /// A spacing option between `regular` and `medium`.
  static const double xMedium = 20.0;

  /// Medium spacing: `24.0`
  static const double medium = 24.0;

  /// Large spacing: `32.0`
  static const double large = 32.0;

  /// Extra large spacing: `44.0`
  static const double xLarge = 44.0;
}
