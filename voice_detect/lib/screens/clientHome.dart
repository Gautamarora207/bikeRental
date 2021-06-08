import 'package:flutter/material.dart';
import 'package:voice_detect/screens/selectUserType.dart';
import 'package:voice_detect/services/auth.dart';

class ClientHomeScreen extends StatelessWidget {
  static const routeName = 'client-home/';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await Auth().logout();
                Navigator.of(context).pushReplacementNamed(
                  SelectUser.routeName,
                );
              }),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text(
            'Client',
          ),
        ),
      ),
    );
  }
}
