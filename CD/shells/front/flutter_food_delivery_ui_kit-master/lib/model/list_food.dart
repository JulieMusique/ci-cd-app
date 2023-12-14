class FoodCategory {
  String imagePath; // Chemin de l'image représentant la catégorie d'aliments
  String name; // Nom de la catégorie d'aliments

  FoodCategory({required this.imagePath, required this.name});
}

class Food {
  int id; // Identifiant unique de l'aliment
  String title; // Nom de l'aliment
  String description; // Description de l'aliment
  double price; // Prix de l'aliment en euros
  String imagePath; // Chemin de l'image de l'aliment
  List categories; // Catégories de l'aliment
  List allergens; // Informations sur les allergènes de l'aliment
  List<Ingredient> ingredients;
  int quantity; // Quantité d'aliment sélectionnée (par défaut à 1)

  Food({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imagePath,
    required this.categories,
    required this.allergens,
    required this.ingredients,
    this.quantity = 1,
  });

  void incrementQuantity() {
    this.quantity =
        this.quantity + 1; // Incrémente la quantité d'aliments sélectionnés
  }

  void decrementQuantity() {
    this.quantity =
        this.quantity - 1; // Décrémente la quantité d'aliments sélectionnés
  }

  List getNameIngredient() {
    List resultName = [];
    for (int i = 0; i < ingredients.length; i++)
      resultName.add(ingredients[i].name);
    return resultName;
  }

  void setQuantity(int quantity) {
    this.quantity = quantity;
  }

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['idDish'],
      title: json['title'],
      description: json['description'],
      price: json['price'],
      imagePath: json['imagePath'],
      categories: json['categories'],
      allergens: json['allergenList'],
      ingredients: json['ingredientList'],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> jsonIngredient =
        ingredients.map((item) => item.toJson()).toList();
    return {
      'title': title,
      'description': description,
      'price': price,
      'imagePath': imagePath,
      'categories': categories,
      'allergenList': allergens,
      'ingredientList': jsonIngredient,
    };
  }

  @override
  String toString() {
    return "Plat : $id\n$title\n$description\n$price\n$price\n$imagePath\n$categories\n$allergens\n$ingredients\n";
  }
}

class Ingredient {
  final int idIngredient;
  final String name;
  final int calorie;
  final List allergenList;

  Ingredient(
      {required this.idIngredient,
      required this.name,
      required this.calorie,
      required this.allergenList});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
        idIngredient: json['idIngredient'],
        name: json['name'],
        calorie: json['calorie'],
        allergenList: json['allergenList']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'calorie': calorie, 'allergenList': allergenList};
  }

  @override
  String toString() {
    return "Ingrédient : $idIngredient\n$name\n$calorie\n$allergenList\n";
  }
}

List<FoodCategory> foodCategoryList = [
  // Liste des catégories d'aliments
  FoodCategory(
    imagePath: 'vege.svg',
    name: 'Vegetarian',
  ),
  FoodCategory(
    imagePath: 'meat.svg',
    name: 'Meat',
  ),
  FoodCategory(
    imagePath: 'assets/sea-food.svg',
    name: 'Fish',
  ),
  FoodCategory(
    imagePath: 'healthy.svg',
    name: 'Healthy',
  ),
  FoodCategory(
    imagePath: 'fat.svg',
    name: 'Fat',
  ),
];
