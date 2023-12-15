import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_ui_food_delivery_app/History/bloc/providerHistory.dart';
import 'package:flutter_ui_food_delivery_app/model/Command.dart';
import 'package:rxdart/rxdart.dart';

class HistoryListBloc extends BlocBase {
  HistoryListBloc();

  var _listController = BehaviorSubject<List<Command>>.seeded([]);

  //provider class
  HistoryProvider provider = HistoryProvider();

  //output
  Stream<List<Command>> get listStream => _listController.stream;

  //input
  Sink<List<Command>> get listSink => _listController.sink;

  addToList(Command command) {
    listSink.add(provider.addToList(command));
  }

  removeFromList(Command command) {
    listSink.add(provider.removeFromList(command));
  }

  //Dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _listController.close();
    super.dispose();
  }
}
