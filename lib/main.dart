import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'custom_card.dart';
import 'package:flutter/foundation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter CRUD'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
            padding: const EdgeInsets.all(10.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('product')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return new CustomCard(
                          id: document.documentID,
                          name: document['name'],
                          description: document['description'],
                          price: int.parse(document['price'].toString()),
                          categoryId: document['category_id'],
                        );
                      }).toList(),
                    );
                }
              },
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }

  TextEditingController productNameInputController;
  TextEditingController productDescriptionInputController;
  String _selectedCategory;
  TextEditingController productPriceController;

  @override
  initState() {
    productNameInputController = new TextEditingController();
    productDescriptionInputController = new TextEditingController();
    productPriceController = new TextEditingController();
    super.initState();
  }

  _showDialog() async {

    await showDialog<String>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('category').snapshots(),
                builder:
                    (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return new Text('Loading...');
                    default:
                      return Column(
                        children: <Widget>[
                          Text("Create Product"),
                          Column(
                            children: <Widget>[
                              Container(
                                child: TextField(
                                  decoration: InputDecoration(labelText:'Product Name*' ),
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
                                child: new DropdownButton(
                                  hint: Text("Product Category*"),
                                  value: _selectedCategory,
                                  isDense: true,
                                  onChanged: (String newValue){
                                    setState(() {
                                      _selectedCategory = newValue;

                                    });
                                  },
                                  items: snapshot.data.documents.map((DocumentSnapshot document) {
                                    return new DropdownMenuItem(
                                      child: new Text(document['category_name'].toString()),
                                      value: document.documentID,
                                    );
                                  }).toList(),
                                ),
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
                            ],
                          ) ,
                        ],
                      );
                  }
                },
              ),
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                productNameInputController.clear();
                productDescriptionInputController.clear();
                productPriceController.clear();
//                _selectedCategory = null;
                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('Add'),
              onPressed: () {
                if (productNameInputController.text.isNotEmpty &&
                    productDescriptionInputController.text.isNotEmpty &&
                    _selectedCategory.isNotEmpty &&
                    productPriceController.text.isNotEmpty) {
                  Firestore.instance
                      .collection('product')
                      .add({
                    "name": productNameInputController.text,
                    "description": productDescriptionInputController.text,
                    "category_id": _selectedCategory,
                    "price": int.parse(productPriceController.text.toString())
                  })
                      .then((result) => {
                    Navigator.pop(context),
                    productNameInputController.clear(),
                    productDescriptionInputController.clear(),
                    productPriceController.clear(),
                  })
                      .catchError((err) => print(err));
                }
              })
        ],
      ),
    );
  }
}
