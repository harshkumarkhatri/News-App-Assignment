import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_apps_bloc_rest_api/bloc/news_bloc.dart';
import 'package:news_apps_bloc_rest_api/bloc/news_event.dart';
import 'package:news_apps_bloc_rest_api/bloc/news_state.dart';
import 'package:news_apps_bloc_rest_api/model/article_model.dart';
import 'package:news_apps_bloc_rest_api/repository/news_repository.dart';
import 'package:news_apps_bloc_rest_api/screens/constants/colors.dart';
import 'package:news_apps_bloc_rest_api/screens/widgets/post_card.dart';

class ListArticles extends StatefulWidget {
  const ListArticles({Key? key}) : super(key: key);

  @override
  State<ListArticles> createState() => _ListArticlesState();
}

class _ListArticlesState extends State<ListArticles> {
  final NewsRepository repository = NewsRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 14,
            child: BlocBuilder<NewsBloc, NewsState>(
              builder: (context, state) {
                if (state is NewsInitialState) {
                  context.read<NewsBloc>().add(GetArticlesEvent());
                } else if (state is NewsLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: purple,
                    ),
                  );
                } else if (state is NewsSuccessState) {
                  return RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<NewsBloc>(context).add(
                          GetArticlesEvent(),
                        );
                      },
                      child: buildArticles(context, state.articles));
                } else if (state is NewsErrorState) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<NewsBloc>(context).add(
                        GetArticlesEvent(),
                      );
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
}
