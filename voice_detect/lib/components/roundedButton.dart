import 'package:flutter/material.dart';

Widget roundedRectButton(
    String title, BuildContext context, Function function) {
  return Builder(builder: (BuildContext mContext) {
    return InkWell(
      onTap: function,
      child: Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(mContext).size.width / 2,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            color: Theme.of(context).primaryColor,
          ),
          child: Text(title,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          padding: EdgeInsets.only(top: 16, bottom: 16),
        ),
      ),
    );
  });
}
