import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/core/routes/routes.gr.dart';

/// Defines the application's routing configuration using `auto_route`.
///
/// This class extends [RootStackRouter] and provides a centralized declaration
/// of all available routes in the app. It uses custom transitions and nested navigation.
///
/// The [@AutoRouterConfig] annotation tells `auto_route` to generate route
/// classes with names that replace `Page`, `Route`, or `Screen` from the
/// widget class names.
@AutoRouterConfig(
  replaceInRouteName: 'Page,Route,Screen',
)
class AppRouter extends RootStackRouter {
  /// The default transition type for all routes.
  /// [RouteType.adaptive] ensures platform-specific transitions
  /// (Cupertino on iOS, Material on Android).
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  /// The list of all routes available in the app.
  ///
  /// Includes:
  /// - `/` → [LoginScreenRoute] with slide-left-with-fade transition.
  /// - `/register` → [RegisterScreenRoute] with slide-left-with-fade transition.
  /// - `/navigation/products` → Nested route under [NavigationScreenRoute]
  ///   pointing to [ProductsScreenRoute] with custom transition.
  @override
  final List<AutoRoute> routes = [
    CustomRoute(
      path: '/',
      page: LoginScreenRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    CustomRoute(
      path: '/register',
      page: RegisterScreenRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    CustomRoute(
      path: '/inventoryFormRoute',
      page: InventoryFormRoute.page,
      transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
    ),
    AutoRoute(
      path: '/navigation',
      page: NavigationScreenRoute.page,
      children: [
        CustomRoute(
          path: 'products',
          page: ProductsScreenRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
        CustomRoute(
          path: 'inventory',
          page: InventoryScreenRoute.page,
          transitionsBuilder: TransitionsBuilders.slideLeftWithFade,
        ),
      ],
    ),
  ];
}
