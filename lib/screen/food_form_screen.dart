import 'dart:io';
import 'package:cwhp_flutter/model/food.dart';
import 'package:cwhp_flutter/provider/food_provider.dart';
import 'package:cwhp_flutter/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class FoodFormScreen extends StatefulWidget {
  final bool isUpdating;
  FoodFormScreen({this.isUpdating});

  @override
  _FoodFormScreenState createState() => _FoodFormScreenState();
}

class _FoodFormScreenState extends State<FoodFormScreen> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final _subingredientController = TextEditingController();
    List _subingredients = [];
    Food _currentFood;
    String _imageUrl;
    File _imageFile;
    bool _isLoading = false;
    bool _isInit = true;




    @override
    void didChangeDependencies() {
      if (_isInit) {
        FoodProvider foodProvider = Provider.of<FoodProvider>(context, listen: false);
        if (foodProvider.currentFood != null) {
        _currentFood = foodProvider.currentFood;
        _subingredients.addAll(_currentFood.subIngredients);
        _imageUrl = _currentFood.image;
        
        }else {
          _currentFood = new Food();
        }
      }
      _isInit = false;
      super.didChangeDependencies();
    }

    Widget _showImage() {
      if (_imageUrl == null && _imageFile == null) {
        return Text('Image PlaceHolder');
      }else if (_imageFile != null) {
        print("Showing image from local File");
        return Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            Image.file(
              _imageFile, 
              fit: BoxFit.cover,
              height: 250
            ),
            FlatButton(
              padding: EdgeInsets.all(16),
              color: Colors.black45,
              onPressed: () => _getLocalImage(),
              child: Text('Change Image', style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600
              ),)
            )
          ],
        );
      } else if (_imageUrl != null) {
        print("Showing image from Url");
        return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          Image.network(
            _imageUrl, 
            fit: BoxFit.cover,
            height: 250
          ),
          FlatButton(
            padding: EdgeInsets.all(16),
            color: Colors.black45,
            onPressed: () => _getLocalImage(),
            child: Text('Change Image', style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w600
            ),)
          )
        ],
      );
      }       
    }

    Future<void> _getLocalImage() async{
      final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);
      setState(() {
        if (imageFile != null) {
          _imageFile = File(imageFile.path);
        }else {
          print('No image selected');
        }
      });
    }

    void addSubIngredient(String value) {
      if (value.isNotEmpty) {
        setState(() {
          _subingredients.add(value);
        });
      }
      _subingredientController.clear();
    }
  
    void _saveForm() {
      if (!_formKey.currentState.validate()) {
        return ;
      }
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      _currentFood.subIngredients = _subingredients;
      uploadFoodAndImage(_currentFood, widget.isUpdating, _imageFile, _onFoodUploaded);
    }

    _onFoodUploaded(Food food) {
      FoodProvider foodProvider = Provider.of<FoodProvider>(context, listen: false);
      foodProvider.addFood(food);
      Navigator.pop(context);
    }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Form'),
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator()
      ) : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidate: true,
          child: Column(
            children: [
              _showImage(),
              SizedBox(height: 18),
              Text( widget.isUpdating ? 'Edit Food': 'Create Food' , style: TextStyle(
                fontSize: 30
              ),),
              SizedBox(height: 16),
              
              _imageFile == null && _imageUrl == null ?
               ButtonTheme(
                child: RaisedButton(
                  child: Text('Add Image', style: TextStyle(
                    color: Colors.white
                  ),),
                  onPressed: () => _getLocalImage()
                ),
              )
              : SizedBox(height: 0),

              SizedBox(height: 10),
              TextFormField(                    
                initialValue: _currentFood.name,
                decoration: InputDecoration(
                  labelText: 'Name',
                  filled: true,
                  isDense: true,                    
                ),
                textInputAction: TextInputAction.next,              
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter provid value';
                  }
                  return null;
                },
                onSaved: (value) {
                  _currentFood.name = value;
                },
              ),
              SizedBox(height: 10,),               
              TextFormField(
                initialValue: _currentFood.category,
                decoration: InputDecoration(
                  labelText: 'Category',
                  filled: true,
                  isDense: true,
                ),
                onSaved: (value) {
                  _currentFood.category = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter provide value';
                  }                 
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 200,
                    child: TextField(
                      controller: _subingredientController,
                      decoration: InputDecoration(
                        labelText: 'SubIngredient'
                      ),
                      keyboardType: TextInputType.text,
                    )
                  ),
                  ButtonTheme(
                    child: RaisedButton(
                      child: Text('Add'),
                      onPressed: () => addSubIngredient(_subingredientController.text),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
                padding: EdgeInsets.all(8),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: _subingredients
                .map((ingredient) =>  Card(
                  color: Colors.black54,
                  child: Center(
                    child: Text(ingredient, style: TextStyle(
                      color: Colors.white
                    ),),
                  ),
                )).toList(),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _saveForm
      ),
    );
  }
}