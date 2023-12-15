import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/home/home_screen.dart';
import 'package:flutter_ui_food_delivery_app/model/User.dart';
import 'package:flutter_ui_food_delivery_app/utils/routes.dart';
import 'avatarAndText.dart';
import 'timer.dart';
import 'util.dart';

class TrackingScreen extends StatefulWidget {
  final User user;

  TrackingScreen({required this.user});

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTweenone;
  late Animation<Color?> _colorTweentwo;
  late Animation<Color?> _colorTweenthree;

  final dotSize = 20.0;
  final timerDuration = Duration(milliseconds: 2500);

  late Animation<TextStyle> textOneStyle;
  late Animation<double> progressBarOne;
  late Animation<TextStyle> textTwoStyle;
  late Animation<double> progressBarTwo;
  late Animation<TextStyle> textThreeStyle;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: Duration(milliseconds: 8800),
      vsync: this,
    );

    _colorTweenone = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.000,
          0.100,
          curve: Curves.linear,
        ),
      ),
    );
    _colorTweentwo = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.450,
          0.550,
          curve: Curves.linear,
        ),
      ),
    );
    _colorTweenthree = ColorTween(begin: Colors.blue, end: Colors.red).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.900,
          1.000,
          curve: Curves.linear,
        ),
      ),
    );
    textOneStyle = TextStyleTween(
      begin: TextStyle(
        fontWeight: FontWeight.w400,
        color: FoodColors.Grey,
        fontSize: 12,
      ),
      end: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        fontSize: 12,
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.000, 0.100, curve: Curves.linear),
      ),
    );

    progressBarOne = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.100, 0.450),
      ),
    );

    textTwoStyle = TextStyleTween(
      begin: TextStyle(
        fontWeight: FontWeight.w400,
        color: FoodColors.Grey,
        fontSize: 12,
      ),
      end: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        fontSize: 12,
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.450, 0.550, curve: Curves.linear),
      ),
    );

    progressBarTwo = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.550, 0.900),
      ),
    );

    textThreeStyle = TextStyleTween(
      begin: TextStyle(
        fontWeight: FontWeight.w400,
        color: FoodColors.Grey,
        fontSize: 12,
      ),
      end: TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.black87,
        fontSize: 12,
      ),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.900, 1.000, curve: Curves.linear),
      ),
    );

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: true,
              leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                  size: 40,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Timer(),
                    Center(
                      child: AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          textOneStyle = TextStyleTween(
                            begin: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: FoodColors.Grey,
                                fontSize: 12),
                            end: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 12),
                          ).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                0.000,
                                0.100,
                                curve: Curves.linear,
                              ),
                            ),
                          );

                          progressBarOne = Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(0.100, 0.450),
                            ),
                          );

                          textTwoStyle = TextStyleTween(
                            begin: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: FoodColors.Grey,
                                fontSize: 12),
                            end: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 12),
                          ).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                0.450,
                                0.550,
                                curve: Curves.linear,
                              ),
                            ),
                          );
                          progressBarTwo = Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(0.550, 0.900),
                            ),
                          );

                          textThreeStyle = TextStyleTween(
                            begin: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: FoodColors.Grey,
                                fontSize: 12),
                            end: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                fontSize: 12),
                          ).animate(
                            CurvedAnimation(
                              parent: _controller,
                              curve: Interval(
                                0.900,
                                1.000,
                                curve: Curves.linear,
                              ),
                            ),
                          );
                          return Container(
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (BuildContext context, Widget? child) =>
                                  Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1.3,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        // Text('${(controller.value * 100.0).toStringAsFixed(1)}%'),
                                        Container(
                                          width: dotSize,
                                          height: dotSize,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      dotSize / 2),
                                              color: _colorTweenone.value),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 2,
                                            child: LinearProgressIndicator(
                                              backgroundColor: FoodColors.Grey,
                                              value: progressBarOne.value,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      FoodColors.Yellow),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: dotSize,
                                          height: dotSize,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      dotSize / 2),
                                              color: _colorTweentwo.value),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          flex: 1,
                                          child: Container(
                                            height: 2,
                                            child: LinearProgressIndicator(
                                              backgroundColor: FoodColors.Grey,
                                              value: progressBarTwo.value,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      FoodColors.Yellow),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: dotSize,
                                          height: dotSize,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      dotSize / 2),
                                              color: _colorTweenthree.value),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 5),
                                    width:
                                        MediaQuery.of(context).size.width / 1.2,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        //Order Status
                                        Text(
                                          'Preparing',
                                          style: textOneStyle.value,
                                        ),
                                        Text(
                                          'On the way',
                                          style: textTwoStyle.value,
                                        ),
                                        Text(
                                          'Ready',
                                          style: textThreeStyle.value,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 50),
                    AvatarAndText(user: widget.user),
                    SizedBox(height: 50),
                  ]),
            )));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
