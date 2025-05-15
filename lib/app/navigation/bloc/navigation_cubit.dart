import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:ccl_app/domain/model/user.dart';

part 'navigation_state.dart';

/// A [Cubit] responsible for managing the state of the bottom navigation bar.
///
/// This cubit emits different states to indicate which tab is currently selected
/// in the navigation interface.
///
/// It starts in [NavigationInit] state, and transitions to [NavigationSelected]
/// when a tab is selected.
///
/// Dependencies are injected via `injectable`.
@injectable
class NavigationCubit extends Cubit<NavigationState> {
  /// Creates a new instance of [NavigationCubit], starting in [NavigationInit] state.
  NavigationCubit() : super(NavigationInit());

  /// Updates the selected index and emits a [NavigationSelected] state.
  ///
  /// This is typically triggered when the user taps on a bottom navigation item.
  void setSelectIndex(int index) =>
      emit(NavigationSelected(selectedIndex: index));

  /// Initializes the cubit, re-emitting the [NavigationInit] state.
  ///
  /// Can be used to reset or prepare the navigation state when the screen loads.
  Future<void> start() async {
    emit(NavigationInit());
  }

  void reloadProductsTab() {
    emit(NavigationReload(tab: NavigationTab.products));
  }

  void reloadInventoryTab() {
    emit(NavigationReload(tab: NavigationTab.inventory));
  }
}

