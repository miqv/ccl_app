import 'package:ccl_app/core/dimens.dart';
import 'package:flutter/widgets.dart';

/// Utilidad estática para definir espacios constantes en la interfaz de usuario.
///
/// Esta clase proporciona [SizedBox] con tamaños estandarizados,
/// permitiendo una separación coherente entre widgets en toda la aplicación.
///
/// Todos los valores provienen de la clase [Dimen] para mantener la consistencia global.
///
/// Ejemplo de uso:
/// ```dart
/// Column(
///   children: [
///     Text('Nombre'),
///     Spacing.small,
///     TextField(),
///     Spacing.medium,
///     ElevatedButton(onPressed: () {}, child: Text('Guardar')),
///   ],
/// );
/// ```
abstract class Spacing {
  /// Espacio muy pequeño (`4.0` px).
  static const SizedBox micro = SizedBox(
    height: Dimen.micro,
    width: Dimen.micro,
  );

  /// Espacio pequeño (`6.0` px).
  static const SizedBox tiny = SizedBox(
    height: Dimen.tiny,
    width: Dimen.tiny,
  );

  /// Espacio extra pequeño (`8.0` px).
  static const SizedBox xSmall = SizedBox(
    height: Dimen.xSmall,
    width: Dimen.xSmall,
  );

  /// Espacio pequeño común (`12.0` px).
  static const SizedBox small = SizedBox(
    height: Dimen.small,
    width: Dimen.small,
  );

  /// Espacio regular (`16.0` px), ideal para separación estándar.
  static const SizedBox regular = SizedBox(
    height: Dimen.regular,
    width: Dimen.regular,
  );

  /// Espacio mediano (`24.0` px).
  static const SizedBox medium = SizedBox(
    height: Dimen.medium,
    width: Dimen.medium,
  );

  /// Espacio grande (`32.0` px).
  static const SizedBox large = SizedBox(
    height: Dimen.large,
    width: Dimen.large,
  );

  /// Espacio extra grande (`44.0` px), útil para secciones o divisores importantes.
  static const SizedBox xLarge = SizedBox(
    height: Dimen.xLarge,
    width: Dimen.xLarge,
  );
}
