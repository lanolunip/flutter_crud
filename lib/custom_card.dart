import 'package:flutter/material.dart';
import 'second_page.dart';
class CustomCard extends StatelessWidget {
  CustomCard({@required this.id,this.name, this.description,this.price,this.categoryId});

  final String id;
  final String name;
  final String description;
  final int price;
  final String categoryId;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Container(
            padding: const EdgeInsets.only(top: 5.0),
            child: Column(
              children: <Widget>[
                Text(name),
                Text(description),
                Text(price.toString()),
                Text(categoryId),
                FlatButton(
                    child: Text("See More"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SecondPage(
                                  id:id,name: name, description: description,categoryID: categoryId,price: price,)));
                    }),
              ],
            )));
  }
}