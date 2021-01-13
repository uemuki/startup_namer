// import 'dart:async';

import '../model/dog.dart';
import './index.dart';

dbDemo() async {
  final db = new DemoDB();
  await db.init();

  var fido = Dog(
    id: 0,
    name: 'Fido',
    age: 35,
  );
  // Insert a dog into the database (在数据库插入一条狗狗的数据)
  await db.insertDog(fido);
  // Print the list of dogs (only Fido for now) [打印一个列表的狗狗们 (现在列表里只有一只叫 Fido 的狗狗)]
  print(await db.dogs());
  // Update Fido's age and save it to the database (修改数据库中 Fido 的年龄并且保存)
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await db.updateDog(fido);
  // Print Fido's updated information (打印 Fido 的修改后的信息)
  print(await db.dogs());
  // Delete Fido from the database (从数据库中删除 Fido)
  await db.deleteDog(fido.id);
  // Print the list of dogs (empty) [打印一个列表的狗狗们 (这里已经空了)]
  print(await db.dogs());
}
