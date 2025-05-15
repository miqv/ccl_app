import 'package:auto_route/auto_route.dart';
import 'package:ccl_app/core/components/snackbar_service.dart';
import 'package:ccl_app/core/translations/localization_constants.dart';
import 'package:ccl_app/domain/model/inventory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccl_app/domain/model/product.dart';
import 'package:ccl_app/core/dimens.dart';
import 'package:ccl_app/core/components/spacer.dart';
import 'package:ccl_app/core/di/injection.dart';
import 'package:ccl_app/app/inventory/bloc/inventory_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dropdown_search/dropdown_search.dart';

/// InventoryForm is a page to register a new inventory transaction (input or output).
///
/// It allows the user to:
/// - Select a product from a searchable dropdown.
/// - Pick a date for the transaction.
/// - Enter the quantity and description.
/// - Select the type of movement (input/output).
/// - Submit the form to save the inventory transaction.
///
/// The form validates user input and prevents stock output greater than available.
@RoutePage()
class InventoryForm extends StatelessWidget {
  const InventoryForm({
    super.key,
    this.onBack,
  });

  /// Callback to execute when the form is successfully submitted and closed.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<InventoryCubit>()..getAllProducts(onBack: onBack),
      child: const _InventoryForm(),
    );
  }
}

class _InventoryForm extends StatefulWidget {
  const _InventoryForm();

  @override
  State<_InventoryForm> createState() => _InventoryFormState();
}

class _InventoryFormState extends State<_InventoryForm> {
  final _formKey = GlobalKey<FormState>();

  Product? selectedProduct;
  DateTime selectedDate = DateTime.now();
  String? movementType; // Either 'input' or 'output'
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Product> products = [];

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.dispose();
  }

  /// Opens a date picker and updates the selectedDate.
  void _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() => selectedDate = date);
    }
  }

  /// Submits the inventory entry form.
  ///
  /// Validates inputs, checks stock if it's an output transaction,
  /// creates the [Inventory] object and dispatches it to the cubit.
  void _submit() {
    if (_formKey.currentState!.validate() &&
        selectedProduct != null &&
        movementType != null) {
      final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
      final description = descriptionController.text.trim();
      final isInput = movementType == 'input';
      final productId = selectedProduct!.id!;

      if (!isInput) {
        final availableStock =
            products.firstWhere((product) => product.id == productId).stock;
        if (quantity > availableStock) {
          SnackbarService.showError(
            context,
            LocaleKeys.inventory.stockAvailableError
                .tr(args: [availableStock.toString()]),
          );
          return;
        }
      }

      Inventory inventory = Inventory(
        productId: selectedProduct!.id!,
        date: selectedDate,
        quantity: quantity,
        description: description,
        isInput: isInput,
      );

      context.read<InventoryCubit>().addInventory(inventory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.inventory.titleAdd.tr())),
      body: Padding(
        padding: const EdgeInsets.all(Dimen.regular),
        child: BlocConsumer<InventoryCubit, InventoryState>(
          listener: (context, state) {
            InventoryCubit cubit = BlocProvider.of<InventoryCubit>(context);

            if (state is InventoryFailure || state is InventoryCreatedFailure) {
              SnackbarService.showError(
                context,
                LocaleKeys.register.failedMessage.tr(),
              );
            }

            if (state is InventoryProductsSuccess) {
              products = state.results;
            }

            if (state is InventoryCreatedSuccess) {
              String inventoryType = state.isInput
                  ? LocaleKeys.inventory.menuItemInput.tr()
                  : LocaleKeys.inventory.menuItemOutput.tr();
              SnackbarService.showSuccess(
                context,
                LocaleKeys.inventory.addInventorySuccess.tr(
                  args: [inventoryType],
                ),
              );
              if (cubit.onBack != null) {
                Navigator.pop(context);
              }
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Dropdown to select a product from the list.
                  DropdownSearch<Product>(
                    items: products,
                    selectedItem: selectedProduct,
                    itemAsString: (Product p) => p.name,
                    onChanged: (value) {
                      setState(() {
                        selectedProduct = value;
                      });
                    },
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: LocaleKeys.inventory.productFieldLabel.tr(),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    popupProps: PopupProps.menu(
                      showSearchBox: true,
                      searchFieldProps: TextFieldProps(
                        decoration: InputDecoration(
                          labelText:
                              LocaleKeys.inventory.productSearchFieldLabel.tr(),
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      constraints: BoxConstraints(maxHeight: 300),
                    ),
                    validator: (value) => value == null
                        ? LocaleKeys.inventory.productFieldError.tr()
                        : null,
                  ),

                  Spacing.small,

                  /// Date picker for selecting the transaction date.
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: LocaleKeys.inventory.dateFieldLabel.tr(),
                        border: OutlineInputBorder(),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(DateFormat.yMMMd().format(selectedDate)),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),

                  Spacing.small,

                  /// Field to enter the quantity of items.
                  TextFormField(
                    controller: quantityController,
                    decoration: InputDecoration(
                      labelText: LocaleKeys.inventory.quantityFieldLabel.tr(),
                      hintText: LocaleKeys.inventory.quantityFieldLabel.tr(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => (value == null || value.isEmpty)
                        ? LocaleKeys.inventory.quantityFieldError.tr()
                        : null,
                  ),

                  Spacing.small,

                  /// Optional field for additional description.
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText:
                          LocaleKeys.inventory.descriptionFieldLabel.tr(),
                      hintText: LocaleKeys.inventory.descriptionFieldLabel.tr(),
                    ),
                    maxLines: 3,
                    validator: (value) => (value == null || value.isEmpty)
                        ? LocaleKeys.inventory.descriptionFieldError.tr()
                        : null,
                  ),

                  Spacing.small,

                  /// Dropdown to select the type of movement (input or output).
                  DropdownButtonFormField<String>(
                    value: movementType,
                    items: [
                      DropdownMenuItem(
                          value: 'input',
                          child: Text(
                            LocaleKeys.inventory.menuItemInput.tr(),
                          )),
                      DropdownMenuItem(
                          value: 'output',
                          child: Text(
                            LocaleKeys.inventory.menuItemOutput.tr(),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() => movementType = value);
                    },
                    decoration: InputDecoration(
                      labelText: LocaleKeys.inventory.movementFieldLabel.tr(),
                      hintText: LocaleKeys.inventory.movementFieldLabel.tr(),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null
                        ? LocaleKeys.inventory.movementFieldError.tr()
                        : null,
                  ),

                  const Spacer(),

                  /// Save button to submit the form.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.save),
                      label: Text(LocaleKeys.general.save.tr()),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
