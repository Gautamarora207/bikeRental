import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_detect/screens/login.dart';
import 'package:voice_detect/services/auth.dart';

class SelectUser extends StatefulWidget {
  static const routeName = 'select-user/';

  @override
  _SelectUserState createState() => _SelectUserState();
}

class _SelectUserState extends State<SelectUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60,
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Positioned(
                        right: MediaQuery.of(context).size.width * 0.5 - 40,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getUserCard(
                  Icons.person,
                  'Client',
                ),
                getUserCard(
                  Icons.person,
                  'Master',
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getUserCard(
    IconData iconData,
    String title,
  ) {
    List<Widget> children = [
      Icon(
        iconData,
        size: 60,
        color: Theme.of(context).primaryColor,
      ),
      MediaQuery.of(context).orientation == Orientation.portrait
          ? SizedBox(
              height: 20,
            )
          : SizedBox(
              width: 20,
            ),
      Text(
        title,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];
    return InkWell(
      onTap: () {
        Provider.of<Auth>(context, listen: false).userType =
            title.toUpperCase();
        Navigator.of(context).pushNamed(Login.routeName);
      },
      child: Container(
        constraints: BoxConstraints(maxHeight: 150, maxWidth: 300),
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: MediaQuery.of(context).orientation == Orientation.portrait
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
      ),
    );
  }
}
