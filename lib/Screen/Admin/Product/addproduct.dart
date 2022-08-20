import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:anees_costing/Helpers/firestore_methods.dart';
import 'package:anees_costing/Models/product.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
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
  String? downloadImgUrl;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
      Provider.of<Categories>(context, listen: false).fetchAndUpdateCat();
    }
    super.didChangeDependencies();
  }

  _addProduct(var img) async {
    if (productNotEmpty()) {
      setState(() {
        isLoading = true;
      });
      var provider = Provider.of<Products>(context, listen: false);
      downloadImgUrl =
          await StorageMethods().uploadImage(file: img, collection: "products");
      Product newProduct = Product(
        id: "",
        name: _prodNameController.text.trim(),
        length: _prodLengthController.text.trim(),
        width: _prodWidthController.text.trim(),
        unit: prodUnit,
        categoryId: category!.id,
        image: downloadImgUrl!,
        dateTime: DateTime.now().microsecondsSinceEpoch.toString(),
      );
      await provider.addProduct(product: newProduct);

      clearControllersAndImage();

      setState(() {
        isLoading = false;
      });
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
      Product newProduct = prodObj();

      newProduct.id = prodId;
      newProduct.image = imageUrl;

      var provider = Provider.of<Products>(context, listen: false);

      await StorageMethods().updateImage(
        imageURl: newProduct.image.split("?").first,
        file: img,
      );

      await provider.updateProduct(product: newProduct);

      clearControllersAndImage();
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
    Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    List<Category> categories =
        Provider.of<Categories>(context, listen: true).categories;

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
                    args["action"] == "add" ? 'Add New Design' : "Edit Design",
                svgIcon: 'assets/icons/daimond.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {
                  Navigator.of(context).pop();
                },
                tarilingIcon: Icons.filter_list,
                tarilingTap: () {},
              ),
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
                    child: image != null
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
                            );

                            print(result1!.files);
                            setState(() {
                              image = result1.files.first.bytes;
                              print(image);
                            });
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
                        args["action"] == "add"
                            ? _addProduct(image)
                            : _editProduct(
                                img: image,
                                prodId: (args["product"] as Product).id,
                                imageUrl: (args["product"] as Product).image);
                      },
                      title: 'Add Design')
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
        length: _prodLengthController.text.trim(),
        width: _prodWidthController.text.trim(),
        unit: prodUnit,
        categoryId: category!.id,
        image: "",
        dateTime: "");
  }

  void clearControllersAndImage() {
    image = null;
    _prodLengthController.clear();
    _prodWidthController.clear();
    _prodNameController.clear();
  }

  bool productNotEmpty() {
    if (image != null &&
        category != null &&
        _prodNameController.text.isNotEmpty &&
        _prodLengthController.text.isNotEmpty &&
        _prodWidthController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
