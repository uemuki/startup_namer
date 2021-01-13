import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

// Avoid errors caused by flutter upgrade.
import 'package:flutter/widgets.dart';

import '../model/dog.dart';

class DemoDB {
  Future<Database> database;

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    database = openDatabase(
      // 设置数据库的路径。注意：使用 `path` 包中的 `join` 方法是
      // 确保在多平台上路径都正确的最佳实践。
      // 数据库名称 doggie_database
      join(await getDatabasesPath(), 'doggie_database.db'),
      // 当数据库第一次被创建的时候，创建一个数据表，用以存储狗狗们的数据。
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
      },
      // 设置版本。它将执行 onCreate 方法，同时提供数据库升级和降级的路径。
      version: 1,
    );
  }

  /// 增
  Future<void> insertDog(Dog dog) async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // 在正确的数据表里插入狗狗的数据。我们也要在这个操作中指定 `conflictAlgorithm` 策略。
    // 如果同样的狗狗数据被多次插入，后一次插入的数据将会覆盖之前的数据。
    await db.insert(
      'dogs',
      dog.toMap(),
      // 冲突算法
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /**
   * 查
   */
  Future<List<Dog>> dogs() async {
    // Get a reference to the database (获得数据库引用)
    final Database db = await database;
    // Query the table for all The Dogs (查询数据表，获取所有的狗狗们)
    final List<Map<String, dynamic>> maps = await db.query('dogs');
    // (将 List<Map<String, dynamic> 转换成 List<Dog> 数据类型)
    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database (获得数据库引用)
    final db = await database;
    // 修改给定的狗狗的数据
    await db.update(
      'dogs',
      dog.toMap(),
      // 确定给定的狗狗id是否匹配
      where: "id = ?",
      // 通过 whereArg 传递狗狗的 id 可以防止 SQL 注入
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    // Get a reference to the database (获得数据库引用)
    final db = await database;
    // Remove the Dog from the database (将狗狗从数据库移除)
    await db.delete(
      'dogs',
      // Use a `where` clause to delete a specific dog (使用 `where` 语句删除指定的狗狗)
      where: "id = ?",
      // 通过 `whereArg` 将狗狗的 id 传递给 `delete` 方法，以防止 SQL 注入
      whereArgs: [id],
    );
  }
}
