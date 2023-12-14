import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_food_delivery_app/History/bloc/HistorylistBloc.dart';
import 'package:flutter_ui_food_delivery_app/home/main_screen.dart';
import 'package:flutter_ui_food_delivery_app/http/HttpServiceCart.dart';
import 'package:flutter_ui_food_delivery_app/model/Command.dart';
import 'package:flutter_ui_food_delivery_app/utils/colors.dart';
import 'package:flutter_ui_food_delivery_app/utils/style.dart';
import '../model/User.dart';
import 'bloc/listTileColorBloc.dart';

class HistoryScreen extends StatefulWidget {
  final User user;
  HistoryScreen({required this.user});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late HistoryListBloc bloc;
  Future<List<Command>>? commandItems = Future.value([]);

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.getBloc<HistoryListBloc>();
    fetchHistoryCommands(widget.user.id ?? 0).then((list) {
      if (list.isNotEmpty) {
        setState(() {
          print(list);
          commandItems = Future.value(list);
        });
      } else {
        setState(() {
          commandItems = Future.error("No data found");
        });
      }
    }).catchError((error) {
      setState(() {
        commandItems = Future.error(error);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Command>>(
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
                "History",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ),
            body: SafeArea(child: SafeArea(child: HistoryBody(commandItems))),
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

class HistoryBody extends StatelessWidget {
  Future<List<Command>>? commandItems;

  HistoryBody(this.commandItems);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Command>>(
      future: commandItems,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Chargement de la page
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return noItemContainer();
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // Affichage de la liste quand toutes les données sont récupérées
          return Container(
            padding: EdgeInsets.fromLTRB(20, 30, 15, 0),
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: commandItemList(snapshot.data!),
                )
              ],
            ),
          );
        } else {
          return noItemContainer();
        }
      },
    );
  }

  Container noItemContainer() {
    return Container(
      child: Center(
        child: Text(
          "No More Items Left In History",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              fontSize: 20),
        ),
      ),
    );
  }

  ListView commandItemList(List<Command> commandItems) {
    return ListView.builder(
      itemCount: commandItems.length,
      itemBuilder: (context, index) {
        return HistoryListItem(commandItem: commandItems[index]);
      },
    );
  }
}

class HistoryListItem extends StatelessWidget {
  final Command commandItem;

  HistoryListItem({required this.commandItem});

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable(
      hapticFeedbackOnStart: false,
      maxSimultaneousDrags: 1,
      data: commandItem,
      feedback: DraggableChildFeedback(commandItem: commandItem),
      child: DraggableChild(commandItem: commandItem),
      childWhenDragging: DraggableChild(commandItem: commandItem),
    );
  }
}

class DraggableChild extends StatelessWidget {
  const DraggableChild({
    Key? key,
    required this.commandItem,
  }) : super(key: key);

  final Command commandItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: ItemContent(
        commandItem: commandItem,
      ),
    );
  }
}

class DraggableChildFeedback extends StatelessWidget {
  const DraggableChildFeedback({
    Key? key,
    required this.commandItem,
  }) : super(key: key);

  final Command commandItem;

  @override
  Widget build(BuildContext context) {
    final ColorBloc colorBloc = BlocProvider.getBloc<ColorBloc>();

    return Opacity(
      opacity: 0.7,
      child: Material(
        child: StreamBuilder(
          stream: colorBloc.colorStream,
          builder: (context, snapshot) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: snapshot.data != null ? snapshot.data : Colors.white,
              ),
              child: ItemContent(commandItem: commandItem),
            );
          },
        ),
      ),
    );
  }
}

class ItemContent extends StatelessWidget {
  const ItemContent({
    Key? key,
    required this.commandItem,
  }) : super(key: key);

  final Command commandItem;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PrimaryText(
                    text: 'La commande du ${commandItem.orderDate}',
                    size: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  PrimaryText(
                    text: '\$${commandItem.totalAmount}',
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
    );
  }
}
