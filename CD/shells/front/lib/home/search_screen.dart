// Import des packages Flutter nécessaires
import 'package:flutter/material.dart'; // Import du package Material Design
import 'package:flutter_ui_food_delivery_app/utils/colors.dart'; // Import des couleurs personnalisées
import 'package:flutter_ui_food_delivery_app/home/FoodDetail.dart'; // Importation de la page de détail des aliments
import '../http/HttpServiceDish.dart';
import '../model/list_food.dart'; // Import du widget de texte personnalisé
import '../model/User.dart';

// Définition d'une classe SearchScreen qui étend StatefulWidget
class SearchScreen extends StatefulWidget {
  User user;
  SearchScreen({Key? key, required this.user}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

// Définition de la classe d'état _SearchScreenState
class _SearchScreenState extends State<SearchScreen> {
  late Future<List<Food>>? foodList;
  // Contrôleur de texte pour la barre de recherche
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    // Logique d'initialisation de l'écran (vide dans cet exemple)
    foodList = null;
  }

  @override
  void dispose() {
    // Libération des ressources à la fermeture de l'écran
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Construction de l'interface utilisateur de l'écran de recherche
    return Scaffold(
      body: Stack(
        children: [
          // Conteneur arrière-plan avec une couleur de fond et des éléments d'interface utilisateur
          Container(
            color: gallery, // Couleur d'arrière-plan
            padding: EdgeInsets.all(24), // Marge intérieure
            child: Column(
              children: [
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height * 0.075, // Espacement
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black, // Couleur de l'icône
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(); // Action de retour
                      },
                    ),
                    Expanded(
                      child: TextField(
                          controller: controller,
                          decoration: InputDecoration.collapsed(
                            hintText:
                                "Search", // Texte de l'indicateur de recherche
                            border: InputBorder.none, // Pas de bordure
                          ),
                          style:
                              TextStyle(color: Colors.black), // Style du texte
                          onChanged: (text) {
                            setState(() {
                              if (text.isNotEmpty) {
                                var url = urlLocal + "?searchedTitle=" + text;
                                foodList = fetchDishes(url);
                              } else
                                foodList = Future.value([]);
                            });
                          }),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Conteneur avant-plan avec des résultats de recherche
          Container(
            margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height *
                    0.2), // Marge supérieure
            decoration: BoxDecoration(
                color: alabaster, // Couleur de fond
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))), // Coins arrondis
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<List<Food>>(
                        future: foodList,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(); // Écran de chargement
                          } else if (snapshot.hasError) {
                            return Text('Erreur : ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('Aucune donnée disponible.');
                          } else {
                            final dishes = snapshot.data;

                            if (dishes != null) {
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: dishes.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                            dishes[index].imagePath),
                                      ),
                                      title: Text(dishes[index].title),
                                      onTap: () {
                                        // Utilisation de MaterialPageRoute pour naviguer vers la page de détail
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => DetailFood(
                                              user: widget.user,
                                              food: dishes[index]),
                                        ));
                                      },
                                    ),
                                  );
                                },
                              );
                            } else {
                              return Container(
                                child: Center(
                                  child: Text(
                                    "Aucun résultat :(",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[500],
                                        fontSize: 20),
                                  ),
                                ),
                              );
                            }
                          }
                        })),
                Flexible(
                    child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Nombre de colonnes dans la grille
                      childAspectRatio:
                          2 / 3, // Ratio largeur/hauteur des éléments
                      crossAxisSpacing:
                          4.0, // Espacement horizontal entre les éléments
                      mainAxisSpacing:
                          4.0), // Espacement vertical entre les éléments
                  itemBuilder: (BuildContext context, int index) {
                    // Fonction de construction des éléments de la grille
                  },
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
