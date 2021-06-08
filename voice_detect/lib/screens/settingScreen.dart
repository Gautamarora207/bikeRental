import 'package:flutter/material.dart';
import 'package:voice_detect/components/playAudio.dart';
import 'package:voice_detect/screens/selectClient.dart';
import 'package:voice_detect/components/audioRecognize.dart';
import 'package:voice_detect/components/pickSelectImage.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = 'master-settings/';
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  String selectedLanguage = 'English';

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(height: 400, child: AudioRecognize()),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(SelectClient.routeName);
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor: Theme.of(context).primaryColor,
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
              child: Text('Select Client'),
            ),
            SizedBox(
              height: 5,
            ),
            Text('Selected : Gautam'),
            SizedBox(
              height: 10,
            ),
            PickSelectImage(),
            Container(height: 900, child: PlayAudio()),
          ],
        ),
      ),
    );
  }
}
