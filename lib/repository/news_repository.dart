import 'package:news_apps_bloc_rest_api/data_provider/data_provider.dart';
import 'package:news_apps_bloc_rest_api/model/article_model.dart';

class NewsRepository {
  final DataProvider dataProvider = DataProvider();

  Future<List<Article>> getArticles() async {
    return await dataProvider.getArticles();
  }
}
