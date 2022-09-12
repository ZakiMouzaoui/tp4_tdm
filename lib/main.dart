import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tp4_tdm/database_helper.dart';
import 'package:tp4_tdm/detail_page.dart';
import 'package:tp4_tdm/tweet.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(primarySwatch: Colors.purple),
    home: AnimatedSplashScreen(
      nextScreen: const MyApp(),
      splash: Image.asset("twitter_icon.png"),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var countries = [];
  TextEditingController tweetController = TextEditingController();
  final db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    void addItem(author, tweet){
      setState(() {
        countries.add(Tweet(author: author, tweet: tweet, date: DateTime.now().toString()));
      });

      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tweet ajouté"))
      );
    }

    void removeItem(index){
      setState(() {
        countries.removeAt(index);
      });

      ScaffoldMessenger.of(context).removeCurrentSnackBar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tweet supprimé"),
        )
      );
    }

    void showAddDialog(BuildContext context){
      showDialog(context: context, builder: (builder){
        return AlertDialog(
          title: const Text("Tweeter"),
          content: TextField(
            decoration: const InputDecoration(
              hintText: "Quoi de neuf ?"
            ),
            controller: tweetController,
          ),
          actions: [
            TextButton(onPressed: (){
              var tweet = tweetController.text;
              if(tweet.toString().trim().isNotEmpty){
                addItem("Mouzaoui Zakaria", tweetController.text.toString());
                tweetController.text = "";
                Navigator.of(context).pop("dialog");
              }
            },
            child: const Text("Tweeter"),)
          ],
        );
      });
    }

    void showRemoveDialog(BuildContext context, index){
      var alertDialog = AlertDialog(
        title: const Text("Suppression"),
        content: const Text("Vous confirmez la suppression?"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context, rootNavigator: true).pop('dialog');
          }, child: const Text("Annuler")),
          TextButton(onPressed: (){
            removeItem(index);
            Navigator.of(context, rootNavigator: true).pop('dialog');
          }, child: const Text("Oui")),
        ],
      );
      showDialog(context: context, builder: (builder){
        return alertDialog;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Twitter'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: GestureDetector(
              child: const Image(image: AssetImage("twitter_icon.png"),
              color: Colors.lightBlueAccent),
              onTap: (){
                showAddDialog(context);
              },
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
            shrinkWrap: true,
            itemCount: countries.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: ListTile(
                  title: const Text("Mouzaoui Zakaria",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.purple
                  ),),
                  subtitle: Text(countries[index].tweet,
                  style: const TextStyle(
                    color: Colors.black
                  ),),
                  leading: const CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage("purple-wallpaper-background.jpg")
                  ),
                  trailing: const Icon(
                    Icons.arrow_right
                  ),
                  onTap: (){
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return TwitterDetail(
                          author: "Mouzaoui Zakaria", tweet: countries[index].tweet, date: countries[index].date);
                    }));
                  },
                  onLongPress: (){
                    showRemoveDialog(context, index);
                    /*removeItem(index);*/
                  },
                ),
              );
            },
          ),
            ElevatedButton(onPressed: () async{
              final tweets = await db.getTweets();
              for (var tweet in tweets) {
                if (kDebugMode) {
                  print(tweet);
                }
              }
            }, child: const Text("Query all tweets"))
        ]
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async{
          await db.add(
              TweetModel(
                  tweet: "Hello world",
                  author: "Mouzaoui Zakaria",
                  date: DateTime.now().toString())
          );
          if (kDebugMode) {
            print("Tweet inserted");
          }

        },
      ),
    );
  }
}


class TweetModel{
  TweetModel({this.id, required this.tweet, required this.author,
    required this.date});

  int? id;
  String tweet;
  String author;
  String date;

  factory TweetModel.fromMap(Map<String, dynamic> json) => TweetModel(
    id: json["id"],
    tweet: json["tweet"],
    author: json["author"],
    date: json["date"]
  );

  Map<String, dynamic> toMap() => {
    "id" : id,
    "tweet": tweet,
    "author": author,
    "date": date
  };
}