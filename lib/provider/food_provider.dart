import 'dart:collection';

import 'package:cwhp_flutter/model/food.dart';
import 'package:flutter/foundation.dart';

class FoodProvider with ChangeNotifier {
  List<Food> _foodList = [];
  Food _currentFood;


  UnmodifiableListView<Food> get foodList => UnmodifiableListView(_foodList);

  Food get currentFood => _currentFood;

  set foodList(List<Food> foodList) {
    _foodList = foodList;
    notifyListeners();
  }

  set currentFood(Food food) {
    _currentFood = food;
    notifyListeners();
  }

  addFood(Food food) {
    _foodList.insert(0, food);
    notifyListeners();
  }



}