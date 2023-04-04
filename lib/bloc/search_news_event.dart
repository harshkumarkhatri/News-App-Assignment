import 'package:equatable/equatable.dart';

class SearchNewsEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

// ignore: must_be_immutable
class GetSearchArticlesEvent extends SearchNewsEvent {
  String? query;
  GetSearchArticlesEvent({this.query});
}
