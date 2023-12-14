import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/home/home_screen.dart';
import 'package:flutter_ui_food_delivery_app/home/main_screen.dart';
import 'package:flutter_ui_food_delivery_app/model/User.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_button.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_input.dart';
import 'package:http/http.dart' as http;
import '../../utils/colors.dart';
import '../../utils/helper.dart';

class ProfileScreen extends StatefulWidget {
  User user;

  ProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isPasswordEnabled = false;

  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  void enablePasswordField() {
    if (!isPasswordEnabled) {
      setState(() {
        isPasswordEnabled = true;
        print(isPasswordEnabled);
      });
    }
  }

  bool isPasswordValid(String password) {
    // Utilisation d'une expression régulière pour valider le mot de passe
    final passwordRegex =
        RegExp(r'^(?=.*[A-Z])(?=.*\d)(?!.*[&%$#@!])[A-Za-z\d&%$#@!]{8,12}$');
    return passwordRegex.hasMatch(password);
  }

  Future<void> saveUser() async {
    if (isPasswordEnabled) {
      final password = passwordController.text;
      if (!isPasswordValid(password)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Le mot de passe n\'est pas valide. Le nombre de caractères doit être compris entre 8 et 12 avec une lettre maj minimum.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      widget.user.password = password;
      int? id = widget.user.id;
      final response = await http.put(Uri.parse(
          'http://localhost:8080/DelivCROUS/users/updatePassword/$id/$password'));
      if (response.statusCode == 204) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: widget.user),
          ),
        );
      } else {
        // Gestion d'autres erreurs
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la modification du mot de passe.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'), // Titre de la page de profil
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.green, // Icône de retour
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(
                          onTap: () {},
                          user: widget.user,
                        )));
          }, // Retour à la page précédente
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: Helper.getScreenHeight(context),
              width: Helper.getScreenWidth(context),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      // Image de profil avec l'option de la caméra
                      ClipOval(
                        child: Stack(
                          children: [
                            Container(
                              height: 80,
                              width: 80,
                              child: Image.asset(
                                Helper.getAssetName(
                                  "man.jpeg",
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                height: 20,
                                width: 80,
                                color: Colors.black.withOpacity(0.3),
                                child: Image.asset(
                                    Helper.getAssetName("camera.png")),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      // Champ de formulaire personnalisé pour le nom
                      CustomFormInput(
                        label: "First name",
                        value: widget.user.firstName,
                        enabled: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomFormInput(
                        label: "Last name",
                        value: widget.user.lastName,
                        enabled: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Champ de formulaire personnalisé pour l'e-mail
                      CustomFormInput(
                        label: "Email",
                        value: widget.user.email,
                        enabled: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Champ de formulaire personnalisé pour le numéro de téléphone mobile
                      CustomFormInput(
                        label: "Mobile No",
                        value: widget.user.phone ?? 'Non renseigné',
                        enabled: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Champ de formulaire personnalisé pour l'adresse
                      CustomFormInput(
                        label: "Address",
                        value: widget.user.address ?? 'Non renseigné',
                        enabled: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Champ de formulaire personnalisé pour le mot de passe
                      CustomFormInput(
                        label: "Password",
                        value: '',
                        isPassword: true,
                        enabled: false,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        child: AppInputText(
                          controller: passwordController,
                          hint: "New password",
                          obscureText: true,
                        ),
                        visible: isPasswordEnabled,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          enablePasswordField();
                        },
                        child: Text("Modifier le mot de passe"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Bouton "Save" pour enregistrer les modifications du profil
                      AppButton(
                        bgColor: vermilion,
                        borderRadius: 30,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        onTap: () async {
                          saveUser();
                        },
                        text: "Save",
                        textColor: athens_gray,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomFormInput extends StatelessWidget {
  const CustomFormInput({
    Key? key,
    required String label,
    required String value,
    bool isPassword = false,
    bool enabled = true,
  })  : _label = label,
        _value = value,
        _isPassword = isPassword,
        _enabled = enabled,
        super(key: key);

  final String _label;
  final String _value;
  final bool _isPassword;
  final bool _enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 40),
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.placeholderBg, // Couleur de fond du champ de formulaire
      ),
      child: TextFormField(
        enabled: _enabled,
        onTap: () {
          if (!_enabled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Merci de passer par le service client pour modifier cette donnée"),
              ),
            );
          }
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: _label, // Libellé du champ de formulaire
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
        obscureText:
            _isPassword, // Cache le texte si c'est un champ de mot de passe
        initialValue: _value, // Valeur initiale du champ de formulaire
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
