import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_apps_bloc_rest_api/bloc/search_news_bloc.dart';
import 'package:news_apps_bloc_rest_api/bloc/search_news_event.dart';
import 'package:news_apps_bloc_rest_api/bloc/search_news_state.dart';
import 'package:news_apps_bloc_rest_api/model/article_model.dart';
import 'package:news_apps_bloc_rest_api/repository/search_news_repository.dart';
import 'package:news_apps_bloc_rest_api/screens/constants/colors.dart';
import 'package:news_apps_bloc_rest_api/screens/widgets/post_card.dart';

class SearchArticles extends StatefulWidget {
  const SearchArticles({Key? key}) : super(key: key);

  @override
  State<SearchArticles> createState() => _SearchArticlesState();
}

class _SearchArticlesState extends State<SearchArticles> {
  String? currentQuery;
  Timer? _debounce;
  final SearchNewsRepository repository = SearchNewsRepository();

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  _onSearchChanged(String query) {
    setState(() {
      currentQuery = query;
    });
    if (_debounce != null && _debounce!.isActive) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      BlocProvider.of<SearchNewsBloc>(context).add(
        GetSearchArticlesEvent(query: query),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _controller,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(hintText: "Enter query"),
              ),
            ),
          ),
          if (!(currentQuery != null && currentQuery != ''))
            const Center(
              child: Text("Please enter a query to continue"),
            ),
          if (currentQuery != null && currentQuery != '')
            Expanded(
              flex: 14,
              child: BlocBuilder<SearchNewsBloc, SearchNewsState>(
                builder: (context, state) {
                  if (state is SearchNewsInitialState &&
                      currentQuery != null &&
                      currentQuery != '') {
                    context
                        .read<SearchNewsBloc>()
                        .add(GetSearchArticlesEvent(query: currentQuery));
                  } else if (state is SearchNewsLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: purple,
                      ),
                    );
                  } else if (state is SearchNewsSuccessState) {
                    if (state.articles.isEmpty) {
                      return const Center(
                        child: Text(
                          "No items found",
                        ),
                      );
                    }
                    return RefreshIndicator(
                        onRefresh: () async {
                          if (currentQuery != null && currentQuery != '') {
                            BlocProvider.of<SearchNewsBloc>(context).add(
                              GetSearchArticlesEvent(query: currentQuery),
                            );
                          }
                        },
                        child: buildArticles(context, state.articles));
                  } else if (state is SearchNewsErrorState) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        if (currentQuery != null && currentQuery != '') {
                          BlocProvider.of<SearchNewsBloc>(context).add(
                            GetSearchArticlesEvent(query: currentQuery),
                          );
                        }
                      },
                      child: Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.error_outline),
                          Text("Connection Error!"),
                        ],
                      )),
                    );
                  }
                  return const Center(child: Text('Something Else Happened!'));
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget buildArticles(BuildContext context, List<Article>? articles) {
    double heigth = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
              padding: EdgeInsets.only(
                  left: width * 0.025, right: width * 0.025, top: width * 0.01),
              itemCount: articles!.length,
              itemBuilder: ((context, index) {
                return PostCard(
                  heigth: heigth * 0.451,
                  width: width,
                  padding: width * 0.03,
                  title: articles[index].title,
                  description: articles[index].description,
                  author: articles[index].author,
                  content: articles[index].content,
                  publishedAt: articles[index].publishedAt,
                  url: articles[index].url,
                  urlToImage: articles[index].urlToImage,
                );
              })),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
