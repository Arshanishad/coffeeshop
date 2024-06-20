import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/common/globals.dart';
import '../../../core/pallete/theme.dart';
import '../../../core/widget/alertbox.dart';
import '../../../core/widget/rounded_loading_button.dart';
import '../../../core/widget/textformfield.dart';
import '../../../model/product_model.dart';
import '../../../model/settings_model.dart';
import '../../Home/screens/navigation_screen.dart';
import '../controller/product_controller.dart';
import '../repository/storage_repository.dart';




class ProductAddScreen extends ConsumerStatefulWidget {
  @override
  _ProductAddScreenState createState() => _ProductAddScreenState();
}

class _ProductAddScreenState extends ConsumerState<ProductAddScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
   TextEditingController _nameController=TextEditingController();
   TextEditingController _descriptionController=TextEditingController();
   TextEditingController _priceController=TextEditingController();
   TextEditingController _categoryController=TextEditingController();
   TextEditingController _weightController=TextEditingController();
   TextEditingController _unitPriceController=TextEditingController();
   TextEditingController _mrpController=TextEditingController();
   TextEditingController _taxController=TextEditingController();


  final _formKey = GlobalKey<FormState>();
  final imageProvider = StateProvider<File?>((ref) => null);
  final picker = ImagePicker();
  late ScaffoldMessengerState scaffoldMessenger;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }
  @override


  @override

  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    super.dispose();
  }


  Future<void> _getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      ref
          .watch(imageProvider.notifier)
          .update((state) => File(pickedFile.path));
    }
    if(mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      ref
          .watch(imageProvider.notifier)
          .update((state) => File(pickedFile.path));
    }
    if(mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showImagePickerDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Choose an option"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  onTap: _getImageFromGallery,
                  child: const Text("Gallery"),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: _getImageFromCamera,
                  child: const Text("Camera"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

 SettingsModel? settingsModel;

  void confirmAlert(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return ConfirmationDialog(
            onConfirmed: () {
              Navigator.pop(dialogContext); // Close the confirmation dialog
              _addProduct(context);
            },
            onCancel: () {
              Navigator.pop(dialogContext);
            },
            message: 'Are you sure you want to add this product?',
          );
        },
      );
    }
  }

  Future<void> _addProduct(BuildContext context) async {
    try {
      File? imageFile = ref.read(imageProvider);
      if (imageFile == null) {
        _showSnackBar(context, 'No image selected.');
        return;
      }

      String imageUrl = await ref
          .read(storageRepositoryProvider)
          .storeFile(path: 'product_images/${DateTime.now().millisecondsSinceEpoch}.png', file: imageFile);

      ProductModel productModel = ProductModel(
        id: "",
        category: _categoryController.text.trim(),
        productName: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        tax: double.parse(_taxController.text.trim()),
        mrp: double.parse(_mrpController.text.trim()),
        status: 0,
        delete: false,
        createdTime: DateTime.now(),
        search: [],
        image: imageUrl,
      );

      await ref.read(productControllerProvider.notifier).productAdd(productModel, context);

      // Clear text controllers
      _nameController.clear();
      _descriptionController.clear();
      _taxController.clear();
      _mrpController.clear();

      // Show success message using ScaffoldMessenger
      _showSnackBar(context, 'Product added successfully!');
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');
      _showSnackBar(context, 'Error uploading image or adding product: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }








  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Add'),
        backgroundColor: Palette.redLightColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Consumer(builder: (context, ref, child) {
                  final imageFile = ref.watch(imageProvider);
                  return InkWell(
                    onTap: () async {
                      _showImagePickerDialog();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.width * 0.3,
                      decoration: BoxDecoration(
                        border: Border.all(color: Palette.containerBorderColor),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: imageFile != null
                          ? Image.file(imageFile, fit: BoxFit.cover)
                          : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset("assets/icons/uploadIcon.svg"),
                            const SizedBox(height: 8),
                            const Text("Upload Image"),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                SizedBox(height: 20),
                CustomTextInput(
                  controller:_nameController ,
                  label: 'product Name',
                   prefixIcon:Icons.production_quantity_limits,
                  width: 0.5, height: 0.1,
                ),
                SizedBox(width: 4,),
                CustomTextInput(
                  controller:_descriptionController ,
                  label: 'Description',
                  prefixIcon:Icons.description,
                  width: 0.7, height: 0.1,
                ),
                SizedBox(height: 10,),

                // CustomTextInput(
                //   controller:_categoryController ,
                //   label: 'Category',
                //   prefixIcon:Icons.category,
                //   width: 0.4, height: 0.1,
                // ),

                SizedBox(height: 10,),
                Row(
                  children: [
                    CustomTextInput(
                      keyboardType:
                      const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                      ],
                      controller:_mrpController ,
                      label: 'Mrp',
                      prefixIcon:Icons.monitor_weight,
                      width: 0.4, height: 0.1,
                    ),
                    SizedBox(width: 5,),
                    CustomTextInput(
                      keyboardType:
                      const TextInputType.numberWithOptions(
                          decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^(\d+)?\.?\d{0,2}'))
                      ],
                      controller:_taxController ,
                      label: 'Tax',
                      prefixIcon:Icons.monitor_weight,
                      width: 0.4, height: 0.1,
                    )
                  ],
                ),
                SizedBox(height: 16.0),
                Consumer(
                    builder: (context,ref,child) {
                      double width = (w ?? 0) * 0.7;
                      double height = (h ?? 0) * 0.05;
                      return SizedBox(
                        width: width,
                        height: height,
                        child: RoundedLoadingButton(icon: false,
                          backgroundColor:Palette.redLightColor,
                          TextColor: Colors.white,
                          text: 'Add Product',
                          isLoading: false, onPressed: (){
                            confirmAlert(context);
                          },),
                      );
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
