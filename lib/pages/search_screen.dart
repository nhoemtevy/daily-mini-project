import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Ensure this imports your Blog, Author, and Category classes
import '../blogs/model.dart';
import 'home_screen.dart';
import 'sign_in_screen.dart'; // Import your SignInScreen
import 'detail_screen.dart'; // Import your DetailScreen

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  List<Blog> _posts = []; // Store fetched Blog objects
  List<Blog> _suggestions = []; // Store search suggestions
  bool _isLoading = true; // Loading state
  bool _isFavorited = false; // Add this line
  List<Category> _categories = [];  // Add this line
  TextEditingController _searchController = TextEditingController(); // Add a controller for the search field

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchFilterLabel(); // Fetch the filter label
    fetchPosts(); // Fetch default posts
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigate to HomeScreen when 'Home' tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()), // Navigate to HomeScreen
      );
    } else if (index == 2) {
      // Navigate to SearchScreen when 'Explore' tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()), // Navigate to SearchScreen
      );
    } else {
      setState(() {
        _selectedIndex = index;
        _tabController.animateTo(index); // Sync TabBar and BottomNavBar
      });
    }
  }

  Future<void> fetchPosts({String? categoryId, String? query}) async {
    String url = 'https://blog-api.automatex.dev/blogs';
    if (categoryId != null) {
      url += '?category_id=$categoryId';
    } else if (query != null && query.isNotEmpty) {
      url += '?title=$query';
    }

    print('Fetching posts from URL: $url'); // Print the URL

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);

        // Print the raw JSON response for debugging
        print('Raw API response: $jsonData');

        setState(() {
          // Map the JSON response to a List of Blog objects
          _posts = (jsonData['blogs'] as List<dynamic>).map((json) => Blog.fromJson(json)).toList();
          _suggestions = _posts; // Update suggestions with the fetched posts
          _isLoading = false; // Stop loading

          // Print the mapped posts to verify the content
          _posts.forEach((post) {
            print('Blog post: ${post.title}, Author: ${post.author.username}');
          });
        });
      } else {
        throw Exception('Failed to load posts: Status Code ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors here,
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      print('Error fetching posts: $e'); // Log the error for debugging
    }
  }

  Future<void> fetchFilterLabel() async {
    try {
      final response = await http.get(Uri.parse('https://blog-api.automatex.dev/categories'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        // Print the raw JSON response for debugging
        print('Raw API response Categories: $jsonData');

        setState(() {
          // Store the category objects in the _categories list
          _categories = jsonData.map((category) => Category.fromJson(category)).toList();
        });

        // Print the id and name field of each category
        jsonData.forEach((category) {
          print('Category id: ${category['id']}, name: ${category['name']}');
        });
      } else {
        throw Exception('Failed to load categories: Status Code ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.grey[950],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                filled: false, // Remove background color
                // Add border with color
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey, // Border color
                    width: 1.5, // Border width
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey, // Border color when focused
                    width: 1.0, // Border width when focused
                  ),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey), // Search icon
              ),
              style: TextStyle(color: Colors.grey[950]), // Text color
              cursorColor: Colors.grey[500], // Cursor color
              onChanged: (query) {
                fetchPosts(query: query); // Fetch posts based on the search query
              },
            ),
            SizedBox(height: 20,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0), // Add some spacing between chips
                    child: FilterChip(
                      label: Text(category.name, style: TextStyle(color: Colors.grey[500])),
                      selected: false,
                      backgroundColor: Colors.grey[950],
                      selectedColor: Colors.grey,
                      onSelected: (bool selected) {
                        // Fetch posts for the selected category and current search query
                        fetchPosts(categoryId: category.id, query: _searchController.text);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            // Display search suggestions
            Expanded(
              child: _suggestions.isEmpty
                  ? Center(child: Text("No suggestions available."))
                  : ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final suggestion = _suggestions[index];
                        return _buildPostCard(
                          suggestion.author.username, // Author's username
                          suggestion.getFormattedDate(), // Formatted date
                          suggestion.title, // Content of the post
                          suggestion.thumbnail, // Post image URL
                          suggestion.author.profileUrl, // Author's profile URL
                          suggestion // Pass the entire post object
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search), // Explore icon
            label: 'Explore',
          ),
        ],
      ),
    );
  }

  Widget _buildPostFeed() {
    return _isLoading
        ? Center(child: CircularProgressIndicator()) // Show a loading indicator
        : _posts.isEmpty
        ? Center(child: Text("No posts available.")) // Handle empty posts
        : ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildPostCard(
            post.author.username, // Author's username
            post.getFormattedDate(), // Formatted date
            post.title, // Content of the post
            post.thumbnail, // Post image URL
            post.author.profileUrl, // Author's profile URL
            post // Pass the entire post object
        );
      },
    );
  }

  Widget _buildPostCard(String username, String location, String content, String imagePath, String profileUrl, Blog post) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailScreen(post: post)), // Navigate to DetailScreen
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(profileUrl), // Replace with user's avatar
              ), // Replace with user's avatar
              title: Text(username),
              subtitle: Text(location),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(content, style: TextStyle(fontSize: 16)),
            ),
            Image.network(
              imagePath,
              errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Icon(Icons.error); // Display an error icon if the image fails to load
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isFavorited = !_isFavorited;
                      });
                    },
                    icon: Icon(
                      _isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorited ? Colors.red : Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.comment),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.share),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.bookmark_border),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.link),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTagsFeed() => Center(child: Text('Tags Tab'));
  Widget _buildBookmarksFeed() => Center(child: Text('Bookmarks Tab'));
  Widget _buildHistoryFeed() => Center(child: Text('History Tab'));
}