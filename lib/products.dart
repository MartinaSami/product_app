import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
  });
}

class Products with ChangeNotifier {
  List<Product> productsList = [];
  String authToken;

//Products(this.authToken,this.productsList);
  getData(String authTok, List<Product> products) {
    authToken = authTok;
    productsList = products;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      final url =
          "https://provider-models-default-rtdb.firebaseio.com/products.json?auth=$authToken";
      final http.Response res = await http.get(url);

      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((proId, proData) {
        final proIndex =
            productsList.indexWhere((element) => element.id == proId);
        if (proIndex >= 0) {
          productsList[proIndex] = Product(
            id: proId,
            title: proData['title'],
            description: proData['description'],
            price: proData['price'],
            imageUrl: proData['imageUrl'],
          );
        } else {
          productsList.add(Product(
            id: proId,
            title: proData['title'],
            description: proData['description'],
            price: proData['price'],
            imageUrl: proData['imageUrl'],
          ));
        }
      });

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateData(String id) async {
    final url =
        "https://provider-models-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    final proIndex = productsList.indexWhere((element) => element.id == id);
    if (proIndex >= 0) {
      await http.patch(url,
          body: json.encode({
            "title": " new title",
            "description": " new description",
            "price": 99.14,
            "imageUrl":
                "https://cdn.pixabay.com/photo/2013/07/21/13/00/rose-165819__340.jpg",
          }));
      productsList[proIndex] = Product(
          id: id,
          title: " new title 2",
          description: " new description 2",
          price: 99.14,
          imageUrl:
              "https://cdn.pixabay.com/photo/2013/07/21/13/00/rose-165819__340.jpg");

      notifyListeners();
    } else {
      print("0000000");
    }
  }

  Future<void> add(
      {String id,
      String title,
      String description,
      double price,
      String imageUrl}) async {
    try {
      final url =
          "https://provider-models-default-rtdb.firebaseio.com/products.json?auth=$authToken";
      http.Response res = await http.post(url,
          body: json.encode({
            "id": id,
            "title": title,
            "description": description,
            "price": price,
            "imageUrl": imageUrl,
          }));

      print(json.decode(res.body));
      productsList.add(Product(
        id: json.decode(res.body)['name'],
        title: title,
        description: description,
        price: price,
        imageUrl: imageUrl,
      ));
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> delete(String id, ctx) async {
    final url =
        "https://provider-models-default-rtdb.firebaseio.com/products.json?auth=$authToken";
    var proIndex = productsList.indexWhere((element) => element.id == id);
    var prodItem = productsList[proIndex];
    productsList.removeAt(proIndex);
    notifyListeners();
    var res = await http.delete(url);
    Toast.show("Item deleted!", ctx, duration: Toast.LENGTH_LONG);
    if (res.statusCode >= 400) {
      productsList.insert(proIndex, prodItem);
      notifyListeners();
      Toast.show("Item cannot be deleted!", ctx, duration: Toast.LENGTH_LONG);
    } else {
      prodItem = null;
    }
    print("Item Deleted");
  }
}
