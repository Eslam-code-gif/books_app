import 'package:books_app/const/api_key.dart';
import 'package:books_app/model/book_model.dart';
import 'package:dio/dio.dart';

class ApiService {
  late final Dio _dio;
  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://www.googleapis.com/books/v1/volumes',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }
  Future<List<Book>?> getNewestBooks({
    int startIndex = 0,
    int maxResults = 40,
  }) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          'q': 'books',
          'orderBy': 'newest',
          'startIndex': startIndex,
          'maxResults': maxResults,
          'key': apiKey,
        },
      );
      if (response.statusCode == 200) {
        final items = response.data['items'] as List?;
        if (items != null) {
          return items.map((item) => Book.fromJson(item)).toList();
        }
        return [];
      }
    } catch (e) {
      print('Error getting newest books: $e');
      return null;
    }
    return null;
  }

  Future<List<Book>?> getBooksByCategory(
    String category, {
    int startIndex = 0,
    int maxResults = 40,
  }) async {
    try {
      final response = await _dio.get(
        '',
        queryParameters: {
          'q': 'subject:$category',
          'startIndex': startIndex,
          'maxResults': maxResults,
          'key': apiKey,
        },
      );
      if (response.statusCode == 200) {
        final items = response.data['items'] as List?;
        if (items != null) {
          return items.map((item) => Book.fromJson(item)).toList();
        }
        return [];
      }
    } catch (e) {
      print('Error getting category books: $e');
      return null;
    }
    return null;
  }

  Future<Book?> getBookById(String id) async {
    try {
      final response = await _dio.get('/$id', queryParameters: {'key': apiKey});
      if (response.statusCode == 200) {
        return Book.fromJson(response.data);
      }
    } catch (e) {
      print('Error getting book details: $e');
      return null;
    }
    return null;
  }
}
