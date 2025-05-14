/// Clase abstracta que centraliza las constantes de dimensiones utilizadas en la UI.
///
/// Esta clase define valores estándar para márgenes, paddings, tamaños de elementos
/// y otros espacios consistentes en toda la aplicación, lo cual facilita la
/// mantenibilidad y coherencia del diseño visual.
///
/// Todas las propiedades están definidas como constantes (`const`) para
/// garantizar eficiencia y evitar modificaciones accidentales.
abstract class Dimen {
  /// Grosor de borde estándar: `1.0`
  static const double border = 1.0;

  /// Espaciado extra micro: `2.5`
  ///
  /// Útil para ajustes muy pequeños entre elementos.
  static const double xMicro = 2.5;

  /// Espaciado micro: `4.0`
  ///
  /// Recomendado para espacios mínimos entre componentes muy juntos.
  static const double micro = 4.0;

  /// Espaciado muy pequeño (tiny): `6.0`
  static const double tiny = 6.0;

  /// Espaciado pequeño (xSmall): `8.0`
  static const double xSmall = 8.0;

  /// Espaciado pequeño estándar: `12.0`
  static const double small = 12.0;

  /// Espaciado regular (default): `16.0`
  static const double regular = 16.0;

  /// Espaciado medio intermedio (xMedium): `20.0`
  ///
  /// Alternativa entre `regular` y `medium`.
  static const double xMedium = 20.0;

  /// Espaciado medio: `24.0`
  static const double medium = 24.0;

  /// Espaciado grande: `32.0`
  static const double large = 32.0;

  /// Espaciado extra grande: `44.0`
  static const double xLarge = 44.0;
}
