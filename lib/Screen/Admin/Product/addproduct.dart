import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Helpers/show_snackbar.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Models/category.dart';
import '../../../Helpers/storage_methods.dart';
import '../../../Widget/adaptive_indecator.dart';
import '../../../Widget/appbar.dart';
import '../../../Widget/customautocomplete.dart';
import '../../../Widget/dropDown.dart';
import '../../../Widget/input_feild.dart';
import '../../../Widget/submitbutton.dart';
import '../../../contant.dart';

class AddProduct extends StatefulWidget {
  static const routeName = '/addproduct';

  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _prodNameController = TextEditingController();
  final _prodLengthController = TextEditingController();
  final _prodWidthController = TextEditingController();

  bool isFirst = true;
  String prodUnit = "CM";
  Category? category;
  Uint8List? image;

  File? image123;
  String? editImage;

  String? downloadImgUrl;
  String? imageExtention;
  String base64Image = '';
  bool isLoading = false;
  Map<String, dynamic>? args;
  CurrentUser? currentUser;
  String editCat = '';
  String editCatId = '';

  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
      currentUser = Provider.of<Auth>(context, listen: false).currentUser;
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      if (args!['action'] == 'edit') {
        Product prod = args!['product'];
        _prodNameController.text = prod.name;
        _prodLengthController.text = prod.length;
        _prodWidthController.text = prod.width;
        editImage = prod.image;
        editCat = prod.categoryTitle;
        editCatId = prod.categoryId;
      }
      Provider.of<Categories>(context, listen: false)
          .fetchAndUpdateCat(currentUser!.token);
    }
    super.didChangeDependencies();
  }

  void _addProduct(var img) async {
    print(img);

    if (category != null) {
      List<Category> childs = Provider.of<Categories>(context, listen: false)
          .getChildCategories(category!.id);

      if (childs.isNotEmpty) {
        showSnackBar(
            context, "You can't assign ${category!.title} as it have child");

        return;
      }
    }
    if (productNotEmpty()) {
      setState(() {
        isLoading = true;
      });
      var provider = Provider.of<Products>(context, listen: false);

      Product newProduct = Product(
        id: "",
        name: _prodNameController.text.trim(),
        length: _prodLengthController.text.trim(),
        width: _prodWidthController.text.trim(),
        unit: prodUnit,
        customers: [],
        categoryId: category!.id,
        categoryTitle: category!.title,
        image: img,
        dateTime: DateTime.now().microsecondsSinceEpoch.toString(),
      );
      await provider.addProduct(
        product: newProduct,
        userToken: currentUser!.token,
        imageExtension: imageExtention!,
      );

      clearControllersAndImage();

      setState(() {
        isLoading = false;
      });
    } else {
      print("hi");
      showSnackBar(context, "Please fill all fields");
    }
  }

  _editProduct(
      {required var img,
      required String prodId,
      required String imageUrl}) async {
    setState(() {
      isLoading = true;
    });

    if (productNotEmpty()) {
      Product newProduct = Product(
        id: prodId,
          customers: [],
        name: _prodNameController.text.trim(),
        length: _prodLengthController.text.trim(),
        width: _prodWidthController.text.trim(),
        unit: prodUnit,
        categoryId: category == null ? editCatId : category!.id,
        categoryTitle: category == null ? editCat : category!.title,
        image: img,
        dateTime: DateTime.now().microsecondsSinceEpoch.toString(),
      );

      var provider = Provider.of<Products>(context, listen: false);

      await provider.updateProduct(
        product: newProduct,
        userToken: currentUser!.token,
        imageExtension: imageExtention == null ? '' : imageExtention!,
      );
      // Provider.of<Products>(context, listen: false)
      //     .updateProductLocally(newProducts);

      clearControllersAndImage();
      Navigator.of(context).pop();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _prodNameController.dispose();
    _prodWidthController.dispose();
    _prodLengthController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories =
        Provider.of<Categories>(context, listen: true).childCategories;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Appbar(
                title: 'Design',
                subtitle:
                    args!["action"] == "add" ? 'Add New Design' : "Edit Design",
                svgIcon: 'assets/icons/daimond.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {
                  Navigator.of(context).pop();
                },
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {},
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(
                      height: height(context) * 2,
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          width: width(context) * 80,
                          height: height(context) * 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.5),
                                width: 2,
                                style: BorderStyle.solid,
                              )),
                          child: args!['action'] == 'edit'
                              ? image != null
                                  ? Image.memory(
                                      image!,
                                      fit: BoxFit.contain,
                                    )
                                  : Image.network(editImage!)
                              : image != null
                                  ? Image.memory(
                                      image!,
                                      fit: BoxFit.contain,
                                    )
                                  : Container(),
                        ),
                        Positioned(
                            right: 1,
                            bottom: 1,
                            child: IconButton(
                                onPressed: () async {
                                  FilePickerResult? result1 =
                                      await FilePicker.platform.pickFiles(
                                          withData: true,
                                          allowCompression: true);
                                  print(1234);

                                  setState(() {
                                    image = result1!.files.first.bytes;

                                    print(image);
                                  });
                                  var selectedImage = result1!.files.first;
                                  base64Image = base64Encode(
                                      File(selectedImage.path!)
                                          .readAsBytesSync());
                                  print('this is base $base64Image');
                                  imageExtention =
                                      result1.files.first.extension;

                                  print(imageExtention);
                                },
                                icon: Icon(
                                  Icons.add_a_photo_outlined,
                                  color: primaryColor.withOpacity(0.5),
                                  size: 30,
                                ))),
                      ],
                    ),
                    SizedBox(
                      height: height(context) * 5,
                    ),
                    CustomAutoComplete(
                      categories: categories,
                      firstSelction:
                          editCat.isEmpty ? "Select Category" : editCat,
                      onChange: (Category cat) {
                        category = cat;
                      },
                    ),
                    SizedBox(
                      height: height(context) * 2,
                    ),
                    InputFeild(
                        hinntText: 'Enter Article Number',
                        validatior: () {},
                        inputController: _prodNameController),
                    SizedBox(
                      height: height(context) * 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: InputFeild(
                              hinntText: 'Length',
                              validatior: () {},
                              inputController: _prodLengthController),
                        ),
                        SizedBox(
                          width: width(context) * 3,
                        ),
                        Expanded(
                          child: InputFeild(
                              hinntText: 'Width',
                              validatior: () {},
                              inputController: _prodWidthController),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height(context) * 2,
                    ),
                    Row(
                      children: [
                        Expanded(flex: 2, child: Container()),
                        Expanded(
                          flex: 4,
                          child: CustomDropDown(
                              items: const ['Cm', 'MM'],
                              onChanged: (String value) {
                                prodUnit = value;
                              }),
                        ),
                        Expanded(flex: 2, child: Container()),
                      ],
                    ),
                    SizedBox(
                      height: height(context) * 5,
                    ),
                    isLoading
                        ? AdaptiveIndecator(
                            color: primaryColor,
                          )
                        : SubmitButton(
                            height: height(context),
                            width: width(context),
                            onTap: () {
                              args!["action"] == "add"
                                  ? _addProduct(base64Image)
                                  : _editProduct(
                                      img: base64Image,
                                      prodId: (args!["product"] as Product).id,
                                      imageUrl:
                                          (args!["product"] as Product).image,
                                    );
                            },
                            title: args!["action"] == "add"
                                ? 'Add Design'
                                : 'Edit Design')
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Product prodObj() {
    return Product(
        id: "",
        name: _prodNameController.text.trim(),
          customers: [],
        length: _prodLengthController.text.trim(),
        width: _prodWidthController.text.trim(),
        unit: prodUnit,
        categoryId: category!.id,
        categoryTitle: category!.title,
        image: "",
        dateTime: "");
  }

  void clearControllersAndImage() {
    image = null;
    _prodLengthController.clear();
    _prodWidthController.clear();
    _prodNameController.clear();
    editCat = "";
  }

  bool productNotEmpty() {
    if ((image != null || editCat.isNotEmpty) &&
        (category != null || editCat.isNotEmpty) &&
        _prodNameController.text.isNotEmpty &&
        _prodLengthController.text.isNotEmpty &&
        _prodWidthController.text.isNotEmpty) {
      return true;
    } else {
      print("Hello");
      showCustomDialog(
          context: context,
          title: "Empty Fields",
          btn1: "OK",
          content: "Please fill all the fields",
          btn2: null,
          btn1Pressed: () {
            Navigator.of(context).pop();
          },
          btn2Pressed: null);
      return false;
    }
  }
}
