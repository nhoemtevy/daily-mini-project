import 'package:dailydev/pages/sign_in_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      body: ListView(
        children: [
          _buildPostCard(
            "How To Design UI",
            "Microfrontend architecture allows independent frontend pieces to be developed by separate teams and integrated into a complete system, enabling faster releases and reduced complexity. The post explores nine integration patterns, such as Micro Apps, iFrames, App Shell, and Module Federation, highlighting their strengths and weaknesses.",
            'assets/images/img2.png', // Sample post image path
          ),
          _buildPostCard(
            "Microservice architecture vs modular architecture",
            "This post compares the two approaches for breaking down complex systems. Microservices provide loosely coupled services, while modular architectures help in isolating different functionalities within the same app.",
            'assets/images/img4.png', // Sample post image path
          ),
        ],
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
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
        ],
      ),
    );
  }

  // Helper function to build a post card
  Widget _buildPostCard(String title, String content, String imagePath) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Image.asset(imagePath), // Post image
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
}
