import 'package:english_words/english_words.dart';
import 'package:sqflite/sqflite.dart';
import 'helper.dart';

class FavoriteRepository {
  Future<Database> get _db async => DatabaseHelper.instance.database;

  Future<List<WordPair>> getAll() async {
    final db = await _db;
    final result = await db.query('favorites');

    return result.map((row) {
      return WordPair(
        row['first'] as String,
        row['second'] as String,
      );
    }).toList();
  }

  Future<void> insert(WordPair pair) async {
    final db = await _db;
    await db.insert(
      'favorites',
      {
        'first': pair.first,
        'second': pair.second,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<void> delete(WordPair pair) async {
    final db = await _db;
    await db.delete(
      'favorites',
      where: 'first = ? AND second = ?',
      whereArgs: [pair.first, pair.second],
    );
  }
}
