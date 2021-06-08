import 'package:flutter/material.dart';
import 'package:voice_detect/services/clients.dart';

class SelectClient extends StatefulWidget {
  static final routeName = 'select-client';
  @override
  _SelectClientState createState() => _SelectClientState();
}

class _SelectClientState extends State<SelectClient> {
  bool loading = true;
  List clients;

  void fetchClients() async {
    clients = await Clients().fetchClients();
    setState(() {
      loading = false;
    });
  }

  void initState() {
    super.initState();
    fetchClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Client',
        ),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Client',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: 2),
                )
              ],
            ),
    );
  }
}
