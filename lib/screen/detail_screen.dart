import 'package:cwhp_flutter/model/food.dart';
import 'package:cwhp_flutter/provider/food_provider.dart';
import 'package:cwhp_flutter/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'food_form_screen.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FoodProvider foodProvider = Provider.of<FoodProvider>(context);
    
    _onFoodDeleted(Food food) {
      Navigator.pop(context);
      foodProvider.deleteFood(food);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(foodProvider.currentFood.name),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Column(
              children: [
                Image.network(foodProvider.currentFood.image != null ? foodProvider.currentFood.image : Center(child: Text('No Image'))),
                SizedBox(height: 25),

                Text(foodProvider.currentFood.name, style: TextStyle(
                  fontSize: 40
                ),),
                Text(foodProvider.currentFood.category, style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic
                ),),
                SizedBox(height: 30),
                GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  padding: EdgeInsets.all(8),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: foodProvider.currentFood.subIngredients
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
          )
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'btn1',
            child: Icon(Icons.delete),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            onPressed: () => deleteFood(foodProvider.currentFood, _onFoodDeleted)
          ),
          SizedBox(height: 10),
          FloatingActionButton(   
            heroTag: 'btn2',   
            child: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:(BuildContext context) =>  
                  FoodFormScreen(
                    isUpdating: true,
                  )
                )
              );
            },
          ),
        ],
      ),
    );
  }
}