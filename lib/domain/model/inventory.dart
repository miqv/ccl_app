import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';

/// The `Inventory` class represents an inventory record in the application.
/// It supports both input (incoming) and output (outgoing) product operations,
/// and includes metadata for database interaction and UI display.
class Inventory extends Equatable {
  const Inventory({
    this.id,
    this.productId,
    this.productName,
    required this.description,
    this.quantity = 0,
    required this.date,
    this.dateFormat,
    this.isInput = false,
  });

  /// Unique identifier for the inventory record (from DB).
  final int? id;

  /// ID of the associated product.
  final int? productId;

  /// Name of the associated product (used for UI display).
  final String? productName;

  /// Description of the inventory operation.
  final String description;

  /// Quantity of the product involved in the inventory operation.
  final int quantity;

  /// Date when the inventory record was created.
  final DateTime date;

  /// Formatted date for display purposes (e.g., 'May 14, 2025').
  final String? dateFormat;

  /// Indicates whether the record is an input (true) or output (false).
  final bool isInput;

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    description,
    quantity,
    date,
    dateFormat,
    isInput,
  ];

  /// Returns a copy of the current `Inventory` object with overridden values.
  Inventory copyWith({
    int? id,
    int? productId,
    String? productName,
    String? description,
    int? quantity,
    DateTime? date,
    String? dateFormat,
    bool? isInput,
  }) {
    return Inventory(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      date: date ?? this.date,
      dateFormat: dateFormat ?? this.dateFormat,
      isInput: isInput ?? this.isInput,
    );
  }

  /// Converts the `Inventory` object to a map suitable for database insertion.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product_id': productId,
      'description': description,
      'date': date.toString(),
      'quantity': quantity,
    };
  }

  /// Factory constructor to create an `Inventory` instance from a database map.
  /// It parses the date and generates a formatted date string.
  factory Inventory.fromMap(Map<String, dynamic> map) {
    DateTime date = DateFormat("yyyy-MM-dd").parse(map['date']);
    String dateFormat = DateFormat.yMMMMd().format(date);
    return Inventory(
      id: map['id'] as int,
      productId: map['product_id'] as int,
      productName: map['product_name'] as String,
      description: map['description'] as String,
      date: date,
      dateFormat: dateFormat,
      quantity: map['quantity'] as int,
      isInput: map['is_input'] == 1,
    );
  }
}
