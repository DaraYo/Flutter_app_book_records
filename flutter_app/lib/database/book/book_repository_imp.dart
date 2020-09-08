import 'package:flutter_app/database/book/book_dao.dart';
import 'package:flutter_app/database/book/book_repository.dart';
import 'package:flutter_app/database/database_constants.dart';
import 'package:flutter_app/database/database_provider.dart';
import 'package:flutter_app/models/book.dart';

class BookRepositoryImp implements BookRepository {
  @override
  DBProvider databaseProvider;

  BookRepositoryImp(this.databaseProvider);

  @override
  Future<int> delete(String code) async {
    return await databaseProvider.bookDelete(
        DatabaseConstants.bookTable, DatabaseConstants.bookColumnCode, code);
  }

  @override
  Future<int> update(Book item) async {
    return await databaseProvider.updateBook(DatabaseConstants.bookTable,
        DatabaseConstants.bookColumnCode, BookDao().toMap(item));
  }

  @override
  Future<int> insert(Book item) async {
    return await databaseProvider.insert(
        DatabaseConstants.bookTable, BookDao().toMap(item));
  }

  @override
  Future<List<Book>> get(String code) async {
    final allQueries = await databaseProvider.queryAllRowsByColumnValue(
        DatabaseConstants.bookTable, DatabaseConstants.bookColumnCode, code);
    return BookDao().fromList(allQueries);
  }
}
