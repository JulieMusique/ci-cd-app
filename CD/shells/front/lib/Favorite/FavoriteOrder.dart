import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/Favorite/bloc/FavoriteslistBloc.dart';
import 'package:flutter_ui_food_delivery_app/home/main_screen.dart';
import 'package:flutter_ui_food_delivery_app/http/HttpServiceFav.dart';
import 'package:flutter_ui_food_delivery_app/model/list_food.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';
import 'package:flutter_ui_food_delivery_app/utils/style.dart';
import '../model/User.dart';

// La liste des plats en favoris
class FavoriteScreen extends StatefulWidget {
  final User user;

  FavoriteScreen({required this.user});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late FavoriteListBloc bloc;
  late Future<List<Food>> foodItems =
      Future.value(fetchFavoriteDishes(widget.user.id ?? 0));
  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.getBloc<FavoriteListBloc>();
    // Récupération de la liste des aliments favoris et gestion des cas d'erreur

    fetchFavoriteDishes(widget.user.id ?? 0).then((list) {
      if (list.isNotEmpty) {
        setState(() {
          foodItems = Future.value(list);
        });
      } else {
        setState(() {
          foodItems = Future.error("No data found");
        });
      }
    }).catchError((error) {
      setState(() {
        foodItems = Future.error(error);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Food>>(
      stream: bloc.listStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              leading: GestureDetector(
                child: Icon(
                  CupertinoIcons.back,
                  size: 20,
                ),
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainScreen(
                                onTap: () {},
                                user: widget.user,
                              )));
                },
              ),
              title: Text(
                "My Favorite Dishes ",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            body: SafeArea(
              child: FavBody(foodItems, widget.user),
            ),
          );
        } else if (snapshot.hasError) {
          return Container(
            child: Text("An error occurred: ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container(
            child: Text("Waiting for data..."),
          );
        }
      },
    );
  }
}

class FavBody extends StatelessWidget {
  final Future<List<Food>> foodItems;
  final User user;
  FavBody(this.foodItems, this.user);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Food>>(
      future: foodItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Chargement de la page
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Si le Future est en cours d'exécution,  un indicateur de chargement sera affiché
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // En cas d'erreur,  un message d'erreur sera affiché
          return noItemContainer();
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Si des données sont disponibles et non vides,  la liste d'articles sera affiché
          return Container(
            padding: EdgeInsets.fromLTRB(20, 30, 15, 0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: foodItemList(snapshot.data!),
                )
              ],
            ),
          );
        } else {
          // Si aucune des conditions ci-dessus n'est remplie, un message approprié sera affiché.
          return noItemContainer();
        }
      },
    );
  }

  Container noItemContainer() {
    return Container(
      child: Center(
        child: Text(
          "No More Items Left In Favoris",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              fontSize: 20),
        ),
      ),
    );
  }

  ListView foodItemList(List<Food> foodItems) {
    return ListView.builder(
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        return FavoriteListItem(user: user, foodItem: foodItems, index: index);
      },
    );
  }
}

class FavoriteListItem extends StatefulWidget {
  final List<Food> foodItem;
  final User user;
  final int index;
  FavoriteListItem(
      {required this.foodItem, required this.user, required this.index});

  @override
  _FavoriteListItemState createState() => _FavoriteListItemState();
}

class _FavoriteListItemState extends State<FavoriteListItem> {
  final FavoriteListBloc bloc = BlocProvider.getBloc<FavoriteListBloc>();

  @override
  Widget build(BuildContext context) {
    return DraggableChild(
        user: widget.user, foodItem: widget.foodItem, index: widget.index);
  }
}

class DraggableChild extends StatelessWidget {
  const DraggableChild(
      {Key? key,
      required this.foodItem,
      required this.user,
      required this.index})
      : super(key: key);

  final List<Food> foodItem;
  final User user;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: ItemContent(user: user, foodItem: foodItem, index: index),
    );
  }
}

class ItemContent extends StatefulWidget {
  const ItemContent({
    Key? key,
    required this.foodItem,
    required this.user,
    required this.index,
  }) : super(key: key);

  final List<Food> foodItem;
  final User user;
  final int index;
  @override
  ItemContentState createState() => ItemContentState();
}

class ItemContentState extends State<ItemContent> {
  @override
  Widget build(BuildContext context) {
    final FavoriteListBloc bloc = BlocProvider.getBloc<FavoriteListBloc>();
    String _fetchImageUrl(String imagePath) {
      if (imagePath.contains("http") || imagePath.contains("https")) {
        return imagePath;
      } else {
        return "/assets/$imagePath";
      }
    }

    if (widget.index >= 0 && widget.index < widget.foodItem.length) {
      // Verifie si l'indice est bien entre 0 et la longueur du tableau de foodItem
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          // Affichage un dialogue de confirmation
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirmation"),
                content: Text(
                    "Confirmez-vous la suppression de ce repas des favoris"),
                actions: <Widget>[
                  TextButton(
                    child: Text("Annuler"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text("Supprimer"),
                    onPressed: () {
                      deleteFavoriteDish(
                          widget.user.id!, widget.foodItem[widget.index].id);
                      bloc.removeFromList(widget.foodItem[widget.index]);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FavoriteScreen(user: widget.user),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) {
          // Code à exécuter lorsque l'élément est supprimé
          deleteFavoriteDish(widget.user.id!, widget.foodItem[widget.index].id);
          bloc.removeFromList(widget.foodItem[widget.index]);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${widget.foodItem[widget.index].title} removed from favorites'),
              duration: Duration(seconds: 1),
            ),
          );
          // Reconstruire la page FavoriteScreen après la suppression
          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => FavoriteScreen(user: widget.user),
              ),
            );
          });
        },
        background: Container(
          color: Colors.red,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 30,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(blurRadius: 10, color: AppColor.lighterGray)],
            color: AppColor.white,
          ),
          child: Row(
            children: [
              Row(
                children: [
                  Hero(
                    tag: NetworkImage(_fetchImageUrl(widget
                        .foodItem[widget.index]
                        .imagePath)), // Tag pour l'animation Hero (transition d'image)
                    child: Image.network(
                      _fetchImageUrl(widget.foodItem[widget.index].imagePath),
                      width: MediaQuery.of(context).size.width /
                          6, // Largeur de l'image
                    ),
                  ),
                  SizedBox(width: 16), // Espace entre l'image et le nom/prix
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PrimaryText(
                        text: widget.foodItem[widget.index].title,
                        size: 18,
                        fontWeight: FontWeight.w700,
                      ),
                      PrimaryText(
                        text: '\$${widget.foodItem[widget.index].price}',
                        size: 16,
                        color: AppColor.lightGray,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      );
    } else {
      return Container(
        child: Center(
          child: Text(
            "Please refresh the page",
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                fontSize: 20),
          ),
        ),
      );
    }
  }
}
