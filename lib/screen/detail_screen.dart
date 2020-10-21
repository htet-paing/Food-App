import 'package:cwhp_flutter/provider/food_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'food_form_screen.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FoodProvider foodProvider = Provider.of<FoodProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(foodProvider.currentFood.name),
      ),
      body: Center(
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: (){
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:(BuildContext context) =>  
              FoodFormScreen(
                isUpdating: true,
              )
            )
          );
        }
      ),
    );
  }
}