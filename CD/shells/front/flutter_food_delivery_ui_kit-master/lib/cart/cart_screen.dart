import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/cart/buy_food.dart';
import 'package:flutter_ui_food_delivery_app/cart/payment_screen.dart';
import 'package:flutter_ui_food_delivery_app/http/HttpServiceCart.dart';
import 'package:flutter_ui_food_delivery_app/model/Command.dart';
import 'package:flutter_ui_food_delivery_app/model/Compose.dart';
import 'package:flutter_ui_food_delivery_app/model/User.dart';
import 'package:flutter_ui_food_delivery_app/model/list_food.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';
import 'package:flutter_ui_food_delivery_app/utils/style.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_button.dart';
import 'bloc/cartlistBloc.dart';
import 'bloc/listTileColorBloc.dart';

//Cette classe est le panier de l'application
class CartScreen extends StatefulWidget {
  final User user;
  CartScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Food> dishes = [];
  late Command command;
  @override
  void initState() {
    super.initState();
    command = Command(
      idUser: widget.user.id,
      deliveryAdress: "",
      totalAmount: 0.0,
      compose: [],
    );
    //Recupération de la commande en cours
    fetchCurrentCommand(widget.user.id ?? 0).then((list) {
      setState(() {
        if (list != null) {
          command = list;
          for (Compose compose in command.compose) {
            dishes.add(compose.dish);
          }
        }
      });
    }).catchError((error) {
      setState(() {
        command = Command(
          idUser: widget.user.id,
          deliveryAdress: "",
          totalAmount: 0.0,
          compose: [],
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final CartListBloc bloc = BlocProvider.getBloc<CartListBloc>();
    return StreamBuilder(
      stream: bloc.listStream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          return Scaffold(
            body: SafeArea(
              child: CartBody(dishes, command, widget.user),
            ),
            bottomNavigationBar: BottomBar(dishes, command, widget.user),
          );
        } else {
          return Container(
            child: Text("Something returned null"),
          );
        }
      },
    );
  }
}

Container totalAmount(Command command) {
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Total:",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
        ),
        Text(
          "\$${command.totalAmount}",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
        ),
      ],
    ),
  );
}

class BottomBar extends StatefulWidget {
  final List<Food> foodItems;
  final Command command;
  final User user;

  BottomBar(this.foodItems, this.command, this.user);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  double totalAmount = 0.0;

  @override
  void initState() {
    updateTotalAmount();

    super.initState();
  }

  // Met à jour le montant total en fonction des éléments dans le panier
  void updateTotalAmount() {
    double total = 0.0;
    for (int i = 0; i < widget.foodItems.length; i++) {
      total = total + widget.foodItems[i].price * widget.foodItems[i].quantity;
    }

    setState(() {
      totalAmount = total;
    });
  }

  bool isShowSignInDialog = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 35, bottom: 25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            padding: EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Total:",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),
                ),
                Text(
                  "\$${widget.command.totalAmount}",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 28),
                ),
              ],
            ),
          ),
          // Bouton "Continue" pour finaliser la commande
          GestureDetector(
              child: AppButton(
            bgColor: vermilion,
            borderRadius: 30,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            onTap: () {
              if (widget.command.totalAmount == 0) {
                final snackBar = SnackBar(
                  content: Text('Vous devez ajouter au moins un articlee'),
                  // Message de la barre d'informations
                  duration: Duration(
                      milliseconds:
                          550), // Durée d'affichage de la barre d'informations
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                Future.delayed(
                  const Duration(milliseconds: 800),
                  () {
                    setState(() {
                      isShowSignInDialog = true;
                    });
                    showCustomDialog(
                      context,
                      onValue: (_) {
                        setState(() {
                          isShowSignInDialog = false;
                        });
                      },
                      user: widget.user,
                      command: widget.command,
                    );
                  },
                );
              }
            },
            text: "Confirm order",
            textColor: Colors.white,
          )),
        ],
      ),
    );
  }
}

// Classe représentant le corps de l'écran du panier
class CartBody extends StatelessWidget {
  final List<Food> foodItems; // Liste des articles alimentaires dans le panier
  final Command command;
  final User user;

  CartBody(this.foodItems, this.command,
      this.user); // Constructeur prenant la liste des articles alimentaires comme paramètre

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 30, 15, 0), // Espacement intérieur du conteneur
      child: Column(
        children: <Widget>[
          CustomAppBar(), // Affiche la barre d'applications personnalisée
          Expanded(
            flex: 1,
            child: foodItems.length > 0
                ? foodItemList() // Affiche la liste des articles alimentaires si elle n'est pas vide
                : noItemContainer(), // Affiche un message si la liste est vide
          )
        ],
      ),
    );
  }

  // Widget pour afficher un message lorsque le panier est vide
  Scaffold noItemContainer() {
    return Scaffold(
        body: SafeArea(
            child: Container(
      child: Center(
        child: Text(
          "No More Items Left In The Cart",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              fontSize: 20),
        ),
      ),
    )));
  }

  // Widget pour afficher la liste des articles alimentaires dans le panier
  ListView foodItemList() {
    return ListView.builder(
      itemCount: foodItems.length,
      itemBuilder: (context, index) {
        return CartListItem(
          foodItem: foodItems[index],
          command: command,
          user: user,
        );
      },
    );
  }
}

// Classe représentant un élément de la liste du panier
class CartListItem extends StatelessWidget {
  final Food foodItem; // L'article alimentaire associé à cet élément
  final Command command;
  final User user;

