
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/globals.dart';
import '../../../core/pallete/theme.dart';
import '../../../core/widget/textformfield.dart';
import '../../../model/order_model.dart';
import '../../../model/product_model.dart';
import '../controller/order_controller.dart';

class AddOrderPage extends ConsumerStatefulWidget {
  final ProductModel? selectedProduct;

  AddOrderPage({this.selectedProduct});

  @override
  _AddOrderPageState createState() => _AddOrderPageState();
}

class _AddOrderPageState extends ConsumerState<AddOrderPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController totalPriceController = TextEditingController();
  double grandTotal = 0.0;

  final orderProductListProvider = StateProvider<List<OrderBagModel>>((ref) => []);

  @override
  void initState() {
    super.initState();
    if (widget.selectedProduct != null) {
      selectedProduct = widget.selectedProduct;
    }
  }

  ProductModel? selectedProduct;

  void addProduct() {
    if (selectedProduct != null && quantityController.text.isNotEmpty) {
      final quantity = int.parse(quantityController.text.trim());
      final totalPrice = selectedProduct!.mrp * quantity;

      final orderBagModel = OrderBagModel(
        productName: selectedProduct!.productName,
        quantity: quantity,
        mrp: selectedProduct!.mrp,
        productPrice: selectedProduct!.mrp,
        productId: selectedProduct!.id,
        tax: 0,
      );
      ref.watch(orderProductListProvider.notifier).update((state) => [
        ...state,
        orderBagModel
      ]);
      // Update order product list with Riverpod
      // ref.read(orderProductListProvider) = [...ref.read(orderProductListProvider), orderBagModel];

      grandTotal += totalPrice;

      // Clear selected product and controllers
      selectedProduct = null;
      quantityController.clear();
      totalPriceController.text = grandTotal.toStringAsFixed(2);

      // Update UI to reflect changes (trigger rebuild)
      setState(() {}); // If using StatefulWidgets
    }
  }

  // Function to add order
  void orderAdd() {
    if (_formKey.currentState!.validate()) {
      // Retrieve products from orderProductListProvider
      final products = ref.read(orderProductListProvider);

      // Calculate total quantity and grand total
      int totalQuantity = products.fold(0, (sum, item) => sum + item.quantity);
      double grandTotal = products.fold(0.0, (sum, item) => sum + item.quantity * item.mrp);

      // Create list of OrderBagModel from products
      List<OrderBagModel> orderProducts = products.map((item) => OrderBagModel(
        productName: item.productName,
        quantity: item.quantity,
        mrp: item.mrp,
        productPrice: item.productPrice,
        productId: item.productId,
        tax: item.tax,
      )).toList();

      // Create order model
      OrderModel orderModel = OrderModel(
        customerName: customerNameController.text.trim(),
        status: 0, // Default status to 0 (Pending)
        totalPrice: grandTotal,
        orderDate: DateTime.now(),
        search: [], // You may need to populate this based on your search requirements
        delete: false, // Assuming this field is for soft delete
        bag: orderProducts, // List of OrderBagModel instances
        grandTotal: grandTotal,
        rejectReason: '', // Ensure this field is handled appropriately
        quantity: totalQuantity,
      );

      // Call the orderAdd method from your provider
      ref.read(orderControllerProvider.notifier).orderAdd(orderModel: orderModel, context: context)
          .then((value) {
        // Successfully added order, clear form and state
        customerNameController.clear();
        quantityController.clear();
        totalPriceController.clear();
        ref.read(orderProductListProvider.notifier).update((state) => []); // Clear the order product list
        setState(() {}); // Trigger UI update if necessary
      })
          .catchError((error) {
        // Handle error if order add fails
        print('Failed to add order: $error');
        // You may choose to show a SnackBar or handle the error differently
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    final orderProductListState = ref.watch(orderProductListProvider);
    final productListAsyncValue = ref.watch(getProductNamesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Order'),
        backgroundColor: Palette.redLightColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedProduct != null) ...[
                  Image.network(selectedProduct!.image),
                  SizedBox(height: 10),
                  Text(
                    selectedProduct!.productName,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                ],
        CustomTextInput(controller: customerNameController, label: 'Customer Name', width: MediaQuery.of(context).size.width * 0.7, height: 0.1),

        // productListAsyncValue.when(
                //   data: (productList) {
                //     return DropdownButtonFormField<ProductModel>(
                //       value: selectedProduct,
                //       hint: Text('Select Product'),
                //       onChanged: (ProductModel? newValue) {
                //         setState(() {
                //           selectedProduct = newValue;
                //         });
                //       },
                //       items: productList.map((ProductModel product) {
                //         return DropdownMenuItem<ProductModel>(
                //           value: product,
                //           child: Text(product.productName),
                //         );
                //       }).toList(),
                //       decoration: InputDecoration(
                //         labelText: 'Product',
                //         border: OutlineInputBorder(),
                //       ),
                //     );
                //   },
                //   loading: () => CircularProgressIndicator(),
                //   error: (error, stack) {
                //     print('Error: $error');
                //     return Text('Error loading products: $error');
                //   },
                // ),
                SizedBox(height: 10),
                CustomTextInput(controller: quantityController, label: 'Quantity', width: MediaQuery.of(context).size.width * 0.7, height: 0.1),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: addProduct,
                  child: Text('Add Product'),
                ),
                SizedBox(height: 10),
                CustomTextInput(controller: totalPriceController, label: 'Total Price', width: MediaQuery.of(context).size.width * 0.7, height: 0.1),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: orderAdd,
                  child: Text('Add Order'),
                ),
                SizedBox(height: 20),
                Text('Order Bag:'),
                ...orderProductListState.map((product) => ListTile(
                  title: Text(product.productName),
                  subtitle: Text('Price: \$${product.mrp} x ${product.quantity} = \$${product.mrp * product.quantity}'),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
