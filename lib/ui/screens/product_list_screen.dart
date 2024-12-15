import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_crud_operation_ostd/models/product.dart';
import 'package:flutter_crud_operation_ostd/ui/screens/add_new_product_screen.dart';
import 'package:flutter_crud_operation_ostd/ui/widgets/product_item.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreen();
}

class _ProductListScreen extends State<ProductListScreen> {
  List<Product> productList = [];
  bool _getProductListInProgress = false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            onPressed: () {
              _getProductList();
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getProductList();
        },
        child: Visibility(
          visible: _getProductListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return ProductItem(
                    product: productList[index],
                    deleteButton:(){
                _deleteProductMessage(productList[index], index);
                setState(() {});
                }
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddNewProductScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _getProductList() async {
    productList.clear();
    _getProductListInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      print(decodedData['status']);
      for (Map<String, dynamic> p in decodedData['data']) {
        Product product = Product(
          id: p['_id'],
          productName: p['ProductName'],
          productCode: p['ProductCode'],
          quantity: p['Qty'],
          unitPrice: p['UnitPrice'],
          image: p['Img'],
          totalPrice: p['TotalPrice'],
          createdDate: p['CreatedDate'],
        );
        productList.add(product);
      }
      setState(() {});
    }
    _getProductListInProgress = false;
    setState(() {});
  }
//Functionality for delete product.
  void _deleteProductMessage(Product product, index) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: const Text('Do you want to delete this item?'),
        backgroundColor: Colors.grey.shade100,
        content: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16),),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Image(
                  height: 80,
                  width: 80,
                  image: NetworkImage('${product.image}'),
                ),
                title: Text(product.productName ?? ''),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product Code: ${product.productCode ?? ''}'),
                    Text('Quantity:  ${product.quantity ?? ''}'),
                    Text('Price:  ${product.unitPrice ?? ''}'),
                    Text('Total Price:  ${product.totalPrice ?? ''}'),
                  ],
                ),
                tileColor: Colors.white,
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(onPressed: () {
            _deleteProduct('${product.id}', index);
            Navigator.pop(context);
          },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade700
              ),
              child: const Text('Yes',
                style: TextStyle(
                    color: Colors.white),)),

          ElevatedButton(onPressed: () {
            _deleteProduct('${product.id}', index);
            Navigator.pop(context);
          },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade700
              ),
              child: const Text('No', style: TextStyle(color: Colors.white),)),
        ],
      );
    }
    );
  }
//API call for delete
  Future<void> _deleteProduct(String id, index) async {
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/DeleteProduct/$id');
    Response response = await get(uri);
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Has Been Deleted'),
        ),
      );
      productList.removeAt(index);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Deletion Failed!'),
        ),
      );
    }
    setState(() {});
  }
}