  CartListItem(
      {required this.foodItem,
      required this.command,
      required this.user}); // Constructeur avec l'article alimentaire comme paramètre

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      hapticFeedbackOnStart:
          false, // Désactive la rétroaction haptique au début du glissement
      maxSimultaneousDrags:
          1, // Permet un seul glissement simultané de cet élément
      data: foodItem, // L'article alimentaire associé aux données de glissement
      feedback: DraggableChildFeedback(
        foodItem: foodItem,
        command: command,
        user: user,
      ), // Rétroaction visuelle pendant le glissement
      child: DraggableChild(
          foodItem: foodItem,
          command: command,
          user: user), // Contenu de l'élément glissable
      childWhenDragging: foodItem.quantity > 1
          ? DraggableChild(
              foodItem: foodItem,
              command: command,
              user: user,
            ) // Affiche l'élément glissable lors du glissement si la quantité est supérieure à 1
          : Container(), // Affiche un conteneur vide lors du glissement si la quantité est égale à 1
    );
  }
}

// Classe représentant un élément pouvant être glissé (draggable) pour un article du panier
class DraggableChild extends StatelessWidget {
  const DraggableChild({
    Key? key,
    required this.foodItem, // L'article alimentaire associé à cet élément glissable
    required this.command,
    required this.user,
  }) : super(key: key);

  final User user;
  final Food
      foodItem; // L'article alimentaire affiché dans cet élément glissable
  final Command command;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          bottom:
              25), // Marge inférieure pour espacement entre les éléments glissables
      child: ItemContent(
        foodItem: foodItem,
        command: command,
        user: user,
      ), // Affiche le contenu de l'article alimentaire
    );
  }
}

// Classe représentant un élément de feedback lors du glissement (drag) d'un article du panier
class DraggableChildFeedback extends StatelessWidget {
  const DraggableChildFeedback({
    Key? key,
    required this.foodItem, // L'article alimentaire associé à cet élément de feedback
    required this.command,
    required this.user,
  }) : super(key: key);
  final User user;
  final Food
      foodItem; // L'article alimentaire affiché dans cet élément de feedback
  final Command command;

  @override
  Widget build(BuildContext context) {
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

    return Opacity(
      opacity: 0.7, // Opacité de l'élément de feedback (70% de transparence)
      child: Material(
        child: StreamBuilder(
          stream: colorBloc
              .colorStream, // Flux de couleurs pour le changement de couleur
          builder: (context, snapshot) {
            return Container(
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(15), // Coins arrondis du conteneur
                color: snapshot.data != null
                    ? snapshot.data
                    : Colors
                        .white, // Couleur du conteneur basée sur le flux de couleurs
              ),
              child: ItemContent(
                  foodItem: foodItem,
                  command: command,
                  user:
                      user), // Affiche l'élément de contenu de l'article alimentaire
            );
          },
        ),
      ),
    );
  }
}

// Classe représentant un élément de contenu d'un article dans le panier
class ItemContent extends StatelessWidget {
  const ItemContent({
    Key? key,
    required this.foodItem,
    required this.command,
    required this.user,
  }) : super(key: key);

  final User user;
  final Food
      foodItem; // Représente l'article alimentaire affiché dans cet élément
  final Command command;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(blurRadius: 10, color: AppColor.lighterGray)],
        color: AppColor.white, // Couleur de fond de l'élément de contenu
      ),
      child: Row(
        children: [
          Row(
            children: [
              Hero(
                tag: NetworkImage(_fetchImageUrl(foodItem
                    .imagePath)), // Tag pour l'animation Hero (transition d'image)
                child: Image.network(
                  _fetchImageUrl(foodItem.imagePath),
                  width: MediaQuery.of(context).size.width /
                      6, // Largeur de l'image
                ),
              ),
              SizedBox(width: 16), // Espace entre l'image et le nom/prix
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: foodItem.title, // Nom de l'article alimentaire
                    size: 18, // Taille de la police pour le nom
                    fontWeight: FontWeight.w700, // Poids de la police en gras
                  ),
                  PrimaryText(
                    text: '\$${foodItem.price}', // Prix de l'article
                    size: 16, // Taille de la police pour le prix
                    color: AppColor.lightGray, // Couleur du texte du prix
                  ),
                ],
              ),
            ],
          ),
          Spacer(), // Étire l'espace disponible entre les éléments
          Container(
            decoration: BoxDecoration(
              color: vermilion, // Couleur de fond du conteneur
              borderRadius:
                  BorderRadius.circular(15), // Coins arrondis du conteneur
            ),
            child: BuyFood(
              command: command,
              dish: foodItem,
              user: user,
            ), // Affiche un widget "BuyFood" (peut être un bouton d'achat)
          ),
        ],
      ),
    );
  }

  String _fetchImageUrl(String imagePath) {
    if (imagePath.contains("http") || imagePath.contains("https")) {
      return imagePath;
    } else {
      return "/assets/$imagePath";
    }
  }
}

// Classe pour afficher une barre d'app bar personnalisée
class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        child: Icon(
          CupertinoIcons.back, // Icône de flèche de retour style iOS
          size: 20, // Taille de l'icône
        ),
        onTap: () {
          // Lorsqu'on appuie sur l'icône de retour
          Navigator.pop(
              context); // Navigue en arrière pour revenir à l'écran précédent
        },
      ),
      title: Text(
        "My Order", // Titre de la barre d'app bar
        style: TextStyle(
          fontWeight: FontWeight.w700, // Poids de la police en gras
          fontSize: 15, // Taille de la police
        ),
      ),
    );
  }
}
