import 'package:flutter/material.dart';
import 'package:voice_detect/constants/urlConstants.dart';
import 'package:voice_detect/core/databaseService.dart';

class Clients with ChangeNotifier {
  Future fetchClients() async {
    Map response = await DatabaseService().readData(clientUsers);
    List clients = response.values.toList();
    return clients;
  }
}
