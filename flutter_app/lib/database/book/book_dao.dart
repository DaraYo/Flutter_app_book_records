import 'package:flutter_app/database/base_dao.dart';
import 'package:flutter_app/database/database_constants.dart';
import 'package:flutter_app/models/book.dart';

class BookDao implements BaseDao<Book> {
  @override
  // TODO: implement createTableQuery
  String get createTableQuery => '''
          CREATE TABLE ${DatabaseConstants.bookTable} (
            ${DatabaseConstants.bookColumnCode} TEXT NOT NULL,
            ${DatabaseConstants.bookColumnTitle} TEXT NOT NULL,
            ${DatabaseConstants.bookColumnAuthor1} TEXT,
            ${DatabaseConstants.bookColumnAuthor2} TEXT,
            ${DatabaseConstants.bookColumnAuthor3} TEXT,
            ${DatabaseConstants.bookColumnAuthor4} TEXT,
            ${DatabaseConstants.bookColumnAuthor5} TEXT,
            ${DatabaseConstants.bookColumnPublishedDate} TEXT,
            ${DatabaseConstants.bookColumnPageCount} INTEGER,
            ${DatabaseConstants.bookColumLanguage} TEXT,
            ${DatabaseConstants.bookColumnDeleted} BIT DEFAULT 0,
            PRIMARY KEY (${DatabaseConstants.bookColumnCode})
          )
          ''';

  @override
  List<Book> fromList(List<Map<String, dynamic>> query) {
    List<Book> books = List<Book>();
    for (Map map in query) {
      books.add(fromMap(map));
    }
    return books;
  }

  @override
  Book fromMap(Map<String, dynamic> query) {
    Book book = Book();
    book.code = query[DatabaseConstants.bookColumnCode];
    book.title = query[DatabaseConstants.bookColumnTitle];
    book.author1 = query[DatabaseConstants.bookColumnAuthor1];
    book.author2 = query[DatabaseConstants.bookColumnAuthor2];
    book.author3 = query[DatabaseConstants.bookColumnAuthor3];
    book.author4 = query[DatabaseConstants.bookColumnAuthor4];
    book.author5 = query[DatabaseConstants.bookColumnAuthor5];
    book.publishedDate = query[DatabaseConstants.bookColumnPublishedDate];
    book.pageCount = query[DatabaseConstants.bookColumnPageCount];
    book.language = query[DatabaseConstants.bookColumLanguage];
    book.deleted = query[DatabaseConstants.bookColumnDeleted] == 1;
    return book;
  }

  @override
  Map<String, dynamic> toMap(Book book) {
    return <String, dynamic>{
      DatabaseConstants.bookColumnCode: book.code,
      DatabaseConstants.bookColumnTitle: book.title,
      DatabaseConstants.bookColumnAuthor1: book.author1,
      DatabaseConstants.bookColumnAuthor2: book.author2,
      DatabaseConstants.bookColumnAuthor3: book.author3,
      DatabaseConstants.bookColumnAuthor4: book.author4,
      DatabaseConstants.bookColumnAuthor5: book.author5,
      DatabaseConstants.bookColumnPublishedDate: book.publishedDate,
      DatabaseConstants.bookColumnPageCount: book.pageCount,
      DatabaseConstants.bookColumLanguage: book.language,
    };
  }
}
