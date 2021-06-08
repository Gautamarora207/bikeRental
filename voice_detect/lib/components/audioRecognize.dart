import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:voice_detect/constants/constants.dart';
import 'package:speech_recognition/speech_recognition.dart';

class AudioRecognize extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AudioRecognizeState();
}

class _AudioRecognizeState extends State<AudioRecognize> {
  SpeechRecognition _speechRecognition;
  bool _isAvailable = false;
  bool _isListening = false;
  String resultText = "";
  var language = LanguageLocal();
  TextEditingController _controller = TextEditingController();
  var langCodesList = ["ar", "en", "fr"];

  List<DropdownMenuItem<String>> languageList;

  String _selectedLanguage = "en";

  Future<void> initSpeechRecognizer() async {
    _speechRecognition = SpeechRecognition();

    _speechRecognition.setAvailabilityHandler(
      (bool result) => setState(() => _isAvailable = result),
    );

    _speechRecognition.setRecognitionStartedHandler(
      () => setState(() => _isListening = true),
    );

    _speechRecognition.setRecognitionResultHandler(
      (String speech) {
        _controller.text = speech;
        setState(() => resultText = speech);
      },
    );

    _speechRecognition.setRecognitionCompleteHandler(
      () => setState(() => _isListening = false),
    );

    await _speechRecognition.activate().then(
          (result) => setState(() => _isAvailable = result),
        );
  }

  @override
  void initState() {
    initSpeechRecognizer();
    _controller.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => () {
          setState(() {
            _selectedLanguage = Localizations.localeOf(context).languageCode;
          });
        });
    langCodesList = language.isoLangs.keys.toList();
    languageList = langCodesList.map((String value) {
      return DropdownMenuItem<String>(
        child: Text(language.getDisplayLanguage(value)["name"] +
            ' (${language.getDisplayLanguage(value)["nativeName"]})'),
        value: value,
      );
    }).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(8),
              child: SearchableDropdown.single(
                value: _selectedLanguage,
                items: languageList,
                displayClearIcon: false,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    _selectedLanguage = value;
                  });
                },
                displayItem: (item, selected) {
                  return (Row(
                    children: [
                      selected
                          ? Icon(
                              Icons.radio_button_checked,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.grey,
                            ),
                      SizedBox(width: 7),
                      Expanded(
                        child: item,
                      ),
                    ],
                  ));
                },
                isExpanded: true,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(
                  8,
                ),
                margin: EdgeInsets.all(
                  16,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: (_isAvailable && !_isListening)
                          ? () async {
                              await _speechRecognition
                                  .listen(locale: _selectedLanguage)
                                  .then((result) {
                                print('$result');
                              });
                            }
                          : () async {
                              if (_isListening)
                                await _speechRecognition.stop().then(
                                      (result) =>
                                          setState(() => _isListening = result),
                                    );
                            },
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 40,
                        child: Center(
                          child: Icon(
                            _isListening ? Icons.stop : Icons.mic,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Speak Now',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 70,
                      child: TextFormField(
                        maxLines: null,
                        controller: _controller,
                        decoration: InputDecoration(
                            hintText: 'Click and talk to display text'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
