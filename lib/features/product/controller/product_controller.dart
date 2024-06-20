

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/product_model.dart';
import '../../Home/screens/navigation_screen.dart';
import '../repository/product_repository.dart';
import '../repository/storage_repository.dart';



final productControllerProvider = StateNotifierProvider<ProductController, bool>(
        (ref) => ProductController(
        productRepository: ref.read(productRepositoryProvider), ref: ref, storageRepository:ref.read(storageRepositoryProvider)));
final productDisplayStreamProvider=StreamProvider.family((ref,String search) =>ref.read(productControllerProvider.notifier).productDisplay(search));

class ProductController extends StateNotifier<bool> {
  final ProductRepository _productRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  ProductController( {
    required ProductRepository productRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })
      : _productRepository = productRepository,
        _storageRepository=storageRepository,
        _ref = ref,
        super(false);

        // addProduct({required String name, required BuildContext context,required String categoryId,required String description,
        //   required String image,
        //  required double tax,required double mrp,
        //  })
        // async {
        //   state =true;
        //   final category=await _productRepository.addProduct(name: name,category: categoryId,description: description,
        //       tax: tax,mrp: mrp,
        //     image:image,
        //   );
        //   state=false;
        //   category.fold((l) => ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text('Failed to add Product')),
        //   ), (r) async {
        //     ScaffoldMessenger.of(context).showSnackBar(
        //       SnackBar(content: Text('Product added successfully!')),
        //     );
        //     Navigator.push(context, MaterialPageRoute(builder:(context)=>NavigationScreen()));
        //   }
        //   );
        //   Navigator.pop(context);
        // }
  Future<void> productAdd(ProductModel productModel, BuildContext context) async {
    final res = await _productRepository.productAdd(productModel);
    res.fold(
          (l) => null,
          (r) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Product added successfully!')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavigationScreen()),
          );
        }
      },
    );
  }  editProduct({ required BuildContext context,required String categoryId,required String description, required double tax,
    required String name,required double mrp,required ProductModel productModel})
  async {
    state =true;
    final category=await _productRepository.editProduct(categoryId: categoryId,description: description,
       tax: tax,productModel: productModel,
        mrp: mrp,name: name,);
    state=false;
    category.fold((l) =>
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add Product')),
        ),
            (r) =>    ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Product added successfully!')),
            ));
    Navigator.push(context, MaterialPageRoute(builder: (context)=>NavigationScreen()));
  }



  Stream<List<ProductModel>> productDisplay(String search) {
    return _productRepository.productDisplay(search);
  }

  void deleteProduct(String id) {
    _productRepository.deleteProduct(id);
  }
}



