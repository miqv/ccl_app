// Required imports for UI, state management, dependency injection, translations, and splash screen.
import 'package:ccl_app/core/components/spacer.dart';
import 'package:ccl_app/core/dimens.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/app/products/bloc/products_cubit.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

/// Main screen that displays the list of products.
/// Annotated with @RoutePage() for AutoRoute integration.
@RoutePage()
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Provides the ProductsCubit and initializes it with .start()
    return BlocProvider(
      create: (_) => getIt<ProductsCubit>()..start(),
      child: _ProductsScreen(),
    );
  }
}

/// Internal widget that builds the actual product UI.
class _ProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar with search field and "add product" button.
        PreferredSize(
          preferredSize: Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Dimen.xSmall, horizontal: Dimen.regular),
            child: Row(
              children: [
                // Search input field.
                Expanded(
                  child: TextField(
                    onChanged: (query) {
                      context.read<ProductsCubit>().search(query);
                    },
                    decoration: InputDecoration(
                      labelText: LocaleKeys.products.labelTextSearch.tr(),
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                Spacing.xSmall,
                // Button to show the add product dialog.
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return _buildAddProductDialog(
                          dialogContext,
                          context.read<ProductsCubit>(),
                        );
                      },
                    );
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  tooltip: LocaleKeys.products.tooltipProduct.tr(),
                ),
              ],
            ),
          ),
        ),
        Divider(),

        // Main content: displays product list or appropriate messages.
        Expanded(
          child: BlocConsumer<ProductsCubit, ProductsState>(
            // Removes splash screen when initialization completes.
            listener: (context, state) {
              if (state is ProductsInit) {
                FlutterNativeSplash.remove();
              }
            },
            // Only rebuild when these specific states change.
            buildWhen: (_, state) =>
                state is ProductsInit ||
                state is ProductsLoading ||
                state is ProductsSuccess ||
                state is ProductsNoResultsFound,
            builder: (context, state) {
              // If no results found, show message and image.
              if (state is ProductsNoResultsFound) {
                return Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png', height: 200),
                      Text(
                        LocaleKeys.products.noResultsFound.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                );
              }

              // Display product list when data is successfully loaded.
              if (state is ProductsSuccess) {
                return ListView.builder(
                  itemCount: state.results.length,
                  itemBuilder: (context, index) {
                    return _buildListItem(context, state.results[index]);
                  },
                );
              }

              // Show loading indicator by default.
              return const Center(child: CircularProgressIndicator());
            },
          ),
        )
      ],
    );
  }

  /// Builds a product list item card.
  Widget _buildListItem(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => showProductDetailDialog(context, product),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name and description.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacing.xSmall,
                        Text(
                          product.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Button to show product detail dialog.
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () => showProductDetailDialog(context, product),
                  ),
                ],
              ),
              const Divider(height: Dimen.xMedium, thickness: Dimen.border),
              _sectionInfo(
                  product), // Show product metrics (input/output/stock).
            ],
          ),
        ),
      ),
    );
  }

  /// Builds a single metric item (Input, Output, Stock).
  Widget _buildInfoItem(IconData icon, String label, int value) {
    return Column(
      children: [
        Icon(icon, size: Dimen.medium, color: Colors.blueAccent),
        Spacing.micro,
        Text(
          '$value',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  /// Displays product metrics in a horizontal row.
  Widget _sectionInfo(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildInfoItem(Icons.arrow_downward,
            LocaleKeys.products.titleInput.tr(), product.input),
        _buildInfoItem(Icons.arrow_upward, LocaleKeys.products.titleOutput.tr(),
            product.output),
        _buildInfoItem(Icons.inventory_2_outlined,
            LocaleKeys.products.titleStock.tr(), product.stock),
      ],
    );
  }

  /// Displays a product detail dialog.
  void showProductDetailDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(product.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionInfo(product), // Show input/output/stock section.
            const Divider(height: Dimen.xMedium, thickness: Dimen.border),
            Text(product.description),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(LocaleKeys.general.close.tr()),
          ),
        ],
      ),
    );
  }

  /// Shows a form inside an AlertDialog to add a new product.
  Widget _buildAddProductDialog(BuildContext context, ProductsCubit cubit) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: Text(LocaleKeys.products.tooltipProduct.tr()),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name input field.
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                  labelText: LocaleKeys.products.addProductName.tr()),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? LocaleKeys.products.errorProductName.tr()
                  : null,
            ),
            Spacing.small,
            // Description input field.
            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: LocaleKeys.products.addProductDescription.tr(),
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? LocaleKeys.products.errorProductDescription.tr()
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        // Cancel button.
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.general.cancel.tr()),
        ),
        // Save button, only triggers if form is valid.
        ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final product = Product(
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
              );
              cubit.addProduct(product);
              Navigator.of(context).pop();
            }
          },
          child: Text(LocaleKeys.general.save.tr()),
        ),
      ],
    );
  }
}
