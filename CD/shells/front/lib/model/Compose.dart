import 'package:flutter_ui_food_delivery_app/model/list_food.dart';

class Compose {
  QuantityDishKey? id;
  final Food dish;
  int quantity;

  Compose({
    this.id,
    required this.dish,
    required this.quantity,
  });

  get food {
    return food;
  }

  factory Compose.fromJson(Map<String, dynamic> json) {
    return Compose(
      id: QuantityDishKey.fromJson(json['id']),
      dish: Food.fromJson(json['dish']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dish': dish.toJson(),
      'quantity': quantity,
    };
  }
}

class QuantityDishKey {
  final int idDish;
  final int idCommand;

  QuantityDishKey({
    required this.idDish,
    required this.idCommand,
  });

  factory QuantityDishKey.fromJson(Map<String, dynamic> json) {
    return QuantityDishKey(
      idDish: json['idDish'],
      idCommand: json['idCommand'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDish': idDish,
      'idCommand': idCommand,
    };
  }
}
