import 'package:flutter_ui_food_delivery_app/model/list_food.dart';

class FavoriteProvider {
  List<Food> foodItems = [];

  List<Food> addToList(Food foodItem) {
    bool isPresent = false;

    if (foodItems.length > 0) {
      for (int i = 0; i < foodItems.length; i++) {
        if (foodItems[i].id == foodItem.id) {
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        foodItems.add(foodItem);
      }
    } else {
      foodItems.add(foodItem);
    }

    return foodItems;
  }

  List<Food> removeFromList(Food foodItem) {
    //remove it from the list
    foodItems.remove(foodItem);

    return foodItems;
  }
}
