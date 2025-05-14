import 'dart:ui';

import 'package:ccl_app/core/translations/es-CO.dart';
import 'package:easy_localization/easy_localization.dart' show AssetLoader;

/// Clase personalizada para la carga de archivos de localización.
///
/// Esta clase extiende [AssetLoader] de la librería `easy_localization` y permite
/// cargar traducciones directamente desde un mapa en memoria, en lugar de usar
/// archivos JSON externos.
///
/// Actualmente solo soporta el idioma español de Colombia (`es_CO`).
class Localization extends AssetLoader {
  /// Constructor constante para permitir el uso como singleton.
  const Localization();

  /// Sobrescribe el método [load] para retornar el mapa de traducción
  /// correspondiente al `locale` solicitado.
  ///
  /// Este método no accede al sistema de archivos, ya que las traducciones
  /// están definidas en memoria dentro de [mapLocales].
  ///
  /// - [path] es ignorado en esta implementación.
  /// - [locale] es utilizado para obtener el mapa correspondiente.
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) {
    return Future.value(mapLocales[locale.toString()]);
  }

  /// Mapa que contiene los locales soportados por la aplicación.
  ///
  /// Clave: String con el código de idioma y país (por ejemplo: `"es_CO"`).
  /// Valor: Mapa de traducciones definido en el archivo `es-CO.dart`.
  static Map<String, Map<String, dynamic>> mapLocales = {
    "es_CO": esCO,
  };
}
