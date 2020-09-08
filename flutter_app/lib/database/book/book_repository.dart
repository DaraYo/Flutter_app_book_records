import 'package:flutter_app/database/database_provider.dart';
import 'package:flutter_app/models/book.dart';

abstract class BookRepository {
  DBProvider databaseProvider;

  Future<int> insert(Book item);

  Future<int> update(Book item);

  Future<int> delete(String code);

  Future<List<Book>> get(String code);

  // Future<List<Book>> getAll();
}
