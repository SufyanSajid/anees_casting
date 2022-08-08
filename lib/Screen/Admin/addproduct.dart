
import 'package:flutter/material.dart';

import '../../Widget/appbar.dart';
import '../../Widget/customautocomplete.dart';
import '../../Widget/dropDown.dart';
import '../../Widget/input_feild.dart';
import '../../Widget/submitbutton.dart';
import '../../contant.dart';

class AddProduct extends StatelessWidget {
  static const routeName = '/addproduct';
  final _categoryController = TextEditingController();
  final _articleController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _MeasureController = TextEditingController();
  AddProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Appbar(
                title: 'Design',
                subtitle: 'Add New Design',
                svgIcon: 'assets/icons/daimond.svg',
                leadingIcon: Icons.arrow_back,
                leadingTap: () {},
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
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: primaryColor.withOpacity(0.5),
                          width: 2,
                          style: BorderStyle.solid,
                        )),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(
                        'https://media.istockphoto.com/photos/one-beautiful-woman-looking-at-the-camera-in-profile-picture-id1303539316?s=612x612',
                        height: height(context) * 12,
                        width: height(context) * 12,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                      right: 0,
                      bottom: -10,
                      child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.add_a_photo_outlined,
                            color: primaryColor,
                            size: 30,
                          ))),
                ],
              ),
              SizedBox(
                height: height(context) * 5,
              ),
            CustomAutoComplete(onChange: (){},),
              SizedBox(
                height: height(context) * 2,
              ),
              InputFeild(
                  hinntText: 'Enter Article Number',
                  validatior: () {},
                  inputController: _categoryController),
              SizedBox(
                height: height(context) * 2,
              ),
              Row(
                children: [
                  Expanded(
                    child: InputFeild(
                        hinntText: 'Length',
                        validatior: () {},
                        inputController: _categoryController),
                  ),
                  SizedBox(
                    width: width(context) * 3,
                  ),
                  Expanded(
                    child: InputFeild(
                        hinntText: 'Width',
                        validatior: () {},
                        inputController: _categoryController),
                  ),
                ],
              ),
              SizedBox(
                height: height(context) * 2,
              ),
              Row(
                children: [
                Expanded(
                  flex: 2,
                    child: Container()),  
               
                  Expanded(
                    flex: 4,
                    child: CustomDropDown(items: [
                      'Cm',
                      'MM'
                    ],onChanged: (value){
                      
                      print(value);
                    }),
                  ),
                   Expanded(
                    flex: 2,
                    child: Container()),  
                ],
              ),
              SizedBox(
                height: height(context) * 5,
              ),
              SubmitButton(
                  height: height(context),
                  width: width(context),
                  onTap: () {},
                  title: 'Add Design')
            ],
          ),
        ),
      ),
    );
  }
}
