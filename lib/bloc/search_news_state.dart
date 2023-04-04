import 'package:equatable/equatable.dart';
import 'package:news_apps_bloc_rest_api/model/article_model.dart';

class SearchNewsState extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SearchNewsInitialState extends SearchNewsState {}

class SearchNewsLoadingState extends SearchNewsState {}

class SearchNewsErrorState extends SearchNewsState {}

class SearchNewsSuccessState extends SearchNewsState {
  final List<Article> articles;
  SearchNewsSuccessState(this.articles);
}
