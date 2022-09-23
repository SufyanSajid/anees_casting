import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Helpers/show_snackbar.dart';
import 'package:anees_costing/Models/auth.dart';
import 'package:anees_costing/Models/counts.dart';
import 'package:anees_costing/Widget/adaptiveDialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Helpers/storage_methods.dart';
import '../../../../Models/category.dart';
import '../../../../Models/product.dart';
import '../../../../Widget/adaptive_indecator.dart';
import '../../../../Widget/customautocomplete.dart';
import '../../../../Widget/dropDown.dart';
import '../../../../Widget/input_feild.dart';
import '../../../../Widget/submitbutton.dart';
import '../../../../contant.dart';

class AddProductFeilds extends StatefulWidget {
  const AddProductFeilds({Key? key}) : super(key: key);

  @override
  State<AddProductFeilds> createState() => _AddProductFeildsState();
}

class _AddProductFeildsState extends State<AddProductFeilds> {
  final _prodNameController = TextEditingController();

  final _prodLengthController = TextEditingController();

  final _prodWidthController = TextEditingController();

  bool isFirst = true;

  String prodUnit = "CM";

  Category? category;

  Uint8List? image;
  String? imageExtention;
  String base64Image = '';
  String? downloadImgUrl;

  bool isLoading = false;
  Product? drawerProduct;
  String? prodImageUrl;
  String? selectedCatTitle;
  CurrentUser? currentUser;
  String editCat = '';
  String editCatId = '';

  @override
  void initState() {
    currentUser = Provider.of<Auth>(context, listen: false).currentUser;
    drawerProduct = Provider.of<Products>(context, listen: false).drawerProduct;
    if (drawerProduct != null) {
      category = Provider.of<Categories>(context, listen: false)
          .getCategoryById(drawerProduct!.categoryId);

      _prodNameController.text = drawerProduct!.name;
      _prodLengthController.text = drawerProduct!.length;
      _prodWidthController.text = drawerProduct!.width;
      prodUnit = drawerProduct!.unit;
      prodImageUrl = drawerProduct!.image;
      selectedCatTitle = drawerProduct!.categoryTitle;
    } else {
      _prodNameController.text = '';
      _prodLengthController.text = '';
      _prodWidthController.text = '';
      prodUnit = 'CM';
      prodImageUrl = null;
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isFirst) {
      isFirst = false;
    }
    super.didChangeDependencies();
  }

  Product prodObj() {
    return Product(
        id: "",
        name: _prodNameController.text.trim(),
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
  }

  bool productNotEmpty() {
    if (image != null &&
        category != null &&
        _prodNameController.text.isNotEmpty &&
        _prodLengthController.text.isNotEmpty &&
        _prodWidthController.text.isNotEmpty) {
      return true;
    } else if (drawerProduct != null &&
        category != null &&
        _prodNameController.text.isNotEmpty &&
        _prodLengthController.text.isNotEmpty &&
        _prodWidthController.text.isNotEmpty) {
      return true;
    } else {
      showCustomDialog(
          context: context,
          title: "Empty Fields",
          btn1: "Ok",
          content: "Please Fill all Fields",
          btn2: null,
          btn1Pressed: () {
            Navigator.of(context).pop();
          },
          btn2Pressed: null);
      return false;
    }
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

  // bool isProductEmpty(BuildContext context) {
  //   var prod = Provider.of<Products>(context, listen: false).drawerProduct;
  //   if (prod == null) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  _editProduct(
      {required var img,
      required String prodId,
      required String imageUrl}) async {
    setState(() {
      isLoading = true;
    });

    print('eddddddiiiiiting product');

    if (productNotEmpty()) {
      Product newProduct = Product(
        id: prodId,
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

      clearControllersAndImage();
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Category> categories =
        Provider.of<Categories>(context, listen: true).categories;
    return Column(
      children: [
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
              child: prodImageUrl != null
                  ? Image.network(prodImageUrl!)
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
                      FilePickerResult? result1 = await FilePicker.platform
                          .pickFiles(withData: true, type: FileType.image);

                      setState(() {
                        image = result1?.files.first.bytes;
                      });
                      var selectedImage = result1!.files.first;
                      base64Image = base64Encode(
                          File(selectedImage.path!).readAsBytesSync());
                      print('this is base $base64Image');
                      imageExtention = result1.files.first.extension;

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
          onChange: (Category cat) {
            category = cat;
          },
          firstSelction: selectedCatTitle,
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
                inputController: _prodWidthController,
              ),
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
                },
              ),
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
                  drawerProduct == null
                      ? _addProduct(base64Image)
                      : _editProduct(
                          img: base64Image,
                          prodId: drawerProduct!.id,
                          imageUrl: drawerProduct!.image,
                        );
                },
                title: drawerProduct != null ? 'Save Changes' : 'Add Design',
              )
      ],
    );
  }
}
