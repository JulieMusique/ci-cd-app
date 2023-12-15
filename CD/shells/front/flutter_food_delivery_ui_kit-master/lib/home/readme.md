# MainScreen

- `MainScreen` est un StatefulWidget qui représente l'écran principal de l'application.
- Il contient un Scaffold avec un fond de couleur "concrete" et une barre de navigation en bas.
- Le bas de l'écran est géré par un widget BottomNavigationBar qui permet de basculer entre les onglets "Accueil", "Favoris", "Historique" et "Profil".
- Chaque onglet est associé à une icône et une étiquette.
- L'écran principal est composé d'une liste de widgets, où chaque widget correspond à un onglet.
- L'index de l'onglet sélectionné est suivi par `_selectedIndex`.

# _HomeScreenState (Classe interne de HomeScreen)
HomeScreen est un widget StatefulWidget qui représente l'écran principal de l'application.
- `_HomeScreenState` est un State qui gère l'état de la classe `HomeScreen`.
- Il initialise un contrôleur de texte `_controller` pour la zone de recherche.
selectedFoodCard est une variable entière utilisée pour suivre la catégorie de nourriture sélectionnée.
- _controller est un TextEditingController utilisé pour contrôler un champ de texte dans un formulaire de recherche.
- isAscendingOrder est un booléen qui détermine si la liste des plats doit être triée par ordre croissant ou décroissant.
- initState() est une méthode appelée lors de la création de l'état de l'écran.
- dispose() est une méthode appelée lors de la suppression de l'état de l'écran. Elle est utilisée pour libérer des ressources telles que le contrôleur de texte.
- La méthode `build` crée l'interface utilisateur de l'écran d'accueil.
- Elle affiche une barre de recherche, une liste de catégories de nourriture, et une liste de cartes d'aliments.
build(BuildContext context) :

Cette méthode construit l'interface utilisateur de l'écran principal.
Elle contient une ListView avec plusieurs éléments, notamment des titres, une boîte de recherche, des catégories de nourriture et une liste de plats.
- Les catégories de nourriture sont affichées horizontalement en utilisant un `ListView.builder`.
- Les cartes d'aliments sont générées à partir de la liste `FoodList`.
# FoodCard() :

Il s'agit d'un widget personnalisé qui affiche les détails d'un plat de nourriture, notamment une image, un nom, un poids, un prix, et des boutons pour ajouter le plat au panier et le marquer comme favori.
# foodCategoryCard() :

Il s'agit d'un widget personnalisé qui représente une catégorie de nourriture sous forme de cercle. Il affiche une icône, un nom et une flèche de droite pour la sélection.
# FavB (Favori) :

Il s'agit d'un widget StatefulWidget qui permet à l'utilisateur d'ajouter ou de supprimer un plat de nourriture de sa liste de favoris. Il affiche une icône de cœur rempli ou vide en fonction de l'état actuel.
L'ensemble du code semble être une partie d'une application Flutter qui présente des plats de nourriture, des catégories de nourriture, et permet aux utilisateurs d'ajouter des plats à leur panier et de les marquer comme favoris. Il utilise également la gestion d'état avec BLoC (Business Logic Component) pour gérer la liste des plats dans le panier.



# DetailFood

- `DetailFood` est un StatefulWidget qui représente l'écran de détail d'un aliment.
- Il affiche les détails d'un aliment, y compris son image, nom, catégorie, prix, description, allergène, et une option pour l'ajouter au panier.
- Les boutons "+" et "-" sont utilisés pour incrémenter ou décrémenter la quantité d'aliments.
- Il contient également un bouton "Acheter maintenant" qui n'a pas encore de logique définie.

# BuyFood (Classe interne de DetailFood)

- `BuyFood` est un StatefulWidget qui gère les boutons "+" et "-" pour la quantité d'aliments.
- Il maintient un état local `buyFood` qui représente la quantité actuelle d'aliments.
- Les boutons permettent d'augmenter ou de diminuer la quantité et mettent à jour l'état.

# FoodCategory

- `FoodCategory` est une classe qui représente une catégorie de nourriture avec une image et un nom.
- Elle est utilisée pour afficher les catégories de nourriture sur l'écran d'accueil.

# Food

- `Food` est une classe qui représente un aliment avec un ID, une image, un nom, une description, un prix, une catégorie, un allergène et une quantité. faut ajouter les ingredients 
- La quantité est utilisée pour suivre combien d'articles de cet aliment sont dans le panier.
- Les méthodes `incrementQuantity` et `decrementQuantity` permettent d'ajuster la quantité.
