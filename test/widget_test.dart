import 'package:dailydev/blogs/api-service.dart';
import 'package:dailydev/blogs/model.dart';
import 'package:dailydev/pages/sign_in_screen.dart';
import 'package:dailydev/pages/sign_up_screen.dart';
import 'package:dailydev/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: SizedBox(
          width: 300,
          height: 300,
          child: Image.asset(
            'assets/images/logo1.png',
            width: 300,
            height: 300,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SignInScreen(),
                ),
              );
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SvgPicture.string(
            '''
            <svg xmlns="http://www.w3.org/2000/svg" width="1em" height="1em" viewBox="0 0 16 16">
              <path fill="currentColor" d="M8 0h1v16H8z" />
            </svg>
            ''',
            color: Colors.white,
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignUpScreen(),
                ),
              );
            },
            child: const Text(
              'Sign up',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 8.0 , horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  print('Search button pressed');
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Search',
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 60,
              child: CategoryList(),
            ),
            SizedBox(
              height: 600,
              child: BlogListPage(),
            ),
          ],
        ),
      ),
    );
  }
}





// ========= card ==========
class BlogListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Blog>>(
        future: fetchBlogs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Blog>? blogs = snapshot.data;
            return ListView.builder(
              itemCount: blogs?.length ?? 0,
              itemBuilder: (context, index) {
                Blog blog = blogs![index];
                return GestureDetector( // Use GestureDetector for tap detection
                  onTap: () {
                    // Navigate to the BlogDetailsPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetailsPage(blog: blog),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey[900], // Adjust color as needed
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile row
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(blog.author.profileUrl),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    blog.author.username,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Created: ${blog.getFormattedDate()}",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            blog.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[100],
                            ),
                          ),
                          SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              blog.thumbnail,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 15),
                          // Icons row
                          Row(
                            children: [
                              // Left side: Heart and Share icons
                              Expanded(
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.favorite_border, color: Colors.white),
                                          onPressed: () {
                                            print('Heart icon pressed');
                                          },
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${blog.numberOfLikes}', // Display the number of likes
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 16),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.share_outlined, color: Colors.white),
                                          onPressed: () {
                                            print('Share icon pressed');
                                          },
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          '${blog.numberOfBookmarks}', // Assuming sharesCount
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.bookmark_border, color: Colors.white),
                                    onPressed: () {
                                      print('Bookmark icon pressed');
                                    },
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${blog.numberOfBookmarks}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No blogs found'));
          }
        },
      ),
    );
  }
}


class BlogDetailsPage extends StatelessWidget {
  final Blog blog;

  BlogDetailsPage({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // title: Text(blog.title, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        iconTheme: IconThemeData(
          color: Colors.white, // Set the back button color to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                blog.title,
                style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "By ${blog.author.username} - ${blog.getFormattedDate()}",
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              Text(
                blog.content,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 15),

              // Display categories here
              Wrap(
                spacing: 8.0, // Space between categories
                children: blog.categories.map((category) {
                  return Text(
                    '# ${category.name}',
                    style: TextStyle(color: Colors.grey[600]),
                  );
                }).toList(), // Convert Iterable to List
              ),


              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(blog.thumbnail),
              ),
              SizedBox(height: 15),
              // Icons row
              Row(
                children: [
                  // Left side: Heart and Share icons
                  Expanded(
                    child: Row(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.favorite_border, color: Colors.white),
                              onPressed: () {
                                print('Heart icon pressed');
                              },
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${blog.numberOfLikes}', // Display the number of likes
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        SizedBox(width: 16),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.share_outlined, color: Colors.white),
                              onPressed: () {
                                print('Share icon pressed');
                              },
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${blog.numberOfBookmarks}', // Assuming sharesCount
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.bookmark_border, color: Colors.white),
                        onPressed: () {
                          print('Bookmark icon pressed');
                        },
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${blog.numberOfBookmarks}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}