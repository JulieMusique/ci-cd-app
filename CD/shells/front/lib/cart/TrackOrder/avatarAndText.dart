import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/home/main_screen.dart';
import 'package:flutter_ui_food_delivery_app/model/User.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';
import 'package:flutter_ui_food_delivery_app/widgets/custom_button.dart';
import 'package:lottie/lottie.dart';

class AvatarAndText extends StatefulWidget {
  User user;
  AvatarAndText({Key? key, required this.user}) : super(key: key);

  _AvatarAndTextState createState() => _AvatarAndTextState();
}

class _AvatarAndTextState extends State<AvatarAndText>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  final textOne = "Your order is being prepared";

  final imageOne = Lottie.asset(
    '/anim/onTheWay.json',
    fit: BoxFit.contain,
    height: 350,
    width: 400,
  );
  final textTwo = "Your order is on the Way";
  final imageTwo = Lottie.asset(
    '/anim/Preparing.json',
    fit: BoxFit.contain,
    height: 300,
    width: 300,
  );
  final imageThree = Lottie.asset(
    '/anim/TimeToPickUporder.json',
    fit: BoxFit.contain,
    height: 300,
    width: 300,
  );
  final textThree = "Your order is ready to pick up";
  LottieBuilder actualImage = Lottie.asset(
    '/anim/Preparing.json',
    fit: BoxFit.contain,
    height: 350,
    width: 350,
  );
  var actualText = "";

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(milliseconds: 8800),
      vsync: this,
    );
    animationController.forward();
    animationController.addListener(() {
      if (animationController.value < 0.450) {
        setState(() {
          actualImage = imageOne;
          actualText = textOne;
        });
      } else if (animationController.value >= 0.450 &&
          animationController.value < 0.900) {
        setState(() {
          actualImage = imageTwo;
          actualText = textTwo;
        });
      } else if (animationController.value >= 0.900 &&
          animationController.value <= 1.0) {
        setState(() {
          actualImage = imageThree;
          actualText = textThree;
        });
      } else {}
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AvatarAnimation(
      controller: animationController,
      image: actualImage,
      text: actualText,
      user: widget.user,
    );
  }
}

class AvatarAnimation extends StatelessWidget {
  AvatarAnimation(
      {Key? key,
      required this.controller,
      required this.image,
      required this.text,
      required this.user})
      : super(key: key);

  final AnimationController controller;
  final LottieBuilder image;
  final String text;
  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        image,
        SizedBox(height: 30),
        Text(
          text,
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w600),
        ),
        AppButton(
            bgColor: vermilion,
            text: 'home',
            textColor: Colors.white,
            borderRadius: 30,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => MainScreen(onTap: () {}, user: user)),
              );
            }),
      ],
    );
  }
}
