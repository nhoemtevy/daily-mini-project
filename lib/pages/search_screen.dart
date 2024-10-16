import 'package:flutter/material.dart';

void main() {
  runApp(SearchScreen());
}
class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.grey[900], // Darker shade for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                filled: false, // Remove background color
                contentPadding: EdgeInsets.symmetric(vertical: 12.0), // Adjust height
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey[600]!, // Darker border for consistency
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: Colors.grey[400]!, // Lighter when focused
                    width: 1.5,
                  ),
                ),
                prefixIcon: Icon(Icons.search, color: Colors.grey[500]), // Search icon
              ),
              style: TextStyle(color: Colors.grey[700]), // Text color
              cursorColor: Colors.grey[500], // Cursor color
            ),
            SizedBox(height: 20),
            // Filter chips
            Row(
              children: [
                FilterChip(
                  label: Text('Education', style: TextStyle(color: Colors.grey[300])), // Light text for better contrast
                  selected: false,
                  backgroundColor: Colors.grey[850], // Match the background theme
                  selectedColor: Colors.grey[700], // Color when selected
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  ),
                  onSelected: (bool selected) {
                    // Handle filter logic here
                  },
                ),
                SizedBox(width: 10), // Adjust spacing between chips
                FilterChip(
                  label: Text('Technology', style: TextStyle(color: Colors.grey[300])),
                  selected: false,
                  backgroundColor: Colors.grey[850],
                  selectedColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onSelected: (bool selected) {
                    // Handle filter logic here
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            // Add your search results widget here
          ],
        ),
      ),
    );
  }
}
