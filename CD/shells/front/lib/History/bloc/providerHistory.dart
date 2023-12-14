import 'package:flutter_ui_food_delivery_app/model/Command.dart';

class HistoryProvider {
  List<Command> commandItems = [];

  List<Command> addToList(Command commandItem) {
    bool isPresent = false;

    if (commandItems.length > 0) {
      for (int i = 0; i < commandItems.length; i++) {
        if (commandItems[i].idCommand == commandItem.idCommand) {
          isPresent = true;
          break;
        } else {
          isPresent = false;
        }
      }

      if (!isPresent) {
        commandItems.add(commandItem);
      }
    } else {
      commandItems.add(commandItem);
    }

    return commandItems;
  }

  List<Command> removeFromList(Command commandItem) {
    commandItems.remove(commandItem);
    return commandItems;
  }
}
