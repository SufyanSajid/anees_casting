import 'dart:typed_data';

import 'package:anees_costing/Functions/dailog.dart';
import 'package:anees_costing/Helpers/show_snackbar.dart';
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

  String? downloadImgUrl;

  bool isLoading = false;
  Product? drawerProduct;
  String? prodImageUrl;
  String? selectedCatTitle;

  @override
  void initState() {
    // Provider.of<Categories>(cont
    //ext, listen: false).fetchAndUpdateCat();
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

  _addProduct(var img) async {
    if (productNotEmpty()) {
      setState(() {
        isLoading = true;
      });
      var productProvider = Provider.of<Products>(context, listen: false);
      var countProvider = Provider.of<Counts>(context, listen: false);
      downloadImgUrl =
          await StorageMethods().uploadImage(file: img, collection: "products");
      Product newProduct = Product(
        id: "",
        name: _prodNameController.text.trim(),
        length: _prodLengthController.text.trim(),
        width: _prodWidthController.text.trim(),
        unit: prodUnit,
        categoryId: category!.id,
        categoryTitle: category!.title,
        image: downloadImgUrl!,
        dateTime: DateTime.now().microsecondsSinceEpoch.toString(),
      );
      await productProvider.addProduct(product: newProduct, context: context);
      await productProvider.fetchAndUpdateProducts();
      countProvider.increaseCount(product: 1);

      clearControllersAndImage();

      setState(() {
        isLoading = false;
        Navigator.of(context).pop();
      });
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
      {required Uint8List? img,
      required String prodId,
      required String imageUrl}) async {
    if (productNotEmpty()) {
      setState(() {
        isLoading = true;
      });

      Product newProduct = prodObj();
      var navigator = Navigator.of(context);

      newProduct.id = prodId;
      newProduct.image = imageUrl;

      var provider = Provider.of<Products>(context, listen: false);

      if (image != null) {
        String newImageUrl = await StorageMethods().updateImage(
          imageURl: newProduct.image.split("?").first,
          file: img,
        );
        newProduct.image = newImageUrl;
      }

      await provider.updateProduct(product: newProduct);
      await provider.fetchAndUpdateProducts();

      clearControllersAndImage();
      setState(() {
        isLoading = false;
      });
      navigator.pop();
    }
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
                      ? _addProduct(image)
                      : _editProduct(
                          img: image,
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
