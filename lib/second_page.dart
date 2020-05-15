import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class SecondPage extends StatelessWidget {
  SecondPage({@required this.id,this.name, this.description,this.categoryID,this.price});

  final String id;
  final String name;
  final String description;
  final String categoryID;
  final int price;

  TextEditingController productNameInputController;
  TextEditingController productDescriptionInputController;
  String _selectedCategory;
  TextEditingController productPriceController;
  TextEditingController productCategoryIDController;


  @override
  Widget build(BuildContext context) {
    productNameInputController = new TextEditingController();
    productNameInputController.text = name;
    productDescriptionInputController = new TextEditingController();
    productDescriptionInputController.text = description;
    productPriceController = new TextEditingController();
    productPriceController.text = price.toString();
    productCategoryIDController = new TextEditingController();
    productCategoryIDController.text = categoryID.toString();

    return Scaffold(
        appBar: AppBar(
          title: Text("EDIT"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Container(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance.collection('category').snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                            if (snapshot.hasError)
                              return new Text('Error: ${snapshot.error}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return new Text('Loading...');
                              default:
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                            children: <Widget>[
                                              Container(
                                                child: TextField(
                                                  decoration: InputDecoration(labelText:'Product Name*'),
                                                  controller: productNameInputController,
                                                ),
                                              ),
                                              Container(
                                                child: TextField(
                                                  decoration: InputDecoration(labelText:'Product Description*' ),
                                                  controller: productDescriptionInputController,
                                                ),
                                              ),
                                              Container(
                                                  child: TextField(
                                                    decoration: InputDecoration(labelText:'Product Category ID',enabled: false ),
                                                    controller: productCategoryIDController,
                                                  )

//                                    child: new DropdownButton(
//                                      hint: Text("Product Category*"),
//                                      value: _selectedCategory,
//                                      isDense: true,
//                                      onChanged: (String newValue){
//                                        setState(() {
//                                          _selectedCategory = newValue;
//                                        });
//                                      },
//                                      items: snapshot.data.documents.map((DocumentSnapshot document) {
//                                        return new DropdownMenuItem(
//                                          child: new Text(document['category_name'].toString()),
//                                          value: document.documentID,
//                                        );
//                                      }).toList(),
//                                    ),
                                              ),
                                              Container(
                                                height: 50,
                                                child: TextField(
                                                    decoration: InputDecoration(labelText: 'Product Price*'),
                                                    controller: productPriceController,
                                                    keyboardType: TextInputType.number,
                                                    inputFormatters: <TextInputFormatter> [
                                                      WhitelistingTextInputFormatter.digitsOnly
                                                    ]
                                                ),
                                              )
                                            ]
                                        ),
                                      ),
                                      RaisedButton(
                                          child: Text('Back To HomeScreen'),
                                          color: Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          onPressed: () => Navigator.pop(context)
                                      ),
                                      RaisedButton(
                                          child: Text('Update'),
                                          color: Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            Firestore.instance.collection('product')
                                                .document(id)
                                                .updateData(
                                                {
                                                  'name': productNameInputController
                                                      .text,
                                                  'description': productDescriptionInputController
                                                      .text,
                                                  'category_id': categoryID,
                                                  'price': int.parse(
                                                      productPriceController.text
                                                          .toString())
                                                }
                                            );
                                            Navigator.pop(context);
                                          }

                                      ),
                                      RaisedButton(
                                          child: Text('Delete'),
                                          color: Theme.of(context).primaryColor,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            Firestore.instance.collection('product').document(id).delete();
                                            Navigator.pop(context);
                                          }
                                      ),
                                    ]
                                );}
                          },
                        )
                    ),
                  ),
                ]),
          )


          ),
        );
  }
}