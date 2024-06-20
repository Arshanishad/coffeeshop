
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import '../../../core/common/search.dart';
import '../../../core/constants/firebase_constants.dart';
import '../../../core/providers/failure.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/providers/type_def.dart';
import '../../../model/product_model.dart';

final productRepositoryProvider = Provider(
        (ref) => ProductRepository(firestore: ref.read(firestoreProvider)));

class ProductRepository {
  final FirebaseFirestore _firestore;

  ProductRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  CollectionReference get _settings =>
      _firestore.collection(FirebaseConstants.settingsCollections);

  CollectionReference get _product =>
      _firestore.collection(FirebaseConstants.productsCollections);
  Future<int> getUid() async {
    DocumentSnapshot id =
    await _firestore.collection('settings').doc('settings').get();

    int uid = id['productId'];

    uid++;

    await _firestore
        .collection('settings')
        .doc('settings')
        .update({'productId': FieldValue.increment(1)});
    return uid;
  }

  Future<int> getUserUid() async {
    try {
      DocumentSnapshot settingsDoc = await _firestore.collection('settings').doc('settings').get();
      int uid = settingsDoc.exists ? settingsDoc['productId'] ?? 0 : 0;
      await _firestore.collection('settings').doc('settings').update({'productId': FieldValue.increment(1)});
      return uid + 1;
    } catch (e) {
      if (kDebugMode) {
        print("Error getting user UID: $e");
      }
      rethrow;
    }
  }

  FutureEither<ProductModel> productAdd(ProductModel productModel) async {
    try {
      int uid = await getUserUid();
      if (kDebugMode) {
        print("Generated UID: U$uid");
      }

      DocumentReference productRef = _product.doc("P$uid");
      await productRef.set(productModel.toMap());
      if (kDebugMode) {
        print("User document created: U$uid");
      }

      productModel = productModel.copyWith(
        reference: productRef,
        id: "U$uid",
        search: setSearchParam("S$uid ${productModel.productName} ${productModel.category}"),
      );

      await productRef.update(productModel.toMap());
      if (kDebugMode) {
        print("User document updated: U$uid");
      }

      return right(productModel);
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("FirebaseException: ${e.message}");
      }
      return Left(Failure(e.message ?? "Firebase Exception occurred"));
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      return Left(Failure(e.toString()));
    }
  }


  // FutureEither<ProductModel> addProduct({required String description,required double tax,
  //   required String name,required String category, required double mrp,
  //   required String image,
  //  })
  //  async {
  //   try{
  //     QuerySnapshot productSnap = await  _product.where('productName',isEqualTo: name)
  //         .where("delete",isEqualTo: false)
  //         .get();
  //     if(productSnap.docs.isNotEmpty){
  //       throw 'Product Already Exist';
  //     }
  //     DocumentSnapshot doc = await _settings.doc('settings').get();
  //     var docId = doc.get('productId');
  //     await _settings.doc('settings').update({
  //       'productId': FieldValue.increment(1),
  //     });
  //     var i = Timestamp.now().millisecondsSinceEpoch;
  //     String id = "tcs$docId$i".toString();
  //     DocumentReference reference = _product.doc(id);
  //     ProductModel productModel=ProductModel(
  //         productName: name,
  //         status: 0,
  //         delete: false,
  //         id: id,
  //         createdTime:  DateTime.now(),
  //         search:  setSearchParam(name.trim()),
  //         image: image,
  //         category: category,
  //         description: description,
  //         tax:tax,
  //         mrp: mrp,
  //         reference: reference);
  //     await _product.doc(id).set(productModel.toMap());
  //     return  right(productModel);
  //   }
  //   on FirebaseException catch(e)
  //   {
  //     throw e.message!;
  //   }
  //   catch(error)
  //   {
  //     return left(Failure(error.toString()));
  //   }
  // }
  Futurevoid editProduct(
      {required ProductModel productModel,
        required String description,required double tax,
        required String categoryId,
        required String name,required double mrp,}) async {
    try {

      ProductModel edit = productModel.copyWith(categoryId: categoryId,
        mrp: mrp,
        productName: name,
        search: setSearchParam(name.trim()),
        tax: tax,
        description: description,
      );
      return right(_product.doc(productModel.id).update(edit.toMap()));

    } on FirebaseException catch (em) {
      throw em.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }


  Stream<List<ProductModel>> productDisplay(String search) {
    if (search.isEmpty) {
      return _product
          .orderBy("createdTime", descending: true)
          .snapshots()
          .map((event) => event.docs.map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>)).toList());
    } else {
      return _product
          .where("search", arrayContains: search.isEmpty ? null : search.toUpperCase().trim())
          .orderBy("createdTime", descending: true)
          .snapshots()
          .map((event) => event.docs.map((e) => ProductModel.fromMap(e.data() as Map<String, dynamic>)).toList());
    }
  }


  deleteProduct(String id){
    _product.doc(id).update({
      'delete':true
    });
  }



}
