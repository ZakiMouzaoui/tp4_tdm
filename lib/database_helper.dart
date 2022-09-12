import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tp4_tdm/main.dart';

/*
class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;
  static const table = 'tweets';
  static const id = 'id';
  static const tweet = 'tweet';
  static const author = 'author';
  static const date = 'date';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $id INTEGER PRIMARY KEY,
        $tweet TEXT NOT NULL,
        $author VARCHAR NOT NULL,
        $date DATE
      )
    ''');
  }
  // Helper methods
  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int?> insert(Map<String, dynamic> row) async {
    Database? db = await instance.database;
    return await db?.insert(table, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>?> getTweets() async {
    Database? db = await instance.database;
    return await db?.query(table);
  }
}
 */

class DatabaseHelper{
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tweets.db");

    return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tweets (
        id INTEGER PRIMARY KEY,
        tweet TEXT NOT NULL,
        author VARCHAR NOT NULL,
        date TEXT
      )
    ''');
  }

  Future<List<TweetModel>> getTweets() async {
    Database? db = await instance.database;
    var tweets = await db.query("tweets");
    List<TweetModel> tweetsList = tweets.isNotEmpty ? tweets.map((tweet) =>
        TweetModel.fromMap(tweet)).toList() : [];

    return tweetsList;
  }

  Future<int> add(TweetModel tweetModel) async {
    Database db = await instance.database;
    return await db.insert("tweets", tweetModel.toMap());
  }
}
