import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:final_water_managment/news/api_handling.dart';
import 'package:final_water_managment/news/model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with AutomaticKeepAliveClientMixin{
  final NewsApi newsApi = NewsApi(
    apiKey: 'AIzaSyCBK4nEPyNKqT9R8XXIWvZAUHQJ4DLDaRY',
    customSearchEngineId: 'f4034221246424e01',
  );

  List<NewsItem> newsItems = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final news = await newsApi.fetchNews('water tips');
    setState(() {
      newsItems = news;
    });
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _refresh() async {
    await fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News', style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white10,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ConditionalBuilder(
          condition: newsItems.length > 0,
          builder: (context) => ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: newsItems.length,
            itemBuilder: (context, index) {
              final newsItem = newsItems[index];
              return NewsCard(
                newsItem: newsItem,
                onTap: () {
                  _launchURL(newsItem.link);
                },
              );
            },
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final NewsItem newsItem;
  final VoidCallback onTap;

  const NewsCard({
    required this.newsItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 4.0,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: newsItem.imageUrl.isNotEmpty
                      ? NetworkImage(newsItem.imageUrl)
                      : AssetImage('assets/images/white.png') as ImageProvider,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem.title,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    newsItem.snippet,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}