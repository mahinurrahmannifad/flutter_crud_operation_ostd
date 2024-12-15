import 'package:flutter/material.dart';
import 'package:flutter_crud_operation_ostd/ui/screens/update_product_screen.dart';
import '../../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  VoidCallback? deleteButton;
  ProductItem({super.key, required this.product, this.deleteButton}); //delete method call.

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(
        product.image ?? '',
        width: 50,
      ),
      title: Text(product.productName ?? ''),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Product Code: ${product.productCode ?? ''}'),
          Text('Quantity: ${product.quantity ?? ''}'),
          Text('Price: ${product.unitPrice ?? ''}'),
          Text('Total Price: ${product.totalPrice ?? ''}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: deleteButton,
            icon: const Icon(Icons.delete),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  UpdateProductScreen.name,
                  arguments: product,
                );
              },
              icon: const Icon(Icons.edit))
        ],
      ),
    );
  }
}
