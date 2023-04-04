import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_apps_bloc_rest_api/constants/api_constants.dart';
import 'package:news_apps_bloc_rest_api/model/article_model.dart';

class DataProvider {
  final endPointUrl = "newsapi.org";
  final unencodedPath = "/v2/top-headlines";
  final client = http.Client();

  Future<List<Article>> getArticles() async {
    Map<String, String> queryParameters = {'country': "us"};

    queryParameters['apiKey'] = ApiConstants.apiKey;

    try {
      final uri = Uri.https(endPointUrl, unencodedPath, queryParameters);
      final response = await client.get(uri);

      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['articles'];

      List<Article> articles = [];

      articles = body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } catch (e) {
      throw ("Can't get the Articles!");
    }
  }

  Future<List<Article>> getSearchArticles(String? query) async {
    Map<String, String> queryParameters = {'country': "us"};

    if (query != null && query != '') {
      queryParameters['q'] = query;
    }

    queryParameters['apiKey'] = ApiConstants.apiKey;

    try {
      final uri = Uri.https(endPointUrl, unencodedPath, queryParameters);
      final response = await client.get(uri);

      Map<String, dynamic> json = jsonDecode(response.body);

      List<dynamic> body = json['articles'];

      List<Article> articles = [];

      articles = body.map((dynamic item) => Article.fromJson(item)).toList();

      return articles;
    } catch (e) {
      throw ("Can't get the Articles!");
    }
  }
}
