import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_apps_bloc_rest_api/bloc/search_news_event.dart';
import 'package:news_apps_bloc_rest_api/bloc/search_news_state.dart';

import 'package:news_apps_bloc_rest_api/model/article_model.dart';
import 'package:news_apps_bloc_rest_api/repository/search_news_repository.dart';

class SearchNewsBloc extends Bloc<SearchNewsEvent, SearchNewsState> {
  SearchNewsBloc() : super(SearchNewsInitialState()) {
    on<SearchNewsEvent>((event, emit) async {
      if (event is GetSearchArticlesEvent) {
        emit(SearchNewsLoadingState());
        try {
          String? query = event.query;
          final SearchNewsRepository newsRepository = SearchNewsRepository();
          List<Article> articles =
              await newsRepository.getSearchArticles(query);
          emit(SearchNewsSuccessState(articles));
        } catch (e) {
          emit(SearchNewsErrorState());
          throw ("Couldn't fetch data! BLOC Error!");
        }
      }
    });
  }
}
