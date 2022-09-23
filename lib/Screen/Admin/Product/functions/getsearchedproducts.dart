import 'package:anees_costing/Models/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../Models/product.dart';

getSearchedProduct(String search, BuildContext context) {
  var currentUser = Provider.of<Auth>(context, listen: false).currentUser;
  if (search.isEmpty) {
    Provider.of<Products>(context, listen: false)
        .fetchAndUpdateProducts(userToken: currentUser!.token, forced: true);
  } else {
    Provider.of<Products>(context, listen: false)
        .searchProduct(title: search, userToken: currentUser!.token);
  }
}

getSearchedProductByCat({
  required String search,
  required BuildContext context,
  required String catId,
}) {
  var currentUser = Provider.of<Auth>(context, listen: false).currentUser;
  if (search.isEmpty) {
    Provider.of<Products>(context, listen: false)
        .getCatProducts(catId: catId, userToken: currentUser!.token);
  } else {
    Provider.of<Products>(context, listen: false).searchProduct(
        title: search, userToken: currentUser!.token, catId: catId);
  }
}
