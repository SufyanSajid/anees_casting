import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Models/product.dart';

getSearchedProduct(String search, BuildContext context) {
  if (search.isEmpty) {
    Provider.of<Products>(context, listen: false).fetchAndUpdateProducts();
  } else {
    Provider.of<Products>(context, listen: false)
        .searchProduct(search, 'productName');
  }
}
