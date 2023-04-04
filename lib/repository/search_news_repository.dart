import 'package:news_apps_bloc_rest_api/data_provider/data_provider.dart';
import 'package:news_apps_bloc_rest_api/model/article_model.dart';

class SearchNewsRepository {
  final DataProvider dataProvider = DataProvider();

  Future<List<Article>> getSearchArticles(String? query) async {
    return await dataProvider.getSearchArticles(query);
  }
}
