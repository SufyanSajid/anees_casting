import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Models/product.dart';

getProductsByCatId(String catId, BuildContext context) async {
  await Provider.of<Products>(context, listen: false)
      .searchProduct(catId, 'catId');
}
