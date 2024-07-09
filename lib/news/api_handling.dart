import 'dart:convert';
import 'package:final_water_managment/news/model.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  final String apiKey;
  final String customSearchEngineId;

  NewsApi({required this.apiKey, required this.customSearchEngineId});

  Future<List<NewsItem>> fetchNews(String query) async {
    final response = await http.get(
      Uri.parse(
        'https://www.googleapis.com/customsearch/v1?key=$apiKey&cx=$customSearchEngineId&q=$query',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey('items') && data['items'] is List) {
        final items = data['items'] as List<dynamic>;
        return items.map((item) {
          final title = item['title'] as String;
          final link = item['link'] as String;
          final imageUrl = item['pagemap'] != null && item['pagemap']['cse_thumbnail'] is List
              ? item['pagemap']['cse_thumbnail'][0]['src'] as String
              : ''; // Handle missing or invalid data
          final snippet = item['snippet'] as String; // Add this line
          return NewsItem(title: title, link: link, imageUrl: imageUrl, snippet: snippet);
        }).toList();
      }
    }
    throw Exception('Failed to load news');
  }
  }
