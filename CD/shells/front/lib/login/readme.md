# Explication des classes et fichiers du dossier login
## Classe `OnboardScreen`

- Cette classe représente l'écran de bienvenue de l'application.

### Méthode `build`

- Le widget `Scaffold` est utilisé pour créer la structure de base de la page.
- Il affiche une animation Lottie de bienvenue et un bouton "Get Food" pour passer à l'écran de connexion. 
## Classe `LoginScreen`

- Cette classe représente l'écran de connexion de l'application.
- Elle utilise un onglet `DefaultTabController` avec deux onglets : "Login" et "Sign-Up".
- La classe utilise également une animation Lottie pour ajouter de l'attrait visuel à l'écran.

### Méthode `build`

- Le widget `Scaffold` est utilisé pour créer la structure de base de la page.
- L'interface utilisateur est divisée en deux parties : une partie supérieure avec une animation Lottie et une partie inférieure avec des onglets.
- Un onglet "LoginInputScreen" est affiché par défaut.

## Classe `LoginInputScreen`

- Cette classe représente l'écran de saisie des informations de connexion (nom d'utilisateur et mot de passe).

### Méthode `build`

- Le widget `Scaffold` est utilisé pour créer la structure de base de la page.
- Il contient un formulaire de connexion avec des champs de saisie pour l'e-mail et le mot de passe.
- Un bouton de connexion est affiché en bas de la page.

## Classe `SignUpInputScreen`

- Cette classe représente l'écran de saisie des informations d'inscription (nom, e-mail, mot de passe).

### Méthode `build`

- Le widget `Scaffold` est utilisé pour créer la structure de base de la page.
- Il contient un formulaire d'inscription avec des champs de saisie pour le nom, l'e-mail et le mot de passe.
- Un bouton "SignUp" est affiché en bas de la page.

## Classe `ProfileScreen`

- Cette classe représente l'écran de profil de l'utilisateur.

### Méthode `build`

- Le widget `Scaffold` est utilisé pour créer la structure de base de la page.
- Il affiche le profil de l'utilisateur, y compris une image de profil, le nom, l'e-mail, le numéro de téléphone, l'adresse et un champ de mot de passe.
- Un bouton "Save" est affiché en bas de la page pour enregistrer les modifications du profil.

## Classe `CustomFormInput`

- Cette classe est utilisée pour créer des champs de saisie personnalisés avec une forme de stade et une couleur de fond spécifiques.

### Méthode `build`

- Elle crée un champ de saisie avec une forme de stade personnalisée et une couleur de fond.


