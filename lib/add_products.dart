import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'products.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  var priceController = TextEditingController();
  var imageUrlCont = TextEditingController();
  bool isLoading = false;
  double price;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Title", hintText: "Add title"),
                    controller: titleController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Description", hintText: "Add description"),
                    controller: descController,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Price", hintText: "Add price"),
                    controller: priceController,
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                        labelText: "Image Url",
                        hintText: "Paste your image url here"),
                    controller: imageUrlCont,
                  ),
                  SizedBox(height: 30),
                  Consumer<Products>(
                    builder: (ctx, value, _) => RaisedButton(
                        color: Colors.orangeAccent,
                        textColor: Colors.black,
                        child: Text("Add Product"),
                        onPressed: () {
                          if (titleController.text.isEmpty ||
                              descController.text.isEmpty ||
                              priceController.text.isEmpty ||
                              imageUrlCont.text.isEmpty) {
                            Toast.show("Please enter all Fields", ctx,
                                duration: Toast.LENGTH_LONG);
                          } else {
                            try {
                              setState(() {
                                price = double.parse(priceController.text);
                              });
                              setState(() {
                                isLoading = true;
                              });
                              value
                                  .add(
                                id: DateTime.now().toString(),
                                title: titleController.text,
                                description: descController.text,
                                price: price,
                                imageUrl: imageUrlCont.text,
                              )
                                  .catchError((_) {
                                return showDialog<Null>(
                                    context: context,
                                    builder: (innerContext) => AlertDialog(
                                          title: Text("An AlertDialog"),
                                          content: Text("Something went wrong"),
                                          actions: [
                                            FlatButton(
                                                child: Text("Okay"),
                                                onPressed: () =>
                                                    Navigator.of(innerContext)
                                                        .pop())
                                          ],
                                        ));
                              }).then((_) {
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              });
                            } catch (e) {
                              Toast.show("Please enter a valid price", ctx,
                                  duration: Toast.LENGTH_LONG);
                            }
                          }
                        }),
                  ),
                ],
              ),
            ),
    );
  }
}
