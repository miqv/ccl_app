import 'package:ccl_app/core/di/injection.config.dart'; // Archivo generado automáticamente por Injectable
import 'package:ccl_app/core/routes/routes.dart'; // Define el router personalizado de la app
import 'package:get_it/get_it.dart'; // Service locator
import 'package:injectable/injectable.dart'; // Anotaciones para la generación de dependencias

/// Instancia global de GetIt utilizada para el registro y acceso de dependencias.
///
/// Se usa a lo largo de toda la aplicación para obtener servicios, blocs, repositorios, etc.
final getIt = GetIt.instance;

/// Configura la inyección de dependencias para toda la aplicación.
///
/// - Inicializa todas las dependencias anotadas con `@injectable`
///   usando el archivo generado `injection.config.dart`.
/// - Registra manualmente el `AppRouter` como una instancia única ([singleton]),
///   lo cual es útil para navegación global en la app.
///
/// Este método debe ser llamado al iniciar la aplicación, normalmente dentro del `main()`
/// antes de correr `runApp()`.
@injectableInit
void configureInjection() {
  // Inicializa las dependencias anotadas con @injectable
  getIt.init();

  // Registro manual del router de navegación como singleton
  getIt.registerSingleton<AppRouter>(AppRouter());
}
