import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/core/routes/routes.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route,Screen',
)
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();
  @override
  final List<AutoRoute> routes = [
    CustomRoute(
        path: '/',
        page: LoginScreenRoute.page,
        transitionsBuilder: TransitionsBuilders.slideLeftWithFade),
    CustomRoute(
        path: '/register',
        page: RegisterScreenRoute.page,
        transitionsBuilder: TransitionsBuilders.slideLeftWithFade),
  ];
}
