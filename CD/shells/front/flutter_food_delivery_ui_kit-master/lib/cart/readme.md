Pour le fichier CartScreen :

1. **Classe `CartScreen`** :
   - Cette classe représente l'écran du panier d'achat.
   - Dans la méthode build, elle utilise le modèle Bloc pour obtenir la liste des éléments du panier (foodItems) à partir du CartListBloc.
   - Elle utilise le modèle Bloc pour gérer les données du panier.
   - Le widget `StreamBuilder` est utilisé pour surveiller les changements dans le flux de données du panier.
   - Lorsque des données sont disponibles, la classe affiche un écran de panier d'achat avec un `CartBody` et une `BottomBar`.

2. **Fonction `totalAmount`** :
   - Cette fonction prend une liste de produits en entrée et retourne un conteneur affichant le montant total du panier.
   - Le montant total est calculé en itérant à travers les produits et en multipliant le prix par la quantité.

3. **Fonction `returnTotalAmount`** :
   - Cette fonction prend une liste de produits (foodItems) en entrée et retourne le montant total du panier sous forme de chaîne de caractères formatée.

4. **Classe `BottomBar`** :
   - Cette classe représente la barre inférieure de l'écran du panier.
   - Elle affiche le montant total du panier et un bouton "Continue" pour passer à l'étape suivante.
   - La méthode `updateTotalAmount` est appelée lors de l'initialisation pour mettre à jour le montant total. FAUT FIXER et ajouter un setstate pour que la mise a jour se fait au moment ou j'ajoute de la quantité a voir 

5. **Classe `CartBody`** :
   - Cette classe représente le corps de l'écran du panier.
   - Elle affiche la liste des éléments du panier ou un message si le panier est vide.

7. **Méthode `noItemContainer`** :
   - Cette méthode retourne un conteneur avec un message indiquant qu'il n'y a plus d'articles dans le panier.

8. **Méthode `foodItemList`** :
   - Cette méthode retourne une liste déroulante des éléments du panier à l'aide de `ListView.builder`.

9. **Classe `CartListItem`** :
   - Cette classe représente un élément individuel de la liste du panier.
   - Elle est créée comme élément draggable pouvant être glissé dans le panier.

10. **Classe `DraggableChild`** :
    - Cette classe représente le contenu d'un élément draggable du panier.

11. **Classe `DraggableChildFeedback`** :
    - Cette classe représente le retour visuel lorsqu'un élément est en cours de glissement dans le panier.
    - Elle utilise le modèle Bloc pour gérer la couleur de fond.

12. **Classe `ItemContent`** :
    - Cette classe représente le contenu d'un élément du panier, y compris l'image, le nom et le prix. Il faut ajouter la qauntite ici 

13. **Classe `CustomAppBar`** :
    - Cette classe représente la barre d'applications personnalisée avec un bouton de retour.

Pour le fichier cartlistBloc : 
1. Cette classe est responsable de la gestion des données du panier à l'aide du modèle Bloc.
2. Elle a un contrôleur _listController qui émet une liste d'objets de type Food.
3. La classe utilise également la classe CartProvider pour effectuer des opérations sur la liste des articles du panier.
4. La méthode addToList est utilisée pour ajouter un aliment au panier en utilisant le fournisseur CartProvider.
5. La méthode removeFromList est utilisée pour supprimer un aliment du panier en utilisant le fournisseur CartProvider.
6. La classe implémente BlocBase et dispose automatiquement du contrôleur _listController lorsqu'elle n'est plus nécessaire.

Pour Classe CartProvider :

1. Cette classe est responsable de la gestion de la liste des articles du panier.
2. Elle contient une liste foodItems qui stocke les objets Food ajoutés au panier.
3. La méthode addToList est utilisée pour ajouter un aliment à la liste.
Elle vérifie d'abord si l'aliment est déjà présent dans la liste en comparant les identifiants.
4. Si l'aliment est déjà présent, sa quantité est augmentée.
Sinon, l'aliment est ajouté à la liste.
5. La méthode removeFromList est utilisée pour supprimer un aliment de la liste.
6. Si la quantité de l'aliment est supérieure à 1, la quantité est décrémentée.
Sinon, l'aliment est complètement supprimé de la liste.
Les méthodes increaseItemQuantity et decreaseItemQuantity sont utilisées pour augmenter et diminuer la quantité d'un aliment respectivement.