import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:voice_detect/core/databaseService.dart';
import 'package:voice_detect/services/auth.dart';
import 'package:voice_detect/constants/urlConstants.dart';

class PlayAudio extends StatefulWidget {
  @override
  _PlayAudioState createState() => _PlayAudioState();
}

class _PlayAudioState extends State<PlayAudio> {
  // firebase_storage.Reference ref =
  //     firebase_storage.FirebaseStorage.instance.ref().child('audio/');
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

  seekAudio(Duration durationToSeek) async {
    await audioPlayer.seek(durationToSeek);
  }

  // void getData() async {
  //   firebase_storage.ListResult list = await ref.list();
  //   list.items.forEach((element) async {
  //     var url = await element.getDownloadURL();
  //     setState(() {
  //       audios.add(url);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Audio',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              physics: NeverScrollableScrollPhysics(),
              onReorder: (int i1, int i2) async {
                setState(() {
                  String temp = audios[i1];
                  int i = audioOrder[i1];
                  if (i2 > i1) {
                    audios[i1] = audios[i2 - 1];
                    audios[i2 - 1] = temp;
                    audioOrder[i1] = audioOrder[i2 - 1];
                    audioOrder[i2 - 1] = i;
                  } else {
                    audios[i1] = audios[i2];
                    audios[i2] = temp;
                    audioOrder[i1] = audioOrder[i2];
                    audioOrder[i2] = i;
                  }
                });
                await DatabaseService().updateData(
                    '$masterUsers/${user.uid}', {'audioOrder': audioOrder});
              },
              itemCount: audios.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  key: Key(audios[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: Text(
                        'Audio ${int.parse(audios[index].split('/')[1].split('.')[0]) + 1}',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      trailing: IconButton(
                        splashRadius: 25,
                        icon: Icon(
                          isPlaying && urlPlaying == audios[index]
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.black,
                        ),
                        onPressed: () async {
                          if (!isPlaying) {
                            await playAudio(audios[index]);
                          } else if (isPlaying && urlPlaying != audios[index]) {
                            await stopAudio();
                            await playAudio(audios[index]);
                          } else {
                            await stopAudio();
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
