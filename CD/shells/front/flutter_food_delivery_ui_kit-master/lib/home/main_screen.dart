// Importations des dépendances nécessaires
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_ui_food_delivery_app/Favorite/FavoriteOrder.dart';
import 'package:flutter_ui_food_delivery_app/Favorite/bloc/FavoriteslistBloc.dart';
import 'package:flutter_ui_food_delivery_app/History/HistoryOrder.dart';
import 'package:flutter_ui_food_delivery_app/History/bloc/HistorylistBloc.dart';
import 'package:flutter_ui_food_delivery_app/cart/bloc/cartlistBloc.dart';
import 'package:flutter_ui_food_delivery_app/cart/bloc/listTileColorBloc.dart';
import 'package:flutter_ui_food_delivery_app/cart/cart_screen.dart';
import 'package:flutter_ui_food_delivery_app/home/home_screen.dart';
import 'package:flutter_ui_food_delivery_app/login/profile/profile_screen.dart';
import 'package:flutter_ui_food_delivery_app/model/User.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';

import '../utils/routes.dart';

// Définition du widget MainScreen
// ignore: must_be_immutable
class MainScreen extends StatefulWidget {
  final VoidCallback onTap;
  User user;

  MainScreen({required this.onTap, required this.user});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Liste de widgets pour contenir les pages à afficher
  List<Widget> widgets = [];

  int _selectedIndex = 0;

  @override
  void initState() {
    // Initialisation de la liste de widgets avec des instances de HomeScreen
    widgets.add(HomeScreen(user: widget.user));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Crée un Scaffold, qui fournit une structure de base pour la page
    return Scaffold(
      backgroundColor: concrete, // Définit la couleur de fond de la page
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: concrete),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor:
              concrete, // Définit la couleur de fond de la barre de navigation inférieure
          items: <BottomNavigationBarItem>[
            // Liste des éléments de la barre de navigation inférieure
            BottomNavigationBarItem(
              label: "Accueil", // Étiquette de l'élément
              icon: Icon(Icons.home), // Icône de l'élément
            ),
            BottomNavigationBarItem(
              label: "Favoris",
              icon: IconButton(
                onPressed: () {
                  // Navigue vers l'écran des Favoris lorsqu'on appuie sur l'icône
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FavoriteScreen(user: widget.user)),
                  );
                },
                icon: Icon(Icons.favorite_border),
              ),
            ),
            BottomNavigationBarItem(
              label: "Historique",
              icon: IconButton(
                onPressed: () {
                  // Navigue vers l'écran des Favoris lorsqu'on appuie sur l'icône
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoryScreen(user: widget.user)),
                  );
                },
                icon: Icon(Icons.history),
              ),
            ),
            BottomNavigationBarItem(
                label: "Profile",
                icon: IconButton(
                  onPressed: () {
                    // Navigue vers l'écran des Favoris lorsqu'on appuie sur l'icône
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(user: widget.user)),
                    );
                  },
                  icon: Icon(Icons.account_circle),
                )),
          ],
          unselectedItemColor: manatee, // Couleur des éléments non sélectionnés
          currentIndex:
              _selectedIndex, // Index de l'élément actuellement sélectionné
          selectedItemColor: Color.fromARGB(
              255, 89, 154, 23), // Couleur de l'élément sélectionné
        ),
      ),
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage:
                            AssetImage('man.jpeg'), // Image du profil
                      ),
                      onTap: () {
                        Navigator.of(context).pushNamed(Routes.profile);
                      },
                    ),
                    // Utilisation de BlocProvider pour gérer les BLoCs
                    BlocProvider(
                      blocs: [
                        Bloc((i) => CartListBloc()), // Bloc pour le panier
                        Bloc((i) => ColorBloc()), // Bloc pour la couleur
                        Bloc((i) => FavoriteListBloc()), // Bloc pour la favoris
                        Bloc(
                            (i) => HistoryListBloc()), // Bloc pour l'historique
                      ],
                      dependencies: [],
                      child: IconButton(
                        onPressed: () {
                          // Navigue vers l'écran du panier lorsque l'icône est tapée
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CartScreen(user: widget.user)),
                          );
                        },
                        icon: SvgPicture.asset(
                          "assets/icons/cart.svg", // Icône du panier
                          width: 24,
                          height: 24,
                        ),
                      ),
                    ),
                  ],
                ),
                // Affiche la page sélectionnée à partir de la liste de widgets
                widgets.elementAt(_selectedIndex),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
