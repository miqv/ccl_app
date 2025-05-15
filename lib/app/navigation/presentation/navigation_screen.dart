import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/app/navigation/bloc/navigation_cubit.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/core/routes/routes.gr.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Navigation screen with bottom tab navigation using [AutoTabsScaffold].
///
/// This screen uses [NavigationCubit] to track the selected index and display
/// the appropriate title. It provides navigation between two tabs, both of
/// which currently route to [ProductsScreenRoute].
///
/// The app bar title is dynamically updated based on the selected index.
/// Bottom navigation icons and labels are localized via [EasyLocalization].
@RoutePage()
class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 0;
    String title = LocaleKeys.navigation.titleProducts.tr();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<NavigationCubit>()..start()),
      ],
      child: BlocConsumer<NavigationCubit, NavigationState>(
        listener: (BuildContext context, NavigationState state) {
          if (state is NavigationInit) return;

          if (state is NavigationSelected) {
            selectedIndex = state.selectedIndex;
            switch (selectedIndex) {
              case 0:
                title = LocaleKeys.navigation.titleProducts.tr();
                break;
              case 1:
                title = LocaleKeys.navigation.titleInputOutput.tr();
                break;
            }
          }
        },
        builder: (context, state) {
          return AutoTabsScaffold(
            appBarBuilder: (_, tabsRouter) => AppBar(
              leadingWidth: 0,
              leading: Container(),
              centerTitle: true,
              title: Text(title),
            ),
            routes: const [
              ProductsScreenRoute(),
              ProductsScreenRoute(), // TODO: next commit
            ],
            bottomNavigationBuilder: (_, tabsRouter) {
              return BlocBuilder<NavigationCubit, NavigationState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 100,
                    child: BottomNavigationBar(
                      selectedItemColor: Colors.blue,
                      type: BottomNavigationBarType.fixed,
                      iconSize: 35,
                      items: <BottomNavigationBarItem>[
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.view_list_outlined),
                          label: LocaleKeys.navigation.titleProducts.tr(),
                        ),
                        BottomNavigationBarItem(
                          icon: const Icon(Icons.swap_vert),
                          label: LocaleKeys.navigation.titleInputOutput.tr(),
                        ),
                      ],
                      currentIndex: tabsRouter.activeIndex,
                      onTap: (index) {
                        tabsRouter.setActiveIndex(index);
                        context.read<NavigationCubit>().setSelectIndex(index);
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
