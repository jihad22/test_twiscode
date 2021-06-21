import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_twiscode/app/index/provider/indexProvider.dart';
import 'package:test_twiscode/util/config/uriConfig.dart';

class IndexController extends GetxController {
  final IndexProvider provider = Get.put(IndexProvider());
  var productList = [].obs;

  var cartList = [].obs;

  var isLoading = false.obs;
  var isError = false.obs;

  loadProducts() async {
    isLoading.value = true;
    final r = await provider.products();
    isLoading.value = false;
    var data = json.decode(r);
    for (var d in data) {
      productList.add(d);
    }
  }

  imageLoader(String? uri) {
    if (uri == null || uri == "") {
      return Image.asset("null-image.jpeg");
    } else {
      return Image.network("${UriConfig.imageURI}$uri", fit: BoxFit.cover, repeat: ImageRepeat.noRepeat, height: 220);
    }
  }

  isHalal(String? data) {
    if (data == "1") {
      return Image.asset("halal.jpg", width: 10);
    } else {
      return Container();
    }
  }

  isAvailable(String? data) {
    if (data == "0" || data == "") {
      return Container(
        width: 300,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.redAccent,
        ),
        height: 50,
        //color: Colors.blue,
        child: Text(
          "OUT OF STOCK",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );
    } else {
      return Container(
        width: 300,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        height: 50,
        //color: Colors.blue,
        child: Text(
          "READY STOCK",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      );
    }
  }

  addToCart(var data) {
    cartList.add(data);
    cartList.refresh();
    //print(cartList);
  }

  incrementItem(index) {
    cartList[index]['count'] += 1;
    cartList.refresh();
  }

  decrementItem(index) {
    cartList[index]['count'] -= 1;
    cartList.refresh();
  }

  removeItem(index) {
    cartList.removeAt(index);
    cartList.refresh();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    productList.close();
    super.onClose();
  }
}
