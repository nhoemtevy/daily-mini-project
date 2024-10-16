class Blog {
  final String id;
  final String title;
  final String thumbnail;
  final String createdAt;
  final Author author;
  final int numberOfLikes;
  final int numberOfBookmarks;
  final String content;
  final List<Category> categories;

  Blog({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.createdAt,
    required this.author,
    required this.numberOfLikes,
    required this.numberOfBookmarks,
    required this.content,
    required this.categories,
  });

  String getFormattedDate() {
    DateTime dateTime = DateTime.parse(createdAt);
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      createdAt: json['created_at'],
      author: Author.fromJson(json['author']),
      numberOfLikes: json['number_of_likes'],
      numberOfBookmarks: json['number_of_bookmarks'],
      content: json['content'],
      // Correctly parsing categories from the JSON array
      categories: (json['categories'] as List<dynamic>)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList(),
    );
  }

}

class Author {
  final String username;
  final String profileUrl;
  final String createdAt;

  Author({
    required this.username,
    required this.profileUrl,
    required this.createdAt,
  });


  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      username: json['username'],
      profileUrl: json['profileUrl'],
      createdAt: json['created_at'],
    );
  }
}

class Category {
  final String id;
  final String name;

  Category({required this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
    );
  }
}
