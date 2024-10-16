import 'package:dailydev/blogs/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:http/http.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text('Java News Card'),
        backgroundColor: Colors.grey[900],
      ),
      body: JavaNewsCard(),
    ),
  ));
}

class JavaNewsCard extends StatefulWidget {
  @override
  _JavaNewsCardState createState() => _JavaNewsCardState();
}

class _JavaNewsCardState extends State<JavaNewsCard> {
  late Future<Blog> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  Future<Blog> fetchNews() async {
    final response = await http.get(Uri.parse('https://api.example.com/news'));

    if (response.statusCode == 200) {
      return Blog.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: FutureBuilder<Blog>(
          future: futureNews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No data available');
            } else {
              final news = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Card(
                  color: Colors.grey[950],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(news.author.profileUrl),
                        ),
                        title: Text(
                          news.author.username,
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          news.getFormattedDate(),
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        trailing: Icon(Icons.more_vert, color: Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          news.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Image
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Image.network(
                          news.thumbnail,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                      // Icon Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.favorite_border, color: Colors.grey[400]),
                                SizedBox(width: 10),
                                Icon(Icons.comment, color: Colors.grey[400]),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.bookmark_border, color: Colors.grey[400]),
                                SizedBox(width: 10),
                                Icon(Icons.link, color: Colors.grey[400]),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10), // Add some space at the bottom
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}