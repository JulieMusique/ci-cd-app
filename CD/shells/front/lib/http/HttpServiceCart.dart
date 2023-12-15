import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_ui_food_delivery_app/model/Command.dart';
import 'package:flutter_ui_food_delivery_app/model/Compose.dart';
import 'package:flutter_ui_food_delivery_app/model/list_food.dart';
import 'package:http/http.dart' as http;

String baseURL = "http://localhost:8080/DelivCROUS/commands/";

Future<bool> createCommand(Command command) async {
  var body = jsonEncode(command.toJson());
  var url = Uri.parse(baseURL);
  http.Response response =
      await http.post(url, body: body, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode != 200) {
    // Gérez les erreurs en fonction du code de statut de la réponse
    print("Réponse du serveur : ${response.body}");
    //throw Exception('Erreur lors de l\'ajout du plat dans la commande');
    return false;
  }
  return true;
}

Future<bool> confirmCommand(Command command) async {
  var url = Uri.parse(baseURL + "${command.idCommand}/validate");
  http.Response response = await http.get(url, headers: <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  });
  if (response.statusCode != 200) {
    // Gérez les erreurs en fonction du code de statut de la réponse
    print("Réponse du serveur : ${response.body}");
    //throw Exception('Erreur lors de l\'ajout du plat dans la commande');
    return false;
  }
  return true;
}

Future<Result<List<Command>, Exception>> getCommands() async {
  try {
    final url = Uri.parse(baseURL);
    final response = await http.get(url);
    switch (response.statusCode) {
      case 200:
        List responseList = jsonDecode(response.body);
        List<Command> commands = [];
        for (Map<String, dynamic> commandMap in responseList) {
          Command command = Command.fromJson(commandMap);
          commands.add(command);
        }
        return Success(commands);
      default:
        return Failure(Exception(response.reasonPhrase));
    }
  } on Exception catch (e) {
    return Failure(e);
  }
}

Future<void> addDishToCommand(int? idCommand, int idDish) async {
  final response = await http.put(Uri.parse(baseURL + '$idCommand/add/$idDish'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });

  if (response.statusCode != 200) {
    // Gérez les erreurs en fonction du code de statut de la réponse
    print("Réponse du serveur : ${response.body}");

    throw Exception('Erreur lors de l\'ajout du plat dans la commande');
  }
}

Future<http.Response> updateFood(int id) async {
  var url = Uri.parse(baseURL + '$id');
  http.Response response = await http.put(
    url,
  );
  print(response.body);
  return response;
}

Future<List<Command>> fetchHistoryCommands(int idUser) async {
  try {
    await http.get(Uri.parse(baseURL + 'history/$idUser'));
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  http.Response res = await http.get(Uri.parse(baseURL + 'history/$idUser'));
  if (res.statusCode == 200) {
    List<Command> commandCurrent = [];
    final List objHistory = jsonDecode(res.body);
    if (kDebugMode) {
      //print(obj);
    }
    for (var i = 0; i < objHistory.length; i++) {
      List<Compose> composeItems = [];
      for (var foodJson in objHistory[i]['composeItems']) {
        List<Ingredient> ingredientList = [];
        if (foodJson['dish']['ingredientList'] != null) {
          for (var ingredientJson in foodJson['dish']['ingredientList']) {
            ingredientList.add(Ingredient.fromJson(ingredientJson));
          }
        }
        composeItems.add(Compose(
            id: QuantityDishKey.fromJson(foodJson['id']),
            dish: Food(
                id: foodJson['dish']['idDish'],
                title: foodJson['dish']['title'],
                description: foodJson['dish']['description'],
                categories: foodJson['dish']['categories'],
                price: foodJson['dish']['price'],
                imagePath: foodJson['dish']['imagePath'],
                ingredients: ingredientList,
                allergens: foodJson['dish']['allergenList']),
            quantity: foodJson['quantity']));
      }
      commandCurrent.add(Command(
          idCommand: objHistory[i]['idCommand'],
          idUser: objHistory[i]['idUser']['id'],
          orderDate: objHistory[i]['orderDate'],
          deliveryAdress: objHistory[i]['deliveryAdress'],
          totalAmount: objHistory[i]['totalAmount'],
          compose: composeItems));
    }
    return commandCurrent;
  } else {
    return throw Exception('Failed to load history commands');
  }
}

Future<Command> fetchCurrentCommand(int idUser) async {
  try {
    await http.get(Uri.parse(baseURL + 'notOrdered/$idUser'));
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }

  http.Response res = await http.get(Uri.parse(baseURL + 'notOrdered/$idUser'));

  if (res.statusCode == 200) {
    List<Command> commandCurrent = [];
    final List objHistory = jsonDecode(res.body);
    if (kDebugMode) {
      //print(obj);
    }
    for (var i = 0; i < objHistory.length; i++) {
      List<Compose> composeItems = [];

      for (var foodJson in objHistory[i]['composeItems']) {
        List<Ingredient> ingredientList = [];

        if (foodJson['dish']['ingredientList'] != null) {
          for (var ingredientJson in foodJson['dish']['ingredientList']) {
            ingredientList.add(Ingredient.fromJson(ingredientJson));
          }
        }
        composeItems.add(Compose(
            id: QuantityDishKey.fromJson(foodJson['id']),
            dish: Food(
                id: foodJson['dish']['idDish'],
                title: foodJson['dish']['title'],
                description: foodJson['dish']['description'],
                categories: foodJson['dish']['categories'],
                price: foodJson['dish']['price'],
                imagePath: foodJson['dish']['imagePath'],
                ingredients: ingredientList,
                allergens: foodJson['dish']['allergenList'],
                quantity: foodJson['quantity']),
            quantity: foodJson['quantity']));
      }

      commandCurrent.add(Command(
          idCommand: objHistory[i]['idCommand'],
          idUser: objHistory[i]['idUser']['id'],
          orderDate: objHistory[i]['orderDate'],
          deliveryAdress: objHistory[i]['deliveryAdress'],
          totalAmount: objHistory[i]['totalAmount'],
          compose: composeItems));
    }
    return commandCurrent.first;
  } else {
    return throw Exception('Failed to load not ordered commands');
  }
}

Future<http.Response> delivered() async {
  var url = Uri.parse(baseURL + 'delivered');
  http.Response response = await http.delete(
    url,
  );
  print(response.body);
  return response;
}

Future<http.Response> deleteDishFromCommand(int? idCommand, int idDish) async {
  var url = Uri.parse(baseURL + '$idCommand/remove/$idDish');
  http.Response response = await http.delete(
    url,
  );
  print(response.body);
  return response;
}

Future<http.Response> deleteCommand(int id) async {
  var url = Uri.parse(baseURL + '$id');
  http.Response response = await http.delete(
    url,
  );
  print(response.body);
  return response;
}

sealed class Result<S, E extends Exception> {
  const Result();
}

final class Success<S, E extends Exception> extends Result<S, E> {
  const Success(this.value);
  final S value;
}

final class Failure<S, E extends Exception> extends Result<S, E> {
  const Failure(this.exception);
  final E exception;
}
