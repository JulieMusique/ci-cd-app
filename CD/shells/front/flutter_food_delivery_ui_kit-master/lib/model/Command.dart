import 'package:flutter_ui_food_delivery_app/model/Compose.dart';
import 'package:flutter_ui_food_delivery_app/model/list_food.dart';

class Command {
  int? idCommand;
  int? idUser;
  String? orderDate;
  String? deliveryAdress; // Adresse de livraison
  double totalAmount;
  List<Compose> compose;

  Command({
    this.idCommand,
    required this.idUser,
    this.orderDate,
    required this.deliveryAdress,
    required this.totalAmount,
    required this.compose,
  });

  List<Food> get foods {
    List<Food> foods = [];
    for (Compose compose in this.compose) {
      foods.add(compose.dish);
    }
    return foods;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonCompose =
        compose.map((item) => item.toJson()).toList();
    return {
      'idUser': idUser,
      'deliveryAdress': deliveryAdress,
      'composeItems': jsonCompose
    };
  }

  factory Command.fromJson(Map<String, dynamic> chaineJson) {
    return Command(
        idCommand: chaineJson['idCommand']!,
        idUser: chaineJson['idUser'],
        orderDate: chaineJson['orderDate'],
        deliveryAdress: chaineJson['deliveryAdress'],
        totalAmount: chaineJson['totalAmount'],
        compose: chaineJson['composeItems']);
  }
}
