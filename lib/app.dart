import 'package:flutter/material.dart';
import 'package:flutter_crud_operation_ostd/models/product.dart';
import 'package:flutter_crud_operation_ostd/ui/screens/add_new_product_screen.dart';
import 'package:flutter_crud_operation_ostd/ui/screens/product_list_screen.dart';
import 'package:flutter_crud_operation_ostd/ui/screens/update_product_screen.dart';

class CRUDApp extends StatelessWidget{
  const CRUDApp({super.key});

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     initialRoute: '/',
     onGenerateRoute: (RouteSettings settings){
       late Widget widget;
       if (settings.name == '/'){
         widget =const ProductListScreen();
       }else if (settings.name==AddNewProductScreen.name){
         widget= const AddNewProductScreen();
       }
       else if (settings.name==UpdateProductScreen.name){
         final Product product=settings.arguments as Product;
         widget= UpdateProductScreen(product:product);
       }
       return MaterialPageRoute(builder: (context){
         return widget;
       },
       );
     }
   );
  }

}