import 'package:ccl_app/app/navigation/bloc/navigation_cubit.dart';
import 'package:ccl_app/app/products/bloc/products_cubit.dart';
import 'package:ccl_app/app/products/presentation/products_screen.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:mocktail/mocktail.dart';

import '../../../core/utils.dart';

/// A mock class for ProductsCubit using mocktail.
class MockedProductsCubit extends MockCubit<ProductsState>
    implements ProductsCubit {}

/// A mock class for NavigationCubit using mocktail.
class MockedNavigationCubit extends MockCubit<NavigationState>
    implements NavigationCubit {}

/// A fallback fake class for ProductsState to avoid type errors in tests.
class FakedProductsState extends Fake implements ProductsState {}

void main() async {
  late ProductsCubit cubit;
  late NavigationCubit cubitNavigation;
  late Widget testableWidget;

  // Initialize EasyLocalization before running tests
  await initEasyLocalization();

  // Register fake fallback values globally for mocktail
  setUpAll(() {
    registerFallbackValue(FakedProductsState());
  });

  /// Prepares the test widget by injecting a mocked ProductsCubit
  void initMainWidget() {
    cubit = MockedProductsCubit();
    cubitNavigation = MockedNavigationCubit();

    // Initial state for both cubits
    when(() => cubit.state).thenReturn(ProductsLoading());
    when(() => cubit.start()).thenAnswer((_) async {});
    when(() => cubitNavigation.state).thenReturn(NavigationInit());

    // Register mock dependencies
    GetItHelper(GetIt.instance).factory<ProductsCubit>(() => cubit);
    GetItHelper(GetIt.instance).factory<NavigationCubit>(() => cubitNavigation);

    testableWidget = makeTestableWidget(
      child: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider<ProductsCubit>(create: (_) => getIt<ProductsCubit>()),
            BlocProvider<NavigationCubit>(create: (_) => getIt<NavigationCubit>()),
          ],
          child: BlocListener<NavigationCubit, NavigationState>(
            listener: (context, state) {
              if (state is NavigationReload &&
                  state.tab == NavigationTab.products) {
                context.read<ProductsCubit>().start();
              }
            },
            child: const ProductsScreen(),
          ),
        ),
      ),
    );
  }

  group(
    'UI tests for ProductsScreen based on ProductsCubit states',
        () {
      setUp(() => initMainWidget());
      tearDown(() => GetIt.instance.reset());

      /// Validates the presence of main widgets like the search field
      Future<void> evaluateMainWidgetsPresence(WidgetTester tester) async {
        await tester.pumpWidget(testableWidget);
        await tester.pump();

        expect(
          find.text(LocaleKeys.products.labelTextSearch.tr()),
          findsOneWidget,
        );
      }

      testWidgets(
        'When ProductsLoading state is emitted, '
            "Then only the loading indicator and search field are shown",
            (WidgetTester tester) async {
          when(() => cubit.state).thenReturn(ProductsLoading());
          await evaluateMainWidgetsPresence(tester);
        },
      );

      testWidgets(
        'When ProductsSuccess state is emitted with empty results, '
            'Then an empty ListView is displayed',
            (WidgetTester tester) async {
          when(() => cubit.state).thenReturn(ProductsSuccess([]));
          await tester.pumpWidget(testableWidget);

          whenListen(
            cubit,
            Stream.value(ProductsSuccess([])),
          );
          await tester.pumpAndSettle();

          expect(
            find.byType(ListView),
            findsOneWidget,
          );
        },
      );
    },
  );
}
