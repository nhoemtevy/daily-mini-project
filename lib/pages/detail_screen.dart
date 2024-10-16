import 'package:dailydev/pages/sign_in_screen.dart';
import 'package:flutter/material.dart';
import '../blogs/model.dart';
import 'home_screen.dart'; // Import HomeScreen
import 'search_screen.dart'; // Import SearchScreen

class DetailScreen extends StatefulWidget {
  final Blog post;

  DetailScreen({required this.post});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int _selectedIndex = 0;
  bool _isFavorited = false; // Declare the _isFavorited variable

  void _onItemTapped(int index) {
    if (index == 0) {
      // Navigate to HomeScreen when 'Home' tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 2) {
      // Navigate to SearchScreen when 'Explore' tab is tapped
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SearchScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'By ${widget.post.author.username} on ${widget.post.getFormattedDate()}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              widget.post.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Image.network(widget.post.thumbnail),
            SizedBox(height: 16),
            Container(
            color: Color(0xFF0E1217), // Set your desired background color here
            child: Padding(
              padding: const EdgeInsets.all(0.0),
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
            ),
          )
          ],
        ),
      ),
     bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black, // Set your desired background color here
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
}