import 'package:cwhp_flutter/provider/auth_provider.dart';
import 'package:cwhp_flutter/provider/food_provider.dart';
import 'package:cwhp_flutter/screen/detail_screen.dart';
import 'package:cwhp_flutter/screen/food_form_screen.dart';
import 'package:cwhp_flutter/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isInit = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      FoodProvider foodProvider = Provider.of<FoodProvider>(context, listen: false);
      getFoods(foodProvider).then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    AuthProvider auth =  Provider.of<AuthProvider>(context);
    FoodProvider foodProvider = Provider.of<FoodProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          FlatButton(
            child: Text('Logout', style: TextStyle(
              color: Colors.white
            ),),
            onPressed: (){
              signout(auth);
            },
          )
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: foodProvider.foodList.length,
        itemBuilder: (ctx, i) {
          return Card(
            child: ListTile(
              leading: Container(
                width: 120,
                height: 200,
                child: Image.network(
                  foodProvider.foodList[i].image != null ? foodProvider.foodList[i].image : Center(child: Text('No Image'),),
                   fit: BoxFit.cover),
              ),
              title: Text(foodProvider.foodList[i].name),
              subtitle: Text(foodProvider.foodList[i].category),
              onTap: () {
                foodProvider.currentFood = foodProvider.foodList[i];
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:(BuildContext context) =>  
                    DetailScreen()
                  )
                );
              },
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          foodProvider.currentFood = null;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:(BuildContext context) =>  
              FoodFormScreen(
                isUpdating: false,
              )
            )
          );
        }
      ),
    );
  }
}