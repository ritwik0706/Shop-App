import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/providers/product.dart';
import '../models/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = 'edit-products-screen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _desFocusNode = FocusNode();
  final _imgUrlController = TextEditingController();
  final _imgUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    imageUrl: '',
    price: 0.0,
  );
  var isInit = true;

  @override
  void initState() {
    super.initState();
    _imgUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        print(productId);
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _imgUrlController.text = _editedProduct.imageUrl;
      }
    }

    isInit = false;
  }

  @override
  void dispose() {
    super.dispose();

    _imgUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _desFocusNode.dispose();
    _imgUrlController.dispose();
  }

  void _updateImageUrl() {
    final String value = _imgUrlController.text;
    if (!value.startsWith('http') && !value.startsWith('https')) {
      return;
    }
    if (!value.endsWith('.jpg') &&
        !value.endsWith('.jpeg') &&
        !value.endsWith('png')) {
      return;
    }
    if (!_imgUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final _isValid = _formKey.currentState.validate();
    if (!_isValid) return;
    _formKey.currentState.save();
    print(_editedProduct.id);
    if (_editedProduct.id == null) {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    } else {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add your product'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _saveForm)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _editedProduct.title,
                decoration: InputDecoration(labelText: 'Enter Product Name'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (title) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the name of the product';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: value,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    description: _editedProduct.description,
                    isFavourite: _editedProduct.isFavourite,
                  );
                },
              ),
              TextFormField(
                initialValue: _editedProduct.price != 0.0
                    ? _editedProduct.price.toString()
                    : '',
                decoration: InputDecoration(labelText: 'Enter the price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (price) {
                  FocusScope.of(context).requestFocus(_desFocusNode);
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter the price of the product';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    price: double.parse(value),
                    imageUrl: _editedProduct.imageUrl,
                    isFavourite: _editedProduct.isFavourite,
                    description: _editedProduct.description,
                  );
                },
              ),
              TextFormField(
                initialValue: _editedProduct.description,
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _desFocusNode,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please describe the product';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedProduct = Product(
                    id: _editedProduct.id,
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    imageUrl: _editedProduct.imageUrl,
                    isFavourite: _editedProduct.isFavourite,
                    description: value,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 8, right: 10),
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                    ),
                    child: _imgUrlController.text.isEmpty
                        ? Text('Enter the URL')
                        : FittedBox(
                            child: Image.network(
                              _imgUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Enter Image URL'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: _imgUrlController,
                      focusNode: _imgUrlFocusNode,
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          imageUrl: value,
                          isFavourite: _editedProduct.isFavourite,
                          description: _editedProduct.description,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter url for product image';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a valid url';
                        }
                        if (!value.endsWith('.jpg') &&
                            !value.endsWith('.jpeg') &&
                            !value.endsWith('png')) {
                          return 'Please enter a valid url';
                        }
                        return null;
                      },
                      // onFieldSubmitted: (imgUrl) {
                      //   _saveForm();
                      // },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
