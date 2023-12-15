import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../model/list_food.dart';

String urlLocal = "http://localhost:8080/DelivCROUS/dishs";

//GET
Future<List<Food>> fetchDishes(String url) async {
  try {
    await http.get(Uri.parse(url));
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  http.Response res = await http.get(Uri.parse(url));

  if (res.statusCode == 200) {
    List<Food> dishes = [];
    final List obj = jsonDecode(res.body);
    if (kDebugMode) {
      //print(obj);
    }
    for (var i = 0; i < obj.length; i++) {
      List<Ingredient> ingredientList = [];
      for (var ingredientJson in obj[i]['ingredientList']) {
        ingredientList.add(Ingredient.fromJson(ingredientJson));
      }

      dishes.add(Food(
          id: obj[i]['idDish'],
          title: obj[i]['title'],
          description: obj[i]['description'],
          categories: obj[i]['categories'],
          price: obj[i]['price'],
          imagePath: obj[i]['imagePath'],
          ingredients: ingredientList,
          allergens: obj[i]['allergenList']));
    }
    return dishes;
  } else {
    return throw Exception('Failed to load dishes');
  }
}
