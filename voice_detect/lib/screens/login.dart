import 'package:flutter/material.dart';
import 'package:voice_detect/constants/constants.dart';
import 'package:voice_detect/services/auth.dart';
import 'package:voice_detect/components/inputWidget.dart';
import 'package:voice_detect/components/roundedButton.dart';
import 'package:country_code_picker/country_code_picker.dart';

class Login extends StatefulWidget {
  static const routeName = 'login/';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String countryDialCode = '+91';
  TextEditingController phoneController;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  void initState() {
    phoneController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(100),
                ),
              ),
              child: Hero(
                tag: 'login-header',
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 60,
                    child: Icon(
                      Icons.lock,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            SizedBox(
              height: 40,
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //       top: MediaQuery.of(context).size.height / 2.3),
            // ),
            Padding(
              padding: EdgeInsets.only(
                left: 40,
                bottom: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 24,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                      width: 50,
                      child: Divider(
                        height: 20,
                        color: color,
                      )),
                  Container(
                    width: 200,
                    child: CountryCodePicker(
                      showDropDownButton: true,
                      padding: EdgeInsets.zero,
                      onChanged: (value) {
                        setState(() {
                          countryDialCode = value.dialCode;
                        });
                      },
                      initialSelection: 'IN',
                      alignLeft: true,
                    ),
                  ),
                ],
              ),
            ),
            Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                InputWidget(
                  'Mobile Number',
                  phoneController,
                  _formKey,
                ),
                Padding(
                    padding: EdgeInsets.only(right: 50),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 40,
                            ),
                            child: Text(
                              'Enter your mobile number to continue...',
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 50),
            ),
            roundedRectButton("Send OTP", context, () async {
              if (_formKey.currentState.validate()) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return loadingDialog('Sending OTP...');
                    });
                bool success = await Auth().logInPhone(
                    countryDialCode + phoneController.text, context);
                if (!success) {
                  Navigator.of(context).pop();
                }
              }
            })
          ],
        ),
      ),
    );
  }
}
