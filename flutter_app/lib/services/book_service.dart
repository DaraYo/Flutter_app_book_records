import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_app/models/book.dart';
import 'package:flutter_app/services/api_base_helper.dart';
import 'package:http/http.dart' as http;

class BookService {
  ApiBaseHelper _helper = ApiBaseHelper();

  final String booksUrl = "content.googleapis.com";
  final String booksEndpoint = "/books/v1/volumes";
  final String key = "content.googleapis.com/books/v1/volumes";

  Future<Book> getBook(
      {@required String accessToken, @required String bookCode}) async {
    // final response =
    //     await _helper.getWithAuthorization("/api/invbroj/" + bookCode);
    // print(response);
    // return null;

    var parameters = {'q': bookCode};
    final uri = Uri.https(booksUrl, booksEndpoint, parameters);
    final response = await http.get(
      uri,
      // headers: {'Authorization': 'Bearer $accessToken'},
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data.isNotEmpty) {
        if (data["totalItems"] == 1) {
          var foundedBook = data["items"][0];
          Book book = Book();
          book.code = bookCode;
          var basicInfo = foundedBook["volumeInfo"];
          book.title = basicInfo["title"];
          // for (var i = 0; i < foundedBook.volumeInfo.authors.length; i++) {
          //   book['author${i + 1}'] = foundedBook.volumeInfo.authors[i];
          // }
          book.author1 = basicInfo["authors"][0];
          book.publishedDate = basicInfo["publishedDate"];
          book.pageCount = basicInfo["pageCount"];
          book.language = basicInfo["language"];

          return book;
        } else {
          return null;
        }
      }
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    throw response;
  }
}
