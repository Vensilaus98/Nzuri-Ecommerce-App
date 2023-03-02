import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product_model.dart';

class MyCartDatabase {
  static final MyCartDatabase instance = MyCartDatabase._init();

  static Database? _database;
  MyCartDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('productCart.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
            CREATE TABLE productcart (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            price TEXT,
            description TEXT,
            image TEXT,
            category TEXT,
            rate TEXT,
            count TEXT
          )
   ''');
  }

  //Get all cart products
  Future<List<Product>> getCartProducts() async {
    Database db = await instance.database;
    var cartProducts = await db.query('productcart', orderBy: 'id');

    List<Product> cartProductsList = cartProducts.isNotEmpty
        ? cartProducts.map((e) => Product.fromDatabaseJson(e)).toList()
        : [];
        
    return cartProductsList;
  }

  //Add product to cart
  Future<int> add(Product product) async {
    Database db = await instance.database;

    return await db.insert('productcart', product.toJson());
  }

  //Remove product from cart
  Future<int> delete(Product product) async {
    Database db = await instance.database;

    return await db
        .delete('productcart', where: 'id = ?', whereArgs: [product.id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
