import 'package:ccl_app/app/navigation/bloc/navigation_cubit.dart';
import 'package:ccl_app/core/components/spacer.dart';
import 'package:ccl_app/core/dimens.dart';
import 'package:ccl_app/core/routes/routes.gr.dart';
import 'package:ccl_app/domain/model/inventory.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/app/inventory/bloc/inventory_cubit.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// InventoryScreen displays the inventory transaction list.
/// It allows the user to search, add new inventory entries/exits, and refresh the list.
@RoutePage()
class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InventoryCubit>()..start(),
      child: BlocListener<NavigationCubit, NavigationState>(
        listener: (context, state) {
          // Reloads inventory list if the inventory tab is reselected.
          if (state is NavigationReload &&
              state.tab == NavigationTab.inventory) {
            context.read<InventoryCubit>().start();
          }
        },
        child: _InventoryScreen(),
      ),
    );
  }
}

class _InventoryScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    InventoryCubit cubit = context.read<InventoryCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with search bar and add button
        PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimen.xSmall, horizontal: Dimen.regular),
            child: Row(
              children: [
                // Search field to filter inventory items
                Expanded(
                  child: TextField(
                    onChanged: (query) {
                      context.read<InventoryCubit>().search(query);
                    },
                    decoration: InputDecoration(
                      labelText: LocaleKeys.inventory.labelTextSearch.tr(),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                Spacing.xSmall,
                // Add inventory entry/exit
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    context.router.navigate(InventoryFormRoute(
                      onBack: () {
                        // Refresh list after adding new entry
                        cubit.start();
                      },
                    ));
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
        // Inventory List or loading/error state
        Expanded(
          child: BlocConsumer<InventoryCubit, InventoryState>(
            listener: (context, state) {
              if (state is InventoryInit) {
                FlutterNativeSplash.remove();
              }
            },
            buildWhen: (_, state) =>
            state is InventoryInit ||
                state is InventoryLoading ||
                state is InventorySuccess ||
                state is InventoryNoResultsFound,
            builder: (context, state) {
              if (state is InventoryNoResultsFound) {
                return Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png', height: 200),
                      Text(
                        LocaleKeys.inventory.noResultsFound.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                );
              }
              if (state is InventorySuccess) {
                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(context, state.results[index]);
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }

  /// Builds each inventory list item card
  Widget _buildListItem(BuildContext context, Inventory inventory) {
    return GestureDetector(
      onTap: () => null,
      child: Card(
        margin: const EdgeInsets.symmetric(
            vertical: Dimen.xSmall, horizontal: Dimen.regular),
        elevation: 4,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimen.small)),
        child: Padding(
          padding: const EdgeInsets.all(Dimen.regular),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section: Product name, date, quantity
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inventory.productName!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.xSmall,
                        Text(
                          inventory.dateFormat!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildInfoItem(
                    inventory.isInput
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    inventory.quantity,
                    inventory.isInput ? Colors.blueAccent : Colors.redAccent,
                  ),
                ],
              ),
              const Divider(height: Dimen.xMedium, thickness: Dimen.border),
              // Bottom section: Description
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(inventory.description),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget to display the icon and quantity value
  Widget _buildInfoItem(IconData icon, int value, Color color) {
    return Row(
      children: [
        Icon(icon, size: Dimen.medium, color: color),
        Spacing.micro,
        Text(
          '$value',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
