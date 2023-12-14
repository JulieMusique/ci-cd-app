import 'package:flutter/material.dart';

double w(BuildContext context) => MediaQuery.of(context).size.width;
double h(BuildContext context) => MediaQuery.of(context).size.height;
 final  List<String> listItems = <String>[
       "1 Cité Scientifique, 59650 Villeneuve-d'Ascq, France",
  "12 Rue Albert Einstein, 59650 Villeneuve-d'Ascq, France",
  "6 Rue Paul Langevin, 59650 Villeneuve-d'Ascq, France",
      "123 Rue de la République, Lille, France",
  "456 Avenue des Géants, Lille, France",
  "789 Boulevard de la Liberté, Lille, France",
  "10 Place du Théâtre, Lille, France",
  "543 Rue de la Vieille Comédie, Lille, France",
  "321 Avenue de la Porte d'Arras, Lille, France",
    '1 Place Charles de Gaulle, Lille, France',
  'Rue de la Monnaie, Lille, France',
  '5 Rue du Molinel, Lille, France',
  'Gare de Lille-Flandres, Lille, France',
  'Grand Place, Lille, France',
 "15 Avenue de l'Opéra, 59000 Lille",
 '123 Rue de la République, Lille, France',
  '456 Boulevard de la Liberté, Lille, France',
  '789 Avenue des Géants, Lille, France',
  '10 Rue de Flandre, Lille, France',

  '1 Avenue des Champs-Élysées, Paris, France',
  '2 Rue de la Paix, Paris, France',
  '3 Place de la Bastille, Paris, France',
  '4 Boulevard Saint-Germain, Paris, France',

  '21 Quai de la Citadelle, Dunkerque, France',
  '22 Rue des Bains, Dunkerque, France',
  '23 Avenue de la Mer, Dunkerque, France',
  '24 Rue de la Digue, Dunkerque, France',
  '31 Place du 73ème Régiment d’Infanterie, Béthune, France',
  '32 Rue de la Gare, Béthune, France',
  '33 Boulevard Kitchener, Béthune, France',
  '34 Avenue des Fusillés, Béthune, France',
'25 Rue de la Liberté, Lyon',
  '5 Place de la Bourse, Bordeaux',
  '15 Quai Rambaud, Marseille',
  '40 Rue du Faubourg Saint-Antoine, Paris',
  '18 Place de la Concorde, Paris',
  '41 Place Aristide Briand, Cambrai, France',
  '42 Rue Saint-Georges, Cambrai, France',
  '43 Avenue de Valenciennes, Cambrai, France',
  '44 Boulevard Paul Bezin, Cambrai, France',
  '51 Quai de la Loire, Calais, France',
  '52 Rue Royale, Calais, France',
  '53 Place d''Armes, Calais, France',
  '54 Boulevard Jacquard, Calais, France',

  '61 GrandPlace, Arras, France',
  '62 Rue de la Taillerie, Arras, France',
  '63 Boulevard Carnot, Arras, France',
  '64 Avenue Winston Churchill, Arras, France',
  "876 Rue du Molinel, Lille, France",
  "1 Quai du Wault, Lille, France",
  "234 Rue Nationale, Lille, France",
  "567 Rue Solférino, Lille, France",
  "890 Rue Gambetta, Lille, France",
  "987 Rue Léon Gambetta, Lille, France",
    ];
double ww(BuildContext context, double w) =>
    (MediaQuery.of(context).size.width * w) / 375;
double hh(BuildContext context, double h) =>
    (MediaQuery.of(context).size.height * h) / 812;

double w20(BuildContext context) => ww(context, 20);

Padding horizontalpadding(BuildContext context, {required Widget child}) =>
    Padding(
      padding: EdgeInsets.symmetric(horizontal: w20(context)),
      child: child,
    );
