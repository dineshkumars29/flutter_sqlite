import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlight/model/dish.dart';

class DbHelper {
  Database? _db;

  initDb() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    Database database =
        await openDatabase(path, version: 1, onCreate: onCreate);
    return database;
  }

  onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE Dishes(name TEXT,description TEXT,price DOUBLE)");
  }

  Future<Database?> get db async {
    // ignore: unnecessary_null_comparison
    if (_db == null) {
      _db = await initDb();
      return _db;
    } else {
      return _db;
    }
  }

  Future<int> createDishData(Dish dish) async {
    var dbReady = await db;
    if (kDebugMode) {
      print("created");
    }
    return dbReady!.rawInsert(
        'INSERT INTO Dishes(name, description, price) VALUES("${dish.name}","${dish.description}","${dish.price}")');
    //  "INSERT INTO DISHES(name,discription,price) VALUES ('${dish.name}', '${dish.discription}', '${dish.price}')");
  }

  Future<int> updateDishData(Dish dish) async {
    var dbReady = await db;
    return await dbReady!.rawUpdate(
        "UPDATE Dishes SET description = '${dish.description}', price = '${dish.price}' WHERE name = '${dish.name}'");
  }

  Future<int> deleteDishData(String? name) async {
    var dbReady = await db;
    return await dbReady!.rawInsert("DELETE FROM Dishes WHERE name = '$name'");
  }

  Future<Dish> readDishData(String? name) async {
    var dbReady = await db;
    var readProperty =
        await dbReady?.rawQuery("SELECT * FROM Dishes WHERE name = '$name'");
    if (kDebugMode) {
      print(readProperty.runtimeType);
      print(dbReady
          ?.rawQuery("SELECT * FROM Dishes WHERE name = '$name'")
          .runtimeType);
      print(readProperty?[0]);
    }
    return Dish.fromMap(readProperty![0]);
  }

  Future<List<Dish>> getAllDatasFromSql() async {
    var dbReady = await db;
    List<Map> list = await dbReady!.rawQuery("SELECT * FROM Dishes");
    // List<Dish> dishes = List() as List<Dish>;
    List<Dish> dishes = [];
    for (var i = 0; i < list.length; i++) {
      dishes
          .add(Dish(list[i]["name"], list[i]["description"], list[i]["price"]));
    }
    return dishes;
  }
}
