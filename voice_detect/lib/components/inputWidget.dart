import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  final Key formKey;

  InputWidget(this.title, this.textEditingController, this.formKey);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: EdgeInsets.only(right: 100, bottom: 30),
        child: Container(
          width: MediaQuery.of(context).size.width - 100,
          child: Material(
            elevation: 10,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
              child: TextFormField(
                controller: textEditingController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.length == 0) {
                    return 'Please Enter $title';
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: title,
                    hintStyle: TextStyle(color: Colors.black87, fontSize: 16)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
