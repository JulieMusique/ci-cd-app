import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/Favorite/Favoritebar.dart';
import 'package:flutter_ui_food_delivery_app/cart/buy_food.dart';
import 'package:flutter_ui_food_delivery_app/cart/cart_screen.dart';
import 'package:flutter_ui_food_delivery_app/model/Command.dart';
import 'package:flutter_ui_food_delivery_app/model/list_food.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';

import '../model/User.dart';

const TextStyle styleDetail = TextStyle(
  fontFamily: 'Poppins',
  fontWeight: FontWeight.w600,
  fontSize: 19,
);

class DetailFood extends StatelessWidget {
  final Food food;
  final User user;
  final Command? command;
  const DetailFood(
      {Key? key, required this.food, required this.user, this.command})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // En-tête de la page avec une image
              Container(
                padding: EdgeInsets.all(20),
                color: Color(0xFFD2F5AF), // Couleur de fond de l'en-tête
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Retour à l'écran précédent
                          },
                          icon: Icon(
                            CupertinoIcons.chevron_left_square_fill,
                            color: Colors.white, // Couleur de l'icône
                            size: 35, // Taille de l'icône
                          ),
                        ),
                        FavB(
                            user: user,
                            food: food), // Widget pour gérer les favoris
                      ],
                    ),
                    Image.network(
                      food.imagePath, // Chemin de l'image
                      width: 250, // Largeur de l'image
                    ),
                  ],
                ),
              ),
              // Contenu principal de la page
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white, // Couleur de fond
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30),
                      topLeft: Radius.circular(30)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.title, // Nom de l'aliment
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                      ),
                    ),
                    Text("Description :", // Titre de la description
                        style: styleDetail),
                    Text(
                      food.description, // Description de l'aliment
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                      ),
                    ),
                    ListWidget(
                        relatedName: 'Ingredients',
                        list: food.getNameIngredient()),
                    ListWidget(
                        relatedName: 'Categories', list: food.categories),
                    ListWidget(relatedName: 'Allergens', list: food.allergens),
                    Container(
                      margin: EdgeInsets.only(top: 25, bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            food.price.toString() + "\€", // Prix de l'aliment
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: vermilion,
                              // Couleur de l'arrière-plan du bouton
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: BuyFood(
                              command: command,
                              dish: food,
                              user: user,
                            ), // Widget pour acheter l'aliment
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen(user: user)),
            );
          },
          child: Text(
            "Buy Now",
            style: TextStyle(
              color: Color.fromARGB(
                  251, 255, 255, 255), // Couleur du texte du bouton
            ),
          ),
          style: ElevatedButton.styleFrom(
            primary: vermilion,
            // Couleur de fond du bouton
            padding: EdgeInsets.all(25),
            // Remplissage du bouton
            elevation: 0,
            // Élévation du bouton
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(30), // Bordure arrondie du bouton
              ),
            ),
            textStyle: TextStyle(
              fontFamily: 'Poppins', // Police de caractères du texte du bouton
              fontSize: 17, // Taille du texte du bouton
            ),
          ),
        ),
      ),
    );
  }
}

// ListWidget -> Generic Widget to show text from a list of string and associated name
class ListWidget extends StatelessWidget {
  final String relatedName;
  final List list;

  const ListWidget({super.key, required this.relatedName, required this.list});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$relatedName : ", style: styleDetail),
          SizedBox(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                var item = list[index];
                String firstLetter =
                    item.substring(0, 1); // item = "Hello" -> firstLetter = "H"
                String remainsLowerCase = item
                    .substring(1)
                    .toLowerCase(); // item = "HELLO" -> item.substring(1) = "ELLO" .toLowerCase()
                item = firstLetter + remainsLowerCase;
                return Text(
                  item + (index < list.length - 1 ? ', ' : ''),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
