import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final String apiKey = '5d53fbf398fe4361a267e25848e6d422';
  final String apiUrl =
      'https://newsapi.org/v2/top-headlines?country=us&apiKey=';

  Timer? _debounce;
  String _searchKeyword = '';
  List<dynamic> _filteredArticles = [];

  Future<List<dynamic>> fetchNews(String searchKeyword) async {
    final String url = apiUrl + apiKey;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];
        return articles
            .where((article) => article['title']
                .toLowerCase()
                .contains(searchKeyword.toLowerCase()))
            .toList();
      }
    } catch (e) {
      print('Error fetching news: $e');
    }
    return [];
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _handleSearch(String keyword) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchKeyword = keyword;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchNews(_searchKeyword),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Error fetching news'),
            ),
          );
        } else {
          final List<dynamic> articles = snapshot.data as List<dynamic>;
          _filteredArticles = articles;

          return DefaultTextStyle(
            style: TextStyle(fontFamily: 'Satoshi'),
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 16, top: 16),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Text(
                            'Hi Pranav',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF050125),
                              height: 1.25,
                              letterSpacing: -0.356,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Good Morning!',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF050125),
                              height: 1.25,
                              letterSpacing: -0.356,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: TextFormField(
                                      onChanged: _handleSearch,
                                      decoration: const InputDecoration(
                                        hintText: 'Search for a topic',
                                        hintStyle:
                                            TextStyle(color: Colors.black54),
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Perform action when the image is clicked
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/searchbox.png',
                              width: 50,
                              height: 50,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.feed_rounded),
                          iconSize: 50,
                          onPressed: () {
                            // Perform My Feed action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.newspaper_rounded),
                          iconSize: 50,
                          onPressed: () {
                            // Perform All News action
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.star),
                          iconSize: 50,
                          onPressed: () {
                            // Perform Top News action
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'My Feed',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF050125),
                            height: 1.25,
                            letterSpacing: -0.356,
                          ),
                        ),
                        Text(
                          'All News',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF050125),
                            height: 1.25,
                            letterSpacing: -0.356,
                          ),
                        ),
                        Text(
                          'Top News',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Satoshi',
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF050125),
                            height: 1.25,
                            letterSpacing: -0.356,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      child: const Text(
                        'New Announcement',
                        style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Satoshi',
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF050125),
                          height: 1.25,
                          letterSpacing: -0.356,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var article in _filteredArticles)
                            if (article['urlToImage'] != null)
                              GestureDetector(
                                onTap: () {
                                  launchURL(article['url']);
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SizedBox(
                                        width: 130,
                                        height: 250,
                                        child: Image.network(
                                          article['urlToImage'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 16),
                          child: const Text(
                            'Notifications',
                            style: TextStyle(
                              fontSize: 22,
                              fontFamily: 'Satoshi',
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF050125),
                              height: 1.25,
                              letterSpacing: -0.356,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NewsArticlePage(),
                                settings: RouteSettings(
                                  arguments: _filteredArticles,
                                ),
                              ),
                            );
                          },
                          child: const Text(
                            'VIEW ALL',
                            style: TextStyle(
                                fontSize: 14,
                                color: const Color(0xFFC99F4A),
                                fontFamily: 'Satoshi',
                                fontWeight: FontWeight.w500,
                                height: 1.25,
                                letterSpacing: -0.356,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          for (var article in _filteredArticles)
                            if (article['urlToImage'] != null)
                              GestureDetector(
                                onTap: () {
                                  launchURL(article['url']);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        width: 80,
                                        height: 65,
                                        child: Image.network(
                                          article['urlToImage'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          article['title'],
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontFamily: 'Satoshi',
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF050125),
                                            height: 1.25,
                                            letterSpacing: -0.356,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class NewsArticlePage extends StatefulWidget {
  @override
  _NewsArticlePageState createState() => _NewsArticlePageState();
}

class _NewsArticlePageState extends State<NewsArticlePage> {
  @override
  Widget build(BuildContext context) {
    final List<dynamic> articles =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var article in articles)
              if (article['urlToImage'] != null)
                Column(
                  children: [
                    Image.network(
                      article['urlToImage'],
                      width: double.infinity,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article['title'],
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            article['description'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: NewsPage(),
    debugShowCheckedModeBanner: false,
  ));
}
