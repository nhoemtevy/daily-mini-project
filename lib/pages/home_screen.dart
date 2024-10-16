import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';// Ensure this imports your Blog, Author, and Category classes
import '../blogs/model.dart';
import 'sign_in_screen.dart'; // Import your SignInScreen

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;
  List<Blog> _posts = []; // Store fetched Blog objects
  bool _isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    fetchPosts(); // Fetch data when the widget is initialized
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Navigate to SearchScreen when 'Explore' tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SearchBar()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
        _tabController.animateTo(index); // Sync TabBar and BottomNavBar
      });
    }
  }

  // Fetch data from the API
  Future<void> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('https://blog-api.automatex.dev/blogs'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          // Map the JSON response to a List of Blog objects
          _posts = jsonData.map((json) => Blog.fromJson(json)).toList();
          _isLoading = false; // Stop loading
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      // Handle errors here,
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      print('Error fetching posts: $e'); // Log the error for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30), // Your logo
            Spacer(),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()), // Navigate to SignInScreen
                );
              },
              child: Text(
                "Sign In",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'For you'),
            Tab(text: 'Tags'),
            Tab(text: 'Bookmarks'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: _buildTabBarView(),
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

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildPostFeed(), // Content for 'For you'
        _buildTagsFeed(), // Content for 'Tags'
        _buildBookmarksFeed(), // Content for 'Bookmarks'
        _buildHistoryFeed(), // Content for 'History'
      ],
    );
  }

  // Helper function to build post feed content
  Widget _buildPostFeed() {
    return _isLoading
        ? Center(child: CircularProgressIndicator()) // Show a loading indicator
        : _posts.isEmpty
        ? Center(child: Text("No posts available.")) // Handle empty posts
        : SingleChildScrollView(
      child: Column(
        children: _posts.map((post) {
          return _buildPostCard(
            post.author.username, // Author's username
            "Location", // Static location or dynamic if available
            post.content, // Content of the post
            post.thumbnail, // Post image URL
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPostCard(String username, String location, String content, String imagePath) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)), // Replace with user's avatar
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
                  onPressed: () {},
                  icon: Icon(Icons.favorite_border),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTagsFeed() => Center(child: Text('Tags Tab'));
  Widget _buildBookmarksFeed() => Center(child: Text('Bookmarks Tab'));
  Widget _buildHistoryFeed() => Center(child: Text('History Tab'));
}
