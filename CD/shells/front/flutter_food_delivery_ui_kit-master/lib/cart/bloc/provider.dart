import 'package:flutter_ui_food_delivery_app/model/list_food.dart';

class CartProvider {
  List<Food> foodItems = [];

  List<Food> addToList(Food foodItem) {
    bool isPresent = false;

    if (foodItems.length > 0) {
      for (int i = 0; i < foodItems.length; i++) {
        if (foodItems[i].id == foodItem.id) {
          increaseItemQuantity(foodItem);
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
    if (foodItem.quantity > 1) {
      //only decrease the quantity
      decreaseItemQuantity(foodItem);
    } else {
      //remove it from the list
      foodItems.remove(foodItem);
    }
    return foodItems;
  }

  void increaseItemQuantity(Food foodItem) => foodItem.incrementQuantity();
  void decreaseItemQuantity(Food foodItem) => foodItem.decrementQuantity();
}
