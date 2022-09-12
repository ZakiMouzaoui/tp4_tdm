import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';


class TwitterDetail extends StatelessWidget {
  const TwitterDetail({Key? key, required this.author, required this.tweet, required this.date}) : super(key: key);
  final String author;
  final String tweet;
  final String date;

  void speak() async{
    FlutterTts flutterTts = FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(0.5);
    await flutterTts.speak(tweet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Details"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const CircleAvatar(
              radius: 150,
                backgroundImage: AssetImage("purple-wallpaper-background.jpg")
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              author,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              tweet,
              style: const TextStyle(
                  fontSize: 20
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              date,
              style: const TextStyle(
                fontSize: 20
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(onPressed: (){speak();},
              //child: const Text("Ecouter ce tweet"),
              icon: const Icon(Icons.volume_up_rounded),
              label: const Text("Ecouter ce tweet"),
            ),
          ],
        ),
      ),
    );
  }
}
