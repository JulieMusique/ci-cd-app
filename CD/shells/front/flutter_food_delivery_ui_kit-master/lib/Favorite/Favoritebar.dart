import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/Favorite/bloc/FavoriteslistBloc.dart';
import 'package:flutter_ui_food_delivery_app/http/HttpServiceFav.dart';
import 'package:flutter_ui_food_delivery_app/model/User.dart';
import 'package:flutter_ui_food_delivery_app/model/list_food.dart';

// Widget pour gérer les favoris en format coeur
class FavB extends StatefulWidget {
  final Food food;
  final User user;
  FavB({Key? key, required this.food, required this.user}) : super(key: key);

  @override
  State<FavB> createState() => _FavBState();
}

class _FavBState extends State<FavB> {
  bool isFav = false; // Indicateur d'état des favoris
  final FavoriteListBloc bloc = BlocProvider.getBloc<FavoriteListBloc>();
  late int userId;

  @override
  void initState() {
    if (widget.user.id != null) {
      userId = widget.user.id!;
    } else {
      userId = 0;
    }
    // Vérification si l'aliment est déjà dans la liste de favoris

    fetchFavoriteExist(userId, widget.food.id).then((isFavorite) {
      setState(() {
        isFav = isFavorite;
        print("${widget.food.title} favoris :  ${isFav}");
      });
    });
    super.initState();
  }

  // Fonction pour ajouter un aliment au panier
  addToCart(Food food) {
    bloc.addToList(food);
  }

  // Fonction pour supprimer un aliment du panier
  removeFromList(Food food) {
    bloc.removeFromList(food);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFav ? Icons.favorite : Icons.favorite_border,
        color: isFav ? Colors.red : Colors.black,
      ),
      iconSize: 24.0,
      onPressed: () {
        if (isFav) {
          // Supprimer de la liste de favoris
          removeFromList(widget.food);
          deleteFavoriteDish(userId, widget.food.id);
          showSnackBar('${widget.food.title} retiré des favoris');
        } else {
          //Ajouter à la liste de favoris (si c'est ce que vous voulez faire)
          addToCart(widget.food);
          addFavoriteDish(userId, widget.food.id);
          showSnackBar('${widget.food.title} ajouté aux favoris');
        }
        // Inverser l'état de isFav
        setState(() {
          isFav = !isFav;
        });
      },
    );
  }

  // Affiche un message en bas de l'écran
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }
}
