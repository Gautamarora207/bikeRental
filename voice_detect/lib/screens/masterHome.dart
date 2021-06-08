import 'package:flutter/material.dart';
import 'package:voice_detect/screens/selectUserType.dart';
import 'package:voice_detect/screens/settingScreen.dart';
import 'package:voice_detect/services/auth.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:voice_detect/core/databaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voice_detect/constants/urlConstants.dart';

class MasterHomeScreen extends StatefulWidget {
  static const routeName = 'master-home/';

  @override
  _MasterHomeScreenState createState() => _MasterHomeScreenState();
}

class _MasterHomeScreenState extends State<MasterHomeScreen> {
  bool callStarted = false;
  String name = 'Master Name';
  String imageUrl = '';
  bool loading = true;
  AudioPlayer player = AudioPlayer();
  AudioCache audioCache;
  String urlPlaying;
  bool isPlaying = false;
  List audios = List.generate(10, (i) {
    return "audio/" + i.toString() + '.mp3';
  });
  List audioOrder = List.generate(10, (i) {
    return i;
  });
  User user;

  void initState() {
    initAudio();
    reorderAudio();
    super.initState();
  }

  AudioPlayer audioPlayer = AudioPlayer();

  initAudio() {
    setState(() {
      audioCache = AudioCache(fixedPlayer: audioPlayer);
    });
    audioPlayer.onPlayerStateChanged.listen((playerState) {
      if (playerState == PlayerState.PLAYING) {
        setState(() {
          isPlaying = true;
        });
      } else {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  reorderAudio() async {
    user = await Auth().getUser();
    Map response = await DatabaseService().readData(
      '$masterUsers/${user.uid}',
    );
    print(response);
    if (response.containsKey('audioOrder')) {
      setState(() {
        audioOrder = response['audioOrder'];
      });
    }
    List reorderedAudio = List.generate(
      10,
      (index) => index,
    );
    for (int i = 0; i < audioOrder.length; i++) {
      reorderedAudio[i] = audios[audioOrder[i]];
    }
    setState(() {
      audios = reorderedAudio;
    });
  }

  playAudio(String url) async {
    if (!callStarted) {
      return;
    }
    setState(() {
      urlPlaying = url;
    });
    await audioCache.play(url);
  }

  pauseAudio() async {
    await audioPlayer.pause();
  }

  stopAudio() async {
    await audioPlayer.stop();
  }

  startCall() async {
    for (int i = 0; i < audios.length; i++) {
      if (!callStarted) {
        return;
      }
      if (i == 0) {
        await playAudio(audios[i]);
      } else {
        await Future.delayed(Duration(seconds: 5), () async {
          await playAudio(audios[i]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.settings,
          ),
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SettingScreen(),
              ),
            );
            // Navigator.of(context).pushNamed(
            //   SettingScreen.routeName,
            // );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await Auth().logout();
              Navigator.of(context).pushReplacementNamed(
                SelectUser.routeName,
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
              child: CircleAvatar(
                radius: 70,
                backgroundColor:
                    Theme.of(context).primaryColor.withOpacity(0.4),
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage(
                    'assets/images/profile_female.png',
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            FloatingActionButton.extended(
                backgroundColor: callStarted ? Colors.red : Colors.green,
                onPressed: () async {
                  setState(() {
                    callStarted = !callStarted;
                  });
                  !callStarted ? await stopAudio() : await startCall();
                },
                label: Row(
                  children: [
                    Icon(callStarted ? Icons.call_end : Icons.call),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      callStarted ? 'End' : 'Call',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
